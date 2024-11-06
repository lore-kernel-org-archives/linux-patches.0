Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BDDC1DEFF3;
	Wed,  6 Nov 2024 12:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896561; cv=none; b=rj/iMj9bAulgLSVauh/o7WXu2qLa2AGLXOcVbFNtgc1xZEsje04mjcEYZF0F+P4qGyNNHBw9J3vNuJ2Oi/RVVWuDmMwk+8lL8fFO01BHU4EPGzXbrSpBfCxH2fRDQTWPqoBGXWHqYvYq+r7LsAZLc77qDZf5ARUnzyC16S3eGTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896561; c=relaxed/simple;
	bh=cn6sK+6+9/4NSlphZlN6EsAGVDxgRb3+XY6K5TY0Hkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qFJgLYlGUtJZue/d0xPp2OIekOMMbAMywg7Z63tRDQOmAVC7LoGkxepmh7zwbyHcQ2oQfo/Imf/mEo3rN6rntrvkWz5mMT6HCjHo8HEe7vrM7TzOYXs0tZHHFoSLG2iLkg92ZepRJv+Zd1uCJdpL4bG+4ZrlmHaGJ2L8567PGyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O/0eZmSu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O/0eZmSu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97680C4CED9;
	Wed,  6 Nov 2024 12:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896561;
	bh=cn6sK+6+9/4NSlphZlN6EsAGVDxgRb3+XY6K5TY0Hkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O/0eZmSuVY7daeBTL1dsXC2pwCCyAfnR/1txxUUYjS35yxbBdK92zwEg2VmhHLYGD
	 RRxxZOPTSUQmJkStqHERX7qnG/i5xF51/wEBXiensRGbeAPXccOwCAub3KlputdTcS
	 LLcgesfw8dsDRUtb11vaCd9RjwNsDHFx3FhQVxaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 6.11 244/245] fs/ntfs3: Sequential field availability check in mi_enum_attr()
Date: Wed,  6 Nov 2024 13:04:57 +0100
Message-ID: <20241106120325.277904149@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

commit 090f612756a9720ec18b0b130e28be49839d7cb5 upstream.

The code is slightly reformatted to consistently check field availability
without duplication.

Fixes: 556bdf27c2dd ("ntfs3: Add bounds checking to mi_enum_attr()")
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/record.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/fs/ntfs3/record.c
+++ b/fs/ntfs3/record.c
@@ -237,6 +237,7 @@ struct ATTRIB *mi_enum_attr(struct mft_i
 	}
 
 	/* Can we use the first field (attr->type). */
+	/* NOTE: this code also checks attr->size availability. */
 	if (off + 8 > used) {
 		static_assert(ALIGN(sizeof(enum ATTR_TYPE), 8) == 8);
 		return NULL;
@@ -257,10 +258,6 @@ struct ATTRIB *mi_enum_attr(struct mft_i
 		return NULL;
 
 	asize = le32_to_cpu(attr->size);
-	if (asize < SIZEOF_RESIDENT) {
-		/* Impossible 'cause we should not return such attribute. */
-		return NULL;
-	}
 
 	/* Check overflow and boundary. */
 	if (off + asize < off || off + asize > used)
@@ -290,6 +287,10 @@ struct ATTRIB *mi_enum_attr(struct mft_i
 	if (attr->non_res != 1)
 		return NULL;
 
+	/* Can we use memory including attr->nres.valid_size? */
+	if (asize < SIZEOF_NONRESIDENT)
+		return NULL;
+
 	t16 = le16_to_cpu(attr->nres.run_off);
 	if (t16 > asize)
 		return NULL;
@@ -316,7 +317,8 @@ struct ATTRIB *mi_enum_attr(struct mft_i
 
 	if (!attr->nres.svcn && is_attr_ext(attr)) {
 		/* First segment of sparse/compressed attribute */
-		if (asize + 8 < SIZEOF_NONRESIDENT_EX)
+		/* Can we use memory including attr->nres.total_size? */
+		if (asize < SIZEOF_NONRESIDENT_EX)
 			return NULL;
 
 		tot_size = le64_to_cpu(attr->nres.total_size);
@@ -326,9 +328,6 @@ struct ATTRIB *mi_enum_attr(struct mft_i
 		if (tot_size > alloc_size)
 			return NULL;
 	} else {
-		if (asize + 8 < SIZEOF_NONRESIDENT)
-			return NULL;
-
 		if (attr->nres.c_unit)
 			return NULL;
 


