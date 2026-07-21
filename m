Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CB3946D08F;
	Tue, 21 Jul 2026 17:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655183; cv=none; b=N764JkZ4daYQ+rDpxFUCCagQBXLbk6/+B8CajegyXdahXmnJDr/9QLjCej91slae4lr1snx/4hCZeMTGSL1Nn0iu11vBQ8lzlTknhvRwX+MbmH+D9oQ6KpIvONouoM2XQQpZqed125NkclFqFkx/YmwZclDsT42LCsy6nD3Ilbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655183; c=relaxed/simple;
	bh=mqgccIXq1oXNnDW1LPR70ZUsYDJo5GKGVUNMlxElOq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TE2cYTMGAo2Z6eGEwxVczruG2c/H6it/Fm+RUzoPX2FWRhZZRQ6H04G02pWUEes6+B1AouYWMyiMG/k12RciSkm4ZNlxTeL6N+zQi396Tcn6Gr02WAWxtALRI1igkxQIsipQ1+zSmYmPhc75O+z8Fq1UsQcjUA9K1sZZ9lD6mO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eLV+NQ7m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eLV+NQ7m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E36231F000E9;
	Tue, 21 Jul 2026 17:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655182;
	bh=V6lWuBvgyUT5LT0dVqCGhQpvH78cd4G0ONzkj6ORXrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eLV+NQ7mmAZkwq48Zs7xSqek7iMR/ClR/Dquh/yIrtFSstBlB6nEXOTSXoRd5K9C0
	 B1BuML94PYbNS/D6wTGxV2YI+sWh+fi9VOJGZGObyZ7SYuF0EBwM+crRus1W+U7afR
	 3B53koUpua0FmiExSYEZMCwBzvsIb9bxdb7/ApQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 1943/2077] bnx2x: fix potential memory leak in bnx2x_alloc_mem_bp()
Date: Tue, 21 Jul 2026 17:26:56 +0200
Message-ID: <20260721152638.537090420@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4748,6 +4748,7 @@ int bnx2x_alloc_mem_bp(struct bnx2x *bp)
 	fp = kzalloc_objs(*fp, bp->fp_array_size);
 	if (!fp)
 		goto alloc_err;
+	bp->fp = fp;
 	for (i = 0; i < bp->fp_array_size; i++) {
 		fp[i].tpa_info =
 			kzalloc_objs(struct bnx2x_agg_info,
@@ -4756,8 +4757,6 @@ int bnx2x_alloc_mem_bp(struct bnx2x *bp)
 			goto alloc_err;
 	}
 
-	bp->fp = fp;
-
 	/* allocate sp objs */
 	bp->sp_objs = kzalloc_objs(struct bnx2x_sp_objs, bp->fp_array_size);
 	if (!bp->sp_objs)


