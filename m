Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E8BC37881B;
	Mon,  4 May 2026 14:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903447; cv=none; b=gheGFWfPx1uManatfICJop5ySxIfaQR8uzfXClPz2PUd5X11hSvO50y9Q/JfWCeCPP1jKBh2uiQxUf6sSbAOgM9LRxdgCNEp6bRDUAdrsrEDZoimWZbMyYZRxqonPHYVbVdgpJy6BI2KioPqE/etWuDXlfCvEKj3I5vlHnbl+4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903447; c=relaxed/simple;
	bh=I/0C/na99roZNXNdV7SzmcG8kflDUNY1jRpTJhfEPHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K4SqZa4Igmgrz+6ThRe97wkkgOE6LZedd+k/0cqXmrGVc++OhW8QfsNN0sDAX2OdsPvECEmcQQtQv6gb50WG0S49v/1V/qRI64E9w7ePiNX5XSaiAMwC+Nu9ScIGoTE6j0rs95gyQqzHYQqGtT+rYajdp8Kcu/KMPwQq25ra1WA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gsslo6hT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gsslo6hT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9872AC2BCB8;
	Mon,  4 May 2026 14:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903446;
	bh=I/0C/na99roZNXNdV7SzmcG8kflDUNY1jRpTJhfEPHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gsslo6hTfpWVteI1G5rcXA2RuMdWpjjEVZWqzQQlVYQWI1LBN0T2292FpYUvF8X5D
	 Yw0VolVDntC6h542cJZI7+Oa5I/TtTEe1QxQRvI7EzBQ2ZQ5053gNevUghvuGnVnfK
	 K34XUBGaijhMuoRLg42PVLFVfIsFvSpOVvcQhTwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David (Ming Qiang) Wu" <David.Wu3@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.0 236/307] amdgpu/jpeg: fix deepsleep register for jpeg 5_0_0 and 5_0_2
Date: Mon,  4 May 2026 15:52:01 +0200
Message-ID: <20260504135151.722199729@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David (Ming Qiang) Wu <David.Wu3@amd.com>

commit e90dc3b2d73986610476b02c29d0074aa4d92fb0 upstream.

PCTL0__MMHUB_DEEPSLEEP_IB is 0x69004 on MMHUB 4,1,0 and
and 0x60804 on MMHUB 4,2,0. 0x62a04 is on MMHUB 1,8,0/1.

The DS bits are adjusted to cover more JPEG engines and MMHUB
version.

Signed-off-by: David (Ming Qiang) Wu <David.Wu3@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.c |   52 +++++++++++++++++++++++++++----
 1 file changed, 46 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.c
@@ -736,15 +736,35 @@ static void jpeg_v4_0_3_dec_ring_set_wpt
  */
 void jpeg_v4_0_3_dec_ring_insert_start(struct amdgpu_ring *ring)
 {
-	if (!amdgpu_sriov_vf(ring->adev)) {
+	struct amdgpu_device *adev = ring->adev;
+
+	if (!amdgpu_sriov_vf(adev)) {
+		int jpeg_inst = GET_INST(JPEG, ring->me);
+		uint32_t value = 0x80004000; /* default DS14 */
+
 		amdgpu_ring_write(ring, PACKETJ(regUVD_JRBC_EXTERNAL_REG_INTERNAL_OFFSET,
 			0, 0, PACKETJ_TYPE0));
-		amdgpu_ring_write(ring, 0x62a04); /* PCTL0_MMHUB_DEEPSLEEP_IB */
+
+		/* PCTL0__MMHUB_DEEPSLEEP_IB could be different on different mmhub version */
+		switch (amdgpu_ip_version(adev, MMHUB_HWIP, 0)) {
+		case IP_VERSION(4, 1, 0):
+			amdgpu_ring_write(ring, 0x69004);
+			value = 0x80010000;
+			break;
+		case IP_VERSION(4, 2, 0):
+			amdgpu_ring_write(ring, 0x60804);
+			if (jpeg_inst & 1)
+				value = 0x80010000;
+			break;
+		default:
+			amdgpu_ring_write(ring, 0x62a04);
+			break;
+		}
 
 		amdgpu_ring_write(ring,
 				  PACKETJ(JRBC_DEC_EXTERNAL_REG_WRITE_ADDR, 0,
 					  0, PACKETJ_TYPE0));
-		amdgpu_ring_write(ring, 0x80004000);
+		amdgpu_ring_write(ring, value);
 	}
 }
 
@@ -757,15 +777,35 @@ void jpeg_v4_0_3_dec_ring_insert_start(s
  */
 void jpeg_v4_0_3_dec_ring_insert_end(struct amdgpu_ring *ring)
 {
-	if (!amdgpu_sriov_vf(ring->adev)) {
+	struct amdgpu_device *adev = ring->adev;
+
+	if (!amdgpu_sriov_vf(adev)) {
+		int jpeg_inst = GET_INST(JPEG, ring->me);
+		uint32_t value = 0x00004000; /* default DS14 */
+
 		amdgpu_ring_write(ring, PACKETJ(regUVD_JRBC_EXTERNAL_REG_INTERNAL_OFFSET,
 			0, 0, PACKETJ_TYPE0));
-		amdgpu_ring_write(ring, 0x62a04);
+
+		/* PCTL0__MMHUB_DEEPSLEEP_IB could be different on different mmhub version */
+		switch (amdgpu_ip_version(adev, MMHUB_HWIP, 0)) {
+		case IP_VERSION(4, 1, 0):
+			amdgpu_ring_write(ring, 0x69004);
+			value = 0x00010000;
+			break;
+		case IP_VERSION(4, 2, 0):
+			amdgpu_ring_write(ring, 0x60804);
+			if (jpeg_inst & 1)
+				value = 0x00010000;
+			break;
+		default:
+			amdgpu_ring_write(ring, 0x62a04);
+			break;
+		}
 
 		amdgpu_ring_write(ring,
 				  PACKETJ(JRBC_DEC_EXTERNAL_REG_WRITE_ADDR, 0,
 					  0, PACKETJ_TYPE0));
-		amdgpu_ring_write(ring, 0x00004000);
+		amdgpu_ring_write(ring, value);
 	}
 }
 


