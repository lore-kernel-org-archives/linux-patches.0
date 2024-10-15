Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE8EE1E7653;
	Tue, 15 Oct 2024 13:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998321; cv=none; b=n4zgfaPv7YYwNRJfe5ENNIYNOqDyBdkkpBFv1j0rxxe4ty+3zLIlSqUS+EeeuP066YQcBntNQTbD7oNNlecI132A0kGYv6CDt4kqhnHl5g81ZVnyoRXIfu/T9khsZT2YWFDj/sZA4X1wIWEUeZiwzL3ODdGeQeGictzAp1pKcLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998321; c=relaxed/simple;
	bh=351qantpzzgVjQA5BVRarbrMWC61RJiwqw7sApLt4hs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hFXNut9499348Y1V9DoFO5/ZyleXPCCBIwrWH6h4Ws2UqD6pLmcqC+XtebLbZEspNrkpyieeM18wNE1+80CU70mXTJy550Vi6K/BSpNm6ttBrphuzyqLoLOQMI+WuneOHf06rMb2HKrmjLa3UBZ/SgymaSAFdtfOFlGUhXJOzyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dLMLfVmj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dLMLfVmj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26269C4CED1;
	Tue, 15 Oct 2024 13:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998320;
	bh=351qantpzzgVjQA5BVRarbrMWC61RJiwqw7sApLt4hs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dLMLfVmjR9RX4qZc04tSXdNjh7s8hCrSd/51hgeXLJ4/1d0kcdF3JHDJHnedNhwS2
	 6f6drQwNcnTPSgvxKxQRb1JQ7Ya0wwwE3vRb69Gx8x16YKcuoSXQ3MmAnCvmtHkdfO
	 djdPIM9iGBerWwAtVEY7NXvk+jQnQsoE0o2xQ06M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Wang <zyytlz.wz@163.com>,
	Dikshita Agarwal <quic_dikshita@quicinc.com>,
	Stanimir Varbanov <stanimir.k.varbanov@gmail.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 5.10 403/518] media: venus: fix use after free bug in venus_remove due to race condition
Date: Tue, 15 Oct 2024 14:45:07 +0200
Message-ID: <20241015123932.528171334@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zheng Wang <zyytlz.wz@163.com>

commit c5a85ed88e043474161bbfe54002c89c1cb50ee2 upstream.

in venus_probe, core->work is bound with venus_sys_error_handler, which is
used to handle error. The code use core->sys_err_done to make sync work.
The core->work is started in venus_event_notify.

If we call venus_remove, there might be an unfished work. The possible
sequence is as follows:

CPU0                  CPU1

                     |venus_sys_error_handler
venus_remove         |
hfi_destroy	 		 |
venus_hfi_destroy	 |
kfree(hdev);	     |
                     |hfi_reinit
					 |venus_hfi_queues_reinit
                     |//use hdev

Fix it by canceling the work in venus_remove.

Cc: stable@vger.kernel.org
Fixes: af2c3834c8ca ("[media] media: venus: adding core part and helper functions")
Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
Signed-off-by: Dikshita Agarwal <quic_dikshita@quicinc.com>
Signed-off-by: Stanimir Varbanov <stanimir.k.varbanov@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/venus/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/platform/qcom/venus/core.c
+++ b/drivers/media/platform/qcom/venus/core.c
@@ -366,6 +366,7 @@ static int venus_remove(struct platform_
 	struct device *dev = core->dev;
 	int ret;
 
+	cancel_delayed_work_sync(&core->work);
 	ret = pm_runtime_get_sync(dev);
 	WARN_ON(ret < 0);
 


