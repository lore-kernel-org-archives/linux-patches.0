Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829097;
	b=FRfBkzFIH0Ap1AQqztfKQtArEz7wi9yKjvvAr/8LaBlOopgdebb+gqKg8YKlUD54Bbpe
	 JGgSRGmQhYzs0ThnRCBB7Fb1b7HxcswsVkIuRrbzXLySgIlOexW7vhS0nu24IYl/JM8Rq
	 TA7fdPuSUtjNEyqiOqb0TFqT0TKrdFHiXlYbT6ufrsnykUMxfOB1GbrvpJo+LsUVHBF7K
	 LtRSmqtuh8o4p+msmaH7VGJc9kO55hvd87s3ioPP0seQIOX9+xRrWmbqmPmNczVgcV7TY
	 d3q9qP2y4x7tgMn3N1i04n+cXXKnBYOR4Av8scGBR1WZ0bAAE1ne3ytiAqQOqdnjcvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829097;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VGs4GJesa7/RzgjLGcgx1jHzOP7FwscwcKU0vhAiHjI=;
	b=DKdnWBcq3mE4dNMG26x3rEankdoSsxSiUztOtDx6XjBArY3WvJPcArRab5K0GBcypQYN
	 ZGe2LTLcz3ioo7MTH/5LXKHfgAyfdJ7WBnh7D0TlTA4YZU7PlwqenCsC776gxuRZyHbPj
	 6fb6F0jnbcCxuw6vfBXT2r50zzDhi62vyx6U9EMWbbl07nakWUPwo6VEQiLEDRETM07zu
	 PIX5lr2FkpdjnW++cq43h6ihGlHVi218FNA62wRh61CW9jGuNmy06vshIi6CeG+J9l9zS
	 u23G9ieQKbiPl6RhgM5PlW85oeJMoEMsgdRjVGnAqITxciEQG0X1k2VUE32T+PcWHyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HAMTmomZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA63F6072FB9;
	Wed,  4 Nov 2026 21:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HAMTmomZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3824F1F00A17;
	Wed,  4 Nov 2026 21:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829096;
	bh=VGs4GJesa7/RzgjLGcgx1jHzOP7FwscwcKU0vhAiHjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HAMTmomZ9ZnqX5fk3YkHqeaUpG+fJl/9IEbh7C3dk0GB7VtbU8dTSTerGEJ83EIQr
	 GLm7lSyY/mwnO0TDqNKNURDsI3dRqVCNDWXY+E7Oy8mnu42KbRrez9ZrkxftoNiI54
	 AGxS4JKACER0PzyS0ph1u1G75QDjQv20UD/d3PtE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ameer Hamza <ameer.hamza@truenas.com>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 7.3 444/547] sunrpc: treat empty auth.unix.gid replies as negative entries
Date: Wed,  4 Nov 2026 16:10:28 -0500
Message-ID: <20261104211050.966752044@linuxfoundation.org>
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
@@ -540,6 +540,13 @@ static int unix_gid_parse(struct cache_d
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


