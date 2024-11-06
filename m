Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0DED1DEFD3;
	Wed,  6 Nov 2024 12:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895059; cv=none; b=ofaE+mv1MxZGOBx54nSECFPVIOQ0LqSD196I8fv8BgVkKRCQ/S/+OAAmSkTLIq0yNcwQXW7C//zsA2CrECNAIjKj1pldID7qM6WTXcwiqdCcTlhikMFZi/bXTx42N8AEg01snZfcHMfp0TwKlrPTCWsaIROv9WC/DYuJ8n/EaFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895059; c=relaxed/simple;
	bh=5UyWsTtuSpXq1KXKUCnRr9NQQy1wKXOQdzdxHOWSkrw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZQogJq3kpKVEhP6f2QlV01Zvlw2H/v9RmM9AuANMAxlVb+bSOdQDULE5rbmP6FKY4Dfc7OtevWSLW+e4ORSCgTNjMBxk0Evh/dqmMvQfXt7k/N4RkAV5MCEFw+/tFsIeO8rrs1oGBTrOkHPoJkkhjEmh+1uq3TMQGd1b/TzkUdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CMVzaXbs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CMVzaXbs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 371CBC4CED2;
	Wed,  6 Nov 2024 12:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895059;
	bh=5UyWsTtuSpXq1KXKUCnRr9NQQy1wKXOQdzdxHOWSkrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CMVzaXbsp/9oM5Yp0MVq46qQUARhjFemcm/PPaGFY8jdnBrufgXCF/fOEfitNNiOS
	 w7NC6cOmC+VwaPDd4uV+aCoN6P5kAc+3u0dUYSibYdARMqsKHVulyPXsThZTPwTCTh
	 lMVYdUdaZhuc3JwdBN+cj+eUbDDZ7K1iq/NJu+H0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 055/350] drm/radeon: properly handle vbios fake edid sizing
Date: Wed,  6 Nov 2024 12:59:43 +0100
Message-ID: <20241106120322.248344364@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 17c6baff3d5f65c8da164137a58742541a060b2f ]

The comment in the vbios structure says:
// = 128 means EDID length is 128 bytes, otherwise the EDID length = ucFakeEDIDLength*128

This fake edid struct has not been used in a long time, so I'm
not sure if there were actually any boards out there with a non-128 byte
EDID, but align the code with the comment.

Reviewed-by: Thomas Weißschuh <linux@weissschuh.net>
Reported-by: Thomas Weißschuh <linux@weissschuh.net>
Link: https://lists.freedesktop.org/archives/amd-gfx/2024-June/109964.html
Fixes: c324acd5032f ("drm/radeon/kms: parse the extended LCD info block")
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/radeon/radeon_atombios.c | 29 +++++++++++++-----------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_atombios.c b/drivers/gpu/drm/radeon/radeon_atombios.c
index 0d11d6d1f5f0a..317843bd67d93 100644
--- a/drivers/gpu/drm/radeon/radeon_atombios.c
+++ b/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -1727,26 +1727,29 @@ struct radeon_encoder_atom_dig *radeon_atombios_get_lvds_info(struct
 					fake_edid_record = (ATOM_FAKE_EDID_PATCH_RECORD *)record;
 					if (fake_edid_record->ucFakeEDIDLength) {
 						struct edid *edid;
-						int edid_size =
-							max((int)EDID_LENGTH, (int)fake_edid_record->ucFakeEDIDLength);
-						edid = kmalloc(edid_size, GFP_KERNEL);
+						int edid_size;
+
+						if (fake_edid_record->ucFakeEDIDLength == 128)
+							edid_size = fake_edid_record->ucFakeEDIDLength;
+						else
+							edid_size = fake_edid_record->ucFakeEDIDLength * 128;
+						edid = kmemdup(&fake_edid_record->ucFakeEDIDString[0],
+							       edid_size, GFP_KERNEL);
 						if (edid) {
-							memcpy((u8 *)edid, (u8 *)&fake_edid_record->ucFakeEDIDString[0],
-							       fake_edid_record->ucFakeEDIDLength);
-
 							if (drm_edid_is_valid(edid)) {
 								rdev->mode_info.bios_hardcoded_edid = edid;
 								rdev->mode_info.bios_hardcoded_edid_size = edid_size;
-							} else
+							} else {
 								kfree(edid);
+							}
 						}
+						record += struct_size(fake_edid_record,
+								      ucFakeEDIDString,
+								      edid_size);
+					} else {
+						/* empty fake edid record must be 3 bytes long */
+						record += sizeof(ATOM_FAKE_EDID_PATCH_RECORD) + 1;
 					}
-					record += fake_edid_record->ucFakeEDIDLength ?
-						  struct_size(fake_edid_record,
-							      ucFakeEDIDString,
-							      fake_edid_record->ucFakeEDIDLength) :
-						  /* empty fake edid record must be 3 bytes long */
-						  sizeof(ATOM_FAKE_EDID_PATCH_RECORD) + 1;
 					break;
 				case LCD_PANEL_RESOLUTION_RECORD_TYPE:
 					panel_res_record = (ATOM_PANEL_RESOLUTION_PATCH_RECORD *)record;
-- 
2.43.0



