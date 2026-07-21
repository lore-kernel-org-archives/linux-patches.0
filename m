Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBD553B0AC6;
	Tue, 21 Jul 2026 20:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666759; cv=none; b=RGCvkglMteEpSIiPl7HzsXvaR/C5cTqzkzWg3MPQlwklkCDPilO/EuvcKjjUJ4H808mwoE5RUGmUsky4m9HHyB/6ZTF6dPooIPKqBlVZF/pfJ6gKPpqhaP2VMLPtZThQetNLmugWeFoEqyD6dPQEXbpmhGdWsl8guehcRed+8nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666759; c=relaxed/simple;
	bh=gyrbgrmAu0u5NOMTexr6lUTm4VL8xjBv5aNQQDL3jlI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WdIMXEnIr2hQd9Kfmtql/8DXOOFDGz2fgHAhYeQz73ekeEqjcEii+U4b3pKXwpjFdfMYJ6AYhL55R8kbN8s8uH1rIdB0rk74oewurFAxd9Cja61OTyJdnTCe/waJiK9v6A8QpavOr2FqaNmxt/4FGro9a7f9f32T3h+B5CwU3LY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZMRDKU6i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZMRDKU6i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EA8B1F000E9;
	Tue, 21 Jul 2026 20:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666757;
	bh=lVEcY72UzgkTRSm8Pp2Ydk9HwW/Y6PKjfglZDyvn9uY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZMRDKU6iSfF5PC84UX5KQNCLpEjaAbzlQg92UTwPPulIF6sHvOlEVB7rcSdwSzaBO
	 j4Mae6GMGL0aEWZrWmOhNLf2LLY4QfVuEum9hzYDE7eIMtB+TnJQyCWQnJ7AIXB5fk
	 Ty6vsUTwoKQaO24cNuZusxcWvbV/H8Ex2brSA33w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matvey Kovalev <matvey.kovalev@ispras.ru>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0804/1266] qede: fix out-of-bounds check for cqe->len_list[]
Date: Tue, 21 Jul 2026 17:20:41 +0200
Message-ID: <20260721152459.848809668@linuxfoundation.org>
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
index 273dae622c4113..1de8611a27f238 100644
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



