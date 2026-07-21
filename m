Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 418852F25E4;
	Tue, 21 Jul 2026 20:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665107; cv=none; b=hYucNmtQkihUX+Ltw9Qq8MZkLjSrsQX/0EJGw21JFfFtirsAoWMvCfy4MGMxZcOmpZQcRDftWxRkBz51fbRnabBrJFnElmd4jX0lqASrejTXqdZPhj6i3yDo/OpoPgmwQKFsOdcju2hPj/Gd2tNFetA1sCRVxzI7zDvi4tr9xQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665107; c=relaxed/simple;
	bh=8qpwZR3JemzhDwKWn0pQpLIkZdvL69V4/k5+mRpwcxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M9jAN2WLA4ENHLq0fN7BxQSKQw50YwaX9O+A66CePvnSr1cs8R5yCm6LbVy/6CnGeEBCivAbDjL6gAJZwQTK6k+y7E2qDBtE8kJ1Arhfu1H1XTDFD8uQ7MGVg6cb3ZaIG/UF2abbIpRimO70g5Bo5HHkEfdS0DsP23t3qvE7kRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x2WS4JMx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x2WS4JMx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3D591F00A3A;
	Tue, 21 Jul 2026 20:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665106;
	bh=A3UykVgalPs86JqDjG7FXwHxc0wxk0Qhg2PK4atouEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x2WS4JMxy+v+vX1y5YlqwYnnBYV3xvw2OWxGFyUDlJPgn0Vgy+DE/25+3nFcT6zBQ
	 W5buH123ZwDgfOkLdOicywUyQ9gTVuoB8pPGM2e6ALL3u0ojp0d1Si26fubsNK450J
	 P+5tMBs+5VOtdlQAwlVz1nMaUKBSD5DTNZQWYBvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0177/1266] fs/ntfs3: zero-fill folios beyond i_valid in ntfs_read_folio()
Date: Tue, 21 Jul 2026 17:10:14 +0200
Message-ID: <20260721152445.767897389@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 356fa248168be90109b66f32a61b8eaedc98424a ]

Handle ntfs_read_folio() early when the folio offset is beyond i_valid
by zero-filling the folio and marking it uptodate. This avoids needless
I/O and locking, improves read performance.

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Stable-dep-of: d7ea8495fd30 ("fs/ntfs3: fix missing run load for vcn0 in attr_data_get_block_locked()")
[ sashal: dropped the is_bad_ni() guard, 6.6 lacks 519b078998ce6e
  ("fs/ntfs3: Exclude call make_bad_inode for live nodes.") which
  introduces that helper; pre-patch 6.6 had no such check either ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/inode.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index 787e15ba0ca406..fff604cd952793 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -715,6 +715,14 @@ static int ntfs_read_folio(struct file *file, struct folio *folio)
 	struct address_space *mapping = page->mapping;
 	struct inode *inode = mapping->host;
 	struct ntfs_inode *ni = ntfs_i(inode);
+	loff_t vbo = folio_pos(folio);
+
+	if (ni->i_valid <= vbo) {
+		folio_zero_range(folio, 0, folio_size(folio));
+		folio_mark_uptodate(folio);
+		folio_unlock(folio);
+		return 0;
+	}
 
 	if (is_resident(ni)) {
 		ni_lock(ni);
-- 
2.53.0



