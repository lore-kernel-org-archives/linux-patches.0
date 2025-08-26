Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E3521E502;
	Tue, 26 Aug 2025 13:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215154; cv=none; b=lSxJgWjm+4C7u4MAsxV6yDMF7abbaOBulrjkAUd5vX8BF+FnL7+1y2RaUAbD2NgJ1RoZRpQ83U6v3gmdPUtbdMDYuoOBeAZFQ7Gammn2+Eg3L+CWfu3Q6nGuG83Ye70Hngr/qwUCExttOazsg5ztSIdDwl5+5KYceVUfa3xMbcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215154; c=relaxed/simple;
	bh=HWAgf9sJv6RBXTNIpLGasAGNQk/NVGxY2CXkWeBPC4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rbe9hbDxXprxoqr8L7XfIlRrSa10il0WteLD6xkQgy0Af+qJlHFY5vOyqDl0B4ot93MNC9AAB39oBq+c4LdCoDQLh7UhzQYvidID+sV0wN/fREKmin1GsBYv+dIeeiYSLn0qT91d7j85816esY9jtZYTZyXC07CxDDsrZteDhTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f8+hoHt6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f8+hoHt6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 214DDC4CEF1;
	Tue, 26 Aug 2025 13:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215154;
	bh=HWAgf9sJv6RBXTNIpLGasAGNQk/NVGxY2CXkWeBPC4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f8+hoHt6uuwv0UE3Q613/IaWlItn+aq+nKShk0DmlJxGqcx+DtV6bAE3yCgJxpcEu
	 UROXPSeoMmN3M8ZqrfUjWyEMlfQxijsZsf+tfr8eLpwFTzf60hSQier+kmcI8kbzyb
	 UjNcLtPZNeesXJKsIdY6NZkh7LWBWQwqEuoRY2cw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrei Vagin <avagin@gmail.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 407/482] use uniform permission checks for all mount propagation changes
Date: Tue, 26 Aug 2025 13:11:00 +0200
Message-ID: <20250826110940.883833362@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f0fa2a1a6b05..2a76269f2a4e 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2340,6 +2340,19 @@ static int graft_tree(struct mount *mnt, struct mount *p, struct mountpoint *mp)
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
@@ -2376,10 +2389,10 @@ static int do_change_type(struct path *path, int ms_flags)
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
@@ -2774,18 +2787,11 @@ static int do_set_group(struct path *from_path, struct path *to_path)
 
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



