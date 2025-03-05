Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8192719C542;
	Wed,  5 Mar 2025 18:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198021; cv=none; b=lS0r/yQG/6+F4xA112jer8UL+H+8Pjl9PFg5LRqeANIpfGhmbIhdiGdqsjM2LDYvnLi+JIZG0talhesJLJdoCja+OAq6OqrZHhkhyRZjvsoDbmwUYo8ULd75mdVciCB8D/rXL8KmapgkFPxAmTjWaDg3WmZ2CuKwL38SHLNDYJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198021; c=relaxed/simple;
	bh=BkvhtDEdjGxim9O4X1tUGbMLm8wmmURCPaM75AFTIMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qOuRTQX8wbcLwah9NlB+EkLkRCJXmvpF+l2rqwhACvBK3y8EjBqsxp02gS6nxudp8y2AeMTm9suB/oRBjIGanIXIp8uc4csdGCG9j5ySaOYTSvlVC2QlscYjCmOuKAzeAhzhydcCCQFhu3MptH1J0J8VAPrLL7Q2EAxJbZzEebU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CP0qKp3h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CP0qKp3h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3CEEC4CED1;
	Wed,  5 Mar 2025 18:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198021;
	bh=BkvhtDEdjGxim9O4X1tUGbMLm8wmmURCPaM75AFTIMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CP0qKp3h9deg7mBoUv5Ealz+PinU8XxzVYxGz87rCqMhqgPYZOS+KRA0np+BVDm+h
	 UU9ZxJNU146DB1qze6IphvYkznuR9FMr8qwXSBedx2Vl8ylo0Fr/PaNVxiHUW3tt1a
	 w4q1pJqnhn5c1bccMTvESkKn/xpmY98ZDisCN3RY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 010/150] RDMA/bnxt_re: Add sanity checks on rdev validity
Date: Wed,  5 Mar 2025 18:47:19 +0100
Message-ID: <20250305174504.220558890@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
References: <20250305174503.801402104@linuxfoundation.org>
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

From: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>

[ Upstream commit f0df225d12fcb049429fb5bf5122afe143c2dd15 ]

There is a possibility that ulp_irq_stop and ulp_irq_start
callbacks will be called when the device is in detached state.
This can cause a crash due to NULL pointer dereference as
the rdev is already freed.

Fixes: cc5b9b48d447 ("RDMA/bnxt_re: Recover the device when FW error is detected")
Signed-off-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Link: https://patch.msgid.link/1738657285-23968-3-git-send-email-selvin.xavier@broadcom.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/infiniband/hw/bnxt_re/main.c b/drivers/infiniband/hw/bnxt_re/main.c
index 08cc9ea175276..9fd83189d00a5 100644
--- a/drivers/infiniband/hw/bnxt_re/main.c
+++ b/drivers/infiniband/hw/bnxt_re/main.c
@@ -314,6 +314,8 @@ static void bnxt_re_stop_irq(void *handle)
 	int indx;
 
 	rdev = en_info->rdev;
+	if (!rdev)
+		return;
 	rcfw = &rdev->rcfw;
 
 	for (indx = BNXT_RE_NQ_IDX; indx < rdev->nqr->num_msix; indx++) {
@@ -334,6 +336,8 @@ static void bnxt_re_start_irq(void *handle, struct bnxt_msix_entry *ent)
 	int indx, rc;
 
 	rdev = en_info->rdev;
+	if (!rdev)
+		return;
 	msix_ent = rdev->nqr->msix_entries;
 	rcfw = &rdev->rcfw;
 	if (!ent) {
@@ -2077,6 +2081,7 @@ static int bnxt_re_suspend(struct auxiliary_device *adev, pm_message_t state)
 	ibdev_info(&rdev->ibdev, "%s: L2 driver notified to stop en_state 0x%lx",
 		   __func__, en_dev->en_state);
 	bnxt_re_remove_device(rdev, BNXT_RE_PRE_RECOVERY_REMOVE, adev);
+	bnxt_re_update_en_info_rdev(NULL, en_info, adev);
 	mutex_unlock(&bnxt_re_mutex);
 
 	return 0;
-- 
2.39.5



