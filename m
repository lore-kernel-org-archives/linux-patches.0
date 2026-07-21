Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 502F33E49E7;
	Tue, 21 Jul 2026 17:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654412; cv=none; b=lMrwlLTFj8RuN4Qw3viTD8zr6wKqaNxw/i8qsIc7tQC1RLUJbKV3zuzKasjfb1oeqZaA7TVaV/wskqjUNsozgiaCTLpryCzlSGAST8W97vFvA2Yy/O00s/jrhcWDBBQKuW0Kpg6VHAstauLovpWbcnlTgmw5YpacLrWEBF7wzJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654412; c=relaxed/simple;
	bh=Egv38UMkeKG7pCvUkACOSd2kj6m8m+8ZQm2PiDmxSy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MTLVN5oFuLmHawe0QG+/nUeBmnrE2SltM84mGfLWuJwxEHA9hSpnswTOWRyznHdK52yrIEg3d4nJHoQ9RjeooqDd2xBN0ltU2Jlc1anw1SmDlgTcTP0a/yIGtDXUP4OCNGHjlPuqTBCSptqCJ2jNHsQapRrD5RhqepR1E2u36ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TvJ4EgyG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TvJ4EgyG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4A7D1F000E9;
	Tue, 21 Jul 2026 17:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654410;
	bh=ZRQ2tyQC1wcazn+7aos6t/YWJzlP0OQTG+bBOTlq4E4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TvJ4EgyGJhXo9K1PupVq0QaF87qeA/EOQ2B89ndQSdtqnhfjMbJ+FOxBry/8GutB+
	 O5hl7TaOYjdc6JPtZUqpL6rlHxUhpATwOEZ7uZzka1prdJQFmeH/LGlw0y510VquS0
	 tOlzQLmR0dBLA2qRf4IS6TwnTIK6Ht8LNQVbsfvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	DaeMyung Kang <charsyam@gmail.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 7.1 1693/2077] ntfs: only alias volume $UpCase to default on exact match
Date: Tue, 21 Jul 2026 17:22:46 +0200
Message-ID: <20260721152632.688520234@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: DaeMyung Kang <charsyam@gmail.com>

commit 8f4b6e8bda121ae3d4d8e332b789664604d3e9d2 upstream.

load_and_init_upcase() currently aliases vol->upcase to the global
default upcase whenever the shared prefix matches, and then truncates
vol->upcase_len to that shorter prefix.  The result is correct only by
accident: upcase[] accesses in name collation are gated by upcase_len,
so the prefix-equality alias produces the same fold output as keeping
the volume's own shorter table.

Still, prefix equality is not equality: the volume table is logically
distinct from the default and should not be replaced by it unless they
are byte-for-byte identical.  Use memcmp() to compare the complete table
in one expression and drop the now-redundant upcase_len rewrite.

No user-visible change is expected for compliant volumes whose $UpCase
has exactly default_upcase_len entries; shorter volume tables are no
longer aliased to the default.

Cc: stable@vger.kernel.org # v7.1
Signed-off-by: DaeMyung Kang <charsyam@gmail.com>
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs/super.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

--- a/fs/ntfs/super.c
+++ b/fs/ntfs/super.c
@@ -1329,7 +1329,6 @@ static bool load_and_init_upcase(struct
 	u8 *addr;
 	pgoff_t index, max_index;
 	unsigned int size;
-	int i, max;
 
 	ntfs_debug("Entering.");
 	/* Read upcase table and setup vol->upcase and vol->upcase_len. */
@@ -1380,16 +1379,11 @@ read_partial_upcase_page:
 		mutex_unlock(&ntfs_lock);
 		return true;
 	}
-	max = default_upcase_len;
-	if (max > vol->upcase_len)
-		max = vol->upcase_len;
-	for (i = 0; i < max; i++)
-		if (vol->upcase[i] != default_upcase[i])
-			break;
-	if (i == max) {
+	if (default_upcase_len == vol->upcase_len &&
+	    !memcmp(vol->upcase, default_upcase,
+		    default_upcase_len * sizeof(*default_upcase))) {
 		kvfree(vol->upcase);
 		vol->upcase = default_upcase;
-		vol->upcase_len = max;
 		ntfs_nr_upcase_users++;
 		mutex_unlock(&ntfs_lock);
 		ntfs_debug("Volume specified $UpCase matches default. Using default.");


