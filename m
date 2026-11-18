Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051924;
	b=w4KHwhDNmfjyGLtjHlXMziqtiTbeC8jZBSgVakyCmuI6D/Vf6ARTQ8cKEowZ/N57alx1
	 E1oH2IVPlo5eqGNrZu9tdPqhAkB7/c1sP1Anz4FkbPbkrt20ko3BPcu3T6bTL2yaWaGbA
	 7BHThru5OMsxYIyYp66MHsTGk1aDJRH4nCGCXmG2N2WM7L2BPkElJc7YVPdrcOIRXfJy8
	 wCg+BlIYmfVF8P/zih3frWPCeGeQCT9PS8a7sly9bddfuBqnF6ivubusTxebCZm7/FYZ8
	 WYQgpy39YmbJri3R9wecNTyibo8WUSQK1gPh57M6zv7RedCCPqKGRWL1fsehn/Mfz2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051924;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kAA0CXSgMMIjN9KlRLD5gZl0pY5xErj81alaJ0B2bI0=;
	b=RQfCEO679yuXggfd3PmHoNZLGSL7deXc5Jl0bJ2611awFAihspB3UnYb0zRa2Qx9EWGq
	 x40wgpgB+4O4dQOPIVY9HIyTYoqbPUMMI1LKqUQATJLLmwjTHw/bn3/dqzD5jqWUoaGW0
	 0GO9ekZxWAwsvaMFoFM/LyHPOvGjpbWvoKPER7JcYAEZKb9g6amPl8LcRnarqotFQxzAS
	 BbqCXD3uLT61+275yg54fI57Wr7seW5vuF/Na3VUS6tSC4xrz+fM2tsfcr3BwWK2QgB6o
	 RvaeZUBMjGzK/Wmz5RVlU7C9QsimNhU3jdjPIFEZmIR/0yVL43+YQUp1MD4hwwUdvfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EqGSlYch;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75AC3606A33A;
	Thu, 19 Nov 2026 01:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EqGSlYch
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCD2B1F000C4;
	Thu, 19 Nov 2026 01:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051924;
	bh=kAA0CXSgMMIjN9KlRLD5gZl0pY5xErj81alaJ0B2bI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EqGSlYchAO6NLjyr6mtPhw+cLJ0LpyhbJ5muHL4oHLwiIjoc+B/lM0niZ5PJJ2WNy
	 goe5coKaGGjirPzO6mqi6GXTfBqMvOV1K/cP9mVSxvbvb9GwaTXP24/86dE5bxUIRk
	 S/gDF+58+sQy5Bk/3ReTrovBTNWFK29X8NQFeA2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ameer Hamza <ameer.hamza@truenas.com>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 5.15 0364/2214] sunrpc: treat empty auth.unix.gid replies as negative entries
Date: Wed, 18 Nov 2026 15:34:00 +0100
Message-ID: <20261118150025.230086313@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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
@@ -535,6 +535,13 @@ static int unix_gid_parse(struct cache_d
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


