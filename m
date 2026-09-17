Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E12E3220F2A;
	Thu, 17 Sep 2026 17:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667824; cv=none; b=l5Kp41Jha9kToT4Wejl2PNkaVBlmdfwHrMpRuc27YXg72zvv3x89G+fk0son2JcJcGPjN7jmBh2bKZuMbfqy4Mmhm9Rd49f+nPf+76cfpNtT0pRd9NuMsBZi7hiAxE/vbCmPXoll+i8t4qeww0ezeyhyr8TCN3zUQ5RwqQdicp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667824; c=relaxed/simple;
	bh=Wj3Mh6gmMsF6fxiPwJ0vy65yTJEsS/Nt+Ac+1cGiXnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TAtaB2CFzp4qQlxrm1lyRWg/45pNT59dGA0oiNZMqRBW9UQK/GgIq4egmkV/CAcq8Gol2il3fohXkTev2PPZMMjcftCE9tTHpqn4yu/a1u3tF2gNLLul2Ndoufk/+fgZ6SlYAGBlYb1Sr2HjlmXbshLY5ZdG1yz5XlLCpkTgVG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dVwHI7fQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dVwHI7fQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 621C51F000FF;
	Thu, 17 Sep 2026 17:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667822;
	bh=eO1qIcZWPHVx6HFCDqdeA6e9XZ8cecLwpyDEewfuFnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dVwHI7fQee4iuV5hivHIp96T7QGvl81DIREhML7YKWa+/YCpj41XzRnj/K0yU2oaV
	 LfXa+Xcor4bIyiAK7NmOspAoPREJ+XULJTGK0qhT3uvW8wZmhwqq5CG7XlZfHTGGDH
	 NyBiBUZNTKZHKLJh0wVttLdRTlxjukvUgVHrKkdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Stanley.Yang" <Stanley.Yang@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0222/1102] drm/amdgpu: harden FRU PIA parsing with bounded helpers
Date: Thu, 17 Sep 2026 16:02:45 +0100
Message-ID: <20260917151545.153114825@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Stanley.Yang <Stanley.Yang@amd.com>

[ Upstream commit c990c05eb6c74c98d1ff3acf67a19015312820b7 ]

Replace the open-coded TLV walk with fru_pia_advance()
and fru_pia_copy_field() helpers that bound every read
by the actual EEPROM data length, preventing out-of-bounds
reads on truncated or malformed FRU data.

Signed-off-by: Stanley.Yang <Stanley.Yang@amd.com>
Reviewed-by: Tao Zhou <tao.zhou1@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/amdgpu/amdgpu_fru_eeprom.c    | 95 ++++++++++++-------
 1 file changed, 63 insertions(+), 32 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_fru_eeprom.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_fru_eeprom.c
index ceb5163480f4c..6e70d2fa1d102 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_fru_eeprom.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_fru_eeprom.c
@@ -109,6 +109,43 @@ static bool is_fru_eeprom_supported(struct amdgpu_device *adev, u32 *fru_addr)
 	}
 }
 
+/*
+ * IPMI FRU Product Info Area fields are TLV: one type/length byte
+ * (low 6 bits = data length) followed by that many data bytes. These
+ * helpers walk the cursor and copy a single field while bounding all
+ * accesses to the actual buffer length read from the EEPROM.
+ */
+#define FRU_FIELD_LEN(p, a)	((p)[a] & 0x3F)
+
+/* Advance cursor past the current TLV. Returns false if no more data. */
+static bool fru_pia_advance(u32 *addr, const unsigned char *pia, int len)
+{
+	if (*addr >= (u32)len)
+		return false;
+	*addr += 1 + FRU_FIELD_LEN(pia, *addr);
+	return true;
+}
+
+/*
+ * Copy the current TLV's data into dst (NUL-terminated). Returns false if
+ * the TLV header or data would read past the end of pia.
+ */
+static bool fru_pia_copy_field(char *dst, size_t dst_size,
+			       const unsigned char *pia, u32 addr, int len)
+{
+	size_t fl;
+
+	if (addr + 1 >= (u32)len)
+		return false;
+
+	fl = min3((size_t)FRU_FIELD_LEN(pia, addr),
+			  dst_size - 1,
+			  (size_t)(len - addr - 1));
+	memcpy(dst, pia + addr + 1, fl);
+	dst[fl] = '\0';
+	return true;
+}
+
 int amdgpu_fru_get_product_info(struct amdgpu_device *adev)
 {
 	struct amdgpu_fru_info *fru_info;
@@ -205,52 +242,46 @@ int amdgpu_fru_get_product_info(struct amdgpu_device *adev)
 	 * Read Manufacturer Name field whose length is [3].
 	 */
 	addr = 3;
-	if (addr + 1 >= len)
+	if (!fru_pia_copy_field(fru_info->manufacturer_name,
+				sizeof(fru_info->manufacturer_name),
+				pia, addr, len))
 		goto Out;
-	memcpy(fru_info->manufacturer_name, pia + addr + 1,
-	       min_t(size_t, sizeof(fru_info->manufacturer_name),
-		     pia[addr] & 0x3F));
-	fru_info->manufacturer_name[sizeof(fru_info->manufacturer_name) - 1] =
-		'\0';
 
 	/* Read Product Name field. */
-	addr += 1 + (pia[addr] & 0x3F);
-	if (addr + 1 >= len)
+	if (!fru_pia_advance(&addr, pia, len) ||
+	    !fru_pia_copy_field(fru_info->product_name,
+				sizeof(fru_info->product_name),
+				pia, addr, len))
 		goto Out;
-	memcpy(fru_info->product_name, pia + addr + 1,
-	       min_t(size_t, sizeof(fru_info->product_name), pia[addr] & 0x3F));
-	fru_info->product_name[sizeof(fru_info->product_name) - 1] = '\0';
 
 	/* Go to the Product Part/Model Number field. */
-	addr += 1 + (pia[addr] & 0x3F);
-	if (addr + 1 >= len)
+	if (!fru_pia_advance(&addr, pia, len) ||
+	    !fru_pia_copy_field(fru_info->product_number,
+				sizeof(fru_info->product_number),
+				pia, addr, len))
 		goto Out;
-	memcpy(fru_info->product_number, pia + addr + 1,
-	       min_t(size_t, sizeof(fru_info->product_number),
-		     pia[addr] & 0x3F));
-	fru_info->product_number[sizeof(fru_info->product_number) - 1] = '\0';
 
-	/* Go to the Product Version field. */
-	addr += 1 + (pia[addr] & 0x3F);
+	/* Skip the Product Version field. */
+	if (!fru_pia_advance(&addr, pia, len))
+		goto Out;
 
-	/* Go to the Product Serial Number field. */
-	addr += 1 + (pia[addr] & 0x3F);
-	if (addr + 1 >= len)
+	/* Read the Product Serial Number field. */
+	if (!fru_pia_advance(&addr, pia, len) ||
+	    !fru_pia_copy_field(fru_info->serial,
+				sizeof(fru_info->serial),
+				pia, addr, len))
 		goto Out;
-	memcpy(fru_info->serial, pia + addr + 1,
-	       min_t(size_t, sizeof(fru_info->serial), pia[addr] & 0x3F));
-	fru_info->serial[sizeof(fru_info->serial) - 1] = '\0';
 
-	/* Asset Tag field */
-	addr += 1 + (pia[addr] & 0x3F);
+	/* Skip the Asset Tag field. */
+	if (!fru_pia_advance(&addr, pia, len))
+		goto Out;
 
 	/* FRU File Id field. This could be 'null'. */
-	addr += 1 + (pia[addr] & 0x3F);
-	if ((addr + 1 >= len) || !(pia[addr] & 0x3F))
+	if (!fru_pia_advance(&addr, pia, len) ||
+	    !fru_pia_copy_field(fru_info->fru_id,
+				sizeof(fru_info->fru_id),
+				pia, addr, len))
 		goto Out;
-	memcpy(fru_info->fru_id, pia + addr + 1,
-	       min_t(size_t, sizeof(fru_info->fru_id), pia[addr] & 0x3F));
-	fru_info->fru_id[sizeof(fru_info->fru_id) - 1] = '\0';
 
 Out:
 	kfree(pia);
-- 
2.53.0



