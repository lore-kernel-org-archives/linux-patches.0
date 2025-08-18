Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F145A34AAE2;
	Mon, 18 Aug 2025 14:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525703; cv=none; b=cOuGF4viwq987HIaMI+0Ozn9J16TASAmHKFejfx97+qtaLRmaOUJIHuh0iSNdm35UqBHIw05mn/mxBg+Tftu8F7cUbX2Qfj/YlxP8P32UwqD9Qg6s1h4b4OT/splZ7x11zI48luleB7+pgqtoTfH5rDN0dVoeUk7xMW5pzrmOvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525703; c=relaxed/simple;
	bh=DX+gX29l9SocZpmRtxAOVUWVcjxZ5gf9aq4anKJZfA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RUTaiiQO9oNA2hmUxhMKBImKR5UROS7Rs/8XOMImSQGKYxUxBM/UyVj6OI5eq1FltrAPoLC0JPqFPR1X0pxbGjnZ9GlaB6511oEExMWsYd4TTs4MBp4h8kmfqqifjrGOQvSw3f5xFC9GqOs4N7kFK6DHpjMAJmrZnHS5temB4PU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Fdr1AHm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Fdr1AHm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2590AC4CEEB;
	Mon, 18 Aug 2025 14:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525702;
	bh=DX+gX29l9SocZpmRtxAOVUWVcjxZ5gf9aq4anKJZfA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Fdr1AHm0TQ+2fmlLesf+y9uUW1e3fIx4AFkINLyT9XHm5JMKBnHYADyy5o7ubx/3
	 34yIVEyH/yCGhXVeddHmDMLMl5kizYnqlvMFHjOsCRUpS+Nri8a03ZwYvH16UoSHqZ
	 DGH2K1lXbyHYQtAQCP5s5gippsyrgMPVmTPfRjeE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 309/570] drm/amdgpu: Add more checks to PSP mailbox
Date: Mon, 18 Aug 2025 14:44:56 +0200
Message-ID: <20250818124517.776370600@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lijo Lazar <lijo.lazar@amd.com>

[ Upstream commit 8345a71fc54b28e4d13a759c45ce2664d8540d28 ]

Instead of checking the response flag, use status mask also to check
against any unexpected failures like a device drop. Also, log error if
waiting on a psp response fails/times out.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c  |  4 +++
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.h  | 11 +++++++++
 drivers/gpu/drm/amd/amdgpu/psp_v10_0.c   |  4 +--
 drivers/gpu/drm/amd/amdgpu/psp_v11_0.c   | 31 +++++++++++++++---------
 drivers/gpu/drm/amd/amdgpu/psp_v11_0_8.c | 25 +++++++++++--------
 drivers/gpu/drm/amd/amdgpu/psp_v12_0.c   | 18 ++++++++------
 drivers/gpu/drm/amd/amdgpu/psp_v13_0.c   | 25 +++++++++++--------
 drivers/gpu/drm/amd/amdgpu/psp_v13_0_4.c | 25 +++++++++++--------
 drivers/gpu/drm/amd/amdgpu/psp_v14_0.c   | 25 +++++++++++--------
 9 files changed, 107 insertions(+), 61 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
index c14f63cefe67..7d8b98aa5271 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -596,6 +596,10 @@ int psp_wait_for(struct psp_context *psp, uint32_t reg_index,
 		udelay(1);
 	}
 
+	dev_err(adev->dev,
+		"psp reg (0x%x) wait timed out, mask: %x, read: %x exp: %x",
+		reg_index, mask, val, reg_val);
+
 	return -ETIME;
 }
 
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.h
index 428adc7f741d..a4a00855d0b2 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.h
@@ -51,6 +51,17 @@
 #define C2PMSG_CMD_SPI_GET_ROM_IMAGE_ADDR_HI 0x10
 #define C2PMSG_CMD_SPI_GET_FLASH_IMAGE 0x11
 
+/* Command register bit 31 set to indicate readiness */
+#define MBOX_TOS_READY_FLAG (GFX_FLAG_RESPONSE)
+#define MBOX_TOS_READY_MASK (GFX_CMD_RESPONSE_MASK | GFX_CMD_STATUS_MASK)
+
+/* Values to check for a successful GFX_CMD response wait. Check against
+ * both status bits and response state - helps to detect a command failure
+ * or other unexpected cases like a device drop reading all 0xFFs
+ */
+#define MBOX_TOS_RESP_FLAG (GFX_FLAG_RESPONSE)
+#define MBOX_TOS_RESP_MASK (GFX_CMD_RESPONSE_MASK | GFX_CMD_STATUS_MASK)
+
 extern const struct attribute_group amdgpu_flash_attr_group;
 
 enum psp_shared_mem_size {
diff --git a/drivers/gpu/drm/amd/amdgpu/psp_v10_0.c b/drivers/gpu/drm/amd/amdgpu/psp_v10_0.c
index 145186a1e48f..2c4ebd98927f 100644
--- a/drivers/gpu/drm/amd/amdgpu/psp_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/psp_v10_0.c
@@ -94,7 +94,7 @@ static int psp_v10_0_ring_create(struct psp_context *psp,
 
 	/* Wait for response flag (bit 31) in C2PMSG_64 */
 	ret = psp_wait_for(psp, SOC15_REG_OFFSET(MP0, 0, mmMP0_SMN_C2PMSG_64),
-			   0x80000000, 0x8000FFFF, false);
+			   MBOX_TOS_RESP_FLAG, MBOX_TOS_RESP_MASK, false);
 
 	return ret;
 }
@@ -115,7 +115,7 @@ static int psp_v10_0_ring_stop(struct psp_context *psp,
 
 	/* Wait for response flag (bit 31) in C2PMSG_64 */
 	ret = psp_wait_for(psp, SOC15_REG_OFFSET(MP0, 0, mmMP0_SMN_C2PMSG_64),
-			   0x80000000, 0x80000000, false);
+			   MBOX_TOS_RESP_FLAG, MBOX_TOS_RESP_MASK, false);
 
 	return ret;
 }
diff --git a/drivers/gpu/drm/amd/amdgpu/psp_v11_0.c b/drivers/gpu/drm/amd/amdgpu/psp_v11_0.c
index 215543575f47..1a4a26e6ffd2 100644
--- a/drivers/gpu/drm/amd/amdgpu/psp_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/psp_v11_0.c
@@ -277,11 +277,13 @@ static int psp_v11_0_ring_stop(struct psp_context *psp,
 
 	/* Wait for response flag (bit 31) */
 	if (amdgpu_sriov_vf(adev))
-		ret = psp_wait_for(psp, SOC15_REG_OFFSET(MP0, 0, mmMP0_SMN_C2PMSG_101),
-				   0x80000000, 0x80000000, false);
+		ret = psp_wait_for(
+			psp, SOC15_REG_OFFSET(MP0, 0, mmMP0_SMN_C2PMSG_101),
+			MBOX_TOS_RESP_FLAG, MBOX_TOS_RESP_MASK, false);
 	else
-		ret = psp_wait_for(psp, SOC15_REG_OFFSET(MP0, 0, mmMP0_SMN_C2PMSG_64),
-				   0x80000000, 0x80000000, false);
+		ret = psp_wait_for(
+			psp, SOC15_REG_OFFSET(MP0, 0, mmMP0_SMN_C2PMSG_64),
+			MBOX_TOS_RESP_FLAG, MBOX_TOS_RESP_MASK, false);
 
 	return ret;
 }
@@ -317,13 +319,15 @@ static int psp_v11_0_ring_create(struct psp_context *psp,
 		mdelay(20);
 
 		/* Wait for response flag (bit 31) in C2PMSG_101 */
-		ret = psp_wait_for(psp, SOC15_REG_OFFSET(MP0, 0, mmMP0_SMN_C2PMSG_101),
-				   0x80000000, 0x8000FFFF, false);
+		ret = psp_wait_for(
+			psp, SOC15_REG_OFFSET(MP0, 0, mmMP0_SMN_C2PMSG_101),
+			MBOX_TOS_RESP_FLAG, MBOX_TOS_RESP_MASK, false);
 
 	} else {
 		/* Wait for sOS ready for ring creation */
-		ret = psp_wait_for(psp, SOC15_REG_OFFSET(MP0, 0, mmMP0_SMN_C2PMSG_64),
-				   0x80000000, 0x80000000, false);
+		ret = psp_wait_for(
+			psp, SOC15_REG_OFFSET(MP0, 0, mmMP0_SMN_C2PMSG_64),
+			MBOX_TOS_READY_FLAG, MBOX_TOS_READY_MASK, false);
 		if (ret) {
 			DRM_ERROR("Failed to wait for sOS ready for ring creation\n");
 			return ret;
@@ -347,8 +351,9 @@ static int psp_v11_0_ring_create(struct psp_context *psp,
 		mdelay(20);
 
 		/* Wait for response flag (bit 31) in C2PMSG_64 */
-		ret = psp_wait_for(psp, SOC15_REG_OFFSET(MP0, 0, mmMP0_SMN_C2PMSG_64),
-				   0x80000000, 0x8000FFFF, false);
+		ret = psp_wait_for(
+			psp, SOC15_REG_OFFSET(MP0, 0, mmMP0_SMN_C2PMSG_64),
+			MBOX_TOS_RESP_FLAG, MBOX_TOS_RESP_MASK, false);
 	}
 
 	return ret;
@@ -381,7 +386,8 @@ static int psp_v11_0_mode1_reset(struct psp_context *psp)
 
 	offset = SOC15_REG_OFFSET(MP0, 0, mmMP0_SMN_C2PMSG_64);
 
-	ret = psp_wait_for(psp, offset, 0x80000000, 0x8000FFFF, false);
+	ret = psp_wait_for(psp, offset, MBOX_TOS_READY_FLAG,
+			   MBOX_TOS_READY_MASK, false);
 
 	if (ret) {
 		DRM_INFO("psp is not working correctly before mode1 reset!\n");
@@ -395,7 +401,8 @@ static int psp_v11_0_mode1_reset(struct psp_context *psp)
 
 	offset = SOC15_REG_OFFSET(MP0, 0, mmMP0_SMN_C2PMSG_33);
 
-	ret = psp_wait_for(psp, offset, 0x80000000, 0x80000000, false);
+	ret = psp_wait_for(psp, offset, MBOX_TOS_RESP_FLAG, MBOX_TOS_RESP_MASK,
+			   false);
 
 	if (ret) {
 		DRM_INFO("psp mode 1 reset failed!\n");
diff --git a/drivers/gpu/drm/amd/amdgpu/psp_v11_0_8.c b/drivers/gpu/drm/amd/amdgpu/psp_v11_0_8.c
index 5697760a819b..338d015c0f2e 100644
--- a/drivers/gpu/drm/amd/amdgpu/psp_v11_0_8.c
+++ b/drivers/gpu/drm/amd/amdgpu/psp_v11_0_8.c
@@ -41,8 +41,9 @@ static int psp_v11_0_8_ring_stop(struct psp_context *psp,
 		/* there might be handshake issue with hardware which needs delay */
 		mdelay(20);
 		/* Wait for response flag (bit 31) */
-		ret = psp_wait_for(psp, SOC15_REG_OFFSET(MP0, 0, mmMP0_SMN_C2PMSG_101),
-				   0x80000000, 0x80000000, false);
+		ret = psp_wait_for(
+			psp, SOC15_REG_OFFSET(MP0, 0, mmMP0_SMN_C2PMSG_101),
+			MBOX_TOS_RESP_FLAG, MBOX_TOS_RESP_MASK, false);
 	} else {
 		/* Write the ring destroy command*/
 		WREG32_SOC15(MP0, 0, mmMP0_SMN_C2PMSG_64,
@@ -50,8 +51,9 @@ static int psp_v11_0_8_ring_stop(struct psp_context *psp,
 		/* there might be handshake issue with hardware which needs delay */
 		mdelay(20);
 		/* Wait for response flag (bit 31) */
-		ret = psp_wait_for(psp, SOC15_REG_OFFSET(MP0, 0, mmMP0_SMN_C2PMSG_64),
-				   0x80000000, 0x80000000, false);
+		ret = psp_wait_for(
+			psp, SOC15_REG_OFFSET(MP0, 0, mmMP0_SMN_C2PMSG_64),
+			MBOX_TOS_RESP_FLAG, MBOX_TOS_RESP_MASK, false);
 	}
 
 	return ret;
@@ -87,13 +89,15 @@ static int psp_v11_0_8_ring_create(struct psp_context *psp,
 		mdelay(20);
 
 		/* Wait for response flag (bit 31) in C2PMSG_101 */
-		ret = psp_wait_for(psp, SOC15_REG_OFFSET(MP0, 0, mmMP0_SMN_C2PMSG_101),
-				   0x80000000, 0x8000FFFF, false);
+		ret = psp_wait_for(
+			psp, SOC15_REG_OFFSET(MP0, 0, mmMP0_SMN_C2PMSG_101),
+			MBOX_TOS_RESP_FLAG, MBOX_TOS_RESP_MASK, false);
 
 	} else {
 		/* Wait for sOS ready for ring creation */
-		ret = psp_wait_for(psp, SOC15_REG_OFFSET(MP0, 0, mmMP0_SMN_C2PMSG_64),
-				   0x80000000, 0x80000000, false);
+		ret = psp_wait_for(
+			psp, SOC15_REG_OFFSET(MP0, 0, mmMP0_SMN_C2PMSG_64),
+			MBOX_TOS_READY_FLAG, MBOX_TOS_READY_MASK, false);
 		if (ret) {
 			DRM_ERROR("Failed to wait for trust OS ready for ring creation\n");
 			return ret;
@@ -117,8 +121,9 @@ static int psp_v11_0_8_ring_create(struct psp_context *psp,
 		mdelay(20);
 
 		/* Wait for response flag (bit 31) in C2PMSG_64 */
-		ret = psp_wait_for(psp, SOC15_REG_OFFSET(MP0, 0, mmMP0_SMN_C2PMSG_64),
-				   0x80000000, 0x8000FFFF, false);
+		ret = psp_wait_for(
+			psp, SOC15_REG_OFFSET(MP0, 0, mmMP0_SMN_C2PMSG_64),
+			MBOX_TOS_RESP_FLAG, MBOX_TOS_RESP_MASK, false);
 	}
 
 	return ret;
diff --git a/drivers/gpu/drm/amd/amdgpu/psp_v12_0.c b/drivers/gpu/drm/amd/amdgpu/psp_v12_0.c
index 80153f837470..d54b3e0fabaf 100644
--- a/drivers/gpu/drm/amd/amdgpu/psp_v12_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/psp_v12_0.c
@@ -163,7 +163,7 @@ static int psp_v12_0_ring_create(struct psp_context *psp,
 
 	/* Wait for response flag (bit 31) in C2PMSG_64 */
 	ret = psp_wait_for(psp, SOC15_REG_OFFSET(MP0, 0, mmMP0_SMN_C2PMSG_64),
-			   0x80000000, 0x8000FFFF, false);
+			   MBOX_TOS_RESP_FLAG, MBOX_TOS_RESP_MASK, false);
 
 	return ret;
 }
@@ -184,11 +184,13 @@ static int psp_v12_0_ring_stop(struct psp_context *psp,
 
 	/* Wait for response flag (bit 31) */
 	if (amdgpu_sriov_vf(adev))
-		ret = psp_wait_for(psp, SOC15_REG_OFFSET(MP0, 0, mmMP0_SMN_C2PMSG_101),
-				   0x80000000, 0x80000000, false);
+		ret = psp_wait_for(
+			psp, SOC15_REG_OFFSET(MP0, 0, mmMP0_SMN_C2PMSG_101),
+			MBOX_TOS_RESP_FLAG, MBOX_TOS_RESP_MASK, false);
 	else
-		ret = psp_wait_for(psp, SOC15_REG_OFFSET(MP0, 0, mmMP0_SMN_C2PMSG_64),
-				   0x80000000, 0x80000000, false);
+		ret = psp_wait_for(
+			psp, SOC15_REG_OFFSET(MP0, 0, mmMP0_SMN_C2PMSG_64),
+			MBOX_TOS_RESP_FLAG, MBOX_TOS_RESP_MASK, false);
 
 	return ret;
 }
@@ -219,7 +221,8 @@ static int psp_v12_0_mode1_reset(struct psp_context *psp)
 
 	offset = SOC15_REG_OFFSET(MP0, 0, mmMP0_SMN_C2PMSG_64);
 
-	ret = psp_wait_for(psp, offset, 0x80000000, 0x8000FFFF, false);
+	ret = psp_wait_for(psp, offset, MBOX_TOS_READY_FLAG,
+			   MBOX_TOS_READY_MASK, false);
 
 	if (ret) {
 		DRM_INFO("psp is not working correctly before mode1 reset!\n");
@@ -233,7 +236,8 @@ static int psp_v12_0_mode1_reset(struct psp_context *psp)
 
 	offset = SOC15_REG_OFFSET(MP0, 0, mmMP0_SMN_C2PMSG_33);
 
-	ret = psp_wait_for(psp, offset, 0x80000000, 0x80000000, false);
+	ret = psp_wait_for(psp, offset, MBOX_TOS_RESP_FLAG, MBOX_TOS_RESP_MASK,
+			   false);
 
 	if (ret) {
 		DRM_INFO("psp mode 1 reset failed!\n");
diff --git a/drivers/gpu/drm/amd/amdgpu/psp_v13_0.c b/drivers/gpu/drm/amd/amdgpu/psp_v13_0.c
index ead616c11705..58b6b64dcd68 100644
--- a/drivers/gpu/drm/amd/amdgpu/psp_v13_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/psp_v13_0.c
@@ -384,8 +384,9 @@ static int psp_v13_0_ring_stop(struct psp_context *psp,
 		/* there might be handshake issue with hardware which needs delay */
 		mdelay(20);
 		/* Wait for response flag (bit 31) */
-		ret = psp_wait_for(psp, SOC15_REG_OFFSET(MP0, 0, regMP0_SMN_C2PMSG_101),
-				   0x80000000, 0x80000000, false);
+		ret = psp_wait_for(
+			psp, SOC15_REG_OFFSET(MP0, 0, regMP0_SMN_C2PMSG_101),
+			MBOX_TOS_RESP_FLAG, MBOX_TOS_RESP_MASK, false);
 	} else {
 		/* Write the ring destroy command*/
 		WREG32_SOC15(MP0, 0, regMP0_SMN_C2PMSG_64,
@@ -393,8 +394,9 @@ static int psp_v13_0_ring_stop(struct psp_context *psp,
 		/* there might be handshake issue with hardware which needs delay */
 		mdelay(20);
 		/* Wait for response flag (bit 31) */
-		ret = psp_wait_for(psp, SOC15_REG_OFFSET(MP0, 0, regMP0_SMN_C2PMSG_64),
-				   0x80000000, 0x80000000, false);
+		ret = psp_wait_for(
+			psp, SOC15_REG_OFFSET(MP0, 0, regMP0_SMN_C2PMSG_64),
+			MBOX_TOS_RESP_FLAG, MBOX_TOS_RESP_MASK, false);
 	}
 
 	return ret;
@@ -430,13 +432,15 @@ static int psp_v13_0_ring_create(struct psp_context *psp,
 		mdelay(20);
 
 		/* Wait for response flag (bit 31) in C2PMSG_101 */
-		ret = psp_wait_for(psp, SOC15_REG_OFFSET(MP0, 0, regMP0_SMN_C2PMSG_101),
-				   0x80000000, 0x8000FFFF, false);
+		ret = psp_wait_for(
+			psp, SOC15_REG_OFFSET(MP0, 0, regMP0_SMN_C2PMSG_101),
+			MBOX_TOS_RESP_FLAG, MBOX_TOS_RESP_MASK, false);
 
 	} else {
 		/* Wait for sOS ready for ring creation */
-		ret = psp_wait_for(psp, SOC15_REG_OFFSET(MP0, 0, regMP0_SMN_C2PMSG_64),
-				   0x80000000, 0x80000000, false);
+		ret = psp_wait_for(
+			psp, SOC15_REG_OFFSET(MP0, 0, regMP0_SMN_C2PMSG_64),
+			MBOX_TOS_READY_FLAG, MBOX_TOS_READY_MASK, false);
 		if (ret) {
 			DRM_ERROR("Failed to wait for trust OS ready for ring creation\n");
 			return ret;
@@ -460,8 +464,9 @@ static int psp_v13_0_ring_create(struct psp_context *psp,
 		mdelay(20);
 
 		/* Wait for response flag (bit 31) in C2PMSG_64 */
-		ret = psp_wait_for(psp, SOC15_REG_OFFSET(MP0, 0, regMP0_SMN_C2PMSG_64),
-				   0x80000000, 0x8000FFFF, false);
+		ret = psp_wait_for(
+			psp, SOC15_REG_OFFSET(MP0, 0, regMP0_SMN_C2PMSG_64),
+			MBOX_TOS_RESP_FLAG, MBOX_TOS_RESP_MASK, false);
 	}
 
 	return ret;
diff --git a/drivers/gpu/drm/amd/amdgpu/psp_v13_0_4.c b/drivers/gpu/drm/amd/amdgpu/psp_v13_0_4.c
index eaa5512a21da..f65af52c1c19 100644
--- a/drivers/gpu/drm/amd/amdgpu/psp_v13_0_4.c
+++ b/drivers/gpu/drm/amd/amdgpu/psp_v13_0_4.c
@@ -204,8 +204,9 @@ static int psp_v13_0_4_ring_stop(struct psp_context *psp,
 		/* there might be handshake issue with hardware which needs delay */
 		mdelay(20);
 		/* Wait for response flag (bit 31) */
-		ret = psp_wait_for(psp, SOC15_REG_OFFSET(MP0, 0, regMP0_SMN_C2PMSG_101),
-				   0x80000000, 0x80000000, false);
+		ret = psp_wait_for(
+			psp, SOC15_REG_OFFSET(MP0, 0, regMP0_SMN_C2PMSG_101),
+			MBOX_TOS_RESP_FLAG, MBOX_TOS_RESP_MASK, false);
 	} else {
 		/* Write the ring destroy command*/
 		WREG32_SOC15(MP0, 0, regMP0_SMN_C2PMSG_64,
@@ -213,8 +214,9 @@ static int psp_v13_0_4_ring_stop(struct psp_context *psp,
 		/* there might be handshake issue with hardware which needs delay */
 		mdelay(20);
 		/* Wait for response flag (bit 31) */
-		ret = psp_wait_for(psp, SOC15_REG_OFFSET(MP0, 0, regMP0_SMN_C2PMSG_64),
-				   0x80000000, 0x80000000, false);
+		ret = psp_wait_for(
+			psp, SOC15_REG_OFFSET(MP0, 0, regMP0_SMN_C2PMSG_64),
+			MBOX_TOS_RESP_FLAG, MBOX_TOS_RESP_MASK, false);
 	}
 
 	return ret;
@@ -250,13 +252,15 @@ static int psp_v13_0_4_ring_create(struct psp_context *psp,
 		mdelay(20);
 
 		/* Wait for response flag (bit 31) in C2PMSG_101 */
-		ret = psp_wait_for(psp, SOC15_REG_OFFSET(MP0, 0, regMP0_SMN_C2PMSG_101),
-				   0x80000000, 0x8000FFFF, false);
+		ret = psp_wait_for(
+			psp, SOC15_REG_OFFSET(MP0, 0, regMP0_SMN_C2PMSG_101),
+			MBOX_TOS_RESP_FLAG, MBOX_TOS_RESP_MASK, false);
 
 	} else {
 		/* Wait for sOS ready for ring creation */
-		ret = psp_wait_for(psp, SOC15_REG_OFFSET(MP0, 0, regMP0_SMN_C2PMSG_64),
-				   0x80000000, 0x80000000, false);
+		ret = psp_wait_for(
+			psp, SOC15_REG_OFFSET(MP0, 0, regMP0_SMN_C2PMSG_64),
+			MBOX_TOS_READY_FLAG, MBOX_TOS_READY_MASK, false);
 		if (ret) {
 			DRM_ERROR("Failed to wait for trust OS ready for ring creation\n");
 			return ret;
@@ -280,8 +284,9 @@ static int psp_v13_0_4_ring_create(struct psp_context *psp,
 		mdelay(20);
 
 		/* Wait for response flag (bit 31) in C2PMSG_64 */
-		ret = psp_wait_for(psp, SOC15_REG_OFFSET(MP0, 0, regMP0_SMN_C2PMSG_64),
-				   0x80000000, 0x8000FFFF, false);
+		ret = psp_wait_for(
+			psp, SOC15_REG_OFFSET(MP0, 0, regMP0_SMN_C2PMSG_64),
+			MBOX_TOS_RESP_FLAG, MBOX_TOS_RESP_MASK, false);
 	}
 
 	return ret;
diff --git a/drivers/gpu/drm/amd/amdgpu/psp_v14_0.c b/drivers/gpu/drm/amd/amdgpu/psp_v14_0.c
index 256288c6cd78..ffa47c7d24c9 100644
--- a/drivers/gpu/drm/amd/amdgpu/psp_v14_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/psp_v14_0.c
@@ -248,8 +248,9 @@ static int psp_v14_0_ring_stop(struct psp_context *psp,
 		/* there might be handshake issue with hardware which needs delay */
 		mdelay(20);
 		/* Wait for response flag (bit 31) */
-		ret = psp_wait_for(psp, SOC15_REG_OFFSET(MP0, 0, regMPASP_SMN_C2PMSG_101),
-				   0x80000000, 0x80000000, false);
+		ret = psp_wait_for(
+			psp, SOC15_REG_OFFSET(MP0, 0, regMPASP_SMN_C2PMSG_101),
+			MBOX_TOS_RESP_FLAG, MBOX_TOS_RESP_MASK, false);
 	} else {
 		/* Write the ring destroy command*/
 		WREG32_SOC15(MP0, 0, regMPASP_SMN_C2PMSG_64,
@@ -257,8 +258,9 @@ static int psp_v14_0_ring_stop(struct psp_context *psp,
 		/* there might be handshake issue with hardware which needs delay */
 		mdelay(20);
 		/* Wait for response flag (bit 31) */
-		ret = psp_wait_for(psp, SOC15_REG_OFFSET(MP0, 0, regMPASP_SMN_C2PMSG_64),
-				   0x80000000, 0x80000000, false);
+		ret = psp_wait_for(
+			psp, SOC15_REG_OFFSET(MP0, 0, regMPASP_SMN_C2PMSG_64),
+			MBOX_TOS_RESP_FLAG, MBOX_TOS_RESP_MASK, false);
 	}
 
 	return ret;
@@ -294,13 +296,15 @@ static int psp_v14_0_ring_create(struct psp_context *psp,
 		mdelay(20);
 
 		/* Wait for response flag (bit 31) in C2PMSG_101 */
-		ret = psp_wait_for(psp, SOC15_REG_OFFSET(MP0, 0, regMPASP_SMN_C2PMSG_101),
-				   0x80000000, 0x8000FFFF, false);
+		ret = psp_wait_for(
+			psp, SOC15_REG_OFFSET(MP0, 0, regMPASP_SMN_C2PMSG_101),
+			MBOX_TOS_RESP_FLAG, MBOX_TOS_RESP_MASK, false);
 
 	} else {
 		/* Wait for sOS ready for ring creation */
-		ret = psp_wait_for(psp, SOC15_REG_OFFSET(MP0, 0, regMPASP_SMN_C2PMSG_64),
-				   0x80000000, 0x80000000, false);
+		ret = psp_wait_for(
+			psp, SOC15_REG_OFFSET(MP0, 0, regMPASP_SMN_C2PMSG_64),
+			MBOX_TOS_READY_FLAG, MBOX_TOS_READY_MASK, false);
 		if (ret) {
 			DRM_ERROR("Failed to wait for trust OS ready for ring creation\n");
 			return ret;
@@ -324,8 +328,9 @@ static int psp_v14_0_ring_create(struct psp_context *psp,
 		mdelay(20);
 
 		/* Wait for response flag (bit 31) in C2PMSG_64 */
-		ret = psp_wait_for(psp, SOC15_REG_OFFSET(MP0, 0, regMPASP_SMN_C2PMSG_64),
-				   0x80000000, 0x8000FFFF, false);
+		ret = psp_wait_for(
+			psp, SOC15_REG_OFFSET(MP0, 0, regMPASP_SMN_C2PMSG_64),
+			MBOX_TOS_RESP_FLAG, MBOX_TOS_RESP_MASK, false);
 	}
 
 	return ret;
-- 
2.39.5



