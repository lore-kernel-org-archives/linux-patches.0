Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 936A8315785;
	Mon,  4 May 2026 14:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904231; cv=none; b=pIH9zTykyPnCxE0bgUbnl3ixTJ4HGy+Ocw/jGmM7VQtXyH6mCvgabErLveMm9b9mmHu0IDLMOcqbuQeHIEmPQufVdOoFHWNOeKI8dwpyszhBpC4vtquOBlvTcxRwob4l3tMLd8uEskPuGhJDN9X+NgFiI4dWTq7doGXmdaRB+bY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904231; c=relaxed/simple;
	bh=JYvyAf5yZx+0ktNHoVZc7CsZliyV/FPjDES+sfOHBtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kjs6vHqONBlPpgiLC7bwjhN9GZVUZaCEue/PTga1CN7tjs/PSbUr8dolf9nM6f5vyMUY2t+P/XcciFYfBgT5xxVwpKxc25JQYNcG/1V2V83/TnGgMSSqX6a77CJRMq8ROq/cUPwR2wJCr9topMBqaZhlIgMt+1LG//Hc2CK9c7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LmOam+9a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LmOam+9a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28F4CC2BCB8;
	Mon,  4 May 2026 14:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904231;
	bh=JYvyAf5yZx+0ktNHoVZc7CsZliyV/FPjDES+sfOHBtA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LmOam+9akVsvW0sHb7T0703lXAeDIRINWyYuhEBnRYQkjCelrFS23LY4yK0STEs/n
	 lR7yjjFD2Q9FKisOjMuf6Xpkq50qp8Kj8cimb+BtVJ6CKjVWz/S9ylu66nAIo9/cXA
	 IPYDElL0kfy4ySd2J7PcW3iltlMBoQctCF9b3i8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David (Ming Qiang) Wu" <David.Wu3@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 201/275] amdgpu/jpeg: fix deepsleep register for jpeg 5_0_0 and 5_0_2
Date: Mon,  4 May 2026 15:52:21 +0200
Message-ID: <20260504135150.541850510@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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
 


