Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032748;
	b=gYFy5dOcJR6YlVoflupn1kDLv0YSKyroaTvrG0Azhm1SbP1nf7BFNdsicDLA2DtHvy22
	 rcuhgiY1ysW/OFIshgzJXWdpd9SVQQM6BD0173A6SpAZEkSfO2ztYuk2HNTeRvTklGvr7
	 SWFjjKlFSPYI7ZUHzVzUW4hHKBix3RRafgnBrRCoB3gpf5hUXy8MGBvZFXP39suriE2RS
	 peMrJZCBiaZM5oz0a566IfelfZitZBBk03fk1aOv9Y+fPMy31spZFEOT5RBfwb4/lwzsW
	 pWuJgxIPKFGBE+DWm77HRjWhsO6usPbx+Yki3aTvHw6YI3jRy23jmmPLqwlxa/zF7RQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032748;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qq0JggrdeFxphXrcIimazyFTc/JbwdLhYl8Euwgoux4=;
	b=FkUgkLVffKdNM8SWgTlzYWp/rXurXSjspX+pyn9yYjEa+IooiLuz2OirCzyDrqkyJ1V+
	 UgNGVc0T/asbQq0+I8zB14CNGYPbZioWiPsabdua7XLVNR/7tMUucWvm0YwjNIbSWaQv8
	 uojNHsovoeiLqzwBRxnSiPQ7mn9rdxQYov60DWMMkl7X525RCQcf2zeQfb7AISMdfEiE1
	 XebGK66qtAUZUztbHTF7sWQ/hZRNAlUlCKKAyJtuFKvc74ylgYM3gOM+2a1oB4NPHIXub
	 BZ0ReK2/8V/1n0Zp6ff4PPV5mQa6+XSOwltoX36Je7jdTEX1dgqYCuQD1eH/VbcKqAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qoCoLYz4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FC4B606A32A;
	Wed, 18 Nov 2026 20:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qoCoLYz4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E65831F000C4;
	Wed, 18 Nov 2026 20:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032748;
	bh=qq0JggrdeFxphXrcIimazyFTc/JbwdLhYl8Euwgoux4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qoCoLYz4mKtnpK1mNTjZb34rmLSKtoTxDfL4FXftq9gV0bz7ZVvNww2Rq3KAlrEp5
	 39TzMXs3ITLZpaOFfLCkoLOGOZ0k72dKnxZtjFAi1ShAc80LXefzs2LMECABfP981U
	 OQ4Oxvhm96gzDSI6h3sRemrckENGd0kjx9x4M/Vg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nickolai Zeldovich <nickolai@csail.mit.edu>,
	Serge Hallyn <serge@hallyn.com>,
	Bradley Morgan <brads@mainlining.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1523/1756] nsproxy: Fix cred leak in the error path of prepare_nsset()
Date: Wed, 18 Nov 2026 16:00:50 +0100
Message-ID: <20261118150109.478255845@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c9d97ed201227..635dcf806ea79 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -332,6 +332,7 @@ static int prepare_nsset(unsigned flags, struct nsset *nsset)
 {
 	struct task_struct *me = current;
 
+	nsset->flags = flags;
 	nsset->nsproxy = create_new_namespaces(0, me, current_user_ns(), me->fs);
 	if (IS_ERR(nsset->nsproxy))
 		return PTR_ERR(nsset->nsproxy);
@@ -352,7 +353,6 @@ static int prepare_nsset(unsigned flags, struct nsset *nsset)
 			goto out;
 	}
 
-	nsset->flags = flags;
 	return 0;
 
 out:
-- 
2.53.0



