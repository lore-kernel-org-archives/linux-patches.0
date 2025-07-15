Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D3D62E3AF9;
	Tue, 15 Jul 2025 13:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587537; cv=none; b=iFkHTVQpwrfw9mgY7mc0/WkLmUB1M+QvSDLF7OxaXbfoWiqy2ptVrxxL0yyQeAy2fx2mDz/Nh5S8en3DNKE95EusSi1RFkIvqibPWEvGFDm5hkd8+Uidvg31fj/dbhWAof/mhW89uB4LZRLc+OqY3gmwJaUgI+ig/evilEhSDWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587537; c=relaxed/simple;
	bh=4qJn+IfkjKAM3XwXgCb5U/fHWPfBG2mSyffyWiNYKzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uLwNprHhHbw1f/bIvxx2fAL2kOtR5cKND83W8zkGr13WMXs4O+BXTC7sxdeNSQfyRNxFlJcUfbW0fiCXO0EqlMGZg7ecWm17cmQzpqF2a/UX8REX91iZT+wVYq1+QuyKvZOrbQVrKGbexDM+mp2pNEvwijBCMWk0ZWQaiuFfoFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UFqKUziq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UFqKUziq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27D29C4CEF4;
	Tue, 15 Jul 2025 13:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587537;
	bh=4qJn+IfkjKAM3XwXgCb5U/fHWPfBG2mSyffyWiNYKzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UFqKUziqHQq7FnWXMOifXUDYV4okhNqb1kI9pcnPkcWK9b8nOqsgR4S5NIvXe51wt
	 m6a4bg3l72NcpBoJyEkhn24uFIDU+MXPBLExQqBX2i2xBOnYlfqd3xERMBQiWy8vCd
	 meayU0g0CXvHSlPucfgMYZuVRWhqZJZGX+zrXfpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 049/208] attach_recursive_mnt(): do not lock the covering tree when sliding something under it
Date: Tue, 15 Jul 2025 15:12:38 +0200
Message-ID: <20250715130812.919492337@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 2d5af6653cd11..ee6d139f75292 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2186,14 +2186,14 @@ static int attach_recursive_mnt(struct mount *source_mnt,
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



