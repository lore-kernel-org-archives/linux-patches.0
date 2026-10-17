Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54BD33B71D9;
	Sat, 17 Oct 2026 17:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256450; cv=none; b=J67VfTVgyIEo+wBJ+q4HGBIX4B3LdSQlI1xSdfS3oiJIFBjPkgtmbOWGsN96aizTTPSFo29kiEwolnTl3nLoaTiOi/YCTDnaiOUHrLXRM3sM7Qi17RaJ4Kk9QB+TYj6KNZq5QqFkS2ClyofgXhixkqEyRRiK3U3soZAi8nEWfvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256450; c=relaxed/simple;
	bh=sYA2w6+BUoKn4jzc/3iuQUodJvUVV/pB2tu7zDCKIpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LY+KTnLrbRmtLPt6/W7DgVnFnCvod5DnoEHqp1MwEDy7uGNcDFaKJW5sDqT5IGZiwSO85Y8e4v24F8o69vtZo0EegbYlSW3Odyacp/fyq1v0lDYB5afQhsuhp2UJGU7MyY07BYSNv7zoFK8qcn/Htoc6+EVNCjnGCVrXLl77Ksc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xC8A0+TC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xC8A0+TC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C6F21F000C4;
	Sat, 17 Oct 2026 17:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256449;
	bh=NRUOqiU11sbyEibhzYrA72ZiwWPxE27X5qxpNDriZ+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xC8A0+TC76p5pQkMQcm1yw0FGGleK9LEhdJ538JNSyL0Cp0ZFPo+iKP3fTbbrKv6l
	 DwsSPsTP/91zuENK9ADbHJD8AgnXgp7efPGHdS8DIVMqeRDb1Ydi7lKScU+ZNhkrea
	 ipWK4ya1jNd+B2mQYv97uQ52dwSLYO5i/0tXBn+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imre Kaloz <kaloz@kernel.org>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 0239/1674] drm/radeon: Read the VRAM VBIOS signature with readb()
Date: Sat, 17 Oct 2026 17:41:51 +0200
Message-ID: <20261017160437.268289825@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


