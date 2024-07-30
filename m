Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A61381A6160;
	Tue, 30 Jul 2024 16:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356906; cv=none; b=MurtrB68mi+bK69UQ5WyJN9cyr0Z9+2wKe8hf05pqWV6gOftfsQdFP6Jyvf8Cvu63n5Zu055MzvWp34kHqDhSyr1Dwhrth6zroSDqVXVZfj108DWWAB8z/ShtfjMoEreUf6W+C2HzHUBymAa2TEYFBSg5MA60MMjlgkEai4pRNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356906; c=relaxed/simple;
	bh=fHKEwmorGuj6pOpI1BF53lVELzUVG2IwRKwIDnR4z6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gdva8wEUiKHvSnKZ1JPEc1w4ky6IL0OWhS29SyXzXMKUEhY+cyQD9CpVZ67rNZVWmpCQlDVQ7jN3xcDiGQZKh0xRf0Q45sYMB2rA7LdEEXL7l85OmguyRiGEZ6PzT7c6vvypH/edb9DjsuWyt/1/RPR/zJpPve2W2wIqo1c3KbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=07qfvq8g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="07qfvq8g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C428C4AF0E;
	Tue, 30 Jul 2024 16:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356906;
	bh=fHKEwmorGuj6pOpI1BF53lVELzUVG2IwRKwIDnR4z6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=07qfvq8gY7Z1tNOV1iWoVTCZON7sBPgRrNytU4WYGbPN09HiVyTlLeVY5JhYclyO4
	 RWUmGSkVu8Zs5mzXInFG9oQk8JalV41oJQJjDHgY165v/ZZupr2in3xIwpYmy5n19Q
	 RoRN1wfT7TXasokYsDLKu2UnDNgJ/0b+NDWQFYug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 240/440] fs/ntfs3: Fix transform resident to nonresident for compressed files
Date: Tue, 30 Jul 2024 17:47:53 +0200
Message-ID: <20240730151625.229176401@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 25610ff98d4a34e6a85cbe4fd8671be6b0829f8f ]

Сorrected calculation of required space len (in clusters)
for attribute data storage in case of compression.

Fixes: be71b5cba2e64 ("fs/ntfs3: Add attrib operations")
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/attrib.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/ntfs3/attrib.c b/fs/ntfs3/attrib.c
index 180996c213ccf..f39987f080ee1 100644
--- a/fs/ntfs3/attrib.c
+++ b/fs/ntfs3/attrib.c
@@ -242,7 +242,7 @@ int attr_make_nonresident(struct ntfs_inode *ni, struct ATTRIB *attr,
 	struct ntfs_sb_info *sbi;
 	struct ATTRIB *attr_s;
 	struct MFT_REC *rec;
-	u32 used, asize, rsize, aoff, align;
+	u32 used, asize, rsize, aoff;
 	bool is_data;
 	CLST len, alen;
 	char *next;
@@ -263,10 +263,13 @@ int attr_make_nonresident(struct ntfs_inode *ni, struct ATTRIB *attr,
 	rsize = le32_to_cpu(attr->res.data_size);
 	is_data = attr->type == ATTR_DATA && !attr->name_len;
 
-	align = sbi->cluster_size;
-	if (is_attr_compressed(attr))
-		align <<= NTFS_LZNT_CUNIT;
-	len = (rsize + align - 1) >> sbi->cluster_bits;
+	/* len - how many clusters required to store 'rsize' bytes */
+	if (is_attr_compressed(attr)) {
+		u8 shift = sbi->cluster_bits + NTFS_LZNT_CUNIT;
+		len = ((rsize + (1u << shift) - 1) >> shift) << NTFS_LZNT_CUNIT;
+	} else {
+		len = bytes_to_cluster(sbi, rsize);
+	}
 
 	run_init(run);
 
-- 
2.43.0



