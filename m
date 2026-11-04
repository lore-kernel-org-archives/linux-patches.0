Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828918;
	b=Xv+9v3wDKCwUFb+r0J3WlzM04cojyTNPMvxmMsd9HYCxnFfhsJyqOG5l3duahkY71wH6
	 HQMWXcQgJJtzg08KJVn2Yryx6uX8uCHIIxdJLhf8xrvWzlPZh10Avp9KgeK04tJb4dGal
	 AR6qrYL8gTxAyva4+IYX9gpzZTCGA79oiujoPWfs8yULQf7fT+WAs30IvYhC5ynxUszTY
	 3fAFAy24ehct66gKsIw/i8Xj3gyjDoNJWqjvhxVtQoHEFFiFj64wsM33RmXlQ+ct4KB+T
	 aFciD0VQVA+nk8R7SH5xVmI7yq3HMhtSIT5EiwiuYD+w74VvFo9Gj68e8mIAJ222aFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828918;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cs6ZjaxNe3RcKfaFTbwB2BG3QURUZia1ppOmANhUrV4=;
	b=0NvMLoY0Jxv/hs2/rerXhD0cL/1Mm3/mY9/TN02X3h3LyMk6oGpuGkYr9mFnG+tjWes4
	 fDW6/iCUzQlZQgkgdr8BnzSR1bStZove9RJXYT94YFGPlhcuAZW3lpokB30W81elpUapi
	 m/cm4MEPAwfIcUk/jI4fu/DrpADByrgSMRYyrZn2CNObQgxUwtHY2ZXQeBr/WJagg4cgA
	 9m7/51gs/Bsjqyly2CBvWERiYaRko+BX8nqaJUbBtQf2xtb+LyBOxwfqbyLlb0/+E3Pdu
	 8NLI0nkSK3GACQyuVxhACHYOm0O+6SeDq2dKIs1qCiYUNPZ0mL8rvtj8VLY3eE2arag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZeiOhzL6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A471607031B;
	Wed,  4 Nov 2026 21:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZeiOhzL6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C6321F00A02;
	Wed,  4 Nov 2026 21:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828917;
	bh=cs6ZjaxNe3RcKfaFTbwB2BG3QURUZia1ppOmANhUrV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZeiOhzL60bzRoTmCeLA82wc8Bclkfdpo9sXsFMU976qdGc0pM1K4JgJS/hRU+GM6r
	 BK2jGCiUX7Fh6akrpCMaqBZ0bnQP9HKjM6SmnFswVeI6lUIyX29jHMNGZbNzou2DQO
	 JqgLPXmBctO10+CoZvZ4zVoJwPHOXjD6lZX46roc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.3 325/547] xfs: fix revalidation of xchk_dquot_iter cached mappings
Date: Wed,  4 Nov 2026 16:08:29 -0500
Message-ID: <20261104211047.456801461@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

commit 6c64d650460b455980a6023d43bc6c8859c1cfd2 upstream.

LOLLM noticed that the purpose of xchk_dquot_iter_revalidate_bmap is to
revalidate the quota file mapping after we've (presumably) done
something to the quota file contents.  However, the "yes this is valid"
code isn't quite strong enough -- the mapping must cover at least the
block at fileoff, not just end after fileoff.  Fix that.

Cc: stable@vger.kernel.org # v6.8
Fixes: 21d7500929c8a0 ("xfs: improve dquot iteration for scrub")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/dqiterate.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/xfs/scrub/dqiterate.c
+++ b/fs/xfs/scrub/dqiterate.c
@@ -58,6 +58,7 @@ xchk_dquot_iter_revalidate_bmap(
 	 * no need to reread the bmbt.
 	 */
 	if (cursor->bmap.br_startoff != NULLFILEOFF &&
+	    cursor->bmap.br_startoff <= fileoff &&
 	    cursor->if_seq == ifp->if_seq &&
 	    cursor->bmap.br_startoff + cursor->bmap.br_blockcount > fileoff)
 		return 0;


