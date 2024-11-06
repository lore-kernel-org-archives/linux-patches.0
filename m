Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF4E11E0E13;
	Wed,  6 Nov 2024 12:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897753; cv=none; b=ns/T84Cpg4x4qmFEI3qjYleCfj52WII9lNGgX4IssTcoT8Eo96F5p8zWnPO8VAdqZ22aYzTZxqAjkFb5yelpIlSWO2juPKq8JW4+KZ7KeNuPgDrp5+KbUbsD3zKnto+9FFZLq49MPkF8/Vx28v5djPu5qSsEgCLp7kC4EuFZMBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897753; c=relaxed/simple;
	bh=PZO6Kd3eoNtCOzOAYKVzsMEd+Hyd4lqrR45AkuMFw80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FKspY9yhriV8DCRT1ourPsV7P6JpMZ0s2/mYCyNF6fQcyycpMFciV45mBircnrGHVOYhN2X7Ce/OSZ0LvBTiAeZo5DND1fGOeZRlqIrHQk2ATvDgnpSnCIIz/AQk9D0eVdsopqQcPFE4jcZcKHIRCE3B5CCU+8oo8vwxGd9CCsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FUXh0NHC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FUXh0NHC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72E34C4CECD;
	Wed,  6 Nov 2024 12:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897752;
	bh=PZO6Kd3eoNtCOzOAYKVzsMEd+Hyd4lqrR45AkuMFw80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FUXh0NHC9bmOz/aSfqg90gqlqsa4j8Tusp2HhSHoq3tOgOV7c4TxynNK+Iro9EPkf
	 GHi7hxGiWMqWsRzqUrLdeEQMLHyhTvM77WzLk1qv0xwdRZq6MYvOWoKfdpIuyRFseF
	 Sx6xM5hSb+6HdwMz30JB/CF3aOqSHm58LjSi0NOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 6.6 151/151] fs/ntfs3: Sequential field availability check in mi_enum_attr()
Date: Wed,  6 Nov 2024 13:05:39 +0100
Message-ID: <20241106120312.999330576@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


