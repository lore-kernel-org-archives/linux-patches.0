Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EC27374E60;
	Sat, 17 Oct 2026 17:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257743; cv=none; b=VNqg2n7eT/9e26NXRNMcxI6H4bq5Axj26A9T40IE0RhAnQtOC/XVFdFkox/Ftdmejsx5lo3NUCUPHMEZs5zP3k7NSbcEZfkajKFrn3ucHxG+35YN1177HbQ7EJ3ZX0IwAU+aCMGdXqUCDFip6teINY/EPPEUSHRBmqRu4wwbNE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257743; c=relaxed/simple;
	bh=0J7S1YbDb+VJBB+71PRTVw+f5+qrmrfYl0xbkQ3AxaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ivrk3auoaTy/ThTIVFC84XypzoE/gB44O7psSDGUO6P5wouwAxoNscPpofRfBbovw70jrQd0y73PkxKJahw6y+S7WTqqErhOQliVs5p7sNR+5gI8ORmE0ls5OLgb88YceMoXHV5/9yJ3Kks8frdNMjhWC1SVC5kpfSdglVFbDpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OBAiEDY0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OBAiEDY0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD87E1F000C4;
	Sat, 17 Oct 2026 17:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257742;
	bh=i3EYT1b1dTyMuNwr3KPPNdSK3KbrCcF1RG/TYvlJRjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OBAiEDY0EeQYRRYM4xM95UyMI8uQXndbgCIqwa7Co9marDxRNtzb5WG4z6dESjZAW
	 oCQIM9DRSuX2mgxe9ZTiVjtOVLuYTUsaBmrjiOZKEhkLHUfVA+/npCBYjiL9z7AhZa
	 gazb+ixu0G9PhY7hlrzr3dKCBGA1KuqAcIYRuLD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Chung <chiahsuan.chung@amd.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Roman Li <roman.li@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0654/1674] drm/amd/display: Implement bounds check for stream encoder creation in DCN401
Date: Sat, 17 Oct 2026 17:48:46 +0200
Message-ID: <20261017160447.898365089@linuxfoundation.org>
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

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

[ Upstream commit bdf606810210e8e07a0cdf1af3c467291363b295 ]

'stream_enc_regs' array is an array of dcn10_stream_enc_registers
structures. The array is initialized with four elements, corresponding
to the four calls to stream_enc_regs() in the array initializer. This
means that valid indices for this array are 0, 1, 2, and 3.

The error message 'stream_enc_regs' 4 <= 5 below, is indicating that
there is an attempt to access this array with an index of 5, which is
out of bounds. This could lead to undefined behavior

Here, eng_id is used as an index to access the stream_enc_regs array. If
eng_id is 5, this would result in an out-of-bounds access on the
stream_enc_regs array.

Thus fixing Buffer overflow error in dcn401_stream_encoder_create

Found by smatch:
drivers/gpu/drm/amd/amdgpu/../display/dc/resource/dcn401/dcn401_resource.c:1209 dcn401_stream_encoder_create() error: buffer overflow 'stream_enc_regs' 4 <= 5

Cc: Tom Chung <chiahsuan.chung@amd.com>
Cc: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Cc: Roman Li <roman.li@amd.com>
Cc: Alex Hung <alex.hung@amd.com>
Cc: Aurabindo Pillai <aurabindo.pillai@amd.com>
Cc: Harry Wentland <harry.wentland@amd.com>
Cc: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Reviewed-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn321/dcn321_resource.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn321/dcn321_resource.c b/drivers/gpu/drm/amd/display/dc/dcn321/dcn321_resource.c
index 4289cd1643ece..e02920969c325 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn321/dcn321_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn321/dcn321_resource.c
@@ -1197,7 +1197,7 @@ static struct stream_encoder *dcn321_stream_encoder_create(
 	vpg = dcn321_vpg_create(ctx, vpg_inst);
 	afmt = dcn321_afmt_create(ctx, afmt_inst);
 
-	if (!enc1 || !vpg || !afmt) {
+	if (!enc1 || !vpg || !afmt || eng_id >= ARRAY_SIZE(stream_enc_regs)) {
 		kfree(enc1);
 		kfree(vpg);
 		kfree(afmt);
-- 
2.53.0



