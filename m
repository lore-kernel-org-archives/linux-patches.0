Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021728;
	b=4F8xVGJNXQ2nk05hVR5RXxEu1Lhv9xg06LmKqc+9I6UZdjEPu2/xmWbVko+RFtnGIUwI
	 WluWJ19YoYjWJJQ3/d/yv2Uu3XunUgKLJkSo8YWqgUMXgb89vTYfsQLoyodk4iidDW6Gl
	 apziAcAPRosZogONfarYPTPAmzsjVwusa2J9cnNC+TIY84fmyrfKleRju7BkN9oPCFtQM
	 8D/z6oQ5ANB4i5m9DYRiIF/eVZ6sofAZFunYXbAoBreMwoxorvN13/x/McP/F/GH2KWwR
	 bcUt7PWOKKA+CfnB2ld4bAtS0T6wbtkquJED8mtKqKAKRQkDEcqeBDddjsGGzMyPiSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021728;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NQMz0Luk8w/0bmrvWEP17CxTVHP+iA2OX1zzm8rsYn4=;
	b=2jkif6U4gmBAm15B1qNDIebJZPv0lMbhkf3PygFox++ZpMDNNVHgeZU7Uncm/6CGACSK
	 wIWlYvsDRVLmXgzWi5N8PJyrLLQdu5RNaAVX8csMHDdGcXrLjlRKmvO5s4EOBVkzZcH5c
	 TE9rA+enNz86euz9LhRvkYqEPbPt6GeFo937fMijIFfdUdR+onEhgNvSuOyDK7F4DI778
	 6vpNeQgJMbDjB/KDrCIlEtu9kDvuEMV2gubvNv7MgXFlrtvZsgZIOvY4cUk3ZTzv1J9ZJ
	 YOr8Xsl3+f5t4BH4LeZZyRuFT/iooEM422yDYYxcw7SYzoX9LHk9koH8TZ8A0x5hkmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rYeBSs9p;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5CB860A2635;
	Wed, 18 Nov 2026 17:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rYeBSs9p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21B5F1F000C4;
	Wed, 18 Nov 2026 17:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021728;
	bh=NQMz0Luk8w/0bmrvWEP17CxTVHP+iA2OX1zzm8rsYn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rYeBSs9pLU1SbcKMOejUzzewNr1dcUj85S34wGTTyXaxkpupl7ayqFlplijps5JAK
	 k9rLupQdueggyogcCnJ3nVqSWSEqAd5ct6Pg06vIrXVp/rLZe1lop6+QVbGLhNAwSK
	 s26lNu8ZO3xtqU+BBX26IOgaAsBkvcrt0i3AC0+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nickolai Zeldovich <nickolai@csail.mit.edu>,
	Serge Hallyn <serge@hallyn.com>,
	Bradley Morgan <brads@mainlining.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2359/2651] nsproxy: Fix cred leak in the error path of prepare_nsset()
Date: Wed, 18 Nov 2026 15:59:59 +0100
Message-ID: <20261118150410.487484832@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index 3fb1595a4a593..028019f3e387c 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -355,6 +355,7 @@ static int prepare_nsset(unsigned flags, struct nsset *nsset)
 {
 	struct task_struct *me = current;
 
+	nsset->flags = flags;
 	nsset->nsproxy = create_new_namespaces(0, me, current_user_ns(), me->fs);
 	if (IS_ERR(nsset->nsproxy))
 		return PTR_ERR(nsset->nsproxy);
@@ -375,7 +376,6 @@ static int prepare_nsset(unsigned flags, struct nsset *nsset)
 			goto out;
 	}
 
-	nsset->flags = flags;
 	return 0;
 
 out:
-- 
2.53.0



