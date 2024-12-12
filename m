Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D184213E9F;
	Thu, 12 Dec 2024 16:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021554; cv=none; b=HT7JjQWPSuuLWL0KjDy/zL110iGPBmMrhnu6CbpLNYO04NgT5/VDOfBNChk1KaRAD5diRIbAKqbely/9XNquBI+Im5ydfj2PYfrn2Hr7LinMSFjPUyqog48DAnV822wqdH5ANLZO5QkscVoczycP2qje9HP81qsZQ8byIIq2xFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021554; c=relaxed/simple;
	bh=h7avdHsmlPmWZmXdKB2eiMNYsAKFjyHURZAAy3khF+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mLifZvjEyEPmIAVNCeotqW8iX4Rqn7E1dgbbHSC2rnKnvqadHBwMZpNSuqlWjWeKGh3PIrir6Z4uKfxjYvAfspk3WbumYrSutzrA6R0AMCjDUwDh8hUVqljJ7lbVhgwfhXYnrRRU2xrGHfAJkSM0Wej5kYZlDRSBLNb06+5cMP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2H9dEgXJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2H9dEgXJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93B7DC4CED4;
	Thu, 12 Dec 2024 16:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021554;
	bh=h7avdHsmlPmWZmXdKB2eiMNYsAKFjyHURZAAy3khF+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2H9dEgXJzVEo4d9WQAsDKzcYFJ1PbZ4UGb3w4BaCZnZ3wakV/KTnkNQCxeDvWefZV
	 JZYmHRBdTcvtyrFjHFAvwGzT4yEVW2rUNmpPF0UZLbsIgpr2lHLezdKyguOZ/3NUk9
	 DJ/u553jj6iqtP2aQd8sy5eYfAxAaL8JLXequcgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 6.1 770/772] fs/ntfs3: Sequential field availability check in mi_enum_attr()
Date: Thu, 12 Dec 2024 16:01:55 +0100
Message-ID: <20241212144421.751141390@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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
@@ -231,6 +231,7 @@ struct ATTRIB *mi_enum_attr(struct mft_i
 	}
 
 	/* Can we use the first field (attr->type). */
+	/* NOTE: this code also checks attr->size availability. */
 	if (off + 8 > used) {
 		static_assert(ALIGN(sizeof(enum ATTR_TYPE), 8) == 8);
 		return NULL;
@@ -251,10 +252,6 @@ struct ATTRIB *mi_enum_attr(struct mft_i
 		return NULL;
 
 	asize = le32_to_cpu(attr->size);
-	if (asize < SIZEOF_RESIDENT) {
-		/* Impossible 'cause we should not return such attribute. */
-		return NULL;
-	}
 
 	/* Check overflow and boundary. */
 	if (off + asize < off || off + asize > used)
@@ -285,6 +282,10 @@ struct ATTRIB *mi_enum_attr(struct mft_i
 	if (attr->non_res != 1)
 		return NULL;
 
+	/* Can we use memory including attr->nres.valid_size? */
+	if (asize < SIZEOF_NONRESIDENT)
+		return NULL;
+
 	t16 = le16_to_cpu(attr->nres.run_off);
 	if (t16 > asize)
 		return NULL;
@@ -311,7 +312,8 @@ struct ATTRIB *mi_enum_attr(struct mft_i
 
 	if (!attr->nres.svcn && is_attr_ext(attr)) {
 		/* First segment of sparse/compressed attribute */
-		if (asize + 8 < SIZEOF_NONRESIDENT_EX)
+		/* Can we use memory including attr->nres.total_size? */
+		if (asize < SIZEOF_NONRESIDENT_EX)
 			return NULL;
 
 		tot_size = le64_to_cpu(attr->nres.total_size);
@@ -321,9 +323,6 @@ struct ATTRIB *mi_enum_attr(struct mft_i
 		if (tot_size > alloc_size)
 			return NULL;
 	} else {
-		if (asize + 8 < SIZEOF_NONRESIDENT)
-			return NULL;
-
 		if (attr->nres.c_unit)
 			return NULL;
 	}


