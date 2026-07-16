Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B8AD331A53;
	Thu, 16 Jul 2026 14:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211993; cv=none; b=fzn2yBfN5uUahE04Yiqrw9TOP/j+0YQV9jBjUtEC+rdrfAsM1UYdYrm3Gz6JjTaHV5vtvX6zBEkE0N2lVzO94dDoB00RitLEtQAQFa9rxCVCHiaRufXMejTg7NmcZ0AU2IQlHZRgTmNdBX4OPNG2yczIpCOIzBfBE7vi6h+DnQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211993; c=relaxed/simple;
	bh=CQQNMQ1uCcdltiq7hh5QF4F9gGLGEgEg3raFFcQ/qaw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jc0oPwY1Wj3v54o7G8YMvl8qWuLCP4Rdlr8Qiv9g0zVMWRfY24U5FyVNKE2Dn3iRH29/2Ji0AZ9GzsyB6g1UinMnvfT16u2b3s6MH4kJSVg7kijuv7JHvw1FlTcySUQZOozirtzKjgKML2lavyLeXknEKPmbk+OVJbpSKmgO+HA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uxfo3QUU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uxfo3QUU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0C6E1F000E9;
	Thu, 16 Jul 2026 14:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211992;
	bh=p3mlfJz6jD5NE9i+GSSY2AiFFP4i3f/i7FZVDkJySEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uxfo3QUUXZh30IAXc2fDPYzdlGtbHBbYrRhZLq6UeyjzEs05bCkW5GP8qM041DrqF
	 K2rtbRdGJZBPIGOU5Rbkwkg3O1phS7L9yEfqXNokseKxLjxeb3m8VYGie8K4nGGvvw
	 lrjM6KZ44OAf22Fo/kgeNVpkSvhNJrNTE4v/TA8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 159/349] fs/ntfs3: zero-fill folios beyond i_valid in ntfs_read_folio()
Date: Thu, 16 Jul 2026 15:31:33 +0200
Message-ID: <20260716133036.938913374@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 356fa248168be90109b66f32a61b8eaedc98424a ]

Handle ntfs_read_folio() early when the folio offset is beyond i_valid
by zero-filling the folio and marking it uptodate. This avoids needless
I/O and locking, improves read performance.

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Stable-dep-of: d7ea8495fd30 ("fs/ntfs3: fix missing run load for vcn0 in attr_data_get_block_locked()")
[ sashal: dropped the is_bad_ni() bail-out; 6.12 lacks is_bad_ni()/ni_bad
  (introduced upstream by 519b078998ce6e) ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/inode.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index 5e240d7fb03709..93cf65db77a015 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -723,6 +723,14 @@ static int ntfs_read_folio(struct file *file, struct folio *folio)
 	struct address_space *mapping = folio->mapping;
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



