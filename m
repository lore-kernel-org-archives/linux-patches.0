Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC1FB410D36;
	Fri,  4 Sep 2026 05:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499135; cv=none; b=Woro+vYkxjEEKn0rhEso7s36PH3C/uY4kS7sz9DOWcTbFTnG6EoaQJj6+drc6NIwxvtqzfzeagJbbscUfC9RRrLihRKXdHmWvO/awnwotV5VLDP6hHEBATi79nU/BE0+mtkxB6h+qfG/2sEODLjfTCV0v+1H/kgGU+hss5+FV/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499135; c=relaxed/simple;
	bh=q9vMvF0kBJzonGbgzSu2OvRWAhLVt9AKGnseGek8apk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Stk4aOD9SPquZtSZ227SXZfRLj6aBD0pmfgQoWKNg7z0hZFGP/qrN6Qc9ZHo+hIjP0TRNH330+F2UIdZSTBdPmypKW61DvSdYVqzTxGVUWp38MG/6QaT7AYlMZrYhP3cTjTCS9fVmYz8K+JIcgOwiVNU/snvAoy/WX+ZSboWF1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xIRGfZ9r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xIRGfZ9r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B6D11F00A3D;
	Fri,  4 Sep 2026 05:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499134;
	bh=jDSeazDw0On975CP8HFw6F7cMgOxMob8H1zbXZqJsuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xIRGfZ9rvWH4rW9EALedxHK3Ec9/q9vGeIUjTesg4oByneQ+03pVwaXvPCs9BaONF
	 Y2KpAKjbBEIkJfzSb5AVAdLaQfumL0thIRc/8x3OodF+G5Z6WBWWdMkccM66AFhwcs
	 Jg51V37xwH1b5w4lRpjG59Xn+qEVsAVnluwmUpK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongling Zeng <zenghongling@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 7.2 267/713] ntfs: validate non-resident attribute offsets
Date: Fri,  4 Sep 2026 06:53:55 +0200
Message-ID: <20260904045809.822556830@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongling Zeng <zenghongling@kylinos.cn>

commit a83e82b0ec3ae523028e24813f23f18b43e8fc1c upstream.

ntfs_attr_update_meta() shifts the attribute name when converting between
non-sparse and sparse attributes. Converting to sparse also adds the
compressed_size field before the name and mapping pairs, requiring eight
additional bytes in the attribute record.

However, the validator does not check that name_offset is within safe
boundaries for these operations or that the additional space is available.
A malicious MFT record could set name_offset such that:

1. The name is positioned at the very end of a non-sparse attribute.
   Converting to sparse would shift the name forward by 8 bytes,
   writing beyond the attribute boundary.

2. The name overlaps with the mapping pairs, causing corruption during
   conversion.

Add validation to ensure:
- For named attributes, name_offset is within valid bounds
- Name does not extend beyond the attribute or overlap with mapping pairs
- For non-sparse, non-compressed attributes, eight bytes are available
  after mapping_pairs_offset for the compressed_size field

The space check also covers unnamed attributes, for which name_offset = 0
is valid and no name range needs to be checked.

Fixes: 7e2a1c554bc4 ("ntfs: Fix min_len for compressed/sparse attributes in ntfs_non_resident_attr_value_is_valid()")
Cc: stable@vger.kernel.org
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
Co-developed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs/attrib.c |   24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

--- a/fs/ntfs/attrib.c
+++ b/fs/ntfs/attrib.c
@@ -693,6 +693,8 @@ static bool ntfs_non_resident_attr_value
 	u32 attr_len;
 	u32 min_len;
 	u16 mp_offset;
+	u16 name_offset;
+	u32 name_end;
 
 	attr_len = le32_to_cpu(a->length);
 	min_len = offsetof(struct attr_record, data.non_resident.initialized_size) +
@@ -701,7 +703,27 @@ static bool ntfs_non_resident_attr_value
 		return false;
 
 	mp_offset = le16_to_cpu(a->data.non_resident.mapping_pairs_offset);
-	return mp_offset >= min_len && mp_offset <= attr_len;
+	if (mp_offset < min_len || mp_offset > attr_len)
+		return false;
+
+	if (a->name_length) {
+		name_offset = le16_to_cpu(a->name_offset);
+
+		if (name_offset < min_len || name_offset >= attr_len)
+			return false;
+
+		name_end = name_offset + a->name_length * sizeof(__le16);
+		if (name_end > attr_len || name_end > mp_offset)
+			return false;
+	}
+
+	/* Ensure there's room for the compressed_size field if needed. */
+	if (!(a->flags & (ATTR_IS_SPARSE | ATTR_COMPRESSION_MASK)) &&
+	    attr_len - mp_offset <
+			sizeof(a->data.non_resident.compressed_size))
+		return false;
+
+	return true;
 }
 
 static bool ntfs_attr_value_is_valid(struct ntfs_volume *vol,


