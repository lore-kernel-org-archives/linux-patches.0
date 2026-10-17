Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10A013B71A7;
	Sat, 17 Oct 2026 18:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260397; cv=none; b=QD6Y5omz/xsVV0BFTc5E0LqOHqrxTwHYqbLRrSSYVzvWFhLG/If8jfwWv3TIsR0eTz6yKaZ0jiu7rdoSMzXCXnA6A52CsltWi7ToSDVq820zPK5O8YbhR+VRCUUClt4fVC8sP4Z+5DmkeRE/k9ol76z+Rjhm+68Ip+KbE67gfc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260397; c=relaxed/simple;
	bh=/FXmi3lo91SHiig89bgFKXGh3dJ5/C2COCfTWyMkw5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TwCSPtCjyuBgZVEzdEYIbBsTTO4FSjBPdiM0vBZLUDBe3anCpjNh7UNBXY+CDwB0RUo4fZrFmM7Jn2b1t5KaT1Nem5THnvBzh/NFmqvKL1sSB+sMzkctHWwxySCUaXTJ8JUxGzZJtjmm5xxg2vmiwmtrkXthEA3H8rPEo3g66sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mmuKhLFy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mmuKhLFy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D5C31F000C4;
	Sat, 17 Oct 2026 18:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260396;
	bh=P1cKNCLscsoCNB1RXjftSeFVUyi9EcBTAmT4dV+eb5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mmuKhLFyTA3ik1yJs0qfKiWvgD0eR9tFI6y7xlYF85r5UaiVgg5giuPEdzPEhgaH9
	 73j3q47yiDyDS0fE8HVDJNT95hhrRHR5ylAcQnuNKc8zeetqkoYm03HExzUA1IZu7y
	 NrKd21AFrBGbtZcyCGCeM6fh9Ojq57fcBhauRkXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Stanley.Yang" <Stanley.Yang@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1530/1674] drm/amdgpu: harden FRU PIA parsing with bounded helpers
Date: Sat, 17 Oct 2026 18:03:22 +0200
Message-ID: <20261017160510.392314927@linuxfoundation.org>
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
 .../gpu/drm/amd/amdgpu/amdgpu_fru_eeprom.c    | 74 ++++++++++++++-----
 1 file changed, 55 insertions(+), 19 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_fru_eeprom.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_fru_eeprom.c
index ba62ddeaa31f9..b3b87b6edeb89 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_fru_eeprom.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_fru_eeprom.c
@@ -97,6 +97,43 @@ static bool is_fru_eeprom_supported(struct amdgpu_device *adev, u32 *fru_addr)
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
@@ -193,32 +230,31 @@ int amdgpu_fru_get_product_info(struct amdgpu_device *adev)
 	 * Skip the Manufacturer Name at [3] and go directly to
 	 * the Product Name field.
 	 */
-	addr = 3 + 1 + (pia[3] & 0x3F);
-	if (addr + 1 >= len)
+	addr = 3;
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
+
 Out:
 	kfree(pia);
 	return 0;
-- 
2.53.0



