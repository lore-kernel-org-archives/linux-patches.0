Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44EF62F6931;
	Tue, 21 Jul 2026 20:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664113; cv=none; b=F0YesaawXtEeqmsLEk54Hsu6MRAlKkpLXNidE7ivBxolo7YTue7xnxNDJOuEFdlx3heE15mTfF6gW4WY4qyc8IPxQx/Zd37kSgtMETbNXDySSCr7nhaofBmMynnEZE0B1QjTplQ3UKov2Oqn3R6jxp+cCfw+ha94CLP11xPiQvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664113; c=relaxed/simple;
	bh=bYzh6aDdptWhdqhNpscUj6pn+NU0oMttgaYYMB2WoRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ADo3tN8Z4dt7414rfeVxmM3xnd6OrQr2i5mFzT8Lxch5irVBVT4dipBNpttxpnMlzeNNsb33+RwBdcNEgcsMVFidEfK0zdj7bn0n5/jAjuO9iqKl78LbS9oFPuf6yelHmW9PtImJc0vlkajkQtC6hmI3M4Q8KDnNGre4q2m0a3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mx5QaASk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mx5QaASk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A508B1F000E9;
	Tue, 21 Jul 2026 20:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664112;
	bh=8KSXAuUmSG9CrEpIFk+YrHaWCGLg/qogf7yHuXUKfmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mx5QaASkdkvEBgJCo9yfDmYUKGQZ5nT66ta4l6+zHVudHxRd/1f0J6zEF4kSLC0Do
	 ueInMDZz+TXt8QSMf9eUeMZ7NnOe4jrffXQY8kaxKOoe070FIAJcagEjEqQxR63m31
	 Hta+062gQq8NGZluVZnthv5lzCt9/EB5P9x2k5e4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lee <david.lee@trailofbits.com>,
	Jeff Layton <jlayton@kernel.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.12 1078/1276] fhandle: reject detached mounts in capable_wrt_mount()
Date: Tue, 21 Jul 2026 17:25:21 +0200
Message-ID: <20260721152510.111780783@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: David Lee <david.lee@trailofbits.com>

commit 6c732471740bc2ac9b0946134f9f551dc75f4369 upstream.

The recent fhandle RCU fix moved the mount namespace capability check
into capable_wrt_mount(), so a non-NULL mnt_namespace survives the
ns_capable() dereference. The helper still assumes the later
READ_ONCE(mount->mnt_ns) must be non-NULL because may_decode_fh()
checked is_mounted() first.

That assumption is not stable. A detached mount from
open_tree(..., OPEN_TREE_CLONE) can be dissolved on fput while
open_by_handle_at() is between those checks, and umount_tree() can
clear mount->mnt_ns. If the helper observes NULL, it dereferences
mnt_ns->user_ns and panics.

Return false when the RCU read observes a detached mount. This keeps
the relaxed permission path conservative: a mount no longer attached
to a namespace cannot authorize open_by_handle_at() access.

Fixes: 620c266f3949 ("fhandle: relax open_by_handle_at() permission checks")
Cc: stable@vger.kernel.org
Signed-off-by: David Lee <david.lee@trailofbits.com>
Assisted-by: LLM
Link: https://patch.msgid.link/20260701114438.24431-1-david.lee@trailofbits.com
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fhandle.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/fhandle.c
+++ b/fs/fhandle.c
@@ -252,7 +252,7 @@ static bool capable_wrt_mount(struct mou
 	 */
 	guard(rcu)();
 	mnt_ns = READ_ONCE(mount->mnt_ns);
-	return ns_capable(mnt_ns->user_ns, CAP_SYS_ADMIN);
+	return mnt_ns && ns_capable(mnt_ns->user_ns, CAP_SYS_ADMIN);
 }
 
 /*


