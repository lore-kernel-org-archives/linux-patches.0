Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D73A23D3CEE;
	Fri, 24 Apr 2026 13:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037521; cv=none; b=VKM+TiZ0HEJbUh0JYQX3KmTAn8yHSOGRmGhXdzyaLJ+xGzJlQGlp6KOHV2RTHcnl5AFLtPEYPOD+h78i6JEt6G/7BUahOUg//lCgVTyr6S/yP/8p87CvX+XoWhg58iq6YPEjQja4xpuOfx5NdhXgqjj+4AyBjOjxEA11mvYVQdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037521; c=relaxed/simple;
	bh=lUOKdkBzArG51/WyNkYBrcP2zIiJ1jF3ySmsXZob7Fk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u+PISaZDzcfl8sekzau9/33wIaARLY4552E90gof16LvkE3Gq/fozaWpC4AZ3pBs1rIu+K1Hw3tGVsYtw55zf9lqY8/b+Qw7L5sQhl4zHYNrZJsWs97yIQMpok+KlhLP0MyuQOaz1GmEnKqQASFAWjhE3TDlbHReM9UD6iUOA1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZHdX/53t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZHdX/53t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0C32C2BCB2;
	Fri, 24 Apr 2026 13:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777037520;
	bh=lUOKdkBzArG51/WyNkYBrcP2zIiJ1jF3ySmsXZob7Fk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZHdX/53t0MsV86AmzS5/1plDbmcKkiJNXylPZiC6kgjHHZnzrzIYAh4N0oY2v4nWP
	 Awk6Fef7nJL6M/eb3/wkcEvAyPJifdPuCEDBfGaup+rs+UznqnG8b+ju/1RH8YaRGh
	 6nt1PJjewe5Q/bGGvXOvUOm+vXYwrCjtNhThQ5eo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	stable <stable@kernel.org>
Subject: [PATCH 7.0 10/42] fs/ntfs3: validate rec->used in journal-replay file record check
Date: Fri, 24 Apr 2026 15:30:35 +0200
Message-ID: <20260424132422.610163655@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132420.410310336@linuxfoundation.org>
References: <20260424132420.410310336@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 0ca0485e4b2e837ebb6cbd4f2451aba665a03e4b upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/fslog.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/fs/ntfs3/fslog.c
+++ b/fs/ntfs3/fslog.c
@@ -2791,13 +2791,14 @@ static inline bool check_file_record(con
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
 
@@ -2809,6 +2810,15 @@ static inline bool check_file_record(con
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
 


