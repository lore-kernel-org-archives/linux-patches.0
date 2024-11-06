Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4051D1E0B7C;
	Wed,  6 Nov 2024 12:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897444; cv=none; b=Jp+INHJojY2je26y3PJkb7Ve3x1Szh+k+6K+W9y3qYnm8TBWpe4DU8Gu22ecT53dfzfc1BvhHn0b8H61N6SxsJVbceHHLCPuXFdmbID2VOH6Os1SA4mjzzNIseFfUBAYFrxq4LGz5woKOOlEpANz0xEap0CBY1qw/QhFGEy9rGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897444; c=relaxed/simple;
	bh=LvjJwXzF5fo+ZZqBCCeZB0DidVc+viR77YRPcZznd+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jsGGwDu6XXSRAE3m1EYTPcMMDlWvQoCx5dcLvPxUp0wkYvUvqc63iHSMhdeDOymSGwht7kFiiPObNUkUri0M6kFIUQ+FucXZcFFwwyP/zf0np8VOKWFHcL+y4gwEd2pXOjec60Bn29wfLDf4GPBOUVL4u8uqslJvp5iT9PdPtds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pFAmc989; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pFAmc989"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B97B9C4CECD;
	Wed,  6 Nov 2024 12:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897444;
	bh=LvjJwXzF5fo+ZZqBCCeZB0DidVc+viR77YRPcZznd+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pFAmc989W4bs+vp1A9WBP+mzh3uEBsB0DqshqpBok8gMCj7OBXzAt04OqK08K2CyB
	 br/xX4EWxf+V5A0Pr7l4DJqYj5jX1mk+Nr+o7aY/FN5NAsQLI5Anmp5hRPX0PFsgA6
	 a+5Xp5gKG+5OoF8uPS1Fc8++6Xc659vR7uDCpEik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	lei lu <llfamsec@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 055/151] ntfs3: Add bounds checking to mi_enum_attr()
Date: Wed,  6 Nov 2024 13:04:03 +0100
Message-ID: <20241106120310.346886356@linuxfoundation.org>
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



