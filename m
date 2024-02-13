Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA3545FEFE;
	Tue, 13 Feb 2024 17:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845367; cv=none; b=jdDl08hbV/S537fVknklrHHS/6vs5BdEIWRzNhaQmjCA4jtBAB/b+WrbvwbYGT5bC8HPtTM5Y5wX9RFL3eFM0QTFDHXw3ssift7zr/TcdvZdNoR6PNGfksohscUTIHUCH4StqD9t/HTrozG1OTRugvSNSe0EzVIj5Im55dfkUh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845367; c=relaxed/simple;
	bh=xRTB0XnJX9dXkAxL9qTnQdnNrEshuaeEeMjuP6YWeZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZfbF8Ia55MFu9SwEjJwX6kUOGvThJX3uRQeTS8XFkhNt8kzHQoExTikNZpeELiL/92WjlmbRvyCHC5tCYSBxbYdiyhWgkf7xTLcYPhpfFAF9R3pkuSqTNm92NiKXabD/Nf1/zLLT+fkVqG0+VfnngrQRz9gUyWO3t80qU73FC5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bFbkjrVZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bFbkjrVZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 942ECC433C7;
	Tue, 13 Feb 2024 17:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845367;
	bh=xRTB0XnJX9dXkAxL9qTnQdnNrEshuaeEeMjuP6YWeZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bFbkjrVZunI3xbdsitRVvTVdYEwCuLp/vdPz0o9LOl3XUXDb3Kpi6OaQaO4j6RhZu
	 papVgGsHW4RSdtx076rJE8pQKpjgxfJIcqsdxLGf0fqXr7h1KZwcGEfN8kBNP8/b8+
	 uLaBR+AjuFP0JLXzfT9GqK7eJdtEgU7FNa1LrSx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhipeng Lu <alexious@zju.edu.cn>,
	Jiri Pirko <jiri@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 059/121] octeontx2-pf: Fix a memleak otx2_sq_init
Date: Tue, 13 Feb 2024 18:21:08 +0100
Message-ID: <20240213171854.717190785@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171852.948844634@linuxfoundation.org>
References: <20240213171852.948844634@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhipeng Lu <alexious@zju.edu.cn>

[ Upstream commit b09b58e31b0f43d76f79b9943da3fb7c2843dcbb ]

When qmem_alloc and pfvf->hw_ops->sq_aq_init fails, sq->sg should be
freed to prevent memleak.

Fixes: c9c12d339d93 ("octeontx2-pf: Add support for PTP clock")
Signed-off-by: Zhipeng Lu <alexious@zju.edu.cn>
Acked-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 629cf1659e5f..e6df4e6a78ab 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -951,8 +951,11 @@ int otx2_sq_init(struct otx2_nic *pfvf, u16 qidx, u16 sqb_aura)
 	if (pfvf->ptp && qidx < pfvf->hw.tx_queues) {
 		err = qmem_alloc(pfvf->dev, &sq->timestamps, qset->sqe_cnt,
 				 sizeof(*sq->timestamps));
-		if (err)
+		if (err) {
+			kfree(sq->sg);
+			sq->sg = NULL;
 			return err;
+		}
 	}
 
 	sq->head = 0;
@@ -968,7 +971,14 @@ int otx2_sq_init(struct otx2_nic *pfvf, u16 qidx, u16 sqb_aura)
 	sq->stats.bytes = 0;
 	sq->stats.pkts = 0;
 
-	return pfvf->hw_ops->sq_aq_init(pfvf, qidx, sqb_aura);
+	err = pfvf->hw_ops->sq_aq_init(pfvf, qidx, sqb_aura);
+	if (err) {
+		kfree(sq->sg);
+		sq->sg = NULL;
+		return err;
+	}
+
+	return 0;
 
 }
 
-- 
2.43.0



