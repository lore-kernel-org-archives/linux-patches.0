Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D57C937F31A;
	Thu, 20 Aug 2026 15:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239558; cv=none; b=sF6lT+TDLWzvFwEej0X+hkTwrAAFzGInOpHY29YaxKy9IR5RzmTfWFSjdW2NfV/3mzPb2JJuoEbdMQckWzSlwXR0inXaAF0EJWHDpdXXt5bbYcpgi0UhWlrIE2LRL+2COBLttz13oTeSsYaFTUlECkgFsL3m7aMgJA12GaftyiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239558; c=relaxed/simple;
	bh=F02LzOqcr3+DhjGPI3v2OoBI6YTgz5qYLDSMscXYbR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RYEQ5h4sYn6xuQelfhxqciAoIygfT+DOIanw27XXXt5jpwl0Kt+L1SBluskihJXMVFup34JD2j/YkG7X/W5DGwmIjEAPdrZXJmWJtEdiKYPyXwe3nplVnSW2WvLL5sACfx77IOPHBVjtmYPkskP/kOt3UvCcfbvyWxl1Hz37ONY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qGZksL2e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qGZksL2e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D092A1F000E9;
	Thu, 20 Aug 2026 15:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239556;
	bh=OOOVdR+bUDOvZPHjBeH7m16caZWg1+UzO52msJbVvh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qGZksL2ehuKYS5noETukmvlowG5OSF/zpOHHYfQjfdqSvM37R6HMGcMgkoDaJdAOx
	 7MZUSMAARXGk+gaQxrc6t4eS6vb3BjKGZVs8b0SU1HsSY+8045PpuFLbOpkAQRdbeh
	 A4eeAkbvY9DS5qUJKXV7o9Q4Sri4nCDRCG7ywHfA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Rosca <david.rosca@amd.com>,
	Leo Liu <leo.liu@amd.com>,
	Ruijing Dong <ruijing.dong@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 089/220] drm/amdgpu: Fix UVD dpb min size calculation for H264
Date: Thu, 20 Aug 2026 16:54:39 +0200
Message-ID: <20260820145226.154530075@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

From: David Rosca <david.rosca@amd.com>

commit 21a8084cd76223a13493237e04d45f5226d7cee6 upstream.

This should use actual number of references from the decode
message, instead of maximum derived from level.

Signed-off-by: David Rosca <david.rosca@amd.com>
Acked-by: Leo Liu <leo.liu@amd.com>
Reviewed-by: Ruijing Dong <ruijing.dong@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 64b525edb7e7bdfcdc77883c5e413804e2396856)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c |   62 ++------------------------------
 1 file changed, 4 insertions(+), 58 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c
@@ -645,11 +645,9 @@ static int amdgpu_uvd_cs_msg_decode(stru
 	unsigned int height = msg[7];
 	unsigned int dpb_size = msg[9];
 	unsigned int pitch = msg[28];
-	unsigned int level = msg[57];
 
 	unsigned int width_in_mb = width / 16;
 	unsigned int height_in_mb = ALIGN(height / 16, 2);
-	unsigned int fs_in_mb = width_in_mb * height_in_mb;
 
 	unsigned int image_size, tmp, min_dpb_size, num_dpb_buffer;
 	unsigned int min_ctx_size = ~0;
@@ -668,35 +666,9 @@ static int amdgpu_uvd_cs_msg_decode(stru
 
 	switch (stream_type) {
 	case 0: /* H264 */
-		switch (level) {
-		case 30:
-			num_dpb_buffer = 8100 / fs_in_mb;
-			break;
-		case 31:
-			num_dpb_buffer = 18000 / fs_in_mb;
-			break;
-		case 32:
-			num_dpb_buffer = 20480 / fs_in_mb;
-			break;
-		case 41:
-			num_dpb_buffer = 32768 / fs_in_mb;
-			break;
-		case 42:
-			num_dpb_buffer = 34816 / fs_in_mb;
-			break;
-		case 50:
-			num_dpb_buffer = 110400 / fs_in_mb;
-			break;
-		case 51:
-			num_dpb_buffer = 184320 / fs_in_mb;
-			break;
-		default:
-			num_dpb_buffer = 184320 / fs_in_mb;
-			break;
-		}
-		num_dpb_buffer++;
+		num_dpb_buffer = ((msg[61] >> 16) & 0xff) + 1;
 		if (num_dpb_buffer > 17)
-			num_dpb_buffer = 17;
+			return -EINVAL;
 
 		/* reference picture buffer */
 		min_dpb_size = image_size * num_dpb_buffer;
@@ -746,35 +718,9 @@ static int amdgpu_uvd_cs_msg_decode(stru
 		break;
 
 	case 7: /* H264 Perf */
-		switch (level) {
-		case 30:
-			num_dpb_buffer = 8100 / fs_in_mb;
-			break;
-		case 31:
-			num_dpb_buffer = 18000 / fs_in_mb;
-			break;
-		case 32:
-			num_dpb_buffer = 20480 / fs_in_mb;
-			break;
-		case 41:
-			num_dpb_buffer = 32768 / fs_in_mb;
-			break;
-		case 42:
-			num_dpb_buffer = 34816 / fs_in_mb;
-			break;
-		case 50:
-			num_dpb_buffer = 110400 / fs_in_mb;
-			break;
-		case 51:
-			num_dpb_buffer = 184320 / fs_in_mb;
-			break;
-		default:
-			num_dpb_buffer = 184320 / fs_in_mb;
-			break;
-		}
-		num_dpb_buffer++;
+		num_dpb_buffer = ((msg[61] >> 16) & 0xff) + 1;
 		if (num_dpb_buffer > 17)
-			num_dpb_buffer = 17;
+			return -EINVAL;
 
 		/* reference picture buffer */
 		min_dpb_size = image_size * num_dpb_buffer;


