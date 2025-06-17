Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FF3A2FA622;
	Tue, 17 Jun 2025 16:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179572; cv=none; b=QN5pRtjX6+hRj0v1TpC/oUZOwkiuAFCCVBofEcA/G5xDusXbmSKkSuORRDZSuW2wEulAzxPw5Aqg0ZjaELiSUFQmtgz0++EwF3yzuUgs7mNklI+18a1y5vVkLNgTh3RXjWewhG4UGoidqAazQqops9cv42K1st0GhIXcfsw+6iA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179572; c=relaxed/simple;
	bh=CSkdzI8YGQS9gflZeHzblUTddFHhN0uowjrjPquS9N8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FBtigKcRt1EnLDZ7XiTKCInUmfcAN7NB8zeH+I5cjVjEXgANgXNPJlXi/KQgkHLXoZ+u00ydAq41E+/SUZoYFQmd2KlAo4hmWOOzeaalCQaC9+byFDAey5XAayN4kV01VSWYRCwMcPTdC3SqkFzw9FeiCO6pJegNRbcC4f6tAM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tB/qrCTE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tB/qrCTE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93BB0C4CEF0;
	Tue, 17 Jun 2025 16:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179572;
	bh=CSkdzI8YGQS9gflZeHzblUTddFHhN0uowjrjPquS9N8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tB/qrCTEGnyodonyAEhpZ2gW4WgPgQnQD576gPOS+tJbg1VLNxkyAgulsAdyB/5ht
	 jMdHf3CM7pf7hdV6zjtGY6gqOVDPozUnprZlTt3YkTwJTGp2+yomvbgxbZl62GR1a4
	 /Vu6AGoZtMENyrhxYaLxU3+tkwyMOS5yt2GXbavI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Allison Karlitskaya <lis@redhat.com>,
	Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 6.15 775/780] do_move_mount(): split the checks in subtree-of-our-ns and entire-anon cases
Date: Tue, 17 Jun 2025 17:28:03 +0200
Message-ID: <20250617152523.071660606@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit 290da20e333955637f00647d9fff7c6e3c0b61e0 upstream.

... and fix the breakage in anon-to-anon case.  There are two cases
acceptable for do_move_mount() and mixing checks for those is making
things hard to follow.

One case is move of a subtree in caller's namespace.
        * source and destination must be in caller's namespace
	* source must be detachable from parent
Another is moving the entire anon namespace elsewhere
	* source must be the root of anon namespace
	* target must either in caller's namespace or in a suitable
	  anon namespace (see may_use_mount() for details).
	* target must not be in the same namespace as source.

It's really easier to follow if tests are *not* mixed together...

Reviewed-by: Christian Brauner <brauner@kernel.org>
Fixes: 3b5260d12b1f ("Don't propagate mounts into detached trees")
Reported-by: Allison Karlitskaya <lis@redhat.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/namespace.c |   46 +++++++++++++++++++++++++---------------------
 1 file changed, 25 insertions(+), 21 deletions(-)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -3662,37 +3662,41 @@ static int do_move_mount(struct path *ol
 	ns = old->mnt_ns;
 
 	err = -EINVAL;
-	if (!may_use_mount(p))
-		goto out;
-
 	/* The thing moved must be mounted... */
 	if (!is_mounted(&old->mnt))
 		goto out;
 
-	/* ... and either ours or the root of anon namespace */
-	if (!(attached ? check_mnt(old) : is_anon_ns(ns)))
-		goto out;
-
-	if (is_anon_ns(ns) && ns == p->mnt_ns) {
+	if (check_mnt(old)) {
+		/* if the source is in our namespace... */
+		/* ... it should be detachable from parent */
+		if (!mnt_has_parent(old) || IS_MNT_LOCKED(old))
+			goto out;
+		/* ... and the target should be in our namespace */
+		if (!check_mnt(p))
+			goto out;
+	} else {
 		/*
-		 * Ending up with two files referring to the root of the
-		 * same anonymous mount namespace would cause an error
-		 * as this would mean trying to move the same mount
-		 * twice into the mount tree which would be rejected
-		 * later. But be explicit about it right here.
+		 * otherwise the source must be the root of some anon namespace.
+		 * AV: check for mount being root of an anon namespace is worth
+		 * an inlined predicate...
 		 */
-		goto out;
-	} else if (is_anon_ns(p->mnt_ns)) {
+		if (!is_anon_ns(ns) || mnt_has_parent(old))
+			goto out;
 		/*
-		 * Don't allow moving an attached mount tree to an
-		 * anonymous mount tree.
+		 * Bail out early if the target is within the same namespace -
+		 * subsequent checks would've rejected that, but they lose
+		 * some corner cases if we check it early.
 		 */
-		goto out;
+		if (ns == p->mnt_ns)
+			goto out;
+		/*
+		 * Target should be either in our namespace or in an acceptable
+		 * anon namespace, sensu check_anonymous_mnt().
+		 */
+		if (!may_use_mount(p))
+			goto out;
 	}
 
-	if (old->mnt.mnt_flags & MNT_LOCKED)
-		goto out;
-
 	if (!path_mounted(old_path))
 		goto out;
 


