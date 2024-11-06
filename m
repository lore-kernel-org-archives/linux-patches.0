Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CA111F668F;
	Wed,  6 Nov 2024 13:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898639; cv=none; b=phyj120hHEIvKuFWosk+4MyoBga52/OL6UtNLOny+6qGXw15Rop63ix3AMn/wEHYCIqjElzQx60PpUlNV2hfef/UgQ5D0whZnTvqZPxIDCk+UUvVgF5x2ZKpwua0RLeQEy9+wOtkcaZdxRH4XUQ9NIr8vVf4gf26JHsp7gcp3xU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898639; c=relaxed/simple;
	bh=u0pjIDXfMAYUqcbjLfwmpO3MjLFVSVRJIO4Rjjc8yqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UX7c5GXJxa/nUrSCdMlh5zmq+zoOa0uLd61iyAoRFSyjq8x6B1iqcpu1Fx/9lbyTH9uGrEFHPVDkkl/h3IQbKJuugSRHIMrP8sdWRcJ8tEQCkGr520whpycRlQMmxgi0pepXmvtHxKGK5e2cPmy5H/vb3Jm0iGBoUu72pwn/0WY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A9nunUaS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A9nunUaS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA373C4CECD;
	Wed,  6 Nov 2024 13:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898639;
	bh=u0pjIDXfMAYUqcbjLfwmpO3MjLFVSVRJIO4Rjjc8yqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A9nunUaSMcLi6C8hLj6xc1iUq/aVnf2ftmYXwLWM0wvDOWjlmuuF0QsWMSPg9LO/Q
	 Fxo+sQ99wm6h840rjwhhJBIrlrBvurCjOHgc7Y5F0xr1dD+4RjVmJPBpAlNtFYKQJ2
	 QVkBe888hY/AkUrJzzLAbKyQa/NW44h37aR0cw/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Wang <zyytlz.wz@163.com>,
	Dikshita Agarwal <quic_dikshita@quicinc.com>,
	Stanimir Varbanov <stanimir.k.varbanov@gmail.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 5.4 270/462] media: venus: fix use after free bug in venus_remove due to race condition
Date: Wed,  6 Nov 2024 13:02:43 +0100
Message-ID: <20241106120338.196640014@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -347,6 +347,7 @@ static int venus_remove(struct platform_
 	struct device *dev = core->dev;
 	int ret;
 
+	cancel_delayed_work_sync(&core->work);
 	ret = pm_runtime_get_sync(dev);
 	WARN_ON(ret < 0);
 


