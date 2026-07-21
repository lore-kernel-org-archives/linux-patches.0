Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EA023ACEFE;
	Tue, 21 Jul 2026 21:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670334; cv=none; b=jgg6xCmriHSiEP/J3DrN4HQV0T7XoyvOlvZ9ED8/T/1AC/0ao6ADGUslcnCXi3ZJ6B0j9oJLW2+BVezajWf3LnOU+vwO7I/KvflAaRn3u71382ScElS9GVyBPqVCgKhU95aBE+gK20mRnRU3cqIWZBrC1EjGCeayUEdX6bFIdWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670334; c=relaxed/simple;
	bh=vPq9wXIhLVEloqrNqVVTcjLT0j+ZmjEbMGQOfqsgvgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VF3uXVVFc/Q6iVgj1T6NRnTRYnQdRZZcM8Ph2UuFjut5CG1A1gz2d6VbOliGzXIvGsDWKtoa52e4fT3JpkQACBYhB9SHLJypMaEupv0PPwH91cKxYQxah9ItafIobLCM9DBoC95/Ck668/YIlQ7lbYqNl9J+HeG/cJ4DdFMq3lM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ibUBXx0X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ibUBXx0X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A20DA1F00AC4;
	Tue, 21 Jul 2026 21:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670333;
	bh=GZzGJcW32fTI/45ZJHAWRYpdPddE/UiaUbEXSy3DbJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ibUBXx0XVvV0pT58HI0TE5V1vxL5lkVXRNdWu05zueRnT+G10+lb1BemHDSpwQ+qL
	 qxn5y2qqK0OU47R0u+M4rG0WuUoYFTHncByZ6lMjclkDzJgWtQx4TeKtP9GG48jO6k
	 sh91RcoYasqjlY5XOqvcl22JeQCwOVvfaXRsGrQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 0894/1067] bnx2x: fix potential memory leak in bnx2x_alloc_mem_bp()
Date: Tue, 21 Jul 2026 17:24:55 +0200
Message-ID: <20260721152444.532335277@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4735,6 +4735,7 @@ int bnx2x_alloc_mem_bp(struct bnx2x *bp)
 	fp = kcalloc(bp->fp_array_size, sizeof(*fp), GFP_KERNEL);
 	if (!fp)
 		goto alloc_err;
+	bp->fp = fp;
 	for (i = 0; i < bp->fp_array_size; i++) {
 		fp[i].tpa_info =
 			kcalloc(ETH_MAX_AGGREGATION_QUEUES_E1H_E2,
@@ -4743,8 +4744,6 @@ int bnx2x_alloc_mem_bp(struct bnx2x *bp)
 			goto alloc_err;
 	}
 
-	bp->fp = fp;
-
 	/* allocate sp objs */
 	bp->sp_objs = kcalloc(bp->fp_array_size, sizeof(struct bnx2x_sp_objs),
 			      GFP_KERNEL);


