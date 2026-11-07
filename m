Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063378;
	b=1IpfUlj/Pp4mccnhqfKTcl72zSvUljDif9Bi5Xz1BxOx6ne/Ut2cHH5ZN6/TLBM79VnF
	 3H5+JCWZGildatgJhgsgiMUkGab0DsjNC4QtOPMYAKB5dZeNv+65Sk4/bz8RLUQJtNPr8
	 wvI7JR6gd/8CHZ3ESXSQ1hEmrK9ZCx1TWqxq/4jUfPKzDiE5u9Gc3/rdowELwatn+iGIT
	 jAr75fVjHKPNuodLeDjjbKndqtxwvHVt/DXKM99bGIXismui/JNWFg5HJ0FIpLN/PKRe7
	 jPy9JsHWFY0uerAbZP30HO19jmNUE1l3WVNx3nwp8MzhyFgKne5+TnyEGNbw8PImrdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063378;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+tGO1yM9oMvXy2S9tNC83a5H0vw4YLN8kh5uolbqtQg=;
	b=Wacu0cHvYQj7CZYazdUQ/60eiQqcSNroYwJm8hKMusfTBtTyyHkIx4abxJvsKqUy/shE
	 5cB+IrdJtFrlDpMzoB7Jr552Il9IGQITngd9tYii/u8e7QU51n1OC+ydz1daTe5oiKbkv
	 NqzGhN5A1T587f8A5AaDkQJ6EpZ3MTfZEeJX9LPbgQOhD8T3qcDrR/ia4CngyrjAarofg
	 PKiAKAAFJ1kghDsHHgGdsG5JWPOovhf2lqRkUbTNJBOoi8mjeaGLS9jLnMBiWRr1gw1Db
	 C+cwvPGuN0oQTQOG111EpcnObZmuG4M2LWUC+WX8u51ogLfDa4XbIA9moaicUORsgRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rY8f6nlu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5657C606A32E;
	Sat,  7 Nov 2026 14:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rY8f6nlu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D5FE1F008A1;
	Sat,  7 Nov 2026 14:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063378;
	bh=+tGO1yM9oMvXy2S9tNC83a5H0vw4YLN8kh5uolbqtQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rY8f6nlut0CYToDfHLYOv0xQTCM5s6NAcy+ElyZ+6LjJz7zJ7norh8cxeyLdSOVW6
	 zLWOIMVLTuFRNVGgYS0hmfUminCgfFCrooqU4YaO+jH2VN6eOMpY4kWfoZBYcvGsbe
	 z+K+NLU0po7Iv9HymBBvjzYAdOf+Xr7JZe1ivm2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ashish Kalra <ashish.kalra@amd.com>,
	Ankit Soni <Ankit.Soni@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Matt Fleming <mfleming@cloudflare.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 552/869] iommu/amd: Program device table when kdump reuse fails
Date: Sat,  7 Nov 2026 08:53:54 -0500
Message-ID: <20261107134912.074229013@linuxfoundation.org>
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

From: Matt Fleming <mfleming@cloudflare.com>

[ Upstream commit 05d62be400f3ae0f6856f6910a1281e67cbaabcf ]

Commit 38e5f33ee359 ("iommu/amd: Reuse device table for kdump") made
iommu_set_device_table() return early in every kdump kernel. That is
needed when the previous kernel's device table is reused: the base
register already points at it, and on SNP-enabled systems the register
is locked.

But if reuse isn't possible, early_enable_iommus() falls back to the
freshly allocated table and calls early_enable_iommu(). Because of the
early return, that table is never written to the base register. The
IOMMU keeps using whatever table the register pointed at before, while
the driver writes entries into the new one.

Only skip the write when the previous kernel's table was reused.

Fixes: 38e5f33ee359 ("iommu/amd: Reuse device table for kdump")
Cc: stable@vger.kernel.org
Reviewed-by: Ashish Kalra <ashish.kalra@amd.com>
Reviewed-by: Ankit Soni <Ankit.Soni@amd.com>
Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Signed-off-by: Matt Fleming <mfleming@cloudflare.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/init.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index c07c3a01b978b..0572e1a674f0b 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -409,7 +409,13 @@ static void iommu_set_device_table(struct amd_iommu *iommu)
 
 	BUG_ON(iommu->mmio_base == NULL);
 
-	if (is_kdump_kernel())
+	/*
+	 * A kdump kernel that reuses the previous kernel's device table must
+	 * leave the base register alone. It already points at that table, and
+	 * with SNP enabled the register is locked. If reuse failed, program
+	 * the freshly allocated table like a normal boot.
+	 */
+	if (iommu->pci_seg->old_dev_tbl_cpy)
 		return;
 
 	entry = iommu_virt_to_phys(dev_table);
-- 
2.53.0



