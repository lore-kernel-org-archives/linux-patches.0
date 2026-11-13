Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590517;
	b=XlE+A7Or6gXgA0T3WnP97oZfQPUyBCu5ySBJ9yJwgt+dlUH+4ipO0IpWr7IIpzOQ3pLN
	 SfK0jmnEVQLvvOlhcx6aShSWXYHn39HvRIgGQvOiD84XJKP8e9VvsmP/NTmHNIC+0KFsF
	 amiIVE2vXDABWJu/IWDQYh+zTchF+urIDkUfWzcq/tZxAUKQ1ln9PZiON2zN9VyNf39HH
	 /BlFWPYk1May03wRq826CUkJ4Eu9C0OrTIN7K4UIHPAv1oYtFjvQmfkgoum5y6qJTNefl
	 X7oKslc6oPtAoHpYfKnVF16pudNAFj8jYdThRwrSR0tkCEjY2Rqcvym/U0IZjk8GCkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590517;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fY81w7YEiNZZUer418Rzi5W6JX9VtOAWDZaQbWzrWLU=;
	b=vVxaPIHKMCFTdehj7gv1lpLskivZGh12mQQRx2Cf5aZXdZq+Y1cZjCGk64vd1GYyulH/
	 /7WHwXIo5h8/XaXi62JLm/s6n5ZsoB6KPkHuRyiaT45PRk/Lm4xR5GYqNX4xgunXmCu+L
	 ay68L04QDWDIR02i7gZAQXxp9IUxVo4fZVM0jlfMJr60KA8T71AdjsLAMA5NJ6cJNfaXC
	 Nc1sPMqKdGQ96Z98peW9XPxlyHyhotxaz5ziUMN+vzRXS4EBD2HmMVBkhNZ8PFb6XeGgg
	 tLRiy01itP9ig0HlFbNG36Qe18hSPHV+0QJGr0eCt3NxjVtLqhffUWTGxluUA+3CXPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a4NAtfb2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 938CD606A8A7;
	Fri, 13 Nov 2026 17:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a4NAtfb2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F84A1F000C8;
	Fri, 13 Nov 2026 17:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590517;
	bh=fY81w7YEiNZZUer418Rzi5W6JX9VtOAWDZaQbWzrWLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a4NAtfb2seYh7mRHNophPlBPcimWW1wqeHumDEutYfN1u20dBM0sZU7pBLWzVlkJW
	 L7Ce0/2OdzclID8ZPBB4tUOELugQcUmwJ8sdzcqMRtp7a5eBjLWfkSRtH0DuAtU4Kh
	 2Td6q+H0fdE87F3pft1PsDMpiNJ53EUniqNUFICY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akshay Jindal <Akshay.Jindal@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 455/686] iommu/amd: Skip non-IVMD entries when parsing IVRS memory definitions
Date: Fri, 13 Nov 2026 10:49:48 -0500
Message-ID: <20261113153836.289577763@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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
index 16c26d75f46f4..c20034b8693fc 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -2721,6 +2721,15 @@ static int __init init_unity_map_range(struct ivmd_header *m,
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
@@ -2732,10 +2741,11 @@ static int __init init_memory_definitions(struct acpi_table_header *table)
 
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



