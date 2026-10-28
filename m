Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211470;
	b=f8ljXfoKX6BJuHJThORtM1N8Gwr+sf6E4kG3aVN0gA7u/DniTn1TtiCEXeiNaWRBW1PO
	 ERCQnGen+tzbJxa3ftCIj4Of3DyBkl6T+3HK6wbB0ObwoKqNRb3O+vy9wB+Lvw3cYPjuI
	 4n9ePLF/MEDhBguoVrqtCD7yaCckbMvmy1Y5GgdRq7UwsbmOjnzczVVkw/sRLSBrDujw1
	 tfmYdcjpHyU9BAaS53sp+WGU7e1Usu08Oy8hU6cGguPFAYMmuu9d/Th+kag66JfE4zH1K
	 i09o2marnZ7tCTgbNPDbdTLxVe2yF8kxUb2psTNNbe7RGLVT9Pgwyw5tDPqom+5Tm7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211470;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pqvH05habrReBOLB/AUaz4hGYE9Rvcq4fPebYmn8Qao=;
	b=PyJacy7wc/qnjVegya8+EQVY81Rz66tJkCFXY7+hc6JU2tWrsQdUMKrM/s0GWOQlxTDh
	 DLFc4uDgVh2Ko9zU0WT/Xk1Jpum2IcoRKWuxkKORRgoPlWpz1ZTsu84lrXT7wl1kdSBlE
	 OMHihgSOIlKrsofLJmnODd2gM9YZumPgG6bJ0tQYdu6ftL9ni71GStK08rdOCePVt6Btm
	 wPe7Mi1WJEe+qew53AV+zSW9CwP8aqGWRwnQNp2yNee3qxUSq3pWRtlE4fWKpFIMV6HVs
	 5echkvwU/4dx5cGGETqvOSnsJtLbQWsM9qpi1MZD2+Iqi8or/pf1Z8inq0x0Q8cH5qA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CzPcMo0W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59E09606A31D;
	Wed, 28 Oct 2026 18:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CzPcMo0W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB04B1F01828;
	Wed, 28 Oct 2026 18:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211470;
	bh=pqvH05habrReBOLB/AUaz4hGYE9Rvcq4fPebYmn8Qao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CzPcMo0WBAJQyrvOtTI1qEPU4ncVvONij5X9qFGPftyScTR+Gpbpc65Z5UVrT+QKW
	 60RmIDVurak6HfViXZyq5R5tQuoGaUqbBJye1plP9sJR92tNMJuA9CQI9d10JNf26p
	 0TCo/BLx0G3hdb4gUbAWpCdJfNyO8S5QjUHKomK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 5.15 389/571] namespace: refuse an automount below a mount that is in no namespace
Date: Wed, 28 Oct 2026 17:58:56 +0100
Message-ID: <20261028170017.244388952@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2921,7 +2921,7 @@ static int do_add_mount(struct mount *ne
 		if (!(mnt_flags & MNT_SHRINKABLE))
 			return -EINVAL;
 		/* ... and for those we'd better have mountpoint still alive */
-		if (!parent->mnt_ns)
+		if (!is_mounted(&parent->mnt))
 			return -EINVAL;
 	}
 


