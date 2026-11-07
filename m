Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062777;
	b=dkrPIhP9QdQCZTLZ9cW7gAejvd1hN/yB4wpu0rl2ZgzrwmIAbeku/Mdc03DAVebtcQCI
	 IneiFQiGdXQH86fsgBJMZm4VIWLLDhZQvTgW7mldjZKWmreFmHG5RblOAmjv6AY+zovqf
	 vq9D9E/cbqvgAhSUXNQSXfH85ijj7FBKrz4QmUMMlAwbq4wydFxLlwxX6lrBnAiWUQQAm
	 O9j7iGj4H7GlQsDoSM9LwbXUgZ/WrbiY0qBV+xFRWl0c0QLmDZP2Yv/A1C4Qu/BkoDlfV
	 Zn6+1Pr2ncX8p262PgHqpvuzyhvCa7X78t8myjKM/toCKoNjk9GhFxO69ipS1XXH9fA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062777;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1/q/LON0eHHEtMXpkHe2c5hXsFJSLE3v+JM8aTm5MUM=;
	b=hAthn3omvj4ffvEDmD+KybCqhps+2ntEj44kXxesdx49uly/i64Zt2pHrEije2s3Rv5U
	 8IhTBd6awP531vo7fB/LjvIXr4J5mnmjWeiCRTiy3+gwZffpKUnDG1rRPULPSi2d9/h4D
	 0eeq9xixH4ACYmU+u9wfSrLbkzygOKeE70q8LqjPXY01oS+1LljPBj8MKjFy4PvlZ4G0j
	 uAXBDEJ8Wd9noQwtif3vdwDJiK5SZflZY1yQD+7sSW2d2QNtkJIaksk+UGG9hO+X0wiRS
	 iFKvofhIpR2DCtzPo2uH1CG24hAwVmBmVFWiqzPdNnajCy0BYHs9IQtn1E8EnHurljg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wz+tiaDU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 984EA606A326;
	Sat,  7 Nov 2026 14:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wz+tiaDU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 472811F0089F;
	Sat,  7 Nov 2026 14:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062777;
	bh=1/q/LON0eHHEtMXpkHe2c5hXsFJSLE3v+JM8aTm5MUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wz+tiaDUeLQpwDbvasZX0TEgJ0O+ROqhTBnJYbmjBUety3ruKxx4jX41LM7ymnYcm
	 GfCA3mZOA+xE7u1FySTP8OFqNMHIdXRBXNCOO3LipNSSBVNRCypQUTO/loN4r1oCEG
	 MgsjN+c2x4ZSBCWBrZxS/EUZKTrCVdieF1sJVN48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 047/869] soc: qcom: geni-se: Fix fw_end computed before round-up; propagate size to caller
Date: Sat,  7 Nov 2026 08:45:29 -0500
Message-ID: <20261107134853.709721122@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>

[ Upstream commit d1750c530e9b9b75c8d1b29d3c76e052a049f51f ]

fw_end was computed from the raw fw_size_in_items, before the odd-word
round-up. A segment with an odd word count could pass the bounds check
at the unrounded value but then be copied one word past the validated
limit. Move fw_end (and the cfg_{idx,val}_end) calculations to after
the round-up so they always reflect the true copy extent.

The caller geni_load_se_fw() re-read hdr->fw_size_in_items for the
memcpy_toio() length, bypassing the validated and rounded value
established by geni_find_protocol_fw(). Add a fw_size_out output
parameter and use it in the caller.

Fixes: d4bf06592ad6 ("soc: qcom: geni-se: Add support to load QUP SE Firmware via Linux subsystem")
Cc: stable@vger.kernel.org
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260821-fix-write-to-read-only-firmware-buffer-v3-3-43e6a3abd651@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/qcom-geni-se.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/soc/qcom/qcom-geni-se.c b/drivers/soc/qcom/qcom-geni-se.c
index f73ac13e90014..917f43192e950 100644
--- a/drivers/soc/qcom/qcom-geni-se.c
+++ b/drivers/soc/qcom/qcom-geni-se.c
@@ -991,6 +991,8 @@ EXPORT_SYMBOL_GPL(geni_icc_disable);
  * @se: Pointer to the serial engine structure.
  * @fw: Pointer to the firmware image.
  * @protocol: Expected serial engine protocol type.
+ * @fw_size_out: Non-NULL output parameter; receives the rounded, validated
+ *               firmware word count on success.
  *
  * Identifies the appropriate firmware image or configuration required for a
  * specific communication protocol instance running on a Qualcomm GENI
@@ -1000,7 +1002,8 @@ EXPORT_SYMBOL_GPL(geni_icc_disable);
  * Return: pointer to a valid 'struct se_fw_hdr' if found, or NULL otherwise.
  */
 static struct se_fw_hdr *geni_find_protocol_fw(struct geni_se *se, const struct firmware *fw,
-					       enum geni_se_protocol_type protocol)
+					       enum geni_se_protocol_type protocol,
+					       u32 *fw_size_out)
 {
 	struct device *dev = se->dev;
 	const struct elf32_hdr *ehdr;
@@ -1050,11 +1053,6 @@ static struct se_fw_hdr *geni_find_protocol_fw(struct geni_se *se, const struct
 
 		sefw = (struct se_fw_hdr *)(fw->data + phdr->p_offset);
 		fw_size = le16_to_cpu(sefw->fw_size_in_items);
-		fw_end = le16_to_cpu(sefw->fw_offset) + fw_size * sizeof(u32);
-		cfg_idx_end = le16_to_cpu(sefw->cfg_idx_offset) +
-			      le16_to_cpu(sefw->cfg_size_in_items) * sizeof(u8);
-		cfg_val_end = le16_to_cpu(sefw->cfg_val_offset) +
-			      le16_to_cpu(sefw->cfg_size_in_items) * sizeof(u32);
 
 		if (le32_to_cpu(sefw->magic) != SE_MAGIC_NUM || le32_to_cpu(sefw->version) != 1)
 			continue;
@@ -1067,6 +1065,12 @@ static struct se_fw_hdr *geni_find_protocol_fw(struct geni_se *se, const struct
 			sefw->fw_size_in_items = cpu_to_le16(fw_size);
 		}
 
+		fw_end = le16_to_cpu(sefw->fw_offset) + fw_size * sizeof(u32);
+		cfg_idx_end = le16_to_cpu(sefw->cfg_idx_offset) +
+			      le16_to_cpu(sefw->cfg_size_in_items) * sizeof(u8);
+		cfg_val_end = le16_to_cpu(sefw->cfg_val_offset) +
+			      le16_to_cpu(sefw->cfg_size_in_items) * sizeof(u32);
+
 		prog_ram_depth = FIELD_GET(PROG_RAM_DEPTH_MSK,
 					   readl_relaxed(se->base + SE_HW_PARAM_2));
 		if (fw_size >= prog_ram_depth) {
@@ -1081,6 +1085,7 @@ static struct se_fw_hdr *geni_find_protocol_fw(struct geni_se *se, const struct
 			continue;
 		}
 
+		*fw_size_out = fw_size;
 		return sefw;
 	}
 
@@ -1191,11 +1196,11 @@ static int geni_load_se_fw(struct geni_se *se, const struct firmware *fw,
 {
 	const u32 *fw_data, *cfg_val_arr;
 	const u8 *cfg_idx_arr;
-	u32 i, reg_value;
+	u32 i, reg_value, fw_size_in_items;
 	int ret;
 	struct se_fw_hdr *hdr;
 
-	hdr = geni_find_protocol_fw(se, fw, protocol);
+	hdr = geni_find_protocol_fw(se, fw, protocol, &fw_size_in_items);
 	if (!hdr)
 		return -EINVAL;
 
@@ -1272,7 +1277,7 @@ static int geni_load_se_fw(struct geni_se *se, const struct firmware *fw,
 
 	/* Program RAM address space. */
 	memcpy_toio(se->base + SE_GENI_CFG_RAMN, fw_data,
-		    le16_to_cpu(hdr->fw_size_in_items) * sizeof(u32));
+		    fw_size_in_items * sizeof(u32));
 
 	/* Put default values on GENI's output pads. */
 	writel_relaxed(0x1, se->base + GENI_FORCE_DEFAULT_REG);
-- 
2.53.0



