Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DE14357D10;
	Sat, 12 Sep 2026 18:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238958; cv=none; b=vDx0QSAVSNmGkUx4kf7rJGOjMZjtSj+qibAknFRF1Kn9JleGjJbE8iThArRPJMCvu5JDu6mNQg2eNxsxWgODnC2dROsFFb+P3gqRl88zrI0L7YuJnnuNP/aMjq+HZMOVxTN/PsiHWOpVcnUlzrRy7k34a5y6EjyHL2PFrl6nkDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238958; c=relaxed/simple;
	bh=zDKj4NqhQ8bV30V5A1gkLCiLG0H4iVRvCh4DRYQYUa8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KrUqqh2bksTS3pl3mM2l98Ho3tCJICgumI20th3yluViKj1RxWE5LGR1DoQQUXpLkeUsdBvQTU8GSV5jQVi5ElI0I+JSGmAFHfxgd6V23KZtBcwajIXZJBL7J4xxzy0qN2NOuQfoEidVNU+kE/PCeaPXRKaiW1G39cKa1Besxvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TEa06ZqO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TEa06ZqO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F7181F000FF;
	Sat, 12 Sep 2026 18:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238956;
	bh=XLYhbhLWJFgfY8RRabpWBVMnqYmyHcpqObwhQTzIt4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TEa06ZqOVddJ03zv+ZQWEZxMdLv3rxMzDeX4GAJcD1ofIEl4ZzZFrZII+WJ0VJlZp
	 dkMJ61RFYjewnXYuvPdXQ1aaYtYJ9Q6ZOuN0OacihY8+21DGrjoGXfNqzflJgKOqPF
	 9dmZo92aflJmmOPAVcU/33TDWpx2YDzwPWuDMWQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	TanZheng <tanzheng@kylinos.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 566/935] RDMA/srpt: Fix srpt_alloc_rw_ctxs() unwind counters
Date: Sat, 12 Sep 2026 08:59:56 +0200
Message-ID: <20260912065539.818164276@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

From: TanZheng <tanzheng@kylinos.cn>

[ Upstream commit b38f98e176050850f41bb6415f3a71400056623e ]

When srpt_alloc_rw_ctxs() fails partway through a multi-buffer indirect
descriptor, the unwind path destroys RDMA contexts but leaves stale
n_rw_ctx and n_rdma values (and a dangling rw_ctxs pointer). Later
sq_wr_avail accounting in srpt_queue_response() or srpt_write_pending()
can then subtract the wrong number of send queue credits.

Reset the counters and clear rw_ctxs after freeing the heap
allocation before returning an error.

Fixes: b99f8e4d7bcd ("IB/srpt: convert to the generic RDMA READ/WRITE API")
Signed-off-by: TanZheng <tanzheng@kylinos.cn>
Link: https://patch.msgid.link/20260715101550.45345-1-kensanya@163.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 7aaff0f295069..e4113d5b95117 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -900,6 +900,7 @@ static int srpt_alloc_rw_ctxs(struct srpt_send_ioctx *ioctx,
 	struct srpt_rdma_ch *ch = ioctx->ch;
 	struct scatterlist *prev = NULL;
 	unsigned prev_nents;
+	u8 n_rdma, n_rw_ctx;
 	int ret, i;
 
 	if (nbufs == 1) {
@@ -911,6 +912,9 @@ static int srpt_alloc_rw_ctxs(struct srpt_send_ioctx *ioctx,
 			return -ENOMEM;
 	}
 
+	n_rw_ctx = ioctx->n_rw_ctx;
+	n_rdma = ioctx->n_rdma;
+
 	for (i = ioctx->n_rw_ctx; i < nbufs; i++, db++) {
 		struct srpt_rw_ctx *ctx = &ioctx->rw_ctxs[i];
 		u64 remote_addr = be64_to_cpu(db->va);
@@ -957,6 +961,9 @@ static int srpt_alloc_rw_ctxs(struct srpt_send_ioctx *ioctx,
 	}
 	if (ioctx->rw_ctxs != &ioctx->s_rw_ctx)
 		kfree(ioctx->rw_ctxs);
+	ioctx->rw_ctxs = NULL;
+	ioctx->n_rw_ctx = n_rw_ctx;
+	ioctx->n_rdma = n_rdma;
 	return ret;
 }
 
-- 
2.53.0



