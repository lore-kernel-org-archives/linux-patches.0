Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F22F21E098;
	Sat, 30 May 2026 18:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165016; cv=none; b=dDgkOd5341sNAF4cemvD5p08Rw0V1vgh6tttqPuiKyOEAcpP9V8y4HDC0CcGo+TD4kdpiImO4zRtJc8DsiTTT+SBTck08k7Uk2yS3S55hpZtVZSaHM42RF0fcFdYMwi6v8ODIIaRuglLCjHrWPBGn08B/rl0IbPOMbBGlxz7kgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165016; c=relaxed/simple;
	bh=8XCTPGlaOcWgUJ4GryYQLVQpAtjN4AS9QU0jGobOIyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V0O5uRVNFyUY1ml/sMfVyB8qV049LQ74K5JqWpp8IGrxVzqjVLDKp6jVZ9KAS/Z8d1NjBnbOCvR3U/VvarYHpavHBaeHADwFof0AzVGw0X6QYNpYdpPLfNiAMAmg9B4ucOGSfAkxsysByNeA3SJnyflls9V2Bnz++fvnKShPtMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TNrtlJ0x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TNrtlJ0x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 024FB1F00893;
	Sat, 30 May 2026 18:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165015;
	bh=Np1kVJrDQdofNI4vb4SYB646+kqy8w85GUqFLp3JVnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TNrtlJ0x6vTpLlrPluf8eOxJTTBpCJ2aSKxyXi1gt13JOGqicxpWv2chrzL5kxPVn
	 9fcxWFu4yhjXnSIJVcN5U3UTWRS3sHfBiLZY6pBMhZdbQJ2XCp9SxYLItaIvaEO9nW
	 LUgjG8RWb4mH7EtgOX973FMhWOfWs9nm9MdhasJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 726/776] firmware: arm_ffa: Skip free_pages on RX buffer alloc failure
Date: Sat, 30 May 2026 18:07:20 +0200
Message-ID: <20260530160258.583884743@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index e4fb0c1ae4869..34351f8c4d6f3 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -687,7 +687,7 @@ static int __init ffa_init(void)
 	drv_info->rx_buffer = alloc_pages_exact(RXTX_BUFFER_SIZE, GFP_KERNEL);
 	if (!drv_info->rx_buffer) {
 		ret = -ENOMEM;
-		goto free_pages;
+		goto free_drv_info;
 	}
 
 	drv_info->tx_buffer = alloc_pages_exact(RXTX_BUFFER_SIZE, GFP_KERNEL);
-- 
2.53.0



