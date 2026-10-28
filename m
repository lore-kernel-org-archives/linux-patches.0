Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213521;
	b=UlHPc8QeeghSB5/kSS1+HRhB+eHIh7Gg9Fl4qneydcQXlvj4LTsO8zWoir5dNzXpmp9b
	 d2lkutD1tFS1dc9Re5wwMmrdUuTc7ocSLkL0OS9liXpijvSYTJZ7ezlCuUB6WCawauCZG
	 36xqfNe7TRwOd8BzXeDelQg4jvAJyPqi4mb/080vizrW+a4yAF9O0xvYw/pJ7Ek9+G+no
	 NiwxB7Y1sTEW9VT/qgAFMyuHIY4J3k7688HaG21tkNu92jL1KcTcGsfSDIOCvNhXAd+mv
	 9ysN3k44tCeGI9VxnLn/ebJ8eHSWRKXWOXF7NpxjnGoglDiGvnC85qZ02QKcNKQhbQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213521;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JhO85sozfv84V9yHb7MdASWoPa9NGOI5/pHTFMmsZCE=;
	b=bTRyePDb3XKWofC/Ad3yMygBt/n5G291ZBZjeTnBN5Ct3oKGF816y6qS9yq1EoUkCOv2
	 q/78oSkPrk0Z+PFpgvHpp3/tz56h5n3saIyqfhH9AQf+MksgIZi6b/z0xpWQEFxXWbQ2Z
	 jdOupxJxhSKR+UIIyWqJG+QXPRTGxWlhpGMwgh4UfW6Msbs95+f1gF07OoN1WwWV7Tprn
	 Sd2cauboDfhiPaKt39NEErvlvAfO6nWdITNehgmCiC8bnq92UpIxz3xCBHPBO0jjR2xB6
	 S2nUZ2Pg9dSTCZiXM01yz2BA8epN0G+lh00L0v60y4zgP8WPV9oU37VluQf7NHDJ4PA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fNaDpMr1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 023E1606A31D;
	Wed, 28 Oct 2026 18:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fNaDpMr1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 526631F01825;
	Wed, 28 Oct 2026 18:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213520;
	bh=JhO85sozfv84V9yHb7MdASWoPa9NGOI5/pHTFMmsZCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fNaDpMr10HqVYAyOSddw/2M3b/iKS42ZUcKGBeT9s5CSWPq5tl8jzn8w7k8/1hgMA
	 irgkzuuLZXcH9t1KwfLiWtGRLUvX7bGpqaaIiXoPHaXeFmAWDOqZjl5JWZWECLLDcx
	 F+frtYUP84nqz50cYfe/x7O2W2pafQXCE4+i+tF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.1 0482/1887] namespace: refuse an automount below a mount that is in no namespace
Date: Wed, 28 Oct 2026 17:42:58 +0100
Message-ID: <20261028170510.227951470@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2965,7 +2965,7 @@ static int do_add_mount(struct mount *ne
 		if (!(mnt_flags & MNT_SHRINKABLE))
 			return -EINVAL;
 		/* ... and for those we'd better have mountpoint still alive */
-		if (!parent->mnt_ns)
+		if (!is_mounted(&parent->mnt))
 			return -EINVAL;
 	}
 


