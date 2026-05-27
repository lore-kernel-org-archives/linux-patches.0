Received: from n169-114.mail.139.com (n169-114.mail.139.com [120.232.169.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70325533D6;
	Wed, 27 May 2026 00:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=120.232.169.114
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779843324; cv=none; b=IWaSRiwGmUgyZR0naYaVOkIbLrkcHiebcKoY23uFi03rf2m2i7m77g7d+hCe9dGnvESyCL65f7atWuPCRhaGavYk4osyJFdZ/MVNv/0uxuxfwHL26SL6fC9TRET4f6/1+RXIwQPwMtRn6y5a7pXPcLqsF4RWEQPYijDLZw4Ffwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779843324; c=relaxed/simple;
	bh=yLP+fe59YbWjNozdB0J6vFtGFhRB5cE6vJY5r0Mz1gE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=g5ibONmY8rwSABKSOe0saAOw+oy+VW7E+q7gjDOxxo08IIa8BF98PYi3rq3ZUGyWGUkEVO58x8niLW5qD63wVWjIOOlFdcd+Hn9+e5Bu5p2OUaWOeT/i/iR4eIXvjX6/0MDinMGbMvQNcBugdSKQYd/jwVEI50iv3SA+tizkWuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com; spf=pass smtp.mailfrom=139.com; dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b=wEH7cCJQ; arc=none smtp.client-ip=120.232.169.114
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=139.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b="wEH7cCJQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=139.com; s=dkim; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=wEH7cCJQxJOCzSi1qEjTgWBHgJIztKCZS+SA3bOe+o9lws3V057qbSlTFdON7PWIDUJfYrnOlx442
	 EKhaAupkswkFFuO3xnuyKDEMsokMyP2ceeMh36vO+h6WAcZyHl9R7JAJhPcnzc0cHn437PNcakBLs5
	 wug85vZ67djEVNjo=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM:                                                                                        
X-RM-SPAM-FLAG:00000000
Received:from NTT-kernel-dev (unknown[60.247.85.88])
	by rmsmtp-lg-appmail-45-12076 (RichMail) with SMTP id 2f2c6a1640ed8c6-008d3;
	Wed, 27 May 2026 08:55:10 +0800 (CST)
X-RM-TRANSID:2f2c6a1640ed8c6-008d3
From: Li hongliang <1468888505@139.com>
To: gregkh@linuxfoundation.org,
	stable@vger.kernel.org
Cc: patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	almaz.alexandrovich@paragon-software.com,
	ntfs3@lists.linux.dev
Subject: [PATCH 6.1.y] fs/ntfs3: validate rec->used in journal-replay file record check
Date: Wed, 27 May 2026 08:55:09 +0800
Message-Id: <20260527005509.3175451-1-1468888505@139.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 0ca0485e4b2e837ebb6cbd4f2451aba665a03e4b ]

check_file_record() validates rec->total against the record size but
never validates rec->used.  The do_action() journal-replay handlers read
rec->used from disk and use it to compute memmove lengths:

  DeleteAttribute:    memmove(attr, ..., used - asize - roff)
  CreateAttribute:    memmove(..., attr, used - roff)
  change_attr_size:   memmove(..., used - PtrOffset(rec, next))

When rec->used is smaller than the offset of a validated attribute, or
larger than the record size, these subtractions can underflow allowing
us to copy huge amounts of memory in to a 4kb buffer, generally
considered a bad idea overall.

This requires a corrupted filesystem, which isn't a threat model the
kernel really needs to worry about, but checking for such an obvious
out-of-bounds value is good to keep things robust, especially on journal
replay

Fix this up by bounding rec->used correctly.

This is much like commit b2bc7c44ed17 ("fs/ntfs3: Fix slab-out-of-bounds
read in DeleteIndexEntryRoot") which checked different values in this
same switch statement.

Cc: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Fixes: b46acd6a6a62 ("fs/ntfs3: Add NTFS journal")
Cc: stable <stable@kernel.org>
Assisted-by: gregkh_clanker_t1000
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Li hongliang <1468888505@139.com>
---
 fs/ntfs3/fslog.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/ntfs3/fslog.c b/fs/ntfs3/fslog.c
index 7e6937e7d471..99bd7a06b2bc 100644
--- a/fs/ntfs3/fslog.c
+++ b/fs/ntfs3/fslog.c
@@ -2792,13 +2792,14 @@ static inline bool check_file_record(const struct MFT_REC *rec,
 	u16 fn = le16_to_cpu(rec->rhdr.fix_num);
 	u16 ao = le16_to_cpu(rec->attr_off);
 	u32 rs = sbi->record_size;
+	u32 used = le32_to_cpu(rec->used);
 
 	/* Check the file record header for consistency. */
 	if (rec->rhdr.sign != NTFS_FILE_SIGNATURE ||
 	    fo > (SECTOR_SIZE - ((rs >> SECTOR_SHIFT) + 1) * sizeof(short)) ||
 	    (fn - 1) * SECTOR_SIZE != rs || ao < MFTRECORD_FIXUP_OFFSET_1 ||
 	    ao > sbi->record_size - SIZEOF_RESIDENT || !is_rec_inuse(rec) ||
-	    le32_to_cpu(rec->total) != rs) {
+	    le32_to_cpu(rec->total) != rs || used > rs || used < ao) {
 		return false;
 	}
 
@@ -2810,6 +2811,15 @@ static inline bool check_file_record(const struct MFT_REC *rec,
 		return false;
 	}
 
+	/*
+	 * The do_action() handlers compute memmove lengths as
+	 * "rec->used - <offset of validated attr>", which underflows when
+	 * rec->used is smaller than the attribute walk reached.  At this
+	 * point attr is the ATTR_END marker; rec->used must cover it.
+	 */
+	if (used < PtrOffset(rec, attr) + sizeof(attr->type))
+		return false;
+
 	return true;
 }
 
-- 
2.34.1


