Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82BD24F7CAA;
	Tue, 13 Oct 2026 12:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895944; cv=none; b=HsYdHlnBtyz/b+qAV24sJKO04U1aRmhzqMQzeB6AVbRzvqIb5yhgCOGE0RNzBaglaKdeUNewAUJarjkeJDPCkbd9nh1LVnZ1LdJ4MPmQkQ8rTmLxUjI6XEKi2pt55dHSd293Fu6zjmxk6wtQKd8/sGP+XVs2IgrU2gKBgdSsJZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895944; c=relaxed/simple;
	bh=8EuOXuDUJAmYDzY3YoXEPvYaFEZW+82yWF/ncroeoPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C3dQP1R2hDMs3eM10FYxq3I3T7ztlzrjlkecI8j37TSNu6rvWVa9tiPxqta/nxorT9O9JcRYLwfqEyiy8nOAX/eGvX8ByMnFhjGRdW6XjCq8xvGHKFqNI+aMNm5RtsssE95R9ar7H0NkV/NYg788trbHT34Wxem1qhH0YtRrgbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CZq+Qufe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CZq+Qufe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7FD51F000FF;
	Tue, 13 Oct 2026 12:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895943;
	bh=wxd8FByjgzFThE3BR/IYkDKM23g23rjE3m4R2niKDuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CZq+QufeQZTZulAfanmHF6btCigUMnalUH2OMNWme/OxKpO/PtAT18Wab8mQ8JMsR
	 sPkk8IGroS1722uyEl4jH3yE+SN6gsNem4i3n8RooT9hL2K+TrkgvpmVr1Tgvn4uRq
	 KB5OaJ/hiel5RXxNLCYpRWBAniBaX/rOdn/5nEK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.12 444/497] namespace: refuse an automount below a mount that is in no namespace
Date: Tue, 13 Oct 2026 13:40:11 +0200
Message-ID: <20261013112918.423645661@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

From: Christian Brauner <brauner@kernel.org>

commit ba985ce08471c555af2a2fbe217c1bc2e72a6d8c upstream.

It's possible to add autmounts even when the parent mount isn't in the
mount namespace of the caller. The only requirement we have is that the
parent mount namespace must not be NULL, i.e., unmounted.

Problem is that clone_private_mount() has MNT_NS_INTERNAL which makes
that trivially true. So that passes the test and attach_recursive_mnt()
accepts that as a mount point and funny enough, count_mounts()
dereferences MNT_NS_INTERNAL. The problem is it is an error pointer...

So we can reach this in userspace via fanotify. A filesystem mark on the
lower filesystem of an overlay reports paths on the layer clone and
reading the event hands out a descriptor on it. For example with debugfs
as the lower layer it goes kaboom:

  openat(evfd, "tracing", O_DIRECTORY)

  Oops: general protection fault
  KASAN: null-ptr-deref in range [0x1d0-0x1d7]
  RIP: 0010:count_mounts+0x35/0x200
   attach_recursive_mnt
   finish_automount

And since that sleeping beauty happens under namespace_sem held for
writing every mount operation on the system blocks from then on.
Congrats.

Use is_mounted() instead which rejects unmounted and internal mounts
alike. The open fails with EINVAL just as it did before
clone_private_mount() used MNT_NS_INTERNAL.

Fixes: df820f8de4e4 ("ovl: make private mounts longterm")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261002-work-mount-fixes-4-v1-5-dd44b89d44ce@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/namespace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -3459,7 +3459,7 @@ static int do_add_mount(struct mount *ne
 		if (!(mnt_flags & MNT_SHRINKABLE))
 			return -EINVAL;
 		/* ... and for those we'd better have mountpoint still alive */
-		if (!parent->mnt_ns)
+		if (!is_mounted(&parent->mnt))
 			return -EINVAL;
 	}
 


