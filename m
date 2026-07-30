Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A64FA30C143;
	Thu, 30 Jul 2026 15:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426511; cv=none; b=X8tsrer5LMj4YGWRszvhkK8OLtDiu3mhpbzI6mCZ+C75nMwDxvqt2leqoJaYhVDrQiKGSrndo9F/pk5XWcDxGASxNvzuRM92w0Au9bhe9nFBQXXXJWYJbtezgLfoqODGDwGw/tQTR1+p6LAFrjo4V/pCPqqGKIcQM9j63ohHoBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426511; c=relaxed/simple;
	bh=3wHPIAoeO3k4+2c1hjxJefe0r0jzQuzWW7Lq7HMnh0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SkEtIObQfIArLaAnKGqpEMrMmgl3HBUsginzkwebIiO6cr2dNyRZBWTyvfU9dtKfrgqI2LXPR8OX40FPAoJhj4Ds4DVb16oemrcRojwNqPjUHttjoVrLl2jsGLeSY4no0CmsC4RB+y9umveetTayMaDBHq3jQ5Ygvh1kNx2RPlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GzLal5N+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GzLal5N+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C70C1F000E9;
	Thu, 30 Jul 2026 15:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426510;
	bh=bbMP478RK6f25uKfx7gOX3IaWFCgWp30MOg1N5T1MN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GzLal5N+5fqg8oFajESFBvKXz0sPqzFG+1Ke7m334Fq1mWNaGCbhzaxEBw5jq84F8
	 D7dtO+/BhhTDaWCXatbT+XqQRFOk+fLgwR2fCeCjON4NK7yTX4zT/WXvwMi29t2YgT
	 huAaLeSjedb6CCPOn3pxVS7fE7R9YobM/7YojlBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boyuan Zhang <boyuan.zhang@amd.com>,
	David Rosca <david.rosca@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 445/602] drm/amdgpu/vcn4: avoid rereading IB param length
Date: Thu, 30 Jul 2026 16:13:57 +0200
Message-ID: <20260730141445.313609046@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

From: Boyuan Zhang <boyuan.zhang@amd.com>

commit 3b4082fabc67c9780b06eb959e59dd92fa79c0f0 upstream.

Reuse the parameter length returned by
vcn_v4_0_enc_find_ib_param() instead of rereading it from
the IB.

This avoids a potential TOCTOU issue if the IB contents
change between reads.

Signed-off-by: Boyuan Zhang <boyuan.zhang@amd.com>
Reviewed-by: David Rosca <david.rosca@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit dbb02b4755f8c1f3773263f2d779872c1c0c073a)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c
@@ -1868,14 +1868,17 @@ out:
 #define RENCODE_IB_PARAM_SESSION_INIT			0x00000003
 
 /* return the offset in ib if id is found, -1 otherwise */
-static int vcn_v4_0_enc_find_ib_param(struct amdgpu_ib *ib, uint32_t id, int start)
+static int vcn_v4_0_enc_find_ib_param(struct amdgpu_ib *ib, uint32_t id, int start, uint32_t *length)
 {
 	int i;
 	uint32_t len;
 
 	for (i = start; (len = amdgpu_ib_get_value(ib, i)) >= 8; i += len / 4) {
-		if (amdgpu_ib_get_value(ib, i + 1) == id)
+		if (amdgpu_ib_get_value(ib, i + 1) == id) {
+			if (length)
+				*length = len;
 			return i;
+		}
 	}
 	return -1;
 }
@@ -1885,14 +1888,14 @@ static int vcn_v4_0_ring_patch_cs_in_pla
 					   struct amdgpu_ib *ib)
 {
 	struct amdgpu_ring *ring = amdgpu_job_ring(job);
-	uint32_t val;
+	uint32_t val, len;
 	int idx = 0, sidx;
 
 	/* The first instance can decode anything */
 	if (!ring->me)
 		return 0;
 
-	while ((idx = vcn_v4_0_enc_find_ib_param(ib, RADEON_VCN_ENGINE_INFO, idx)) >= 0) {
+	while ((idx = vcn_v4_0_enc_find_ib_param(ib, RADEON_VCN_ENGINE_INFO, idx, &len)) >= 0) {
 		val = amdgpu_ib_get_value(ib, idx + 2); /* RADEON_VCN_ENGINE_TYPE */
 		if (val == RADEON_VCN_ENGINE_TYPE_DECODE) {
 			uint32_t valid_buf_flag = amdgpu_ib_get_value(ib, idx + 6);
@@ -1905,12 +1908,12 @@ static int vcn_v4_0_ring_patch_cs_in_pla
 				amdgpu_ib_get_value(ib, idx + 8);
 			return vcn_v4_0_dec_msg(p, job, msg_buffer_addr);
 		} else if (val == RADEON_VCN_ENGINE_TYPE_ENCODE) {
-			sidx = vcn_v4_0_enc_find_ib_param(ib, RENCODE_IB_PARAM_SESSION_INIT, idx);
+			sidx = vcn_v4_0_enc_find_ib_param(ib, RENCODE_IB_PARAM_SESSION_INIT, idx, NULL);
 			if (sidx >= 0 &&
 			    amdgpu_ib_get_value(ib, sidx + 2) == RENCODE_ENCODE_STANDARD_AV1)
 				return vcn_v4_0_limit_sched(p, job);
 		}
-		idx += amdgpu_ib_get_value(ib, idx) / 4;
+		idx += len / 4;
 	}
 	return 0;
 }


