Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CB6746D0A8;
	Tue, 21 Jul 2026 18:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657943; cv=none; b=GoHxDdvPe9EoM2OQM4X/LBfc5GbvsJORplV2rnn36WOw3QGel0VESxD1lped0aLzh9e0z+4xHXI9ERQZ3pH9irS6nYmVGDXQ4Xv2+gk8sU4iSHw531bDr/dy2NjxjwCy26O6w7nG9+1iw7wXlKy8lvy+ijBgPMcsscSxsS+WDRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657943; c=relaxed/simple;
	bh=WJMW3HHsSrIjNXDjLlJD5HVlzu43avEhaBSsq4EVZH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uMzR0HWXsjIeRaVqg2sWC2RYDr51nz20TE2xoiIq9fQgSzzw0wEYYPHZ14jamHtTzAr8ISEajlTwS/rSDyZJRDZjWPKC88o4ABXlFHdVhPXfxkzx4eUZMWJhxWubSnvKBihPY4UsaZoc+MmmYx+d1uLU5zGdh0bUyEe6yHvV1js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SaOVAK/X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SaOVAK/X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71D461F00ADE;
	Tue, 21 Jul 2026 18:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657941;
	bh=33vZmtozcyiRFk1ZR0q5POwg4JGCeaF8uOmCsOmAhRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SaOVAK/XcScmFSzeKSOkFymAmIVv+XDSq7NvNRq/uW75944fAnF5iisaSSFawEmwx
	 /eT38s8x0jxc+w6aw0r6ZvlqvZ1Hcf+ohjClNKLw9KfSDknfx4cuzsdYS8iNgwRXeH
	 4morqCSNSl37f7Iq+Ld0K0DDHPdwVlTqr6G14DhY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matvey Kovalev <matvey.kovalev@ispras.ru>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0956/1611] qede: fix out-of-bounds check for cqe->len_list[]
Date: Tue, 21 Jul 2026 17:17:52 +0200
Message-ID: <20260721152536.895590614@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matvey Kovalev <matvey.kovalev@ispras.ru>

[ Upstream commit f9ba47fce5932c15891c89c60e76dfaca919cb8d ]

Move index check before element access.

Fixes: 896f1a2493b5 ("net: qlogic/qede: fix potential out-of-bounds read in qede_tpa_cont() and qede_tpa_end()")
Signed-off-by: Matvey Kovalev <matvey.kovalev@ispras.ru>
Link: https://patch.msgid.link/20260623144602.3521-1-matvey.kovalev@ispras.ru
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qede/qede_fp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede_fp.c b/drivers/net/ethernet/qlogic/qede/qede_fp.c
index e338bfc8b7b2f2..33e18bb6977401 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_fp.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_fp.c
@@ -961,7 +961,7 @@ static inline void qede_tpa_cont(struct qede_dev *edev,
 {
 	int i;
 
-	for (i = 0; cqe->len_list[i] && i < ARRAY_SIZE(cqe->len_list); i++)
+	for (i = 0; i < ARRAY_SIZE(cqe->len_list) && cqe->len_list[i]; i++)
 		qede_fill_frag_skb(edev, rxq, cqe->tpa_agg_index,
 				   le16_to_cpu(cqe->len_list[i]));
 
@@ -986,7 +986,7 @@ static int qede_tpa_end(struct qede_dev *edev,
 		dma_unmap_page(rxq->dev, tpa_info->buffer.mapping,
 			       PAGE_SIZE, rxq->data_direction);
 
-	for (i = 0; cqe->len_list[i] && i < ARRAY_SIZE(cqe->len_list); i++)
+	for (i = 0; i < ARRAY_SIZE(cqe->len_list) && cqe->len_list[i]; i++)
 		qede_fill_frag_skb(edev, rxq, cqe->tpa_agg_index,
 				   le16_to_cpu(cqe->len_list[i]));
 	if (unlikely(i > 1))
-- 
2.53.0



