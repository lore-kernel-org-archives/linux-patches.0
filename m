Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 747244F3EB0;
	Tue, 13 Oct 2026 12:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894972; cv=none; b=NltNAwLKLlZe7T7dV+t6Hd6YPWahO0To7ChQkFi158zTrdfXLlnwnw9cvE7p7ozTVUw76nf5HZ7pl81EGmSvGM+KLKh9UOgeGPJdlU8K2dLJ3WrPWIlOkULRfXKU2V6G1Za2ggVq6IPtAisNHqzOGrv0ZVTCQP3VvvDlhU3pHHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894972; c=relaxed/simple;
	bh=bzDdk9cgofP1OahgFRCxMadDiCGwkkUp5MO+ksWCFtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=heMpskt/mnu4h3vS/eHKYhwGtW2TxhYVk+zu3h6u93FRQ++rTvsPFKRELvfKbDyp4oDXobJ/m3k0PVlo2SygKxC4J0i35CUbC1JQs5gWCOQRS/iUeHhf64iLEfVvQut6Oe7rlKGt4vpXMDnXhwgR3Iy3P97xo17mU5QjPiLEH0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZlA/T9S1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZlA/T9S1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D34231F00898;
	Tue, 13 Oct 2026 12:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894971;
	bh=uHPg40WvYJDYY/BoxX89HpbA9dm7XTH/sYfaUV3pbQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZlA/T9S1mqoDb1DtY8CBE6UdIHqa+d1yWF7dSKdEtZ5kN8ix4XGD6FvLcyxdAoMs5
	 t36aHWmFTB8g158mohEVC7VQr6/VBzE7iK0QyR6e0Ng0Vhzx5uOfPWbqLxba1Q7gLe
	 vAhMk+VWApndeXbSO0CGxv46ZPSLoTMInj8reFH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imre Kaloz <kaloz@kernel.org>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 117/497] drm/radeon: Read the VRAM VBIOS signature with readb()
Date: Tue, 13 Oct 2026 13:34:44 +0200
Message-ID: <20261013112910.667354161@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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


