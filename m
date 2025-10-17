Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFEB43208;
	Fri, 17 Oct 2025 15:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714884; cv=none; b=tLpCcEwcA0+CvxUlPaAzCuRP4KLlE4MlvfpW225aIb2pv3tFQTqDaYHaRkrBrauwW8RsakoZpSJ7OTiiNZysVc8gBdjZbTpORanUPMXdUhdvjzB7HS58j0JDqUPA8QGAkqTe7XNSWjJKZFq2BSxG1hxglewlzcq6VKS5Li3fkcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714884; c=relaxed/simple;
	bh=eG7mnz1HiTpmCJ4mAL6QE2UFLkqK6rVziwBfTOrv5oE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RUkx80AGnLCMoi7cnUY3soRo1uqggthlhLRaZ5OuyJT14sqjXOrg/pDY782NiYNR0MI5DQ/W3MdVyz+J05Hk5H6nZP6cZY4dE36c7f/9YRGg43VRnEGBhxM7bkS70S4WaEjmggvZOSJnkhrSePXr547VtGktrXy38WC4djazaJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ljqSkYvg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ljqSkYvg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18A87C4CEE7;
	Fri, 17 Oct 2025 15:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714882;
	bh=eG7mnz1HiTpmCJ4mAL6QE2UFLkqK6rVziwBfTOrv5oE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ljqSkYvgCohcpJeEI7lB2zYkWz0aWEPuRKZ/3RHleJw3hxRqgLKjkMq4zizCsX0Cb
	 i7dRPK3xdf0kO3B7vjB0MlFquftvjnIj8B6Zv3ot+BP47LN8vMgqyd0CYxrbYctqJR
	 rqgMvb/L+GAqk/RTfopmqxS/F63KbLmJigVxdA/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.17 006/371] statmount: dont call path_put() under namespace semaphore
Date: Fri, 17 Oct 2025 16:49:41 +0200
Message-ID: <20251017145202.022593834@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

commit e8c84e2082e69335f66c8ade4895e80ec270d7c4 upstream.

Massage statmount() and make sure we don't call path_put() under the
namespace semaphore. If we put the last reference we're fscked.

Fixes: 46eae99ef733 ("add statmount(2) syscall")
Cc: stable@vger.kernel.org # v6.8+
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/namespace.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -5711,7 +5711,6 @@ static int grab_requested_root(struct mn
 static int do_statmount(struct kstatmount *s, u64 mnt_id, u64 mnt_ns_id,
 			struct mnt_namespace *ns)
 {
-	struct path root __free(path_put) = {};
 	struct mount *m;
 	int err;
 
@@ -5723,7 +5722,7 @@ static int do_statmount(struct kstatmoun
 	if (!s->mnt)
 		return -ENOENT;
 
-	err = grab_requested_root(ns, &root);
+	err = grab_requested_root(ns, &s->root);
 	if (err)
 		return err;
 
@@ -5732,7 +5731,7 @@ static int do_statmount(struct kstatmoun
 	 * mounts to show users.
 	 */
 	m = real_mount(s->mnt);
-	if (!is_path_reachable(m, m->mnt.mnt_root, &root) &&
+	if (!is_path_reachable(m, m->mnt.mnt_root, &s->root) &&
 	    !ns_capable_noaudit(ns->user_ns, CAP_SYS_ADMIN))
 		return -EPERM;
 
@@ -5740,8 +5739,6 @@ static int do_statmount(struct kstatmoun
 	if (err)
 		return err;
 
-	s->root = root;
-
 	/*
 	 * Note that mount properties in mnt->mnt_flags, mnt->mnt_idmap
 	 * can change concurrently as we only hold the read-side of the
@@ -5963,6 +5960,7 @@ retry:
 	if (!ret)
 		ret = copy_statmount_to_user(ks);
 	kvfree(ks->seq.buf);
+	path_put(&ks->root);
 	if (retry_statmount(ret, &seq_size))
 		goto retry;
 	return ret;


