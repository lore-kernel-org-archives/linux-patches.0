Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D4673ED3B2;
	Tue, 21 Jul 2026 15:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649375; cv=none; b=cm6YmG/oEJs3Aq6mzRHKbBqkwW6+8OQgG9qJT3N+MZ4sedOhTVG32wNDSuGaIcMZVlsHHQMyimdqClhfPDCaUrL0JWhKxcumOW2oeNP/rkWHJQKiLUsmR5SAXTRjJGtLDoOPJPDEqj+kdwqtDHO+O8PTIot9ZVQG0ss3BeDg7rA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649375; c=relaxed/simple;
	bh=mzkU4qZojB5n7Y8FOWmuHdjBx7Nlnk1n/QFYrT82SUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QruANTjmRG67XQZEbSUM2UIBBPt+AOMZuRwNRTS6CFfMwxLuMPx4IQWzwT0w5Q/eYK19tsxGs62VuHqjhUHSx5Wg81qrPlBnnLgik0yIZm8wnF1PU6eIT2hqUEC5p153clFDiCC5/ZV8KJCp4lBdd2J6jTUM8pkGxrf6hHid90I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eVHju2x8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eVHju2x8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 746341F000E9;
	Tue, 21 Jul 2026 15:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649374;
	bh=/i6tpqFLIBoyTcKu9GOJv/Ms4+Lsh8nT5eDSbzF6KXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eVHju2x8BQ3O+rjndKYLKNKeYUEg/LbTjbNK0Q5/dXMwERxeU8GIwMNvSA98vyZ1M
	 276gs+aexMNN7DcN0/MV8G7lD0nLNurrIE4Fq7UOy9w5x7SoH9KsAsDa8nEmT4I1kz
	 A4gfM5rDAvhMtE4wEElUwubSjajfdBQFnKB3WD9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0547/2077] ntfs: bound the attribute-list entry in ntfs_read_inode_mount()
Date: Tue, 21 Jul 2026 17:03:40 +0200
Message-ID: <20260721152605.714005250@linuxfoundation.org>
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

From: Bryam Vargas <hexlabsecurity@proton.me>

[ Upstream commit 98634df5b1cb56c26299b7409227025ddb0167d8 ]

The $MFT attribute-list walk in ntfs_read_inode_mount() validates each
entry only with "(u8 *)al_entry + 6 > al_end" and
"(u8 *)al_entry + le16_to_cpu(al_entry->length) > al_end", but then reads
al_entry->lowest_vcn (an __le64 at offset 8) and al_entry->mft_reference
(offset 16) -- fields beyond the 6 bytes proven in range. al_entry->length
is attacker-controlled and only required non-zero, so a short entry (e.g.
length 8) placed at the tail passes both checks while the lowest_vcn /
mft_reference reads fall past al_end.

al_end is ni->attr_list + attr_list_size (the on-disk size); the buffer is
kvzalloc(round_up(attr_list_size, SECTOR_SIZE)), so the sector rounding
usually absorbs the over-read -- but when attr_list_size is a multiple of
SECTOR_SIZE there is no slack and a crafted $MFT attribute list produces an
out-of-bounds read at mount time.

Validate the entry with ntfs_attr_list_entry_is_valid() (added in patch
1/3) before dereferencing it, matching the bound the other attribute-list
walks now use. The validator already requires the length to cover the fixed
header, which makes the separate "!al_entry->length" check redundant, so
drop it too.

Fixes: 1e9ea7e04472 ("Revert "fs: Remove NTFS classic"")
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/inode.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/ntfs/inode.c b/fs/ntfs/inode.c
index a5f7400fd19dc4..c4fa6aa11c9e8d 100644
--- a/fs/ntfs/inode.c
+++ b/fs/ntfs/inode.c
@@ -2000,10 +2000,7 @@ int ntfs_read_inode_mount(struct inode *vi)
 			/* Catch the end of the attribute list. */
 			if ((u8 *)al_entry == al_end)
 				goto em_put_err_out;
-			if (!al_entry->length)
-				goto em_put_err_out;
-			if ((u8 *)al_entry + 6 > al_end ||
-			    (u8 *)al_entry + le16_to_cpu(al_entry->length) > al_end)
+			if (!ntfs_attr_list_entry_is_valid(al_entry, al_end))
 				goto em_put_err_out;
 			next_al_entry = (struct attr_list_entry *)((u8 *)al_entry +
 					le16_to_cpu(al_entry->length));
-- 
2.53.0



