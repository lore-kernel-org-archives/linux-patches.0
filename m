Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D6AD318EDA;
	Tue, 16 Jun 2026 19:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781636894; cv=none; b=ty9a6kQ1PuBnJDGAcxazQKJtc5ORT5GU5aWfjjreq9olLvldG7RRj9xrW3XfYVTo4qgMlzt/AbbgwpsZWXyky7lRWTLhUZzSoQZkAErKB/wZY31/V07FB4SVAjlQLnYmE3L1yJX1GtMbkBHFhKpxkS0UdN+YD7162f6Z7Guf6lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781636894; c=relaxed/simple;
	bh=oLcRNquS+Wri+/OIfmStO3J+q1guO8pdlPPQuHA7xac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T/72nbnfHW8OEBDThohTBAg4hfPw2S6vfn3OagwkHRVroF76aKXb2RMV0ZAmQcOwOTbohc+BwR5B6A6PkLrbnM/peAk2+faIEdFxxLK5L2COxiW0eplBfXs5yMuZPAQYADWGDKmtfoQvg2hH55AACuDNCLtdh0565JITAyNK9Bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pj/Sg8Xb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pj/Sg8Xb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 506591F000E9;
	Tue, 16 Jun 2026 19:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781636893;
	bh=jjwRVRigoKncI2kzPkuZxZVK/xaUe7EJB2g0nfo8xVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pj/Sg8XbsywadMGsGbB1TSY/WkjN/rSI31NJbqvtDR3juYmOCEfDY5j+2p7j2NdfV
	 qc1RglGCvKU2Rct9KFpCbJpMvFSUj7vsJzfYQKJyceR2c5Hz3te+ZMFOnuy/TF6EFU
	 pNcgNPoIMEufMztkFe/lUKqVMPbAl+nyZpH3UegA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Dawei Feng <dawei.feng@seu.edu.cn>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 292/342] octeontx2-pf: avoid double free of pool->stack on AQ init failure
Date: Tue, 16 Jun 2026 20:29:48 +0530
Message-ID: <20260616145102.021485958@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dawei Feng <dawei.feng@seu.edu.cn>

[ Upstream commit 9b244c242bec48b37e82b89787afd6a4c43457e1 ]

otx2_pool_aq_init() frees pool->stack when mailbox sync or retry
allocation fails, but leaves the pointer unchanged. Later,
otx2_sq_aura_pool_init() unwinds the partial setup through
otx2_aura_pool_free(), which frees pool->stack again. The CN20K-specific
cn20k_pool_aq_init() implementation has the same bug in
its corresponding error path.

Set pool->stack to NULL immediately after the local free so the shared
cleanup path does not free the same stack again while cleaning up
partially initialized pool state.

The bug was first flagged by an experimental analysis tool we are
developing for kernel memory-management bugs while analyzing
v6.13-rc1. The tool is still under development and is not yet publicly
available. Manual inspection confirms that the bug is still present in
v7.1-rc3.

Runtime validation was not performed because reproducing this path
requires OcteonTX2/CN20K hardware.

Fixes: caa2da34fd25 ("octeontx2-pf: Initialize and config queues")
Fixes: d322fbd17203 ("octeontx2-pf: Initialize cn20k specific aura and pool contexts")
Cc: stable@vger.kernel.org
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Signed-off-by: Dawei Feng <dawei.feng@seu.edu.cn>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260515151826.1005397-1-dawei.feng@seu.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -1194,11 +1194,13 @@ static int otx2_pool_init(struct otx2_ni
 		err = otx2_sync_mbox_msg(&pfvf->mbox);
 		if (err) {
 			qmem_free(pfvf->dev, pool->stack);
+			pool->stack = NULL;
 			return err;
 		}
 		aq = otx2_mbox_alloc_msg_npa_aq_enq(&pfvf->mbox);
 		if (!aq) {
 			qmem_free(pfvf->dev, pool->stack);
+			pool->stack = NULL;
 			return -ENOMEM;
 		}
 	}


