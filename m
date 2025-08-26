Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0F4A1E7C08;
	Tue, 26 Aug 2025 14:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216961; cv=none; b=Ng++TeIWfU3oB5xGMD3wn7j5sfxGnY3+EIqfFiqt8u1E8MPcBzuCI7CIYLnUBz8kSi4Ruw7/Uu6ea7htiyaAgwKzg+Cf4JYRQYwYTJpWVixrFlHv9FJssa/hOJm60IRX/YkVQgBHcgI8SkkywO2ZzDtII/F+ifqexT23pZG6RY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216961; c=relaxed/simple;
	bh=XtFooGdewyaJDnvh37CDBzzC15Apr4Fwr5Z2swuNOUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hcfU0LHNYsUcTFRXpvMaX1XS7qx4LzAPM/rHNT0pddqqIZmE7iZ93dNUdq96aotVisL9RtFrg1GGEdq7niOntjkJDf+VhK/zpych5FjNKxEJ4f0BMtpXjz2gLeGhD8BrBPAAK3nDYotW3Q1kTurfFHXs5EXxROuz+U7XhO06G4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jfFurcQY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jfFurcQY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E62EEC4CEF1;
	Tue, 26 Aug 2025 14:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216961;
	bh=XtFooGdewyaJDnvh37CDBzzC15Apr4Fwr5Z2swuNOUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jfFurcQYEGAEcVGt9BdObMKaaF3Omyjvaa+g2i5XWlaTTbGhwkAnZXYSgkVHBrzET
	 3N0+8of2BCrujWbc0wTV21UQRggkUBuBOv84aVs3gnfNwKNT6oZbJyKHYSk7p1LoMg
	 o02kSnfuaxlWe5MLQT8EI4VZM2tqAWDF8qKmJJAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrei Vagin <avagin@gmail.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 575/644] use uniform permission checks for all mount propagation changes
Date: Tue, 26 Aug 2025 13:11:06 +0200
Message-ID: <20250826111000.779189458@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit cffd0441872e7f6b1fce5e78fb1c99187a291330 ]

do_change_type() and do_set_group() are operating on different
aspects of the same thing - propagation graph.  The latter
asks for mounts involved to be mounted in namespace(s) the caller
has CAP_SYS_ADMIN for.  The former is a mess - originally it
didn't even check that mount *is* mounted.  That got fixed,
but the resulting check turns out to be too strict for userland -
in effect, we check that mount is in our namespace, having already
checked that we have CAP_SYS_ADMIN there.

What we really need (in both cases) is
	* only touch mounts that are mounted.  That's a must-have
constraint - data corruption happens if it get violated.
	* don't allow to mess with a namespace unless you already
have enough permissions to do so (i.e. CAP_SYS_ADMIN in its userns).

That's an equivalent of what do_set_group() does; let's extract that
into a helper (may_change_propagation()) and use it in both
do_set_group() and do_change_type().

Fixes: 12f147ddd6de "do_change_type(): refuse to operate on unmounted/not ours mounts"
Acked-by: Andrei Vagin <avagin@gmail.com>
Reviewed-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Tested-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Reviewed-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namespace.c | 34 ++++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 9e1717692be3..35d63bb3b22d 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2296,6 +2296,19 @@ static int graft_tree(struct mount *mnt, struct mount *p, struct mountpoint *mp)
 	return attach_recursive_mnt(mnt, p, mp, false);
 }
 
+static int may_change_propagation(const struct mount *m)
+{
+        struct mnt_namespace *ns = m->mnt_ns;
+
+	 // it must be mounted in some namespace
+	 if (IS_ERR_OR_NULL(ns))         // is_mounted()
+		 return -EINVAL;
+	 // and the caller must be admin in userns of that namespace
+	 if (!ns_capable(ns->user_ns, CAP_SYS_ADMIN))
+		 return -EPERM;
+	 return 0;
+}
+
 /*
  * Sanity check the flags to change_mnt_propagation.
  */
@@ -2332,10 +2345,10 @@ static int do_change_type(struct path *path, int ms_flags)
 		return -EINVAL;
 
 	namespace_lock();
-	if (!check_mnt(mnt)) {
-		err = -EINVAL;
+	err = may_change_propagation(mnt);
+	if (err)
 		goto out_unlock;
-	}
+
 	if (type == MS_SHARED) {
 		err = invent_group_ids(mnt, recurse);
 		if (err)
@@ -2730,18 +2743,11 @@ static int do_set_group(struct path *from_path, struct path *to_path)
 
 	namespace_lock();
 
-	err = -EINVAL;
-	/* To and From must be mounted */
-	if (!is_mounted(&from->mnt))
-		goto out;
-	if (!is_mounted(&to->mnt))
-		goto out;
-
-	err = -EPERM;
-	/* We should be allowed to modify mount namespaces of both mounts */
-	if (!ns_capable(from->mnt_ns->user_ns, CAP_SYS_ADMIN))
+	err = may_change_propagation(from);
+	if (err)
 		goto out;
-	if (!ns_capable(to->mnt_ns->user_ns, CAP_SYS_ADMIN))
+	err = may_change_propagation(to);
+	if (err)
 		goto out;
 
 	err = -EINVAL;
-- 
2.50.1



