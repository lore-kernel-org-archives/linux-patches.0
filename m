Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD0B192D69;
	Tue,  8 Oct 2024 12:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390811; cv=none; b=Qpl6f6GHM+M6hR6bbZHV6C7pua9KoVxH57MzmARiHEd9i8nImpYXfMPlMiDzVjYxVFGd/NidswHmDzaGiHTeHWOdgQoNsPt/hD4QXIG3HMcBufp2Z8/OLYDp73L7I06caKSofo7CJNbmrs4Z0UYSGd6n1oU0ohya93QNQdKbP4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390811; c=relaxed/simple;
	bh=UU5NT8hGE03+kwcbwlDhSBDdWNmn2uwix0zQSqD1vHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XlFRQLU61O++/P9qAp6+YE8K3Brk+DzTuCEBMXzb96yXx6JYW/pVIzMVr8LpwXxGTVl+GkiuIzhgQ1txC/X9UIzy+Q7rALsmHm1jUOVBpMe2hfjs2mPzPOh2rGH595W0oZCOmqq4WKkRslSfbYrDV0sYCTwgs3N8Hg/incYFnvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w1Gbf3wD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w1Gbf3wD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFD20C4CEC7;
	Tue,  8 Oct 2024 12:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390811;
	bh=UU5NT8hGE03+kwcbwlDhSBDdWNmn2uwix0zQSqD1vHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w1Gbf3wDhWbV3NKtvltFIRPIiURckumecX4lQlToivZ6LjH0NbABw4arzzn9XCTRA
	 411B/90OE8cQMXd37FTgWwNGANlkHcS4VdLICkboQPBY9KDApd1Ztw3RO9kLnv0GlB
	 RWYodN0IctU7MNuWb9gdGLJ0cRorXNZ+geaBsaJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Wang <zyytlz.wz@163.com>,
	Dikshita Agarwal <quic_dikshita@quicinc.com>,
	Stanimir Varbanov <stanimir.k.varbanov@gmail.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 6.10 393/482] media: venus: fix use after free bug in venus_remove due to race condition
Date: Tue,  8 Oct 2024 14:07:36 +0200
Message-ID: <20241008115703.876803329@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -426,6 +426,7 @@ static void venus_remove(struct platform
 	struct device *dev = core->dev;
 	int ret;
 
+	cancel_delayed_work_sync(&core->work);
 	ret = pm_runtime_get_sync(dev);
 	WARN_ON(ret < 0);
 


