Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2E081DFE1D;
	Tue,  8 Oct 2024 13:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393911; cv=none; b=rNCocw/MhIRSuqotq/vPBCJwDU4+IMZSJpe2963s1Hln+PZYJqxQIM7pEsr3IfNXAIRBFTQGfDJ16cYUAZAaEzkiC8Xm5/3q6UYw5pY4bxFJJfWP0sAMrbZwP+8fzFadHTBUfz1tba0Smlh1SK4YCaGbHpU1dM/3unuAR8e4SMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393911; c=relaxed/simple;
	bh=2G6GXZ56OeyJSDKRzoQMWs7gpauEYqhxsU93t5BCXfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NceSI4v2krDL8HZFcJfDXsZVit5eWY9cQCkc2f1U25qpMKVlYZAxyDCL8E/S7bsqE3d9m7DPeXHNtZB3qM/oxtfhndqECgVI3+L5U624rzoIpwawei8h2rH0BFro891riVIFkeqtqxG8CGEngztx/8YO9jmAS/RAO1iGsQ8nrpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=osDFSe3F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="osDFSe3F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1E95C4CECC;
	Tue,  8 Oct 2024 13:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393910;
	bh=2G6GXZ56OeyJSDKRzoQMWs7gpauEYqhxsU93t5BCXfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=osDFSe3FmbmN77zbAPRkwiqjzXKveiJnAJzlT104Vv6b/2UunKlpgeAzYjg4tzvWQ
	 P7xxD9pGXITljfnJW33SHC41N9nrjzEcQCUdlIG3Tb04qNi6njo08X2ssl4aJCrx8h
	 oY6UjEhuSPMqd8DtvCx/QxgjGgnUXrAXlObkH++U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Wang <zyytlz.wz@163.com>,
	Dikshita Agarwal <quic_dikshita@quicinc.com>,
	Stanimir Varbanov <stanimir.k.varbanov@gmail.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 6.6 289/386] media: venus: fix use after free bug in venus_remove due to race condition
Date: Tue,  8 Oct 2024 14:08:54 +0200
Message-ID: <20241008115640.758681542@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -424,6 +424,7 @@ static void venus_remove(struct platform
 	struct device *dev = core->dev;
 	int ret;
 
+	cancel_delayed_work_sync(&core->work);
 	ret = pm_runtime_get_sync(dev);
 	WARN_ON(ret < 0);
 


