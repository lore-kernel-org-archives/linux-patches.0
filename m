Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63D2B2E041E;
	Tue, 15 Jul 2025 13:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586449; cv=none; b=Vftk0+jY3DuvCtIGsGgJpFiCVmBMTOwLsdVoft7Vu6UGV+UjmoHjRd1e2gw5Eve2beb+oqYelWJanm3eGFbpa83xeH8tIw2nrBvq64RgE24+ll3FAUTJe36kjywvBkUN4yDq2TdrgcXQN/azQ5brDasnsN/r0aBPmIf06MK1LpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586449; c=relaxed/simple;
	bh=vIgY/9+XQsw1BkgueCyBjSVaM7LUBtnY6RILil2gwIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WL1/qVz0gWsjoEG57yuHf6u707v3kyyvPVT14976vqYpmFpAbOfIwrjANSFBQajvUnZlMsgPjDv6pjSoKIhtN/iSL7bkomthdDDMuM2f51kxDd4OcUJpLWPWqNfH7z2X4ddDMOmeIGNC+WdmzgnSZP4DuxbY0iYaQYA7M57yhJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kg4/rkQd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kg4/rkQd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED6DCC4CEE3;
	Tue, 15 Jul 2025 13:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586449;
	bh=vIgY/9+XQsw1BkgueCyBjSVaM7LUBtnY6RILil2gwIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kg4/rkQdbMW/eKGehqCp5+hzmtdGw9d/hMiZJU40o3muYhGrgs2U+mJxrddzRQwBV
	 PPDv+hPE57CKzwwDZGkp9UrG5vEvzgiC0jRlzcB2b7buMlNmfdXxrOxcLPLoc7b5SF
	 1FYha6gjLWWMtlx9fBQlv22Wyj4hTCgze7NFFMLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 038/148] attach_recursive_mnt(): do not lock the covering tree when sliding something under it
Date: Tue, 15 Jul 2025 15:12:40 +0200
Message-ID: <20250715130801.840801640@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130800.293690950@linuxfoundation.org>
References: <20250715130800.293690950@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit ce7df19686530920f2f6b636e71ce5eb1d9303ef ]

If we are propagating across the userns boundary, we need to lock the
mounts added there.  However, in case when something has already
been mounted there and we end up sliding a new tree under that,
the stuff that had been there before should not get locked.

IOW, lock_mnt_tree() should be called before we reparent the
preexisting tree on top of what we are adding.

Fixes: 3bd045cc9c4b ("separate copying and locking mount tree on cross-userns copies")
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namespace.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 8a35144897686..ee5a87061f205 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2124,14 +2124,14 @@ static int attach_recursive_mnt(struct mount *source_mnt,
 	hlist_for_each_entry_safe(child, n, &tree_list, mnt_hash) {
 		struct mount *q;
 		hlist_del_init(&child->mnt_hash);
-		q = __lookup_mnt(&child->mnt_parent->mnt,
-				 child->mnt_mountpoint);
-		if (q)
-			mnt_change_mountpoint(child, smp, q);
 		/* Notice when we are propagating across user namespaces */
 		if (child->mnt_parent->mnt_ns->user_ns != user_ns)
 			lock_mnt_tree(child);
 		child->mnt.mnt_flags &= ~MNT_LOCKED;
+		q = __lookup_mnt(&child->mnt_parent->mnt,
+				 child->mnt_mountpoint);
+		if (q)
+			mnt_change_mountpoint(child, smp, q);
 		commit_tree(child);
 	}
 	put_mountpoint(smp);
-- 
2.39.5



