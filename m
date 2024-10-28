Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F2FE18DF68;
	Mon, 28 Oct 2024 06:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097305; cv=none; b=UnFCdMtMz4OfoY1vLbOMgseguL8I62J5fcJ1A/2Nsa94sJoVEaxLqRQeUv8NsSfoM4ADZmPG0EXeixNvOXhIlpSCGmGLqdAgvGiYVeAFPCusp8av/Q9fQr+nLeRu6nMofGieDQ/2rolnhnNfXnU5drtYZi5AUDSMleCVxEpCXxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097305; c=relaxed/simple;
	bh=y8MSHOYx24aZ3HiP5q8cLqWcSAOsTCk4gmAfUg9g8Q0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gg/9O3GsJeBzc4cjuhF/C6vNAgIC6iNL5zn2Mgw5pMWt6mVUxR0u5cI2hjNahNQ9xJPyBw6ABVWMgosD/R40M9yI/tSNuaCQIr9YrLUJySUlfJnhw8xj8NQXfNmNhL2rT3HDBhiq3k44CBJVuO/OG+k1FgpLmuEb2UYOJQciHbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XRk6Hh+L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XRk6Hh+L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2CD0C4CEC3;
	Mon, 28 Oct 2024 06:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097305;
	bh=y8MSHOYx24aZ3HiP5q8cLqWcSAOsTCk4gmAfUg9g8Q0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XRk6Hh+Lm2o7CpiU5nYCIUCxEpKrt0Buz5/B0dBTH/yO1rEM+Pt/E7uuxdBoRBD8x
	 4qKNsZOVmBsGOapp7ScbrgOUWcptij5ecozZ4RiY9j/wk952K1jB1mKnTjgxNN1zHD
	 wtzINLwfJBJBPtWASZqJgFzB9EIoOzIbTxXR/Iw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Xiangyu Chen <xiangyu.chen@windriver.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 073/137] fs/ntfs3: Add more attributes checks in mi_enum_attr()
Date: Mon, 28 Oct 2024 07:25:10 +0100
Message-ID: <20241028062300.776820907@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062258.708872330@linuxfoundation.org>
References: <20241028062258.708872330@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 013ff63b649475f0ee134e2c8d0c8e65284ede50 ]

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
CVE: CVE-2023-45896
Signed-off-by: Xiangyu Chen <xiangyu.chen@windriver.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/record.c | 67 ++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 54 insertions(+), 13 deletions(-)

diff --git a/fs/ntfs3/record.c b/fs/ntfs3/record.c
index 1351fb02e1401..7ab4527105729 100644
--- a/fs/ntfs3/record.c
+++ b/fs/ntfs3/record.c
@@ -193,8 +193,9 @@ struct ATTRIB *mi_enum_attr(struct mft_inode *mi, struct ATTRIB *attr)
 {
 	const struct MFT_REC *rec = mi->mrec;
 	u32 used = le32_to_cpu(rec->used);
-	u32 t32, off, asize;
+	u32 t32, off, asize, prev_type;
 	u16 t16;
+	u64 data_size, alloc_size, tot_size;
 
 	if (!attr) {
 		u32 total = le32_to_cpu(rec->total);
@@ -213,6 +214,7 @@ struct ATTRIB *mi_enum_attr(struct mft_inode *mi, struct ATTRIB *attr)
 		if (!is_rec_inuse(rec))
 			return NULL;
 
+		prev_type = 0;
 		attr = Add2Ptr(rec, off);
 	} else {
 		/* Check if input attr inside record. */
@@ -226,6 +228,11 @@ struct ATTRIB *mi_enum_attr(struct mft_inode *mi, struct ATTRIB *attr)
 			return NULL;
 		}
 
+		/* Overflow check. */
+		if (off + asize < off)
+			return NULL;
+
+		prev_type = le32_to_cpu(attr->type);
 		attr = Add2Ptr(attr, asize);
 		off += asize;
 	}
@@ -245,7 +252,11 @@ struct ATTRIB *mi_enum_attr(struct mft_inode *mi, struct ATTRIB *attr)
 
 	/* 0x100 is last known attribute for now. */
 	t32 = le32_to_cpu(attr->type);
-	if ((t32 & 0xf) || (t32 > 0x100))
+	if (!t32 || (t32 & 0xf) || (t32 > 0x100))
+		return NULL;
+
+	/* attributes in record must be ordered by type */
+	if (t32 < prev_type)
 		return NULL;
 
 	/* Check overflow and boundary. */
@@ -254,16 +265,15 @@ struct ATTRIB *mi_enum_attr(struct mft_inode *mi, struct ATTRIB *attr)
 
 	/* Check size of attribute. */
 	if (!attr->non_res) {
+		/* Check resident fields. */
 		if (asize < SIZEOF_RESIDENT)
 			return NULL;
 
 		t16 = le16_to_cpu(attr->res.data_off);
-
 		if (t16 > asize)
 			return NULL;
 
-		t32 = le32_to_cpu(attr->res.data_size);
-		if (t16 + t32 > asize)
+		if (t16 + le32_to_cpu(attr->res.data_size) > asize)
 			return NULL;
 
 		if (attr->name_len &&
@@ -274,21 +284,52 @@ struct ATTRIB *mi_enum_attr(struct mft_inode *mi, struct ATTRIB *attr)
 		return attr;
 	}
 
-	/* Check some nonresident fields. */
-	if (attr->name_len &&
-	    le16_to_cpu(attr->name_off) + sizeof(short) * attr->name_len >
-		    le16_to_cpu(attr->nres.run_off)) {
+	/* Check nonresident fields. */
+	if (attr->non_res != 1)
 		return NULL;
-	}
 
-	if (attr->nres.svcn || !is_attr_ext(attr)) {
+	t16 = le16_to_cpu(attr->nres.run_off);
+	if (t16 > asize)
+		return NULL;
+
+	t32 = sizeof(short) * attr->name_len;
+	if (t32 && le16_to_cpu(attr->name_off) + t32 > t16)
+		return NULL;
+
+	/* Check start/end vcn. */
+	if (le64_to_cpu(attr->nres.svcn) > le64_to_cpu(attr->nres.evcn) + 1)
+		return NULL;
+
+	data_size = le64_to_cpu(attr->nres.data_size);
+	if (le64_to_cpu(attr->nres.valid_size) > data_size)
+		return NULL;
+
+	alloc_size = le64_to_cpu(attr->nres.alloc_size);
+	if (data_size > alloc_size)
+		return NULL;
+
+	t32 = mi->sbi->cluster_mask;
+	if (alloc_size & t32)
+		return NULL;
+
+	if (!attr->nres.svcn && is_attr_ext(attr)) {
+		/* First segment of sparse/compressed attribute */
+		if (asize + 8 < SIZEOF_NONRESIDENT_EX)
+			return NULL;
+
+		tot_size = le64_to_cpu(attr->nres.total_size);
+		if (tot_size & t32)
+			return NULL;
+
+		if (tot_size > alloc_size)
+			return NULL;
+	} else {
 		if (asize + 8 < SIZEOF_NONRESIDENT)
 			return NULL;
 
 		if (attr->nres.c_unit)
 			return NULL;
-	} else if (asize + 8 < SIZEOF_NONRESIDENT_EX)
-		return NULL;
+	}
 
 	return attr;
 }
-- 
2.43.0



