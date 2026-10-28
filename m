Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210905;
	b=4+oi8SWqrl32q1C3plhSwQ98XJ68KNXemkljdVFCyEo1tiEV0Q0QQeLKwaj9OCIBXiKi
	 aNObZP+9QrB2J+H11iO3q8vmrDdWh8ljFTDToq0pdLViVj9DbocV5XVqXDbojY3pKEzb8
	 qPeuVdQm/KowrLcRc7fufnqvmQej4i9Px5R5nsjzK9RW9iArFxay6Zdgwm6xvdBfozpub
	 KLRev544QBRb+mnbsscvl5zeASjicMpJhD61j+u+2ekV/1nc/8eFh666T88X/pIfL97wI
	 QiZAdkTFxzIfEmcToYKFXUT6fiwbKAqtGqXll/p26LLIYy0NJDGE2Rl7KKcccynA0/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210905;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tPejFgXIcjqIvRMBl4iIbugLnjuKR0ASNp1EEC0zTHQ=;
	b=xP2WpzwHgeex5uVWrKDYwYEPFE8U3eNTzxLNUZK4fFQfKmE16OV7O61FjqMzLWVwrA7e
	 uIpaQnSeYdwuuIROpSVLZOc5oXFexEpzFfO7yKQe0pVGCmT8zreCENEXqxf/XY/sI9o0D
	 LWfi9JK/eV5iBbMwblr6CY1qVNM1naK+1FUPWsfewLizSmzb0SE8HiOfHo6BRWo2qusa9
	 2c3Z0Ocw8pNvPS6OY6FVx6gzNnMkr07wi2GViLQw+zafMD4DENAy9L2BMg3QRbZ4ciUfl
	 CEXxzdTy3oDjLNAovKXiCaZAhcE3DE3+k7boI0DuGgG5HoaPvlv12FzNHdtKKGGZDBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VwiPRxh6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17703606A31A;
	Wed, 28 Oct 2026 18:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VwiPRxh6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 686941F01825;
	Wed, 28 Oct 2026 18:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210904;
	bh=tPejFgXIcjqIvRMBl4iIbugLnjuKR0ASNp1EEC0zTHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VwiPRxh6dzYBvC3MeaLUROznA94UQvePbYoV/pVHvzDaKu+UcpaYNvZioYhbBA389
	 GDtrUcqy1CZKDBBkpqiOAearLnNq5A0kVGifBj1mmcGX5RnZX8Jmdde6tRflgiGc2T
	 IXTkLhqTX1KpWTuY7DP72m6J8tnVydRrCq0cDr54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imre Kaloz <kaloz@kernel.org>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 191/571] drm/radeon: Read the VRAM VBIOS signature with readb()
Date: Wed, 28 Oct 2026 17:55:38 +0100
Message-ID: <20261028170012.542246206@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


