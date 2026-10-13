Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 513974EBAD7;
	Tue, 13 Oct 2026 12:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893646; cv=none; b=u+WbUFK8ccAwz0A9EStNJDuj+0oJcXvmpEDmAsyZbkw27MV0iQSA9xR07TpweebINnUrnYlkPjaJWNK/AFEPRSxRsnCrBylJaQwkTyIPuF5SkjDaohbEgV8BJb8LR5XUcqDhxHuz7kPuQ7pzOU4RS8HF29LqxVdyG4MZzMKOwAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893646; c=relaxed/simple;
	bh=Mi77yiL/1e2tAVTgSLk/6rbt6uyNFr5rMrlAGCnPfQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fvGIR1hmDIVqyYGaF7rWpmrJV4W1u5Zc38aXiWXp94YNhtWJ+Mzk7fiCZPU9RIJmSqJk5SrZ3jBnSA5mR8b6LZKuLY0mFoMsBFHExl1JNDsibQPtCW04am+vfLVj7gjV4fodwFiAH7F+SRhaRltHD+AW57gyPEMXyeiI20I6gOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mamlqCZU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mamlqCZU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BF5E1F000FF;
	Tue, 13 Oct 2026 12:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893645;
	bh=Ki7I2b97tC9vhCaZ/jGQ6Cm+21JVKsjcCwqNZ301CF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mamlqCZU/Icb/+KBXrDoZYGRKj/QTPWDpeXhbL7SAI5dgS3gTrrMztw80oIPbf6f9
	 S/s16uz3ELElaNY/9+alRN4l3LkwtSwSfU96tM5J3vyYKJl1tr1cCsF8maTFohWUN/
	 mwYyE8fyH5jXDo0vptuzNez5l9TrN3fnebqjvtZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4d8e30dbafb5c1260479@syzkaller.appspotmail.com,
	Helen Koike <koike@igalia.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 293/621] fs/ntfs3: call _ntfs_bad_inode() when failing to rename
Date: Tue, 13 Oct 2026 13:34:48 +0200
Message-ID: <20261013112927.810566833@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index af5773c0f210c..1cc905a265553 100644
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -3072,8 +3072,8 @@ int ni_rename(struct ntfs_inode *dir_ni, struct ntfs_inode *new_dir_ni,
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



