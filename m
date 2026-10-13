Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CB4B49C4CC;
	Tue, 13 Oct 2026 11:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892589; cv=none; b=pcz5fjQtT30Gyki+HngfVbYimq98SFPQrGS7vsVaDOPEzbjS3ovG9RH35If8TpX6kD/vocvrL6KjqJQmRoXhgSJNR2/Khx2G7w59fSAE3o6W9S2qC6PlC0x4JKB542TEF+ldLI3p3OIC9TEWYsQI6B3hK0pfHUG5JgPAhiHDxqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892589; c=relaxed/simple;
	bh=fMXx7Zmk32i2VqUn2t00jTr2Don30w9id5V54Y8X5vI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aV1JQGvjCm5a7KsqAUG4H9ucYHa5UO5Kh2HC7QHrPHSF9FuEKvJyUdLKYjOV02SWmnXXRHvTXssUdhssemDdXUtvut9geH8qk7GyvfO2fkD5sRKSdApm8TUttkkCCvKcLjJV/XRqGymKGhquvccMorI1LYbbjVCEFhBj92482x4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zih+YubZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zih+YubZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C3F91F000FF;
	Tue, 13 Oct 2026 11:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892587;
	bh=7p3hU2J7wrwkJ1ppBJacL7UImBZBwyaVHwFwoC1CxQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zih+YubZ1SN1TGhV3hTb0vB/FIorBV7g0yzr/pMv6LuBN5eZfIctffg9RcMrc3jvw
	 B4vpj57JXZwsbVmd4zgfGsQclSg18PgbzVinBosQ8XDjEBCJUQufnmUa//ADtmQStR
	 1ddUI88qINgbQ6z0fRN6CbzASTVwlJ8bQN+lfji0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.2 169/281] namespace: refuse an automount below a mount that is in no namespace
Date: Tue, 13 Oct 2026 13:38:05 +0200
Message-ID: <20261013112859.268099055@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3784,7 +3784,7 @@ static int do_add_mount(struct mount *ne
 		if (!(mnt_flags & MNT_SHRINKABLE))
 			return -EINVAL;
 		/* ... and for those we'd better have mountpoint still alive */
-		if (!parent->mnt_ns)
+		if (!is_mounted(&parent->mnt))
 			return -EINVAL;
 	}
 


