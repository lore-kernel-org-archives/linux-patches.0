Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C0A223ABBE;
	Wed, 30 Sep 2026 18:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794292; cv=none; b=cbN1LksuLkq4y7b4XUE+Rg2lzbgiW44muT+U6c7NMPfV6AGhoVn4FDfqXAKjVDfqmZbsMj1ydLefhq0Ay8Pj7zhMBqePNVWU1OB87jRRX3AZL3k3EYyvJBGXs2enGrCYYb4kSEzcYepd0Q13SR8iGi5lm3wYB4TVgRXfPXKOdhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794292; c=relaxed/simple;
	bh=lEcXIZAdeWnDAvHHv8jed9oINUogywBb5N1EPUOAHzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EquWOjsOuqWsXCslQPN0VhFxlNEgNOc40NV0GwSwLYwAj7UBi2konBe89Yq16JFWkeqDp8ZMp5Pb/SUJU0NWyWl4gvkhnN1BsxUdarCMbda4V3eadb0TDc3j59xbdaSizLEJbEXavXQbaJWWavBJEmB4Cq4j+UfmgBAgqBUJ/Cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w5sOlz32; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w5sOlz32"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 381651F000FF;
	Wed, 30 Sep 2026 18:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794290;
	bh=z4RU7dANvbb6o+goCFTOzaxrs49k/EPZCj2/EYh8vXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w5sOlz32tGF6jnh9zobkMlPM84CtOEYLR8yr68TCP8EOlYmNoU2hUWlGeXjtMs3V3
	 v1vtCrKf38Y8ZRMQFzj8T8miaHT/29sPD3SrEAQIJzZNTHsFheymB/ernA65d4vBoA
	 qGWmexN/UzgUC+awvjXK6tFjHmMm/5Xr7MQu2Rpc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alessandro Schino <7991aleschino@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0160/1193] ntfs3: fix out-of-bounds read in ntfs_dir_emit() and hdr_find_e()
Date: Wed, 30 Sep 2026 17:14:04 +0200
Message-ID: <20260930152437.754470681@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alessandro Schino <7991aleschino@gmail.com>

[ Upstream commit aa1bdbb39f49c5bc9779316891c40005517842a5 ]

The bounds check in ntfs_dir_emit() compares fname->name_len (a
character count) against e->size (a byte count) without accounting
for the 2-byte-per-character UTF-16LE encoding or the ATTR_FILE_NAME
header size:

  if (fname->name_len + sizeof(struct NTFS_DE) > le16_to_cpu(e->size))

This computes: name_len + 16 > e_size

The correct check must account for the ATTR_FILE_NAME header (66 bytes
before the name) and the UTF-16LE character size (2 bytes each):

  sizeof(NTFS_DE) + offsetof(ATTR_FILE_NAME, name) +
  name_len * sizeof(short) > e_size

Which computes: 16 + 66 + name_len * 2 > e_size

The correct calculation already exists as fname_full_size() in ntfs.h
and is used in cmp_fnames(), namei.c, and fslog.c, but was not used
in the readdir path.

A crafted NTFS image with an index entry containing a small e->size
but large fname->name_len bypasses the current check, causing
ntfs_utf16_to_nls() to read past the entry boundary.

Additionally, add a key_size validation in hdr_find_e() to ensure the
declared key_size does not exceed the available entry data, preventing
comparison functions from reading past entry boundaries on the lookup
path.

Signed-off-by: Alessandro Schino <7991aleschino@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/dir.c   | 4 +++-
 fs/ntfs3/index.c | 4 ++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/ntfs3/dir.c b/fs/ntfs3/dir.c
index 4bf851273e332..9335d706e2005 100644
--- a/fs/ntfs3/dir.c
+++ b/fs/ntfs3/dir.c
@@ -304,7 +304,9 @@ static inline bool ntfs_dir_emit(struct ntfs_sb_info *sbi,
 	if (sbi->options->nohidden && (fname->dup.fa & FILE_ATTRIBUTE_HIDDEN))
 		return true;
 
-	if (fname->name_len + sizeof(struct NTFS_DE) > le16_to_cpu(e->size))
+	if (sizeof(struct NTFS_DE) +
+	    offsetof(struct ATTR_FILE_NAME, name) +
+	    fname->name_len * sizeof(short) > le16_to_cpu(e->size))
 		return true;
 
 	name_len = ntfs_utf16_to_nls(sbi, fname->name, fname->name_len, name,
diff --git a/fs/ntfs3/index.c b/fs/ntfs3/index.c
index 25707c87fa363..7ca7e6c762021 100644
--- a/fs/ntfs3/index.c
+++ b/fs/ntfs3/index.c
@@ -794,6 +794,10 @@ static struct NTFS_DE *hdr_find_e(const struct ntfs_index *indx,
 binary_search:
 	e_key_len = le16_to_cpu(e->key_size);
 
+	/* Validate key_size fits within the entry data area. */
+	if (e_key_len > le16_to_cpu(e->size) - sizeof(struct NTFS_DE))
+		return NULL;
+
 	diff2 = (*cmp)(key, key_len, e + 1, e_key_len, ctx);
 	if (diff2 > 0) {
 		if (found) {
-- 
2.53.0



