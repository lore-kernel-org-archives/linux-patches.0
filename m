Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABBEC46C4BC;
	Tue, 21 Jul 2026 18:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660322; cv=none; b=UBdskzniZfa+Nv2JMyrW3j+EJ41x80f0UTumQVeY4RE0o+pCz1B7K+erjpMwwrCNLHoOovZ1nBaFp1Th7YXnrmJnLD8lrPt++9AKOL0QKeVAXtqXlK0LQN4yjIebJdo801f6lDSpXpp/gfRL0yq+Wvamy8+UAHDmjjxbm37p51U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660322; c=relaxed/simple;
	bh=KcSByR5gO8Qry11tCem6sz3agHtqk7KDTL0SuVs8BWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LxLe9akr2VsJ79hR0vp0WbFwseVqwvHspWIUmQ9gij4hjSH/+FTFln+/Z19zZ+lYZkYLl0ZAvBN4LOYUZ6FwowxpducOsIDGjIrZe0H8xcFbb051HWhElr3tMi6p/n/NIaWN3RkLuJH8SYqQe0cKkbqIHqxgkIJ0V6kli4nXIbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sj1COkUh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sj1COkUh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E5A71F000E9;
	Tue, 21 Jul 2026 18:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660321;
	bh=f1HP5VdH37YVAho3q/VNHC/g+67YZeLmcp6dIiCr2YQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sj1COkUha2zmbhV3+H2NIVkhzyelIgBSet5H+fK1o1BHuWVMxUxAsvKXbhv3+kBWp
	 oxPLHh9X2+J+cCOBcer4JS+axdceKnTLcZLkaxS4ZtDwvNWvhRB35zgGkqJLnsShF4
	 NeEFkOQDkWbvfIOCyR834DcivMDGOKbDbxBrY1/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4d8e30dbafb5c1260479@syzkaller.appspotmail.com,
	Helen Koike <koike@igalia.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0919/2077] fs/ntfs3: call _ntfs_bad_inode() when failing to rename
Date: Tue, 21 Jul 2026 17:09:52 +0200
Message-ID: <20260721152614.489480850@linuxfoundation.org>
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

From: Helen Koike <koike@igalia.com>

[ Upstream commit e8ed78f40eecd0176fda71d673f6957c98e7ffbe ]

It is safe to call _ntfs_bad_inode on live inodes since:
  commit 519b078998ce ("fs/ntfs3: Exclude call make_bad_inode for live nodes.")

The WARN_ON was added when it wasn't safe by:
  commit d99208b91933 ("fs/ntfs3: cancle set bad inode after removing name fails")

Replace the WARN_ON with a call to _ntfs_bad_inode() to prevent further
operations on the inconsistent inode.

Reported-by: syzbot+4d8e30dbafb5c1260479@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=4d8e30dbafb5c1260479
Fixes: 519b078998ce ("fs/ntfs3: Exclude call make_bad_inode for live nodes.")
Signed-off-by: Helen Koike <koike@igalia.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/frecord.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ntfs3/frecord.c b/fs/ntfs3/frecord.c
index 7b035da63c1219..78eb065c7e431b 100644
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -2800,8 +2800,8 @@ int ni_rename(struct ntfs_inode *dir_ni, struct ntfs_inode *new_dir_ni,
 	err = ni_add_name(new_dir_ni, ni, new_de);
 	if (!err) {
 		err = ni_remove_name(dir_ni, ni, de, &de2, &undo);
-		WARN_ON(err &&
-			ni_remove_name(new_dir_ni, ni, new_de, &de2, &undo));
+		if (err && ni_remove_name(new_dir_ni, ni, new_de, &de2, &undo))
+			_ntfs_bad_inode(&ni->vfs_inode);
 	}
 
 	/*
-- 
2.53.0



