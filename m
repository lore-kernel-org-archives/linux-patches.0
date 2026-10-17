Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E10A3A48E4;
	Sat, 17 Oct 2026 17:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256800; cv=none; b=um5K07jSoT/nRWo8J4jZD1eNVBpXM2FKxhktvcWIhs33k5UywDhzGdf11BkUnwEbL71RERJAnxNLPBsQva+/aPu4y31Mk6SOkmIqdErmJ9oityFeSKgIIO2TIQbGUPzvmB8yPaWS6hhQiUF2XgwYRBRRhGrky0CwxaoD7PJgyII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256800; c=relaxed/simple;
	bh=K1S8WqJSgS2+efB0AKiwjv4m5ftDE49K4GVALSdNnVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cx0LgMjw6UvSaDj/ypeMQIIcfmjqna+MXENNqbtNZfQc4wmPYBibdicwJjibu6wSyu2VJEZVnJIEmX1dyDf5FW+ouvrJ8wgKjWRe3ZqBa6ysneB6LsJgKAkRATeIDKTj6xKkzghTNKfiiJlyWwjxcw0UwbJIsuMMRqamowvqi6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lWFV3v9/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lWFV3v9/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 443C61F000C5;
	Sat, 17 Oct 2026 17:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256798;
	bh=+UHqae8zNM+7MOls6wXjN1rucRYoL/ow4WPuoJg5f8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lWFV3v9/tU/uqijbLoki162CnO4gGWgPqp/HxuJIuIM8hswc2gdgSOKAA6e+yi11G
	 OnIYQyJ/K4r5tjeKiZGDhRdvMSi43N9gUh04sl74yBlcZZZ3MnXjWI+CgdCzFYxigm
	 98BcKEMF39yXpnpiRL3f8SPSXHBoZtzs2MAngDFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Asad Kamal <asad.kamal@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Yang Wang <kevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0356/1674] drm/amd/powerplay: fix VoltageObjectInfo zero-stride loop and OOB read
Date: Sat, 17 Oct 2026 17:43:48 +0200
Message-ID: <20261017160440.257301575@linuxfoundation.org>
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



