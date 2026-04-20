Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BF6833B945;
	Mon, 20 Apr 2026 16:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701455; cv=none; b=fFfKwBwFzveWSrYHz3W3sP5F/QscCbtF7bX3JxxZ8Me0Lv8qI0t29OrqYeHJUCqzJaeyKefxhlO+t5My3HUz+n5RjsMWFoxkawkl9QBmXsc8Kc11dn09QmFJur9clIQRKbNyxTzu9BIFIFehhGonFniTvuJ0iyVN6fcK6nFDE3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701455; c=relaxed/simple;
	bh=PVV6ho+zQw/zuenkYBmbS67DwK8+EzujwQFGK3MbRVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WKO/rn1QI9Bc12jVab2c9W0ANBFuMGUJmEUA7HJze2V7bjZ81qzkpkNO7S4l4++z/1KAszyYSbY9zBujF7SjWzikbttU9Orb9SlHjBBTiiLd0WMXKIxDI5ZP/y3l9P9gvDTyztklOs8sjPABsTEBRnzUVRakXoUQKG/X10DM/Uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zBgGVjwv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zBgGVjwv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D60C0C19425;
	Mon, 20 Apr 2026 16:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776701455;
	bh=PVV6ho+zQw/zuenkYBmbS67DwK8+EzujwQFGK3MbRVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zBgGVjwvX9zjQS61EHCSisQmWdY9y3VzCKZZnOpspWv371Ytzl+92Mc99VAir+iT6
	 F6q7KQMRuldVNIUQ1uXxe2Mz0tJB/r1OSyVgr1HWDUKo6wp8mw49pMrOfEg0twVKYn
	 m1oKHhPkE1JXwKdxqDUOwFXBlNfu3cbcLEZn/ATM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 087/162] Revert "drm/xe/mmio: Avoid double-adjust in 64-bit reads"
Date: Mon, 20 Apr 2026 17:41:59 +0200
Message-ID: <20260420153930.185050090@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153927.006696811@linuxfoundation.org>
References: <20260420153927.006696811@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit 8f6848b2f6eadd903d29572ba0a684eda1e2f4ef.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_mmio.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_mmio.c b/drivers/gpu/drm/xe/xe_mmio.c
index 449e6c5636712..9ea0973337eda 100644
--- a/drivers/gpu/drm/xe/xe_mmio.c
+++ b/drivers/gpu/drm/xe/xe_mmio.c
@@ -316,11 +316,11 @@ u64 __xe_mmio_read64_2x32(struct xe_mmio *mmio, struct xe_reg reg)
 	struct xe_reg reg_udw = { .addr = reg.addr + 0x4 };
 	u32 ldw, udw, oldudw, retries;
 
-	/*
-	 * The two dwords of a 64-bit register can never straddle the offset
-	 * adjustment cutoff.
-	 */
-	xe_tile_assert(mmio->tile, !in_range(mmio->adj_limit, reg.addr + 1, 7));
+	reg.addr = xe_mmio_adjusted_addr(mmio, reg.addr);
+	reg_udw.addr = xe_mmio_adjusted_addr(mmio, reg_udw.addr);
+
+	/* we shouldn't adjust just one register address */
+	xe_tile_assert(mmio->tile, reg_udw.addr == reg.addr + 0x4);
 
 	oldudw = xe_mmio_read32(mmio, reg_udw);
 	for (retries = 5; retries; --retries) {
-- 
2.53.0



