Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2AAB1AAE02;
	Mon, 14 Oct 2024 15:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919362; cv=none; b=oacts8dW4PCSRHBf07vti5JeTeAEVxN3YqUFNgrUTw1dXunqwydx3hDxnNBycczrWA2g6G3x9YO4DmTE6gn/kfdD8iRNjdm/eG820GrXnmtPD/yOTLB3IzlhSRVhvNajoj8jMT+sIPS3EcfgcLT8d/2i50siJTmfSNctLU4LrLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919362; c=relaxed/simple;
	bh=DtmmUq+MlBAIZn3ubE01S31tZfut2bdCxGHptXDhYYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sf/Jo0QvLOkahNFO/Dg1Ndjm/iPV/9wJZIMJWpEhkl80oyCxTu8g5dq9b8r1h3RUn3fpfMV1OdPyd0VcvS0s4OInmY6rHoZlWEjkXZzV85XtVQx5Uys6rvdp3mo51xj7Hnb6zQBWzRrqH866+Bsj+ALwDcJ8CV0wvLQAP/BALWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K4rCS1lE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K4rCS1lE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C02CC4CEC3;
	Mon, 14 Oct 2024 15:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919361;
	bh=DtmmUq+MlBAIZn3ubE01S31tZfut2bdCxGHptXDhYYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K4rCS1lEMIJl9+edj44m892z4sYMyVy1DzLzqr+KKsDS04EjW/XoBP12+H70+rI0m
	 AXefmsHn8w3c1cp+HtLE/StEIaFrhYJQOrMc61PBKPUJy5/2MTRxg+yCPetiXSqh3R
	 2K0kHe/d0BPXmnsV2ZXDuG0QrUobj0BonGwIZdp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Wang <zyytlz.wz@163.com>,
	Dikshita Agarwal <quic_dikshita@quicinc.com>,
	Stanimir Varbanov <stanimir.k.varbanov@gmail.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 6.1 588/798] media: venus: fix use after free bug in venus_remove due to race condition
Date: Mon, 14 Oct 2024 16:19:02 +0200
Message-ID: <20241014141241.104364124@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -423,6 +423,7 @@ static int venus_remove(struct platform_
 	struct device *dev = core->dev;
 	int ret;
 
+	cancel_delayed_work_sync(&core->work);
 	ret = pm_runtime_get_sync(dev);
 	WARN_ON(ret < 0);
 


