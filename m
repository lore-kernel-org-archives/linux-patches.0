Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7242D26F45D;
	Tue,  8 Apr 2025 12:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114864; cv=none; b=Yvhkk6jHZ5vebW6/srr1h4Ff5DvtWY4O0NL/qZS0fxFtkmKxnou+LERL+ZnzF8BOPoOHc/5ki1kJGXX9rMjERElMSMzlBtmE13ZZzOPQhXXK3tyBH1uYTEZ3H8bvLosrvahLXadC9n15+PcADlgpw1l3xeLr6B/4UIF5OMrDLXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114864; c=relaxed/simple;
	bh=Lzm6MFlljiPuzAr+qA6ZW10s+vELuQHD9ki3naHRWJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UlNBsm4NKtqKTZLq2yd0Xt2s6kHoUc4msT1cgTdIVcgOwfsC7p67kw7K5cE0PdqRsIADkO+stDhL/WmNwvrxeFs3bjTiLVbSnCTkvC+KUCRJLQo8ar7i2YmeWOfDPeETcS86vpMFHNkHE68byvMqWyu88XMgwC1av4EObcDQeT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EZB+ogmW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EZB+ogmW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98CA3C4CEE7;
	Tue,  8 Apr 2025 12:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114863;
	bh=Lzm6MFlljiPuzAr+qA6ZW10s+vELuQHD9ki3naHRWJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EZB+ogmWv1AjaxOz//yGs2EZkr3BEZtIK8FSby+QbOzODNp8TasoNufbJrA2BM6Gv
	 ZSd3oG0arm90lF9N21Dg5lR+THdvhbuIFde55XCnfDv/lbUyLj93pPFW0Rh5imHsrA
	 EhWtWbxAviR2CDK3pIQIDVHl/tEKezIgYCpAo9mo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <wahrenst@gmx.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 264/499] staging: vchiq_arm: Fix possible NPR of keep-alive thread
Date: Tue,  8 Apr 2025 12:47:56 +0200
Message-ID: <20250408104857.803388767@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Wahren <wahrenst@gmx.net>

[ Upstream commit 3db89bc6d973e2bcaa852f6409c98c228f39a926 ]

In case vchiq_platform_conn_state_changed() is never called or fails before
driver removal, ka_thread won't be a valid pointer to a task_struct. So
do the necessary checks before calling kthread_stop to avoid a crash.

Fixes: 863a756aaf49 ("staging: vc04_services: vchiq_core: Stop kthreads on vchiq module unload")
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Link: https://lore.kernel.org/r/20250309125014.37166-3-wahrenst@gmx.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
index e2e80e90b555b..d3b7d1227d7d6 100644
--- a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
+++ b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
@@ -1422,7 +1422,8 @@ static void vchiq_remove(struct platform_device *pdev)
 	kthread_stop(mgmt->state.slot_handler_thread);
 
 	arm_state = vchiq_platform_get_arm_state(&mgmt->state);
-	kthread_stop(arm_state->ka_thread);
+	if (!IS_ERR_OR_NULL(arm_state->ka_thread))
+		kthread_stop(arm_state->ka_thread);
 }
 
 static struct platform_driver vchiq_driver = {
-- 
2.39.5



