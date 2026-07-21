Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF8B83B8BA4;
	Tue, 21 Jul 2026 20:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667544; cv=none; b=CmYLEuvTHJSqF5RO015QPcg7j/t9SI/rUQ+SJOonY0e00D1NdoWumAN5fed86N1L1YNqVKOhzSLtaSfmC/bnffSOez2agpo619JCkrBc8mRCI8WWxdhjLz3VkoMzdvwT074xZLxSJKsQdEq4Iar/QF6i+0fIN5X2pNX7Ie0mVwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667544; c=relaxed/simple;
	bh=Z2siLCnShAIfi9UmW2S+wPgMsxzUn5qAviKC1VWWeis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dlrEGJxwpeJcmAXenwBOLi95iUxwnIuXEaWaLewzwTLrr5tHbPsm69jzNHUIHcEMi7B94OIjQMOe3nJ3WIFkTC9eSyJ7YJvXD7vgi2S+N43okKlDi8na+BwITUlek2l+RT71OaqSMVUoT1SkRVAjzpQqwHD/fOeNb09SKw7PFl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LQUsEu5M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LQUsEu5M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 300351F00A3A;
	Tue, 21 Jul 2026 20:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667543;
	bh=lzCt+II6el5D5GZ/8l7t9cvs2WB3k6MJZ3dIQGpdT6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LQUsEu5MLQ2b3dLBBj7TdrED7ibtJarbKYd2Fn2jWUZXRIc3ZIIPUhMr6DC9GzwBw
	 GkvuMKfReMW1q/hZBvQ2YI/YuLhaDmK4P+d1ny617JXE1a72EPz3xsdE29RlFFl4HT
	 kXJklV7EkkUrd49qdb200bcvXNlMt11Yb4hDi6qo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 1099/1266] bnx2x: fix potential memory leak in bnx2x_alloc_mem_bp()
Date: Tue, 21 Jul 2026 17:25:36 +0200
Message-ID: <20260721152506.394445785@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4752,6 +4752,7 @@ int bnx2x_alloc_mem_bp(struct bnx2x *bp)
 	fp = kcalloc(bp->fp_array_size, sizeof(*fp), GFP_KERNEL);
 	if (!fp)
 		goto alloc_err;
+	bp->fp = fp;
 	for (i = 0; i < bp->fp_array_size; i++) {
 		fp[i].tpa_info =
 			kcalloc(ETH_MAX_AGGREGATION_QUEUES_E1H_E2,
@@ -4760,8 +4761,6 @@ int bnx2x_alloc_mem_bp(struct bnx2x *bp)
 			goto alloc_err;
 	}
 
-	bp->fp = fp;
-
 	/* allocate sp objs */
 	bp->sp_objs = kcalloc(bp->fp_array_size, sizeof(struct bnx2x_sp_objs),
 			      GFP_KERNEL);


