Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B57E3FD96B;
	Sat, 12 Sep 2026 10:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207305; cv=none; b=Yo/91fYG15QIm08ORcHz6eHbf1p0YH00/By0RnoH5Onl+H9T2IfBBmkYclvOYip5ttdDRqRlI5NE5Ct1NdBMqbJFRKXTTZKT4EVy/9HPfmBUgyZ2CiX0HXO5YjvQAIsNVxbmotWaHDq87Gw6v2dQ6xszcQUYnb/Luvdzdn7jjxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207305; c=relaxed/simple;
	bh=LxadSw0ko/LSERcsz4A1TN9MpPeurqHVJERc738mg3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nOnJRXK5IT8AnUzdcdIJ6+6xe92rMJKufrBCh2RUoSW6AMYNGCiMKUuDCTTnuqk9iUTYFvRbfCWiaYox5Mr6u+0hj5fMA6pqXk3oQfdXZlmx6B07TnBeVSkDB4PAhkzg08hVEz0NDM4yDj4N2ZFteR7Vo+fvr6wogb7tgJTkHk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uV8SLdy4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uV8SLdy4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB5291F000FF;
	Sat, 12 Sep 2026 10:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207302;
	bh=2D1QUPPCOsip/FJxnd/DUruIRQf/MSFuDAky3+KLbLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uV8SLdy4ncPxrJPk51MBN9KTP6KwoalL4bdOZ4XVLxiSR1yc9wtv+KQWnXjjFVEUb
	 D6EBoiICWEQiHeQf+ZcqJGPkwjXQ9AMj/L4dtcALskz94qDbzNyQ6IHwmHAcwOlwPM
	 rn+jTTdDIsgaXhL/c88xW3X/vwuhKsNJ9zgxm46k=
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
Subject: [PATCH 6.18 0368/1518] rpmsg: glink: fix deadlock in endpoint destroy during driver detach
Date: Sat, 12 Sep 2026 08:42:17 +0200
Message-ID: <20260912065631.795438383@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index df9e98d76847b..7605fde9e6789 100644
--- a/drivers/rpmsg/qcom_glink_native.c
+++ b/drivers/rpmsg/qcom_glink_native.c
@@ -1418,9 +1418,6 @@ static void qcom_glink_destroy_ept(struct rpmsg_endpoint *ept)
 	channel->ept.cb = NULL;
 	spin_unlock_irqrestore(&channel->recv_lock, flags);
 
-	/* Decouple the potential rpdev from the channel */
-	qcom_glink_remove_rpmsg_device(glink, channel);
-
 	qcom_glink_send_close_req(glink, channel);
 }
 
-- 
2.53.0



