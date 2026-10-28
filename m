Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211129;
	b=1zkRb9DHRFBqryzBwiUtbq6UAtEAV/WlK8C7rovBYyCMGXR+IIbOlpB4tmwcsmHWVQlr
	 VdODH9xyGhf+yqtzN4VQTq/XSXNzg2BOKhqDt5jMlR/fkTkulW3x9zTXZCHopWKtCrrVK
	 1pAkDIB9aSDKwaSen/KCIr9Q8m6b0rhqyRQXsiaC1qQhFxg3ZjDRw2mP4PniiRWPQuDqB
	 4MgR2lQw51sxh6vwWQGkdl/96N4VRm1rn3q1XBbbTRD/U1oiC66Y9bZU40EJz6EC3ouJM
	 +Yalmd/UgdkdKXOAnbdt/esC4iO5sa/jxpC2wAlIyBUa+10h8PlN9snCcWEol+jt2uA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211129;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sSDQSIz4KIc4b7XA8WkttAD2UNgCT7Syi3SPrR4GegY=;
	b=FQZ6CcejRLc40YjWd3wjGsgYAzFlwaOEHslhi27KMbUmxW8cpQSTiA1MZ1ud6IL3xriv
	 WLC47Bm4IRpC1ZBDIaOxFvdwt1s1b/ONeG9dW0b58s0A1j/AmCNUUucH8/FvEHoYEOxYw
	 SQtF6o2PL1teDVc2tWa3xar9nXTPypx7FUvpFVO7N85rnlTFj9WTvY89khxqT9cS5aiMW
	 BG/MlDDnGR8FnUHYt675SlFYgHK8PhafuAeqWTeVcB46IObPgjEPQNgoUZ9eyaYq1fFBw
	 L1HWCggxcqGzww//2dpAEuPBhTjpiZ8uBgOW0HrzvX/Cc0meEhtasdwXGVV5ZPrHr8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jioT50aU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6B43606B44D;
	Wed, 28 Oct 2026 18:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jioT50aU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EE621F01828;
	Wed, 28 Oct 2026 18:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211128;
	bh=sSDQSIz4KIc4b7XA8WkttAD2UNgCT7Syi3SPrR4GegY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jioT50aU6sJwJaCNSS+sEnGAtp7xjfTlMpdtSt9UakdlcwpN93uaEd8i3LelU9DWT
	 Hs5+a3MwEQ6+/PnfFDN7gdSQDYiD9lC852sPVDWPoGrNTRS5WeiH3/VBMnbPaLHXeq
	 bXr+H0UJ7Bjq1mCwhwjsvtxqPfchkfCJiAXmq2nY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Asad Kamal <asad.kamal@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Yang Wang <kevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 267/571] drm/amd/powerplay: fix VoltageObjectInfo zero-stride loop and OOB read
Date: Wed, 28 Oct 2026 17:56:54 +0100
Message-ID: <20261028170014.339857844@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Asad Kamal <asad.kamal@amd.com>

[ Upstream commit 5d3cc8e388464f485d0944b87b8f9426e637d082 ]

Reject voltage objects whose usSize is smaller than the header or would
advance the cursor past the table end, preventing an infinite loop or
heap OOB read when the VBIOS supplies a malformed VoltageObjectInfo table.

Fixes: c82baa281843 ("drm/amd/powerplay: add Tonga dpm support (v3)")
Fixes: 0d2c7569e196 ("drm/amdgpu: add new atomfirmware based helpers for powerplay")
Signed-off-by: Asad Kamal <asad.kamal@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Yang Wang <kevinyang.wang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c   | 10 ++++++++--
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppatomfwctrl.c | 11 ++++++++---
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c
index 7e37354a03411..640350bbd9085 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c
@@ -269,15 +269,21 @@ static const ATOM_VOLTAGE_OBJECT_V3 *atomctrl_lookup_voltage_type_v3(
 	unsigned int offset = offsetof(ATOM_VOLTAGE_OBJECT_INFO_V3_1, asVoltageObj[0]);
 	uint8_t *start = (uint8_t *)voltage_object_info_table;
 
-	while (offset < size) {
+	while (offset + sizeof(ATOM_VOLTAGE_OBJECT_HEADER_V3) <= size) {
 		const ATOM_VOLTAGE_OBJECT_V3 *voltage_object =
 			(const ATOM_VOLTAGE_OBJECT_V3 *)(start + offset);
+		u16 obj_size;
+
+		obj_size = le16_to_cpu(voltage_object->asGpioVoltageObj.sHeader.usSize);
+		if (obj_size < sizeof(voltage_object->asGpioVoltageObj.sHeader) ||
+		    offset + obj_size > size)
+			break;
 
 		if (voltage_type == voltage_object->asGpioVoltageObj.sHeader.ucVoltageType &&
 			voltage_mode == voltage_object->asGpioVoltageObj.sHeader.ucVoltageMode)
 			return voltage_object;
 
-		offset += le16_to_cpu(voltage_object->asGpioVoltageObj.sHeader.usSize);
+		offset += obj_size;
 	}
 
 	return NULL;
diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppatomfwctrl.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppatomfwctrl.c
index a47a47238e2b9..e5aa787182025 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppatomfwctrl.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppatomfwctrl.c
@@ -36,16 +36,21 @@ static const union atom_voltage_object_v4 *pp_atomfwctrl_lookup_voltage_type_v4(
 			offsetof(struct atom_voltage_objects_info_v4_1, voltage_object[0]);
 	unsigned long start = (unsigned long)voltage_object_info_table;
 
-	while (offset < size) {
+	while (offset + sizeof(struct atom_voltage_object_header_v4) <= size) {
 		const union atom_voltage_object_v4 *voltage_object =
 			(const union atom_voltage_object_v4 *)(start + offset);
+		u16 obj_size;
+
+		obj_size = le16_to_cpu(voltage_object->gpio_voltage_obj.header.object_size);
+		if (obj_size < sizeof(voltage_object->gpio_voltage_obj.header) ||
+		    offset + obj_size > size)
+			break;
 
 		if (voltage_type == voltage_object->gpio_voltage_obj.header.voltage_type &&
 		    voltage_mode == voltage_object->gpio_voltage_obj.header.voltage_mode)
 			return voltage_object;
 
-		offset += le16_to_cpu(voltage_object->gpio_voltage_obj.header.object_size);
-
+		offset += obj_size;
 	}
 
 	return NULL;
-- 
2.53.0



