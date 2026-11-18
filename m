Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038046;
	b=fAeIkUjQ4JpanKfk+IaBak7O7v6mKC28wVTFuKpYUqqk+ni11HmCI7v4JOBhcDafsSUr
	 51qlKqHH0tMRdfZSnlZ9J3j0+8EPfPlAKdyKv29d3YOk7GJaZ73eyjMxuEFaAjAGTnvQ3
	 pHInAfZ+pIjU03vMDUv7MMGKNZABq9rk8QwIBv5RDUaQS4XCZFMo1UDnq4wwK05gM7FvC
	 uiLbtztP4vGtzHb6AKKiIAWz8aQM0/AZLGoSinZTrncIw7BIij5wv+xf4jVPHeuTd9KOt
	 tas+htJlL6HoXfpdfD9Yc2OvJk+so4fc/cOcW+jDjmnllKFLz3KwIP+d/PlzZ4i7kMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038046;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MQfDqlGGEwXDXLixcg4K5gxZeNHqUG88N6FgEm8pHk0=;
	b=WaLNg0/Q4CRdM15QJGNTZppvlnyLQg4wFItkQhy+1hWNhpb2I/7xESnzhX2nWd+Kb3ZC
	 MeEZF3F6/j79jAim2qyRvX/GwvYT6UqxyyOYGcqbS70GoD5iPwOWpRV+4XnH14lu26lCi
	 HTtT/0O33tk0onb4vnN44VZPLYcs+ZY4yPqyOY1M1XQiyF483985u/C9iKhAjgIy5HbmH
	 OOd8zk5wN+IQTyp2lB5NSLA6MWuojv26rGSp7CtQ+xUF8FHg6F9qk01qHjutcRZam4wqX
	 uA6UHmqGMTulF29Svur27OOn+E9oBr3NEFvn0EX7pedShXJh4/BiiUQrq9/2F1V2nDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CVsSSJ+M;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C07DE606A325;
	Wed, 18 Nov 2026 21:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CVsSSJ+M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D32621F000C5;
	Wed, 18 Nov 2026 21:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038046;
	bh=MQfDqlGGEwXDXLixcg4K5gxZeNHqUG88N6FgEm8pHk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CVsSSJ+MnImlql3gVOQAtmSRIa6CW9cw+lSeWgeaSI7scybLkGNhYX4RkYOQrFF1u
	 EGDMeG9JsBFo0ZVzxUtxXY9aqa8UNonVjowTcHcdpUXnTAisi3CWrgfMvnz/xOpWSj
	 Go35XBrKsxd0Avt5v+NKM+m/VntJLqL4YFiGfTp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akshay Jindal <Akshay.Jindal@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1564/3318] iommu/amd: Skip non-IVMD entries when parsing IVRS memory definitions
Date: Wed, 18 Nov 2026 15:36:26 +0100
Message-ID: <20261118150407.960496599@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 10ab34bed410e..3097c17352655 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -2641,6 +2641,15 @@ static int __init init_unity_map_range(struct ivmd_header *m,
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
@@ -2652,10 +2661,11 @@ static int __init init_memory_definitions(struct acpi_table_header *table)
 
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



