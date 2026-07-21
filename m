Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B03873E5A03;
	Tue, 21 Jul 2026 22:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672614; cv=none; b=ByicyKd4J/4/J06V/oyaORpEEDy4NTOEScAqxu8MYIlzPT9eRRGp5mw6zIqe6vB59kvAbjGPgEffO+Jgij/8NmdjsMn6By0F0HGagqFqpDQZiZ42GTnJkY0vFBQJO5RqG8/cw1ldN32hblg3ypyA9PB/yyuBJ40pk3SoIjlvaCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672614; c=relaxed/simple;
	bh=synmGRgk+zuMKy9growh306Wa2aH8fAtZymyZ958c6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d1u6d4j+3VE75OIQbLK1Lxcw851goyP3LgXnPot//iq8Ug07lK9SRUPyYa97py/eoSv+cMJTdVV30bKf+NWsfFznJ0+r50wJeub5XqTTW1LClY3TYM0jBBEE56URA3xuwA8XxqTvfrON82nnggKxjNPJZAppgQBGt1xAL4Qh05o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zcto1Xhu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zcto1Xhu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 082E31F000E9;
	Tue, 21 Jul 2026 22:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672613;
	bh=FgTAw7cphx/RR6wfMnzG9kLyxc4pJMjbdCI5FHizkHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zcto1Xhu9lZfE3yvDoSu5RLo5IkgyL14j4h73hskISfekvPvrD04PDTrt9ULrCVR2
	 2pomPUQwMI79ZFSerdheNWAqspsQhHpi0LE9+JJe1JG+rcDbtdHGsWqNdiYAC6O2m0
	 TYpRuwhNuigyQj6/U4Wn65EdRV/xf9zbe1J5PLcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 692/843] bnx2x: fix potential memory leak in bnx2x_alloc_mem_bp()
Date: Tue, 21 Jul 2026 17:25:27 +0200
Message-ID: <20260721152421.620832908@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

commit a986fde914d88af47eb78fd29c5d1af7952c3500 upstream.

If the allocation of fp[i].tpa_info fails, the error path will not free
the struct bnx2x_fastpath allocated earlier, as it is not linked to the
bp structure yet. Fix that by linking it immediately after allocation.

Cc: stable@vger.kernel.org
Fixes: 15192a8cf8a8 ("bnx2x: Split the FP structure")
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260620062402.89549-1-nihaal@cse.iitm.ac.in
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -4740,6 +4740,7 @@ int bnx2x_alloc_mem_bp(struct bnx2x *bp)
 	fp = kcalloc(bp->fp_array_size, sizeof(*fp), GFP_KERNEL);
 	if (!fp)
 		goto alloc_err;
+	bp->fp = fp;
 	for (i = 0; i < bp->fp_array_size; i++) {
 		fp[i].tpa_info =
 			kcalloc(ETH_MAX_AGGREGATION_QUEUES_E1H_E2,
@@ -4748,8 +4749,6 @@ int bnx2x_alloc_mem_bp(struct bnx2x *bp)
 			goto alloc_err;
 	}
 
-	bp->fp = fp;
-
 	/* allocate sp objs */
 	bp->sp_objs = kcalloc(bp->fp_array_size, sizeof(struct bnx2x_sp_objs),
 			      GFP_KERNEL);


