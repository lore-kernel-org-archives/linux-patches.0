Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1518568FB2;
	Wed,  9 Sep 2026 14:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963614; cv=none; b=Kc/9wa0Yb+6s7jFDjv4egnhZ732KS7RA0MLKTppgetgwEAHtQ94aQ3SkJ27zCB8T3eiJWDyVP6F9OyB7xYRdHQH8rb7D0askJcVeaAJgYD7Ums9tNL144j/h8Xz9La5ZqJmTyKlZLlSI6qQB4WaKHPw5psxK2yJ80XHrbIi2+hM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963614; c=relaxed/simple;
	bh=G0nV9YNSA1jGSfaYWENq06R9QhtJBjnMFhcMfVs3Ous=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YYE4TUvKkgRmVkhklbAKZKQu0P6ida51K+skVeii76G4yRzeuR+DZH/gpxGq5+bArIWLZzgVzloSWKL14jxkxNgjTKs3xD9dvI4HgF2O8mbCLSWvMOwsaC+ZUwo8mnCu7AoRDwM/K5s0LSyTqTp4HSvdHsCm01Ny5MNThzSq5tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sSrSautj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sSrSautj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E67641F00A3A;
	Wed,  9 Sep 2026 14:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963612;
	bh=rsT3sFpqJ4H4+a3/vmNXIp4Q3gKF0MB5qSltjYd5JTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sSrSautjEXdY/2QAYNJejPEN/dlogv7nmIwlm3E9ZkhlhcE9LEpNxOboYk/SclcRw
	 2ATl+YgjdXxgTGijurs8pxQHZXFzaC7l1ZYjAlTp6GtaDKNU3di9p2MVO54gm+tp4g
	 P6UVXSrRNS37Uf3NuIMeWr2XZI6keT6IJUYMmf+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.18 139/583] mtd: rawnand: validate ONFI extended parameter page sections
Date: Wed,  9 Sep 2026 15:37:04 +0200
Message-ID: <20260909134242.965661035@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

commit e5e415262330bd70f983e091d8919d9dcd99e475 upstream.

nand_flash_detect_ext_param_page() allocates the length declared by the
ONFI parameter page, then treats the data as a fixed header followed by
variable-length sections. It reads that header and advances over sections
without first proving that the fixed page and each current section fit in
the allocation.

Reject pages shorter than the fixed header, track the remaining variable
area while walking sections, and require the ECC section to contain every
field read from struct onfi_ext_ecc_info. Use device-scoped diagnostics
that identify the malformed ONFI section.

Fixes: 6dcbe0cdd83f ("mtd: get the ECC info from the Extended Parameter Page")
Cc: stable@vger.kernel.org
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/nand_onfi.c |   27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

--- a/drivers/mtd/nand/raw/nand_onfi.c
+++ b/drivers/mtd/nand/raw/nand_onfi.c
@@ -35,16 +35,21 @@ static int nand_flash_detect_ext_param_p
 					    struct nand_onfi_params *p)
 {
 	struct nand_device *base = &chip->base;
+	struct mtd_info *mtd = nand_to_mtd(chip);
 	struct nand_ecc_props requirements;
 	struct onfi_ext_param_page *ep;
 	struct onfi_ext_section *s;
 	struct onfi_ext_ecc_info *ecc;
+	size_t remaining, section_len;
 	uint8_t *cursor;
 	int ret;
 	int len;
 	int i;
 
 	len = le16_to_cpu(p->ext_param_page_length) * 16;
+	if (len < sizeof(*ep))
+		return -EINVAL;
+
 	ep = kmalloc(len, GFP_KERNEL);
 	if (!ep)
 		return -ENOMEM;
@@ -77,11 +82,29 @@ static int nand_flash_detect_ext_param_p
 
 	/* find the ECC section. */
 	cursor = (uint8_t *)(ep + 1);
+	remaining = len - sizeof(*ep);
 	for (i = 0; i < ONFI_EXT_SECTION_MAX; i++) {
 		s = ep->sections + i;
-		if (s->type == ONFI_SECTION_TYPE_2)
+		section_len = s->length * 16;
+		if (section_len > remaining) {
+			dev_dbg(&mtd->dev,
+				"ONFI extended parameter section %d exceeds page\n",
+				i);
+			goto ext_out;
+		}
+
+		if (s->type == ONFI_SECTION_TYPE_2) {
+			if (section_len < sizeof(*ecc)) {
+				dev_dbg(&mtd->dev,
+					"ONFI extended parameter ECC section %d is too short\n",
+					i);
+				goto ext_out;
+			}
 			break;
-		cursor += s->length * 16;
+		}
+
+		cursor += section_len;
+		remaining -= section_len;
 	}
 	if (i == ONFI_EXT_SECTION_MAX) {
 		pr_debug("We can not find the ECC section.\n");


