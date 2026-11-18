Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044597;
	b=YqsmT1MxHYm459+RolIJwXf9I3mog5bMzadOoW4LlQ0Ajs82QieD8wbwbiCz6VOJnnwy
	 vRqlTbfyWiEY9k5qh3r52Z+zXBOLDjC256Q7oiHvkmKLEiY+QNmDguDlP0mW1hWRbnjxW
	 sR5sBtylzTTU+xccMv0HXvBeLe+HMbTIPd2K/a9vCgNssAS6vGszqjym+WifushF+rPIn
	 kA7mxwj7OHQKFP93MJzMzZKPW2V9BFQLDO10vCr+StzrOcXGgL60JaKIur5QgiguPnYgZ
	 cUd5yWc669Q21vYachkqkSL8E5HTnSjSysrxDrTXtxsqVHgDUkGaLKAiA4ggAqvn+DA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044597;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mpq99C46qexw8kJMaiBGzsrBaNWajKCcHjC5UniHFTo=;
	b=S6lkYfwEgwoXPHeagIUmcLQUvD307DWg33ZWAUkJCBV+Q6r16JSLaUFgN1VHLG0sXt8w
	 C8Gv3CjszkWJHMXPRrjnpGzcfD/3H3vjeIZCpuFGEqV0ME0iC6+4MKMlajbuRJnK5V5ZT
	 4yHYGmvj35LpB7NIr2rTTsuhteVyMDQtxIcjBV8GpD9Pc5uK5NEqXghiYcD3XjodWSnYl
	 vIP54Yo2oCEk1cLZu8X7GIvwLT7yshS/oog/w/aX7pqY8lrI8ng98o4BeL7nrye+g63Mq
	 YcnsPV29gI384h5UqdJ5txlAQaedeQ+pWRsvtgfazB5OtXU7TVVmGzSHaKles059B4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PO7j+a1N;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC474606A31C;
	Wed, 18 Nov 2026 23:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PO7j+a1N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 299BA1F000C4;
	Wed, 18 Nov 2026 23:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044597;
	bh=mpq99C46qexw8kJMaiBGzsrBaNWajKCcHjC5UniHFTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PO7j+a1N09ia40AiR7LLkO9fW+Fn25asldXaMxG+Ects9x3DtMsJo40q+5xeBS7nd
	 q+DUyLu/CQHOkm7uuq7wBGNcWiQrDUrMGUGlP8+gTLsKl/OWmfv6xAuAbi+VDxjFEy
	 soS8a3WYYpEyqT6cphbD0j3l5Q77FM/FwUv14vmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ameer Hamza <ameer.hamza@truenas.com>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.1 0621/2857] sunrpc: treat empty auth.unix.gid replies as negative entries
Date: Wed, 18 Nov 2026 15:27:35 +0100
Message-ID: <20261118150223.849536665@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Ameer Hamza <ameer.hamza@truenas.com>

commit a12cc0930235b86b934ade7c077a1935c2ac333d upstream.

When rpc.mountd cannot resolve a uid (getpwuid() or getgrouplist()
failure, e.g. while winbind or sssd is briefly unreachable), it
answers the auth.unix.gid upcall with zero groups. unix_gid_parse()
installs that as a valid positive entry, and svcauth_unix_set_client()
then replaces the credential's group list with the empty one on
every request, RPCSEC_GSS included via svcauth_gss_set_client().
One failed lookup strips that uid of all supplementary groups on
every export for up to mountd's configured TTL (30 minutes by
default), long after the NSS backend has recovered.

mountd cannot send an empty list for a successful lookup, since
getgrouplist(3) always includes at least the user's primary group,
so a zero-group reply can only mean the lookup failed. Record it as
a negative entry: unix_gid_find() then returns -ENOENT and
svcauth_unix_set_client() keeps the groups the RPC credential
already carries. This is the fallback that
commit 3fc605a2aa38 ("[PATCH] knfsd: allow the server to provide a
gid list when using AUTH_UNIX authentication") promised when no
answer is available, and the same state try_to_negate_entry()
already creates when no listener holds the channel open.

Fixes: 3fc605a2aa38 ("[PATCH] knfsd: allow the server to provide a gid list when using AUTH_UNIX authentication")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-fable-5
Signed-off-by: Ameer Hamza <ameer.hamza@truenas.com>
Link: https://patch.msgid.link/20260814221953.108837-2-ameer.hamza@truenas.com
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/svcauth_unix.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/net/sunrpc/svcauth_unix.c
+++ b/net/sunrpc/svcauth_unix.c
@@ -536,6 +536,13 @@ static int unix_gid_parse(struct cache_d
 	if (ugp) {
 		struct cache_head *ch;
 		ug.h.flags = 0;
+		/*
+		 * mountd sends at least the user's primary group on
+		 * success, so an empty list can only mean the lookup
+		 * failed. Keep the credential's own groups instead.
+		 */
+		if (gids == 0)
+			set_bit(CACHE_NEGATIVE, &ug.h.flags);
 		ug.h.expiry_time = expiry;
 		ch = sunrpc_cache_update(cd,
 					 &ug.h, &ugp->h,


