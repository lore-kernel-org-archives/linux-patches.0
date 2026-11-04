Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831641;
	b=VZHR8jnnqNuuKK2gxb0x1bFdVvmpPxAibMJFj8VmlvFJwa+Ac0SLujMGhfOvv+EmOra5
	 PF28xxZ7CIBTaxeoZ/2pJ7JxItQom6czlm8VB46B6yAqVWeDzphh7Q3NxxkxWfvG1NzQo
	 gPm5kRglpg0sABP8jnbxhcT+00tE2YeNJYA0baDi5a7vpCMuqGdYbCqGgz05n2zS6bbZu
	 Df2eTSRqhVjUWzLrK8vUpGYNdCsIwi69TjHqMokD5XdqQCeuKSPk6mxCE00nAbiq+1mPu
	 Fr8FGC26pMa+DVLnYLX3dTnVpdX1seDZ5gUM8yncT4BNt8lGr0ecTstSt4ekeUqSfuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831641;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5o+mlH/XUqni6u61uR8rIR6RMPCPjBZYw87kIf/n9gA=;
	b=iNRRx7qloR+Qq3xZmDY3k0mYSuCRs/4wUHmkoREHyokT2bSxYs8hL2GObMsDXpzItJ8g
	 I77pnnfirJrgC6xY3iqEGerZj/XNiI1AoADDqUE9ZaZ98I4qIVU/Jki1Fi739k4BqakQV
	 q6H3TQbC/tzbu9TtM046AoAxDwmAI1sEg84rIArfuIJ6+i40+POmXVB1DdW+nXS8rxAgT
	 ai1GrSJQ1ttjWIQMnOA0I1OxCdth09XovK8GvojX9iIJbsHIRsUK5zNvxYiuMZlRw3AgM
	 rq3S1vGbBXOOmaR5kPZSnKJW0OUcdTn4rE73j3vy5/FmsyN+G5AJ9uk6dBoVL99q8sw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hkRuTevI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80E50606B2C6;
	Wed,  4 Nov 2026 22:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hkRuTevI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E8101F000C1;
	Wed,  4 Nov 2026 22:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831641;
	bh=5o+mlH/XUqni6u61uR8rIR6RMPCPjBZYw87kIf/n9gA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hkRuTevIML6z7+nYE78QdfFceRzhDMdN6hGpIBlm7VnFJQO2RGZmqbGxbtfJKDKk2
	 nrZiSe6roFIO7l8GTbDHjGdqX8t9Wc95uGQLh0WXwm7QqTmNHP9NPJkn49iU3NEd+O
	 eQHflQDcJQscOxGmF69IVQWFnoBYdbaIcfP3stoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 0827/1005] xfs: reduce new btree slack factor if free space is negative
Date: Wed,  4 Nov 2026 16:09:20 -0500
Message-ID: <20261104211106.499219841@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

commit 80f13dc7225eec318da7499c7a562d7a34d25e6a upstream.

LOLLM points out that if the incore fdblocks counter is negative, the
assignment to uint64_t will mask this possibly low space situation and
we don't pack the btree blocks as tightly as we probably ought to.  If
it's the case that there's some free space and fdblocks is too low due
to an error in the superblock field, then we can end up failing btree
rebuilds due to ENOSPC unnecessarily.  This is a corner case, but let's
fix it anyway.

Cc: stable@vger.kernel.org # v6.8
Fixes: be408417630427 ("xfs: implement block reservation accounting for btrees we're staging")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/newbt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/scrub/newbt.c
+++ b/fs/xfs/scrub/newbt.c
@@ -71,7 +71,7 @@ xrep_newbt_estimate_slack(
 		free = sc->sa.pag->pagf_freeblks;
 		sz = xfs_ag_block_count(sc->mp, pag_agno(sc->sa.pag));
 	} else {
-		free = xfs_sum_freecounter_raw(sc->mp, XC_FREE_BLOCKS);
+		free = xfs_sum_freecounter(sc->mp, XC_FREE_BLOCKS);
 		sz = sc->mp->m_sb.sb_dblocks;
 	}
 


