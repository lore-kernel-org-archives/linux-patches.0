Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A91BA12EBEA;
	Tue, 25 Jun 2024 09:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308656; cv=none; b=Zi8Q091KwkTEjzYcudNKO0nSKJIm+pfWdybCJpvYAafCDxOkAjErhVwJix8nF3n1Pz5bwwTqxBl8Mbv4XBfp5E3QUKHjAeM9SEybWxQYYOdAuAqUAHyMfmNY/bOuDqaD/GD6TYscUF8PQMBF5IrNE23xw6mE6oiwCW/dIg0unLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308656; c=relaxed/simple;
	bh=yTDcSwPt57i3EWBIFK7lLXD+0yRLePm7L0nTwiUdUTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qnUPqkprb0dV9tamKM+P8y3yrIwVHCWU5ETmP4fDuB5D7AyYZiVt5rrzz4qtkG8a8B96OCoc3jVVD5nGmNiFVncmEI/apeEyLjN8v5nY4nyHZcgnLFlIbE85r0I/2EbhfP3ufiLNRhnWYY9hw6GEE7w7aqwwcVPbBNiUUGsP24w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cqe/78Qt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cqe/78Qt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27908C32781;
	Tue, 25 Jun 2024 09:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308656;
	bh=yTDcSwPt57i3EWBIFK7lLXD+0yRLePm7L0nTwiUdUTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cqe/78QtyWJwTka1bSznLLigA6NEB4JTvNNUvDCyW1n0S7JjzoE4UWq9v689e+7eK
	 titfmIvpCJ1vcjCrrTJ6eThwJCj94WD68jryCGNp62g0xbkrs3VnvE16AW1aBPej/5
	 hhOMLSYy86pApIC+T+AgTVCh5WlpBu+9EAxJxYPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Honggang LI <honggangli@163.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Li Zhijian <lizhijian@fujitsu.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>
Subject: [PATCH 6.9 194/250] RDMA/rxe: Fix data copy for IB_SEND_INLINE
Date: Tue, 25 Jun 2024 11:32:32 +0200
Message-ID: <20240625085555.496862687@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Honggang LI <honggangli@163.com>

commit 03fa18a992d5626fd7bf3557a52e826bf8b326b3 upstream.

For RDMA Send and Write with IB_SEND_INLINE, the memory buffers
specified in sge list will be placed inline in the Send Request.

The data should be copied by CPU from the virtual addresses of
corresponding sge list DMA addresses.

Cc: stable@kernel.org
Fixes: 8d7c7c0eeb74 ("RDMA: Add ib_virt_dma_to_page()")
Signed-off-by: Honggang LI <honggangli@163.com>
Link: https://lore.kernel.org/r/20240516095052.542767-1-honggangli@163.com
Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Reviewed-by: Li Zhijian <lizhijian@fujitsu.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/sw/rxe/rxe_verbs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/infiniband/sw/rxe/rxe_verbs.c
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
@@ -812,7 +812,7 @@ static void copy_inline_data_to_wqe(stru
 	int i;
 
 	for (i = 0; i < ibwr->num_sge; i++, sge++) {
-		memcpy(p, ib_virt_dma_to_page(sge->addr), sge->length);
+		memcpy(p, ib_virt_dma_to_ptr(sge->addr), sge->length);
 		p += sge->length;
 	}
 }


