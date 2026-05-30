Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BB3B33A9DA;
	Sat, 30 May 2026 17:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162428; cv=none; b=t3E8aZ1V92h71JjQ7Gc4DOwJFsa7vQgVvveJOGZGvemRiLuOh53ptYDECqYezpuS8l+eIfP2JH1IxD6m/3GPWc0iTM13T/g6kM3qnlXWwWAZfoNtKAg82Db2t9XK/gdXrPqoMOnAYnqIfSsUbXlb0ZDSxLmMAmFbCcDaMGX8wL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162428; c=relaxed/simple;
	bh=CELVMKlXoPoU02QU/nhuDJYpiXoNViyi7XNoYPaqVA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VDVDranLrNNjVs2HYCXqzGKWdY6Trol9rY182fSRLWtBneGR5bykWxzKNMA99mIw1VYdR3Q8FMUcK4XX/GK2oRO/wHzIvNG87EUkOa/RHugM5159uyr5kVLu90PYLh0LRpR5/pW3AfI9GfQoP6S2rRbhPI53A6FDHAgIXqRphqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JxVyvTyp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JxVyvTyp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D30581F00893;
	Sat, 30 May 2026 17:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162427;
	bh=R3uIP4THabFYL2conYFNOKgg2pDAYK//AqhgjOQJKd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JxVyvTypD23BBM2qB0PdnGI29ExxCZGHYbrLa95QEdCG+n8jzDPsJXGayrDW0Kwq+
	 OKQUHAbqE7++Ozi0iNwch1ynxNcrBb2Cm6t8586u0Qzb9qt8hiVBoFAl+Fy9YxmLnX
	 2ScZ4EleLghn7sHUbV55ZmjnFrhiS2PsJIYaHP6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 901/969] firmware: arm_ffa: Skip free_pages on RX buffer alloc failure
Date: Sat, 30 May 2026 18:07:05 +0200
Message-ID: <20260530160325.593018001@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Sudeep Holla <sudeep.holla@kernel.org>

[ Upstream commit 09527e2c534911619d7e098729711100290bc3e1 ]

If the RX buffer allocation fails in ffa_init(), the error path jumps to
free_pages even though no buffer has been allocated yet. Route that case
directly to free_drv_info so the cleanup path is only used after at
least one RX/TX buffer allocation has succeeded.

Fixes: 3bbfe9871005 ("firmware: arm_ffa: Add initial Arm FFA driver support")
Link: https://patch.msgid.link/20260428-ffa_fixes-v2-2-8595ae450034@kernel.org
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_ffa/driver.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/arm_ffa/driver.c b/drivers/firmware/arm_ffa/driver.c
index e1e278d431e97..f7c72fcc9b5e3 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -816,7 +816,7 @@ static int __init ffa_init(void)
 	drv_info->rx_buffer = alloc_pages_exact(RXTX_BUFFER_SIZE, GFP_KERNEL);
 	if (!drv_info->rx_buffer) {
 		ret = -ENOMEM;
-		goto free_pages;
+		goto free_drv_info;
 	}
 
 	drv_info->tx_buffer = alloc_pages_exact(RXTX_BUFFER_SIZE, GFP_KERNEL);
-- 
2.53.0



