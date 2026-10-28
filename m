Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208613;
	b=WiA8Py6I+Iry/O9j9k9VCsP1nQgqkQtHVyeZb6gQxQFCZR3Y5G72yVucK+Vp3RqLu6e9
	 Xsy4MBP+QeWfUYjakve5KuxaQNdNyyL06F9tS41pTBGna5AnHalmf7NjVYJMj55oizcFq
	 AI6QTky1KP3t46mRYjeaTBZ2rH9ZqOYGYDWT4PJkcWu7UDm4kPRwjPZJ0tB34+TeosCd3
	 K1ALiqGeesYAusokuF2QXwIZfqjUweHH2c92XDMkgixRdaTrDixMwXOVXky1gLcibfsod
	 agbapb3BIIfg9SDiEckq/FOO+8LxVW1zV6Xp2zXGjHC8C8AIaf0bhhMCmoatplH6DuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208613;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qPLFmXDjpIydrUYQHHbcf9pYN7fc2SbYKYjECf/7LEg=;
	b=DvAdP68wy5/B1yumFuEPi9lLnUCPO1y5Lrcbb3ez9+SL7YK6dXnKyDtDZJf0zj4fu4dE
	 BnFIV+bqaWd4qWW2MZnhKFOzs6W7gCKF4w96iuqrjIKzQOz0lfPWiw40YqmUDL5lRB5I3
	 waB9c51MNahYIGAOOUiHezVottpwXCkqIKFYxQNRqqZ2V7BiZ2n23DNM0B1P6OL85iG4v
	 xoJjR+z7GGyFgRjBBVcGChcK0/1ZnNk9SI/ofksMtICSdH5+ER4coZzQC+8V2T/BtlELk
	 pXgtAoVyAzNAm3tZ0gs8t4pM48mUr+vaByfDLJq3wWgCNqfY2ATi2QZqlrFcH996KFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zF5AIJAf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A046606A31C;
	Wed, 28 Oct 2026 17:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zF5AIJAf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA1B91F01825;
	Wed, 28 Oct 2026 17:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208613;
	bh=qPLFmXDjpIydrUYQHHbcf9pYN7fc2SbYKYjECf/7LEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zF5AIJAfB2CMOeoUV7axVl49wReoOaCErpg5jdtGbYMIv+j67GplsKB9Uy/sfNFWQ
	 C/wdHt0iy3HyoqJtnd2Kxtam+1GFlK1LGLd9itp5hF071LGIRlVUa/C2J5vfkPFfib
	 k1jZ6dB8oPKHnpV7ODbrjLQ2/R6KAaAQUivEb1M8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imre Kaloz <kaloz@kernel.org>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 180/516] drm/radeon: Read the VRAM VBIOS signature with readb()
Date: Wed, 28 Oct 2026 17:55:32 +0100
Message-ID: <20261028170007.768419914@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Imre Kaloz <kaloz@kernel.org>

commit de1eab13efef83fd2b76f4688de5bf672644596f upstream.

igp_read_bios_from_vram() checked bios[0]/bios[1] with a plain
__iomem load, which faults on sparc64 before the copy runs at all.
radeon_read_bios() already reads its two signature bytes with
readb() ahead of its own copy; use the same accessor here, keeping
the check before the allocation.

Fixes: b442962a9e82 ("drm/radeon/kms: add support for "Surround View"")
Signed-off-by: Imre Kaloz <kaloz@kernel.org>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 09155b8932e5013dbce0f5cdff7d75264a279ee5)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/radeon/radeon_bios.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/radeon_bios.c
+++ b/drivers/gpu/drm/radeon/radeon_bios.c
@@ -49,6 +49,7 @@
 static bool igp_read_bios_from_vram(struct radeon_device *rdev)
 {
 	uint8_t __iomem *bios;
+	uint8_t val1, val2;
 	resource_size_t vram_base;
 	resource_size_t size = 256 * 1024; /* ??? */
 
@@ -63,7 +64,10 @@ static bool igp_read_bios_from_vram(stru
 		return false;
 	}
 
-	if (size == 0 || bios[0] != 0x55 || bios[1] != 0xaa) {
+	val1 = readb(&bios[0]);
+	val2 = readb(&bios[1]);
+
+	if (size == 0 || val1 != 0x55 || val2 != 0xaa) {
 		iounmap(bios);
 		return false;
 	}


