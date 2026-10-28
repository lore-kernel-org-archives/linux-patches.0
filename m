Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209096;
	b=0Ma+yEEaj7KQDyrYvqL8ZWIW4Af997bh0CHLYGyv6AHh7JxYaUY79e6qEHZThyzCBniu
	 TplHdIPlkzNZhDKZP5FwUzp3fQEk75nr2lR9baLOLlLP88xvCsHIi4m2GYWFDLlFfSOdW
	 vTN+J4O8axs+gRAQ0sFKePxPlrbOjpio7Rj4ZyESnzczuUNHtZwf6BS5/CYwQ9dwW3Db9
	 3OLnYdZusyfjWBKymko7c6asRqxI2Aoa94cVv2PKSmduV7JBZqsaD5wR+5Jq9gT/C8qDm
	 C2OiiWeRAWoMNh7/Gmn2+OjKsO1loh7iYx73e3zT0c1hb4NtLj7wa/umPB5amtn5cZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209096;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1L/lIL73gqHwJeU+Ns5NGnmjddJ3Sfy6AMnPMXNIezQ=;
	b=JVtDacNEcU+NTi5JEliWgjHNiWluGLLCXhVzkkuJzRdce5sB3Gm+hhlfPn9uBwOHyUVX
	 Lt5PSJ/VDrlclFH6TAy5ktWN00KI86zNwQImc/5DKBJU8Qhl5pCG3eDWm4jO4NXEFJ+wA
	 IIVJmTe5Fu6dY8dOr9QNC/fAQabN0i17H9SHER6eb24KY1mF7igPs/SQGJFuwX0mX3Ded
	 xxsOWys/7kLhQ4oTUipWaKWD/ucYrY60h6Sv5aKxj7LeSwSKUHDxsRUGPUcisqx3A+ewY
	 9BT9LeuH0fLtV0B+CwwuMo5kZk3nPWYwoVRC5IneiJKSmsbCzvrfkZwgGQxdKOC+h+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q5uy80Zs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A02C2606A324;
	Wed, 28 Oct 2026 17:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q5uy80Zs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFEFD1F01825;
	Wed, 28 Oct 2026 17:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209096;
	bh=1L/lIL73gqHwJeU+Ns5NGnmjddJ3Sfy6AMnPMXNIezQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q5uy80ZscwBVfEY2CQWPEta5p+5e+HfGRu5rxoX7syC31LQQF/FQ03PFU8ypOFNle
	 PhG2xe7XTarbEM/cfWM0kRWNOfdxlQNk44k5r35YYF5zk3EO8v4xlG0VWsnyWWlNlI
	 845NUbYmvBn12y5p6SXtPc6glqAYqnMmUMIXTL4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 5.10 351/516] namespace: refuse an automount below a mount that is in no namespace
Date: Wed, 28 Oct 2026 17:58:23 +0100
Message-ID: <20261028170011.806414588@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2893,7 +2893,7 @@ static int do_add_mount(struct mount *ne
 		if (!(mnt_flags & MNT_SHRINKABLE))
 			return -EINVAL;
 		/* ... and for those we'd better have mountpoint still alive */
-		if (!parent->mnt_ns)
+		if (!is_mounted(&parent->mnt))
 			return -EINVAL;
 	}
 


