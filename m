Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062017;
	b=MjyFCPTOTJ991LziSs7mICVRCvn9OXNTzG52W/lv79I/W16NqISeWv51iyHRvlVPAqxU
	 HCFB96HIkzIO0eUTIf+yRJ9/1BQJEnwyHP0Twrlq9fQ4/cUVVYMV/R4jU2jR24FpuF9cU
	 yheWwi1s7893m7mSa9uVfgeYzrkCa20ZtJ/dNckvmMTOOVFiEy1djVSqWjpQbe5sINWpN
	 1i15E5V5nG9triuvKr2LRCPFaO4EMVUgF4IbP2ILJhFuZ7tw3v9pzeU7yrKgFUNY/bRZe
	 vcS5B1sOaGDtEGt0r/XpUJT8ovffTlidaB/PHr63KyM5y9LWRnH9YFKJSjQvlfaiE+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062017;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tS/o5ja1x3CTNhDjJ+x7joPXwnIpcJ9aVhNkorcbo4g=;
	b=F4l9jo0XB+RsOxDpXoZ7Bim3fedu6PvpgxZAXNRvaS976oFkfVbRg2Ulfw94TtJFURlz
	 9lA+e/STSII8tB8p/+KKoEfJi/wxjozEuuh10eiKxOsDYKo+vLnrqE64nFIVUKgUue81r
	 YRmul25P7sKYtGOrXWEuCimPoELjW6q3BG7J83QV/q5iHjXMZhXk5eoZTKUdZp9o+nrlg
	 ywd7tQ452e1FuA2h2foD2IxdgK64Fqu0SB2V81cGGLnIldqlrDzsnoQKec2hHqnLY+AA3
	 Kw+qKdcEpPHJ0GrdcPLWwrDQIwnLXJMIsQ2CxQF8B0vh5eNG1zY0PdyzQXEdCvcG6KA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E6j0pUp+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64188606A326;
	Thu, 19 Nov 2026 04:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E6j0pUp+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 720D11F000C4;
	Thu, 19 Nov 2026 04:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062017;
	bh=tS/o5ja1x3CTNhDjJ+x7joPXwnIpcJ9aVhNkorcbo4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E6j0pUp+7l723JAoCdqjxxcX8TA56R01b6e++pXgAQ/FF6GzYV/pbeaFBY0dt4HtV
	 f5eqDJToYFjmPX8ZSwimN6kmcnyh1it4ipPnofjgKe/mMb9Y8y1UH1bI2vDVunTBPj
	 VOwrR1gAURtBlcu7v4gDKor1wd/wQHPDc6KUTzFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nickolai Zeldovich <nickolai@csail.mit.edu>,
	Serge Hallyn <serge@hallyn.com>,
	Bradley Morgan <brads@mainlining.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1759/1848] nsproxy: Fix cred leak in the error path of prepare_nsset()
Date: Wed, 18 Nov 2026 16:03:17 +0100
Message-ID: <20261118150033.078342799@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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
index 12dd41b39a7ff..9b0317b2ee023 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -318,6 +318,7 @@ static int prepare_nsset(unsigned flags, struct nsset *nsset)
 {
 	struct task_struct *me = current;
 
+	nsset->flags = flags;
 	nsset->nsproxy = create_new_namespaces(0, me, current_user_ns(), me->fs);
 	if (IS_ERR(nsset->nsproxy))
 		return PTR_ERR(nsset->nsproxy);
@@ -338,7 +339,6 @@ static int prepare_nsset(unsigned flags, struct nsset *nsset)
 			goto out;
 	}
 
-	nsset->flags = flags;
 	return 0;
 
 out:
-- 
2.53.0



