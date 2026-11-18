Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027773;
	b=mu+I6/HI1+IauENJ3w5wrl7r+aE+fsWoshWnFGFl2vYVLq7lQpggF9fPalYtjOuvDUSp
	 9NQeynePMqnWsmi6fT/6CFQ80DH749COAuUqbxyyY+UVyTCv6iVNh7t+ySs0YUA++JUx2
	 a5RvzVDmcA8rpIse9hKxlHBtIruYlR/sjPAwM9z6s9WMyGtMbSdiLH8F6Z+nvUzXU3hWQ
	 YkCtJaW8DIsmy5Vi8Hcx1XWtN9WCXkRZ69EAyRfrGS0jtS5Pdve8w2tRd7O3GEfGJrGYJ
	 pyXKPbBuFbjcdQaVD+zeLzYH02x3SqPWeMNtCNNf9p6P5nIp9eok8TkJ0ZEPs7ZPQKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027773;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IMYH/aA5uoYQj4D0xoLGLBWfhr/8xs+6oQsL8x564GU=;
	b=z4xSQV/3M/MpNjVpClP26iHd9BPK206UR51PPde5Dbh0WqDs8nQlif2ul/Raw6rj9Cl1
	 5rzE7eiYQP23p/XsiiqTN5sviHED8z/SYwQ6DVilbqKG4R1BA/TpvXgLKciSpuxH+GzZm
	 AAE1AFS9o4FrGYfK91EqkIJq3boNDdKq7zRHGrkx9LNIdYLu/7o9GBW98dmNCs5VYhHGa
	 stBBVsvfTWGSGwSGPyy1qTempkiv4Q+OfV7E0oZQ8GbR0JAjvCgDp+FpIvQKOxcd7KhVq
	 dADNbwFhe7vMbYykl4FVTpACMW/xUgklfcNerMn+W5a0BYEhqIikH69D26oEWiZw8Eg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N+YsuiSE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 016D8606A337;
	Wed, 18 Nov 2026 18:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N+YsuiSE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F7EA1F000C6;
	Wed, 18 Nov 2026 18:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027772;
	bh=IMYH/aA5uoYQj4D0xoLGLBWfhr/8xs+6oQsL8x564GU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N+YsuiSEcikRhGXTQXnFQm5w2msuKmvhWYTEFizEpo5NXOcaI5SevxbrSOBXMgEM+
	 B3YRIZmtIb+/2w1NuMJdyInHaLA0rKAs6oQxo60eKmpq64rAHbB3z+TwGGITad6QJA
	 aFSF8tSPAJSuY7dh+J3HUwpNZOIyWwMqQSTkJ0Zs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nickolai Zeldovich <nickolai@csail.mit.edu>,
	Serge Hallyn <serge@hallyn.com>,
	Bradley Morgan <brads@mainlining.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1906/2151] nsproxy: Fix cred leak in the error path of prepare_nsset()
Date: Wed, 18 Nov 2026 16:00:41 +0100
Message-ID: <20261118150231.221067012@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nickolai Zeldovich <nickolai@csail.mit.edu>

[ Upstream commit e08601d3a7b2236f4915497dca353dcf117bab5c ]

A task that calls setns() with CLONE_NEWUSER together with CLONE_NEWNS
and at least one more namespace flag leaks a struct cred (and the
user_namespace, ucounts and group_info references it holds) whenever the
call fails at the fs_struct copy.  On a kernel with CONFIG_USER_NS the
leak is one cred per failed setns(); under memory pressure, or driven by
a fault-injecting attacker, it accumulates and pins user namespaces that
can then never be freed.

prepare_nsset() sets nsset->flags only on the success path:

	if (flags & CLONE_NEWUSER)
		nsset->cred = prepare_creds();
	...
	} else if (flags & CLONE_NEWNS) {
		nsset->fs = copy_fs_struct(me->fs);
		if (!nsset->fs)
			goto out;	/* flags still 0 here */
	}
	nsset->flags = flags;
	return 0;
out:
	put_nsset(nsset);

put_nsset() decides what to release from nsset->flags:

	if (flags & CLONE_NEWUSER)
		put_cred(nsset_cred(nsset));

On the copy_fs_struct() failure arm prepare_creds() has already
allocated the cred, but nsset->flags is still the zero from the caller's
"struct nsset nsset = {}", so put_nsset() does not see CLONE_NEWUSER and
never drops it.  The caller (__do_sys_setns) returns the error without
touching nsset, so the cred is lost.

Set nsset->flags at the start of prepare_nsset(), before anything can
fail, so every error exit through put_nsset() releases what was taken.
commit_nsset(), which clears nsset->cred on success, is unaffected.

Reproduced on x86_64 under QEMU with failslab aimed at the fs_struct
cache and kmemleak enabled: 500 calls of
setns(pidfd, CLONE_NEWUSER | CLONE_NEWNS | CLONE_NEWUTS) each fail with
-ENOMEM and leave 851 unreferenced cred objects allocated from
prepare_creds() via setns() before the fix, and none after (the program
is in the notes below).

Found by formal verification of kernel/nsproxy.c.

Fixes: 303cc571d107 ("nsproxy: attach to namespaces via pidfds")
Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
Link: https://patch.msgid.link/20261017033538.793280-1-nickolai@csail.mit.edu
Reviewed-by: Serge Hallyn <serge@hallyn.com>
Reviewed-by: Bradley Morgan <brads@mainlining.org>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/nsproxy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index 6ce76a0278ab4..3d4ee4d6e6b54 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -322,6 +322,7 @@ static int prepare_nsset(unsigned flags, struct nsset *nsset)
 {
 	struct task_struct *me = current;
 
+	nsset->flags = flags;
 	nsset->nsproxy = create_new_namespaces(0, me, current_user_ns(), me->fs);
 	if (IS_ERR(nsset->nsproxy))
 		return PTR_ERR(nsset->nsproxy);
@@ -342,7 +343,6 @@ static int prepare_nsset(unsigned flags, struct nsset *nsset)
 			goto out;
 	}
 
-	nsset->flags = flags;
 	return 0;
 
 out:
-- 
2.53.0



