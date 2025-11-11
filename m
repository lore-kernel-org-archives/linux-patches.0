Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E36A530E83E;
	Tue, 11 Nov 2025 01:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825017; cv=none; b=oMQRWYLRk/XQOUqvsiCmoT5uF6eDp7aB8X2uFsY6nV0bX/oeX2ODlLPm64qX/TWgBxwHgvMom8vodb4l1XThczlG74vAxMit6oRKJoHGCatACpuikSjuRlymKM42M2Qx/+jNeNbxKxanRaiV7Wif5tsgeSK9e/mV1GS90YXmfL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825017; c=relaxed/simple;
	bh=0exUASACt2oCGPKlY9oYGHJwAd5xHVxNfy/WquM4zt8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uBOt+BbBPzRr2QSCYPNoWG2hLXFInXtXX8Pdi/C4rJf3+FAjt+HOUwLZWQ7zdKQYvmwFM9rRqmCZ1T4HlwksttOFvRl9JGJaLKybDXJNvpT950b+r0JDik3uLrRT/vBLyx45Ixf+GLAFFt1aPZqukZrXL52DKGgDUQO+PIq5OzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rrutIoPT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rrutIoPT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80381C113D0;
	Tue, 11 Nov 2025 01:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825016;
	bh=0exUASACt2oCGPKlY9oYGHJwAd5xHVxNfy/WquM4zt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rrutIoPT4cUVWK3og2zw/Bd1a+3UAGZCgwTNEOFJAfs0EpZqMIwyBVswNWY15VY9K
	 lTHpbEIJxOiRzYOwCuC2bgW0xabgrKMJ8CKY7w6i8t7nLd59MZI6x1jvgXd5IxBjVM
	 PSdK3V1r8PrVepLTObFkWSsHtkhvbNIhoY7vwt+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bhargava Marreddy <bhargava.marreddy@broadcom.com>,
	Vikas Gupta <vikas.gupta@broadcom.com>,
	Rajashekar Hudumula <rajashekar.hudumula@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 618/849] bng_en: make bnge_alloc_ring() self-unwind on failure
Date: Tue, 11 Nov 2025 09:43:08 +0900
Message-ID: <20251111004551.373230301@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bhargava Marreddy <bhargava.marreddy@broadcom.com>

[ Upstream commit 9ee5994418bb527788e77361d338af40a126aa21 ]

Ensure bnge_alloc_ring() frees any intermediate allocations
when it fails. This enables later patches to rely on this
self-unwinding behavior.

Signed-off-by: Bhargava Marreddy <bhargava.marreddy@broadcom.com>
Reviewed-by: Vikas Gupta <vikas.gupta@broadcom.com>
Reviewed-by: Rajashekar Hudumula <rajashekar.hudumula@broadcom.com>
Link: https://patch.msgid.link/20250919174742.24969-2-bhargava.marreddy@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnge/bnge_rmem.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnge/bnge_rmem.c b/drivers/net/ethernet/broadcom/bnge/bnge_rmem.c
index 52ada65943a02..98b4e9f55bcbb 100644
--- a/drivers/net/ethernet/broadcom/bnge/bnge_rmem.c
+++ b/drivers/net/ethernet/broadcom/bnge/bnge_rmem.c
@@ -95,7 +95,7 @@ int bnge_alloc_ring(struct bnge_dev *bd, struct bnge_ring_mem_info *rmem)
 						     &rmem->dma_arr[i],
 						     GFP_KERNEL);
 		if (!rmem->pg_arr[i])
-			return -ENOMEM;
+			goto err_free_ring;
 
 		if (rmem->ctx_mem)
 			bnge_init_ctx_mem(rmem->ctx_mem, rmem->pg_arr[i],
@@ -116,10 +116,13 @@ int bnge_alloc_ring(struct bnge_dev *bd, struct bnge_ring_mem_info *rmem)
 	if (rmem->vmem_size) {
 		*rmem->vmem = vzalloc(rmem->vmem_size);
 		if (!(*rmem->vmem))
-			return -ENOMEM;
+			goto err_free_ring;
 	}
-
 	return 0;
+
+err_free_ring:
+	bnge_free_ring(bd, rmem);
+	return -ENOMEM;
 }
 
 static int bnge_alloc_ctx_one_lvl(struct bnge_dev *bd,
-- 
2.51.0



