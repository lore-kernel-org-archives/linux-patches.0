Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A5D53B6BF0;
	Tue, 21 Jul 2026 22:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672088; cv=none; b=O571cFl0XPjtDcR8rSV8z8xlI5Ar/c1qPIwnT2/P57AY0bC1HojcT8oSZCiZJ0oV2bjKZwCus79na1evOrBXXcFujBM3ul38p/VT7maZknf6gjUjKvfb/k8jjWnMghsXITq3pCf+OcgrSVEFhutZbv6Z6sC1f+aMRIpSlffFm6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672088; c=relaxed/simple;
	bh=d/D9sGeEa6JI39b8CiPhG9mAodEFVC68rj7txnhv8ZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ecBxvbJodTT3Vo2qrMR8TAemxcHe4h4LxCPxYuLmJWKy10uNurN72GUCLlRp0kIoBlES5WnVbBgYcxNopgaK/6Rgm2t3UWJoJLoAnO24w822EN41BlgJBZlTfxMqjVE1MfIi1zWC+16CeCKqaiG09eAWFMD+fGviX1gpkXKIiQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wPjUEvom; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wPjUEvom"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EC601F000E9;
	Tue, 21 Jul 2026 22:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672087;
	bh=IlN22LLYyfGoRSoz7ZOGCnt1qCgJaGJ8KrGPNbXc2EY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wPjUEvomEIt1eqQiLbXaqJ3EDC3MXhJm/D5boZ0IafKXprjISnPT0jBz6W0jw0H7l
	 /wqv8L9u6ujh3ljJIVxksCQUskAr5J4o19X6Wfb9UBOa8VoaKoMuZmCoyL15HOOrWp
	 kFZKd2+UvnQAmeKQuEycEeRxenzfhyRd6noUKXr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matvey Kovalev <matvey.kovalev@ispras.ru>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 490/843] qede: fix out-of-bounds check for cqe->len_list[]
Date: Tue, 21 Jul 2026 17:22:05 +0200
Message-ID: <20260721152417.052805504@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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
index 503ab11a5a33e3..f12ea7da3458e1 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_fp.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_fp.c
@@ -962,7 +962,7 @@ static inline void qede_tpa_cont(struct qede_dev *edev,
 {
 	int i;
 
-	for (i = 0; cqe->len_list[i] && i < ARRAY_SIZE(cqe->len_list); i++)
+	for (i = 0; i < ARRAY_SIZE(cqe->len_list) && cqe->len_list[i]; i++)
 		qede_fill_frag_skb(edev, rxq, cqe->tpa_agg_index,
 				   le16_to_cpu(cqe->len_list[i]));
 
@@ -987,7 +987,7 @@ static int qede_tpa_end(struct qede_dev *edev,
 		dma_unmap_page(rxq->dev, tpa_info->buffer.mapping,
 			       PAGE_SIZE, rxq->data_direction);
 
-	for (i = 0; cqe->len_list[i] && i < ARRAY_SIZE(cqe->len_list); i++)
+	for (i = 0; i < ARRAY_SIZE(cqe->len_list) && cqe->len_list[i]; i++)
 		qede_fill_frag_skb(edev, rxq, cqe->tpa_agg_index,
 				   le16_to_cpu(cqe->len_list[i]));
 	if (unlikely(i > 1))
-- 
2.53.0



