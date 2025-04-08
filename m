Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F37E7269D03;
	Tue,  8 Apr 2025 12:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116726; cv=none; b=jqJNh7H9F45cxjj3Dyp8cdkVRXc8VlpfGC3Kb6V31zT/uxGrFPKKwRoG4k1jSkf0dkLCKVLJ2Q5g9nAXGHNVJMxyVzA+89d6MNpCMKbEZTtoCM0FLX8fISkUlenLyz0/zmIm/dAGu9aEV1SiHyw1RlF16zEq4dV2BMNdDx7Kt18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116726; c=relaxed/simple;
	bh=Jz0fnuvDcRGHFDLuSi55+3d9gS+Mw1ousAjTxKrjMaM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EYT7m054fmgEgV5XLBuTe+BtndH/VtDSFVd9VPKK52SRwYrwScq7ZVR+UjXyus9bBDVeNxPyCV2GCKhSRroiLwbHjZL1PXt4dsKaCMStgIHnJsnO0Qnn/rzphX0wvDAO73L44JP7QjfILFHzci2pZk5CbSBL+ZGSbyraa5N8xAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LDtx0oW0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LDtx0oW0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8496BC4CEE5;
	Tue,  8 Apr 2025 12:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116725;
	bh=Jz0fnuvDcRGHFDLuSi55+3d9gS+Mw1ousAjTxKrjMaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LDtx0oW0Ir4Pb8JsT0GmDEH7kRrempFyS41QdZNlB2OLfItJprYaAeUQJfnjtoNu4
	 QX5h7JFFFrKmDTPEt9ylOO+dtsxSSy4FRudvneSRdTl4SSxxGw4B/ptHBhpQazKnGJ
	 I+mr/MHb6UNmW4yqvEnQDzG+GfbhQ7iPs0pOEKGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <wahrenst@gmx.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 219/423] staging: vchiq_arm: Fix possible NPR of keep-alive thread
Date: Tue,  8 Apr 2025 12:49:05 +0200
Message-ID: <20250408104850.829380038@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index ecf6e9635a10b..97787002080a1 100644
--- a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
+++ b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
@@ -1786,7 +1786,8 @@ static void vchiq_remove(struct platform_device *pdev)
 	kthread_stop(mgmt->state.slot_handler_thread);
 
 	arm_state = vchiq_platform_get_arm_state(&mgmt->state);
-	kthread_stop(arm_state->ka_thread);
+	if (!IS_ERR_OR_NULL(arm_state->ka_thread))
+		kthread_stop(arm_state->ka_thread);
 }
 
 static struct platform_driver vchiq_driver = {
-- 
2.39.5



