Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051811;
	b=fdLmgekxQi6JnvtXb30dAkE3cfUKKIr0ue+J+IncRKAM2PJVUbiW9ElKjzOKQmw0mca9
	 Xhtjd5I8kdo9e54axfULsJnR2hOvU8UZfaGDk9LCYJfR3PxInuduUSammSV+PraaczXma
	 d6wbJ6KcSdbhS8Pted3pbxY2T0i6Kkz2VD0Yr/OkkKaDABXwUkm2pnsRynyY6H1DfnUiQ
	 1uoHArW78aexxsWooQzDoEfNz0vzagpGohAmAqOOyCrvD5QNf0PZodb+Du86Tl4y2kpJ/
	 28pnNjAD2bp+P1zlZjeewkLpgUDebDzaJ+44HN1O4TNVnpBx6LqLj0IDxkP+lA03fWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051811;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SW8helSRx8T9HX9f10j6gVtVAq4MIu9fTeYtqxYbnDk=;
	b=P9y032OfF5PNWIXItGa1ZpkWX+kuR7CCiwBJC1hotXZ9VixonruRF8nJXopehIubpigQ
	 yX8UJPi/HJHH0ZU/ZuWSrQvRMPC1w3haBq0/5k9C9IfqQtqhlhNrI5Cc7oNJDUG9ff2n0
	 ldm65/VMaJkXWRO5D0qPYXAt996AqLLyDqZvl5Jc4N/U1dNqEcHEctxdDuXGzqh6BlwSe
	 p5pLQcstmTBXzAbtSaLdQpF6mlrchlOHczEVwnbiH5yuOq5bQOgv/BG7xyd76uLfb7z/e
	 AjkNfL7hNyh6MFGb/NDSHkksQYqTHPBW940jJ6Dz+r/jG1Ozn+FpKdlnbPr0l/lG0yw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LY3Klijp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C59606A31C;
	Thu, 19 Nov 2026 01:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LY3Klijp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD10F1F000C4;
	Thu, 19 Nov 2026 01:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051811;
	bh=SW8helSRx8T9HX9f10j6gVtVAq4MIu9fTeYtqxYbnDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LY3KlijpGZMZAyO1YrEC2/3EOzouzxuGAas+4onsp8yHuXMc1ctOfOAj2fjmDOsUg
	 nXP+IA40UU77IGW/El1VXoQ2kMO50l8hN5bDKzJzIx6DbONjEXJieXEb/tmOrW3kq1
	 hTu/djayTC7vsxPZmfb/otCNoG9qVJCAhNLqhqNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 5.15 0340/2214] xfs: opportunistically skip btree block checks
Date: Wed, 18 Nov 2026 15:33:36 +0100
Message-ID: <20261118150024.225607184@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

commit 4ce244b234c251963fca6dff9de6edf26a209d08 upstream.

LOLLM notices that both callers of xchk_btree_get_block will return
early if *pblock is NULL after a successful return.  However,
xchk_btree_get_block itself can return 0 after flagging a corruption.
There's no point in continuing after we've found a corruption, so null
the pointer out.

Cc: stable@vger.kernel.org # v4.15
Fixes: cc3e0948d2686f ("xfs: scrub the shape of a metadata btree")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/btree.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -550,6 +550,14 @@ xchk_btree_get_block(
 				 level, *pbp);
 	if (failed_at) {
 		xchk_btree_set_corrupt(bs->sc, bs->cur, level);
+		/*
+		 * The btree block fails basic checks, so we know it's corrupt.
+		 * There's no need to continue looking for corruptions, so we
+		 * null out pblock.  If *pbp is non-null then it's also
+		 * attached to the transaction so we won't leak it despite the
+		 * 0 return code.
+		 */
+		*pblock = NULL;
 		return 0;
 	}
 	if (*pbp)


