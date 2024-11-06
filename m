Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCEBA1DF254;
	Wed,  6 Nov 2024 12:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895430; cv=none; b=d06U/vB148B7fwn5wUXaM7x0TMUkHcGIQej0ed/VwFx6RQWw+QoFe2kSBh7+8Tj5ncf+PV6HHOgWusf5MLXdGwjyyhcvSyZ/gMubYr6s7Cpm/jIaUsw4zEKnEaRgmhsWxkwd5w/rDkgUuevaUrGLKAudPFoywDhXC7k8fezHt5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895430; c=relaxed/simple;
	bh=7zKF38gBuyE29DEL1siYIxeN5EtNrKVh8/t7nARVPwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HbIGLUrMuxIXz7YHQQKBqNc6dSuXEwAEmYbnZFUU3QNiGB411zYcxjiRhHM2La78KdoEhkfZOa8IpHIgtsG4Y8rbSoBNsKDUQAPN1zvUXoI6SAzX+eZi/HCTvEoyrghvSjXfd/+r2QoEbSy+zyFHP3EDNbrCtgxnfZwoQnn5fDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N8YF8bx0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N8YF8bx0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1055BC4CECD;
	Wed,  6 Nov 2024 12:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895430;
	bh=7zKF38gBuyE29DEL1siYIxeN5EtNrKVh8/t7nARVPwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N8YF8bx05KeSzt4KYW1Lyx1qdB6DjOrHbpSFbFFsyjbV7kgbmDTmzlM/EBeu7rYV/
	 CnYATNU1tyQKgJozOOlV/I2e6ZrGl9j/e4EqUs/NEeTx/b++snuiLPFnY6+b1Y66Bb
	 E09KBLgfgg71DYn5b54S4UDJ/QDBmzPmhkhVGkd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Wang <zyytlz.wz@163.com>,
	Dikshita Agarwal <quic_dikshita@quicinc.com>,
	Stanimir Varbanov <stanimir.k.varbanov@gmail.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 4.19 208/350] media: venus: fix use after free bug in venus_remove due to race condition
Date: Wed,  6 Nov 2024 13:02:16 +0100
Message-ID: <20241106120326.124322145@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -348,6 +348,7 @@ static int venus_remove(struct platform_
 	struct device *dev = core->dev;
 	int ret;
 
+	cancel_delayed_work_sync(&core->work);
 	ret = pm_runtime_get_sync(dev);
 	WARN_ON(ret < 0);
 


