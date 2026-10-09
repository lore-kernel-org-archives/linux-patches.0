Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D15EE4E3252;
	Fri,  9 Oct 2026 14:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555932; cv=none; b=HqwFbf2uAeKsfLZJAd5UY+BdNEYloujdtQFRGnfWVunmElDuz/lt3ZTYXYJhQAGDcaq3ib7gUmwnAT5bCO0It93dnlu6dwwuMqxgIc8bfMQCYNEEyCgMs4IsRU/tCZ9+ib0p24USHOIB7/2MlEP3cIDbYJQTGOBGUdLuNzTxDmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555932; c=relaxed/simple;
	bh=ZBtSOlFREmi/IiizaeNIt1sf6O1dHYkqECZTOE/Q+hs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G+5R5lbhdJBM9A0wCFPPcHXawI2neu5uYkaPHpi+BbPsOmybJcywA4TtOSPxB6pDmoX63Uq3GbwQQlg+jt07bFmTCQxpKzbMgmLsjm5bCI1SFzcHLTMDFuh1DhsR5CY5QlHsN0mgSO2BZbKBKKzREJb4gIEyQcv3edYpgyGRskw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0/tSfWJJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0/tSfWJJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30F641F000FF;
	Fri,  9 Oct 2026 14:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555931;
	bh=twu5/N9CPzADcyiaBF3v2DO4TzXUKzGQcun/u+a9AZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0/tSfWJJLuFdyuQdosSWPTInJfJOiIrBdLUEWmbcavEPa/+wNUJ5Ab14DlHXb49gl
	 l+UGg1H8GYP4byfh1hKgbDHceweoUgFPf+LfdfsCh8Ts396CKGkYvdI7mTgSZlttOx
	 MyOdOimHiYDcf33gFqb8YtaFo+H2YkqMkt/E8PAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imre Kaloz <kaloz@kernel.org>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 141/403] drm/radeon: Read the VRAM VBIOS signature with readb()
Date: Fri,  9 Oct 2026 16:08:22 +0200
Message-ID: <20261009140955.371793155@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


