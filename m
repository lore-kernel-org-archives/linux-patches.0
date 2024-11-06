Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E85C1D2784;
	Wed,  6 Nov 2024 12:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896185; cv=none; b=jiyXMgnBp7IbUErogsUGvu7jMKHDg/Qwvw2jgdMRO0w4BViKiceKn9KZFoQthMy5DAkM4V749gU4Aw6UQxTbpJZYHa5iXhDbjZWspKhR8r4olnzsNZwXiNfwow966Oe5p2D3TWiGumMf2WiS67KZ9D+FKBTPUfJP2m3kuD5RGCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896185; c=relaxed/simple;
	bh=YNDd2DxFb6VKmRRwzwJJS857J5cF3KLYWGy5/vprxl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U2hRMj3rl6YqDmaJHP+eDQ2ecaLEKi/5ymZdc41O+KKVeAET7ZowS1+OE2AhBlhFBz5zzAy45gK5On8Dt9rLaFnA06rTwgcRA4Zt7j3xY5+gy6nEvewZ9Pp+vjTjkqRnYYnPRI01zj6i2cnIEQoVYPGP/5OCCJXcltsTOU85s80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AbIykjgR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AbIykjgR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC567C4CECD;
	Wed,  6 Nov 2024 12:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896185;
	bh=YNDd2DxFb6VKmRRwzwJJS857J5cF3KLYWGy5/vprxl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AbIykjgR7xnvwIz82S5WEY8kvPvqtw9gkW+x7pwYE/o6Ly2iErIZIwx61wHc43DGv
	 d0UdBz98VmJXr9GST5J8LRaLyLsosSS8ssVGCJGEjgp+x5yc/7TvqPtDD2a6XnFWze
	 S/4xqTcecSqhBiL+vFr6RukfLKhS4maSJAoiOUYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	lei lu <llfamsec@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 082/245] ntfs3: Add bounds checking to mi_enum_attr()
Date: Wed,  6 Nov 2024 13:02:15 +0100
Message-ID: <20241106120321.222056074@linuxfoundation.org>
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

From: lei lu <llfamsec@gmail.com>

[ Upstream commit 556bdf27c2dd5c74a9caacbe524b943a6cd42d99 ]

Added bounds checking to make sure that every attr don't stray beyond
valid memory region.

Signed-off-by: lei lu <llfamsec@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/record.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/fs/ntfs3/record.c b/fs/ntfs3/record.c
index 6c76503edc200..2a375247b3c09 100644
--- a/fs/ntfs3/record.c
+++ b/fs/ntfs3/record.c
@@ -223,28 +223,19 @@ struct ATTRIB *mi_enum_attr(struct mft_inode *mi, struct ATTRIB *attr)
 		prev_type = 0;
 		attr = Add2Ptr(rec, off);
 	} else {
-		/* Check if input attr inside record. */
+		/*
+		 * We don't need to check previous attr here. There is
+		 * a bounds checking in the previous round.
+		 */
 		off = PtrOffset(rec, attr);
-		if (off >= used)
-			return NULL;
 
 		asize = le32_to_cpu(attr->size);
-		if (asize < SIZEOF_RESIDENT) {
-			/* Impossible 'cause we should not return such attribute. */
-			return NULL;
-		}
-
-		/* Overflow check. */
-		if (off + asize < off)
-			return NULL;
 
 		prev_type = le32_to_cpu(attr->type);
 		attr = Add2Ptr(attr, asize);
 		off += asize;
 	}
 
-	asize = le32_to_cpu(attr->size);
-
 	/* Can we use the first field (attr->type). */
 	if (off + 8 > used) {
 		static_assert(ALIGN(sizeof(enum ATTR_TYPE), 8) == 8);
@@ -265,6 +256,12 @@ struct ATTRIB *mi_enum_attr(struct mft_inode *mi, struct ATTRIB *attr)
 	if (t32 < prev_type)
 		return NULL;
 
+	asize = le32_to_cpu(attr->size);
+	if (asize < SIZEOF_RESIDENT) {
+		/* Impossible 'cause we should not return such attribute. */
+		return NULL;
+	}
+
 	/* Check overflow and boundary. */
 	if (off + asize < off || off + asize > used)
 		return NULL;
-- 
2.43.0



