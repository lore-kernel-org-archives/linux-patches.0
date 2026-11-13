Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591266;
	b=mcwqb8/P9GacLd/OqL0b8cwX3FS076BLrVZ1GJX8Ccvkkwl5WwvmfVmsfEdv3nJwr9jy
	 +kDtG+359Svctg4H9hcwB+JuWILhj+2Im2zFqA8UpXGjtTVELma/W5NLyEj/am8N9HlSm
	 3Sc9Q70c1KYivi24z2h+q4TlzjUWE9nOfoKv/tBpA27/W485CySBYToXTHhiU5L9Mzc98
	 q/24oOlUqB1XsSuEXDowIK5teXg/QHuINfUOU3s24Hw8DnqfiiSFMLgm+0Uul7r0RrqyZ
	 Gr2t1UbkkBUgVTkBWMzsgtZ0uM0eewHdY95OigQKhpj2U22s51EQ8a9Zy57R0q9uaaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591266;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JUEhnYJog5OsBJOh2yOLaG+dDUGjnR4Z60NM9rBI1PE=;
	b=P41qN4FL3jQg2AL0Swtq9PJd9B2HrRs0GhBQcS8AIDmaq9cZC8qNZdhvUe0FppEEG/qN
	 wrbeJ68nN2X7JwMfqRJX8AAwi9dSYJTdyId/E8/SDXikc6NnTlgEDKSMN8AONAygpPcBc
	 rKvh+KrMNoesFjRilquwtXLbvAYXptNUyT0ZSKM7UBC1X+4Da2ECiBQpNDhzbHNk9ZSuv
	 zy8VpWrQyonNPq5fohj9qg/Ui2kSZC8DGGgI8Ltyl8Fe8hPUsxl6bFD/UEilBZJTjcbC9
	 YA3imzoYbDTwjehzT9e2cL7BjTpuw0fJQhNf2CZrfQO9XjU7uZNtHXumEaGqSbzDLrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0cPL2RCM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAA186076F97;
	Fri, 13 Nov 2026 17:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0cPL2RCM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 577D91F000C4;
	Fri, 13 Nov 2026 17:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591266;
	bh=JUEhnYJog5OsBJOh2yOLaG+dDUGjnR4Z60NM9rBI1PE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0cPL2RCMuBufxnKBBJVBMC0AJ8VRZCkF94PSdZWv+27zHYatsHTpDhRe4L9lMw1ov
	 m40IP/IUioxxONi2xiXxi0TwO55FmB1dgrRtaGFxpJx/usi9jGAf2odSnmMC3Xfatm
	 3NMffvO6jkv2gjcA1GsMrshjF+RSWONt6b5cSA0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akshay Jindal <Akshay.Jindal@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 390/670] iommu/amd: Skip non-IVMD entries when parsing IVRS memory definitions
Date: Fri, 13 Nov 2026 10:49:14 -0500
Message-ID: <20261113153824.975743480@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Akshay Jindal <Akshay.Jindal@amd.com>

[ Upstream commit e62df37e0eff4d670e78bbd415be2c1675883c15 ]

init_memory_definitions() walks every top-level subtable including the
IVHD blocks (type 0x10/0x11/0x40) in the IVRS ACPI table. It interprets
each one as a 'struct ivmd_header', solely on m->flags, without first
checking that the subtable's type actually is one of the IVMD types
(ACPI_IVMD_TYPE, ACPI_IVMD_TYPE_ALL, ACPI_IVMD_TYPE_RANGE).

    if (m->flags & (IVMD_FLAG_UNITY_MAP | IVMD_FLAG_EXCL_RANGE))
            init_unity_map_range(m, table);

IVMD_FLAG_UNITY_MAP (0x01) occupies the same bit position as the IVHD
flags field's HtTunEn bit. Unlike real hardware, QEMU's AMD IOMMU
emulation sets HtTunEn unconditionally (flags=0xD1 for type 0x10,
0x11 for type 0x11), so every QEMU-emitted IVHD block is misidentified
as a unity-map/exclusion-range IVMD entry, which subsequently results
in the creation of a bogus pci segment. Eg:

    AMD-Vi: PCI segment : 0x4000, last bdf : 0x0000

Fix by checking the subtable's type before treating it as IVMD.

Fixes: be2a022c0dd0 ("x86, AMD IOMMU: add functions to parse IOMMU memory mapping requirements for devices")
Cc: stable@vger.kernel.org
Signed-off-by: Akshay Jindal <Akshay.Jindal@amd.com>
Signed-off-by: Vasant Hegde <vasant.hegde@amd.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/init.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index 54aa09e1174d3..6cc3d2406812c 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -2570,6 +2570,15 @@ static int __init init_unity_map_range(struct ivmd_header *m,
 	return 0;
 }
 
+static bool ivrs_block_type_ivmd(u8 type)
+{
+	if (type == ACPI_IVMD_TYPE ||
+	    type == ACPI_IVMD_TYPE_ALL ||
+	    type == ACPI_IVMD_TYPE_RANGE)
+		return true;
+	return false;
+}
+
 /* iterates over all memory definitions we find in the ACPI table */
 static int __init init_memory_definitions(struct acpi_table_header *table)
 {
@@ -2581,10 +2590,11 @@ static int __init init_memory_definitions(struct acpi_table_header *table)
 
 	while (p < end) {
 		m = (struct ivmd_header *)p;
+		p += m->length;
+		if (!ivrs_block_type_ivmd(m->type))
+			continue;
 		if (m->flags & (IVMD_FLAG_UNITY_MAP | IVMD_FLAG_EXCL_RANGE))
 			init_unity_map_range(m, table);
-
-		p += m->length;
 	}
 
 	return 0;
-- 
2.53.0



