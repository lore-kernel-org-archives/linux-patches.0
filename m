Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216751;
	b=YLDoq2OLE83AISVIJFuuQRR9jqw7I24oN/RydAb3QuKBvJ2XtgNLeh4BuDCEMGAFY/te
	 LXLB1SzanSx5fGSImCYO973NMEdF76D10I8obZHNaG7N8XidlaWNJDChcT9R27AZc5A2m
	 AX1enR10/BpdeMRb04hxSzezVOqkFh2+AkeVAsCbmsHMpcv4+qabM2BItAagAEbVvQJVR
	 5DUaFUNlHBY2DNeHVzB2T7GvwjK3pNf0V1laKUMjZpSdx4bi0l7OMxEX63RH5m8Ywkwal
	 bue1hW/MqWqutqeBubCZd6OvlWM4vk7PuTxWmnxQwfgXDqVSI+vmr2PoRqajKgE/02Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216751;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gcRfK1p8VSWL+c4HSEWNaOp5p9Jv8ioozOpOvxgecv8=;
	b=w75dci92Zdi8sCUFgPYgXXxrNcHbqVh9ikagBmQqZjukg+SClw2tszCl50xwHx8uzfpk
	 MqBpsBNOE06NqSPq2gF/707fKH395N3bCdjunq4Zqy6kId64yGCj1V4+fSJ0ogQHt9pvl
	 rxmVIJsFp4uWCNP1dtJJKU073iip+QpNZcIqYZ7tQnsavbrtD9yopMd9H7J0dUGwcMcLb
	 WGadCAHkxxoOVA2tc/Zc4LHPkbFI54Za5HAStYMjkB1HCQVG099cMzQvrB1BPM5+DpDcI
	 5eZjKr2Um+j4+2hUFFFIgUy68OLkH898IhcgGrl/oe/5boRh0OV7BpWzHtRn8uxyRag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NvJiCxOm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39940606A31A;
	Wed, 28 Oct 2026 19:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NvJiCxOm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 869261F01825;
	Wed, 28 Oct 2026 19:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216751;
	bh=gcRfK1p8VSWL+c4HSEWNaOp5p9Jv8ioozOpOvxgecv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NvJiCxOmbLKkLtEr/JsaqGNpTO3vGMm3dYvxXjvSx4gta6L60El2vezuzWkcziFa9
	 X1Fba6NJdcBwplWD2DsGYa16bjUbGVszE7RVb+fX1pOa6ncK5dNNvptZnlYakp2JnX
	 riKVRiZT5k6vXNfTch4L+mp1YfmavX9onnNbZbnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Timber <dxdt@dev.snart.me>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1666/1887] exfat: fix handling of damaged volume in exfat_create_upcase_table()
Date: Wed, 28 Oct 2026 18:02:42 +0100
Message-ID: <20261028170537.371018584@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Timber <dxdt@dev.snart.me>

[ Upstream commit 20dd3185d13865214ff25b0bf7b931e8d73be1ac ]

When the size of the upcase table is set to zero in the dentry for any
reason(e.g. corrupted media or misbehaving device), an integer overflow
causes the module to loop indefinitely.

If the size of the upcase table is read zero, do not attempt to load the
table. Instead, fallback to loading the default upcase table. If the
size of the upcase table is zero or no upcase table is found, raise
exfat_fs_error() to mark the volume read-only.

Signed-off-by: David Timber <dxdt@dev.snart.me>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exfat/nls.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/fs/exfat/nls.c b/fs/exfat/nls.c
index e027b34356969..4bfe807716deb 100644
--- a/fs/exfat/nls.c
+++ b/fs/exfat/nls.c
@@ -778,13 +778,18 @@ int exfat_create_upcase_table(struct super_block *sb)
 
 			tbl_clu  = le32_to_cpu(ep->dentry.upcase.start_clu);
 			tbl_size = le64_to_cpu(ep->dentry.upcase.size);
-
-			sector = exfat_cluster_to_sector(sbi, tbl_clu);
-			num_sectors = ((tbl_size - 1) >> blksize_bits) + 1;
-			ret = exfat_load_upcase_table(sb, sector, num_sectors,
-				le32_to_cpu(ep->dentry.upcase.checksum));
-
+			if (tbl_size) {
+				sector = exfat_cluster_to_sector(sbi, tbl_clu);
+				num_sectors = ((tbl_size - 1) >> blksize_bits) + 1;
+				ret = exfat_load_upcase_table(sb, sector, num_sectors,
+					le32_to_cpu(ep->dentry.upcase.checksum));
+			} else {
+				exfat_fs_error(sb,
+					       "bad upcase table size (0 bytes). Please run fsck");
+				ret = -EINVAL;
+			}
 			brelse(bh);
+
 			if (ret && ret != -EIO) {
 				/* free memory from exfat_load_upcase_table call */
 				exfat_free_upcase_table(sbi);
@@ -799,6 +804,8 @@ int exfat_create_upcase_table(struct super_block *sb)
 			return -EIO;
 	}
 
+	exfat_fs_error(sb, "no upcase table entry. Please run fsck");
+
 load_default:
 	/* load default upcase table */
 	return exfat_load_default_upcase_table(sb);
-- 
2.53.0



