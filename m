Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828877;
	b=Q1xsWwbEEqFrlb2Om03IDAOH+Z25tfRWYQ3Hv6BHuMqQFhowzcLdXL6YRrAaeppCbZRM
	 /ZzlUbFThRamsQT/NGpygnyPYJ8sCQmXM7Zo6pjfB94ECsdVKupVZgKDmaZmHy4e+JBQO
	 6Sm59lb+xPIiWF5kyQXnV83iA/RTl9z9bFb9PJrO9QISjACL5m/5l95flDl+Pjr0klr9r
	 8Ore0Htc1WEDUmQk/7uEaLzKHIcelV+es4heO5ZW6R/XqH0LzXb/LVWvmfqkaw5byEY/q
	 VXlr2rAsxdkkuyBeeo0QiKP690Tqol7a0CtBuYk9REbMnrxxeM+J7j3YlvFyPEWMtXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828877;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+eMjBtnECMRkYYkvwwRuY8eYh/czFNRf5gUjZVxKWqI=;
	b=FFohIV1z6FwiDG3bB9DS28twrHtlEFPhLhgu1hqsk9LpuCtXLGLoy5lbgrsAieqtoAu6
	 kJbTHISIl+yv4pe1BIukl2xUYdjk3d9w1X4Hmsi1SGRIX3Twgqi/kaKAotgJe3qGd8hp/
	 rZIpTAIdmkWVnGypFhN8PtwEjha8G7sLyFoZ8wCgu0W9rEgeIiP0/+oNPFzvU3l3S6mG6
	 bJnHz1RAhPfUjZmFPeY3VJ0Sv/KRWSJeELGtmUj/6boaYefcTmuEUPChnunbb4rafaOMM
	 VTpbF8sRbzwDrfzRDPdmkFODC4s94zf8T/AFteMpjjZ73aMEa4Vgub9WdpToZCBbc/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fuDEEag9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF366607030C;
	Wed,  4 Nov 2026 21:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fuDEEag9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E60C1F000C1;
	Wed,  4 Nov 2026 21:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828876;
	bh=+eMjBtnECMRkYYkvwwRuY8eYh/czFNRf5gUjZVxKWqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fuDEEag9is0wAFgw7aN+uSy58IOBwfxzaX0nNn6oZZ2/azRsMg2pGdOhnploU5Mwj
	 q5jNDVxiEPyPY5QQ8NZUWSOMBoRNC5CJH57bSJSaW3aKOxnwMC+gosH4QP9EyiKrJQ
	 UkP+geO64DbFznCQYH/bQz0n+UH+WrGYH+SPEFSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 7.3 296/547] ovl: set the revalidate flags after d_instantiate()
Date: Wed,  4 Nov 2026 16:08:00 -0500
Message-ID: <20261104211046.610732791@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <mason@kernel.org>

commit 75e89c0055c1d7f7eeb462995f11253ca5864f79 upstream.

stat() of a file on an overlayfs mount triggers a kernel warning and
fails with ECHILD if another task is creating that file at the same
time. This happens on an overlay with a FUSE upper layer, which is the
layer where overlayfs creates new files. Write access to a directory on
such an overlay is all a user needs to run the two tasks.

The revalidate flags are DCACHE_OP_REVALIDATE and
DCACHE_OP_WEAK_REVALIDATE. They tell path walk to call ->d_revalidate()
or ->d_weak_revalidate() on a dentry, so that the filesystem can check
that the cached dentry is still valid. An overlay dentry only has one of
these flags if a dentry in one of its layers has it. FUSE dentries have
the first one.

When a flag is set on an overlay dentry, path walk calls
ovl_dentry_revalidate_common(). That function only expects a dentry
without an inode in RCU walk, while the dentry is being destroyed. For
such a dentry outside of RCU walk, it hits a WARN_ON() and
returns -ECHILD. So a negative overlay dentry must never have the flags
set.

ovl_instantiate() breaks this rule. When a task creates a file, the
overlay dentry for the new name is hashed but still negative.
ovl_instantiate() then works in this order:

- It copies the flags from the new upper dentry to the overlay dentry.
- It calls ovl_get_inode(), which can sleep in a getxattr request to the
  FUSE server.
- Only then does it call d_instantiate().

A second task that looks up the name between the first step and the last
finds a negative dentry with the flags set and revalidates it.

Reproduced with a FUSE server that delays its getxattr reply: stat() of
a name that was being created hit the WARN_ON() and failed with ECHILD.

Fix this by setting the flags after d_instantiate().

Fixes: bccece1ead36 ("ovl: allow remote upper")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/dir.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -304,7 +304,6 @@ static int ovl_instantiate(struct dentry
 	};
 
 	ovl_dentry_set_upper_alias(dentry);
-	ovl_dentry_init_reval(dentry, newdentry, NULL);
 
 	if (!hardlink) {
 		/*
@@ -335,6 +334,13 @@ static int ovl_instantiate(struct dentry
 		d_mark_tmpfile(tmpfile, inode);
 
 	d_instantiate(dentry, inode);
+	/*
+	 * Unless it is a tmpfile, the dentry is hashed and a path walk can find
+	 * it at any time.  Set the revalidate flags only now, because
+	 * ovl_dentry_revalidate_common() does not expect them on a negative
+	 * dentry.
+	 */
+	ovl_dentry_init_reval(dentry, ovl_dentry_upper(dentry), NULL);
 	if (inode != oip.newinode) {
 		pr_warn_ratelimited("newly created inode found in cache (%pd2)\n",
 				    dentry);


