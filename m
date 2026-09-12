Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62EBD1FCFFC;
	Sat, 12 Sep 2026 14:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223186; cv=none; b=iHJYSDe5aonHFPHvD5Ecb4M8ySbW5uYjVPBd84zcb0S1VIP5Qh7rSu5vvjCzdPscMOx5dm12Vwxwa+cw/VMKYQoWpSump8BayoV+Y8Wp151GxCr2OWQ4BlZh2SgGbYjMNztTe+Kgn4I2JzBSpJRZwLZ+Kbei7HL02QJIcDtLGNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223186; c=relaxed/simple;
	bh=P5TvWh7HmnAljt2LuT+yy3YZJX9GJCYVNjAQ2n9NEQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mVSMXB1ZvHg+30p2QKZdaF0+5im1fB2hgR96MMnDOQIGaHqUAzb8LeHdbU3Vu5o6C96/MzafJzxvMqySmTNYrJ8QuGn+19r8oXT7qxBMI41k1jF/Zee0MKg3CkqBAWhXzilW4SqXo7LTHxM/4aqbLcQiH/7hXgUePJixGAyWZiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z5o+Bxdp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z5o+Bxdp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC1911F000FF;
	Sat, 12 Sep 2026 14:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223185;
	bh=L836GLWZdSRDsnfyFIqjHvChDRb6OVMNmeum1ncBK1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z5o+Bxdptl5gOtZFjXo1UgeJMZcsOpPxV4pDvV6FYLlTqrTK+QZk+wvkMiHxAxmn4
	 dXpsMXbsZZEQts58mKeXz1e+jBItF/9I5p6ZwHnyL7nhwwARcKQhXob/1zyASP9N9j
	 axi+goeoqa5sIDhfrNOfpXPpqXGU9z90QsyzZxw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Deepak Kumar Singh <deepak.singh@oss.qualcomm.com>,
	Vishnu Santhosh <vishnu.santhosh@oss.qualcomm.com>,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0739/1424] rpmsg: glink: fix deadlock in endpoint destroy during driver detach
Date: Sat, 12 Sep 2026 08:52:51 +0200
Message-ID: <20260912065623.845110979@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vishnu Santhosh <vishnu.santhosh@oss.qualcomm.com>

[ Upstream commit 5a5a48e788e02fd8a8eb7188ce440572d6c12418 ]

During driver detach, the device core holds the device mutex throughout
the driver's remove callback chain.  When the rpmsg endpoint is
destroyed as part of that teardown, the GLINK endpoint destroy
implementation attempts to unregister the underlying rpmsg device.
That unregistration calls device_del(), which tries to re-acquire the
same device mutex already held higher up the stack, causing rmmod to
hang indefinitely.

The deadlock manifests with the following call chain:

[<0>] device_del+0x44/0x414  <- tries to acquire same mutex
[<0>] device_unregister+0x18/0x34
[<0>] rpmsg_unregister_device+0x28/0x4c
[<0>] qcom_glink_remove_rpmsg_device+0x70/0xc0
[<0>] qcom_glink_destroy_ept+0x58/0xbc
[<0>] rpmsg_dev_remove+0x50/0x60
[<0>] device_remove+0x4c/0x80
[<0>] device_release_driver_internal+0x1cc/0x228  <- acquires device mutex
[<0>] driver_detach+0x4c/0x98
[<0>] bus_remove_driver+0x6c/0xbc
[<0>] driver_unregister+0x30/0x60
[<0>] unregister_rpmsg_driver+0x10/0x1c
[<0>] fastrpc_exit+0x28/0x38 [fastrpc]
[<0>] __arm64_sys_delete_module+0x1b8/0x294
[<0>] invoke_syscall+0x48/0x10c
[<0>] el0_svc_common.constprop.0+0xc0/0xe0
[<0>] do_el0_svc+0x1c/0x28
[<0>] el0_svc+0x34/0x108
[<0>] el0t_64_sync_handler+0xa0/0xe4
[<0>] el0t_64_sync+0x198/0x19c

The rpmsg device unregistration inside endpoint destroy is redundant.
In both contexts where endpoint destruction is triggered:

- Driver detach path: the driver core already tears down the rpmsg
  device.

- Channel close path: the rpmsg device is already unregistered before
  endpoint destruction is reached.

Remove the redundant unregistration to fix the deadlock.

Co-developed-by: Deepak Kumar Singh <deepak.singh@oss.qualcomm.com>
Signed-off-by: Deepak Kumar Singh <deepak.singh@oss.qualcomm.com>
Signed-off-by: Vishnu Santhosh <vishnu.santhosh@oss.qualcomm.com>
Tested-by: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
Fixes: a53e356df548 ("rpmsg: glink: fix rpmsg device leak")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260604-rpmsg-glink-fix-deadlock-destroy-ept-v1-1-b8a54ad1e4fd@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rpmsg/qcom_glink_native.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/rpmsg/qcom_glink_native.c b/drivers/rpmsg/qcom_glink_native.c
index 4c7817a7a9903..cc30cae95b116 100644
--- a/drivers/rpmsg/qcom_glink_native.c
+++ b/drivers/rpmsg/qcom_glink_native.c
@@ -1336,9 +1336,6 @@ static void qcom_glink_destroy_ept(struct rpmsg_endpoint *ept)
 	channel->ept.cb = NULL;
 	spin_unlock_irqrestore(&channel->recv_lock, flags);
 
-	/* Decouple the potential rpdev from the channel */
-	qcom_glink_remove_rpmsg_device(glink, channel);
-
 	qcom_glink_send_close_req(glink, channel);
 }
 
-- 
2.53.0



