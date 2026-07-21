Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 598A03368B8;
	Tue, 21 Jul 2026 17:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655823; cv=none; b=YDVsfmpIutL+AbgSB+r3seuO38Dy4ZKTF2S6s7N5F03CQcvR1D/uBLNZHdel7v4YoIAG6UlVEAU757KqeekKEFL9MiyyZqYGJLBj1ISns4q6SQhRw8A4Mz7sx3Y8EQUtKYCi5UVDApNIW6hYZ6n7YONSPJHATWq1FD/2PBsf7BM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655823; c=relaxed/simple;
	bh=2xKQ4uK4Yh1pq4J1GZh34yJemFBxtx740Ha0qWEFcZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cg9K8FJjTo48Lg0cHzIICNfypTANoi6aG8nJpTyRLS9d8DWIgUSp0PEbqCj1NU9g9Z1UNr1KqVBfZ53mKtVKmv3CnV3B6N1nBbSGeT2xZgroOnKJ1/xdHpBUN+waMT1zjUT/ihFBLR7bRu9EDpxjjjMnRk3jnlS4J3FDrBpvH1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZQbP9ybV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZQbP9ybV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB42E1F00A3A;
	Tue, 21 Jul 2026 17:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655821;
	bh=bRSubRhxxxHP1iHeDzMTosgpC5i9Spt3lBeHVyFOdQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZQbP9ybVx7STF5kGj2Y4q8WRFrr9TpVkfRjBEfx4S22v9Ww8ast1zJFB0Mxr9DXII
	 e9EaaIj1+lzsY7O8Rg9NUhnGXW/J8Akww2OlwUZU6Rw7jkmqx0/mbmoQlhlpQQzjZ1
	 kkGif0oWlcptwf51odHzcsmC/CSm4hu6ARXGZidg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Chesnokov <Alexander.Chesnokov@kaspersky.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0155/1611] RDMA/hns: Fix arithmetic overflow in calc_hem_config()
Date: Tue, 21 Jul 2026 17:04:31 +0200
Message-ID: <20260721152518.364298939@linuxfoundation.org>
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

From: Alexander Chesnokov <Alexander.Chesnokov@kaspersky.com>

[ Upstream commit a38e4410af9ad8b7ad2217254da06cd4dc21f0ed ]

If bt_num is 3 or 2, then the expressions like
l0_idx * chunk_ba_num + l1_idx are computed in 32-bit
arithmetic before being assigned to a u64 index field,
which can lead to overflow.

Cast the first operand to u64 to ensure the arithmetic
is performed in 64-bit.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 2f49de21f3e9 ("RDMA/hns: Optimize mhop get flow for multi-hop addressing")
Signed-off-by: Alexander Chesnokov <Alexander.Chesnokov@kaspersky.com>
Link: https://patch.msgid.link/20260413091527.39990-1-Alexander.Chesnokov@kaspersky.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hem.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hem.c b/drivers/infiniband/hw/hns/hns_roce_hem.c
index 3d479c63b117a9..1680d0ac071ed1 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hem.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hem.c
@@ -314,14 +314,14 @@ static int calc_hem_config(struct hns_roce_dev *hr_dev,
 	bt_num = hns_roce_get_bt_num(table->type, mhop->hop_num);
 	switch (bt_num) {
 	case 3:
-		index->l1 = l0_idx * chunk_ba_num + l1_idx;
+		index->l1 = (u64)l0_idx * chunk_ba_num + l1_idx;
 		index->l0 = l0_idx;
-		index->buf = l0_idx * chunk_ba_num * chunk_ba_num +
-			     l1_idx * chunk_ba_num + l2_idx;
+		index->buf = (u64)l0_idx * chunk_ba_num * chunk_ba_num +
+					 (u64)l1_idx * chunk_ba_num + l2_idx;
 		break;
 	case 2:
 		index->l0 = l0_idx;
-		index->buf = l0_idx * chunk_ba_num + l1_idx;
+		index->buf = (u64)l0_idx * chunk_ba_num + l1_idx;
 		break;
 	case 1:
 		index->buf = l0_idx;
-- 
2.53.0



