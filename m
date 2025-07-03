Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74A8B231853;
	Thu,  3 Jul 2025 14:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554236; cv=none; b=fQeZJmcwvNC5V1MTX1jucf+ONJ0mrOznq4oXFd7eDmJgw88qFxwZ/X9INnPfnAuWpIBQPQCLSU5z7VkcJJUFb2JUBtXMJ0RIhpxaZlNMzSDzvUg5/sudtcE2G+lkuIkctP5m3CZHJ/oYDeP1ppWs8ReGi0lPctDXacRR4fD+ONk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554236; c=relaxed/simple;
	bh=Pk95um50r8I2ZTUi5J33nUKRRPkqlIHG471hm0Iibzw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dGHloyG8u+v6WfHTMAGc3cteTb/tE4KmS6SQad6E22Nd75ckJFS2WM6b6+vEoE71wEsNG1J68MivlTK4ZlOfDnRaOpErz8M8EVtGuaNEdfKWlm4ZXTclMUT5w7jNvxJlXiGnP4TakIyK9UcCsjPqGB4PYsQTvszmE5OI7HqjNKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=apIFiwse; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="apIFiwse"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8EB6C4AF09;
	Thu,  3 Jul 2025 14:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554236;
	bh=Pk95um50r8I2ZTUi5J33nUKRRPkqlIHG471hm0Iibzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=apIFiwseB01qymc36fnvVPVFUWyngI72r+kdZCatOxRs4CfohECMYf3AQbEUrIATI
	 KnLuB4K1JUv02IMA+xwGz+3fBnAQwxOWUOh1rfp6lN4ESa4uhc/KDNjdPq/4iPwl0A
	 IiqfcJiOPH9Z5ynqe2322Iz497Q8uvBnOfOSUcKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 094/218] attach_recursive_mnt(): do not lock the covering tree when sliding something under it
Date: Thu,  3 Jul 2025 16:40:42 +0200
Message-ID: <20250703143959.693912302@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 843bc6191f30b..b5c5cf01d0c40 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2521,14 +2521,14 @@ static int attach_recursive_mnt(struct mount *source_mnt,
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



