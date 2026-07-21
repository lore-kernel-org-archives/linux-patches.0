Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 985C544AB68;
	Tue, 21 Jul 2026 21:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668798; cv=none; b=edZFB+KUQ2toOuxtFS/Oy6YLd4FKg1Pgfzihp5NdhgB02v8C5lc67kpPIgiPjSf1LIkoqpcmldGJ5dQ4TJsPY7uVVqa/g03hOLC9aidBkyzno+hmDa710NqUHyXLx2qsbirEi5WxJ7EHGXLG4+IajU2Ak2kWD7sSAKfnb15iL5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668798; c=relaxed/simple;
	bh=G/pUsa8dpvRTHpfa2uZ+3nuyd7KZIL8yIoj1eu+55P8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UzA3iFiPkMKM998H6CO4OMwr6tXnVs+wUpQQe0t8o/hs7it/HkLolvX9CswEu8d+glal3Pc+ZrM81pjxg+DYZO1EOBhJIxLioEjQgDi4gWfX/6+VC6dMLkmeTz4XGsKz92h4GtKjZ4Vot/tghVXHTlPVew28SP+m62Y5NadHrEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hW+lzs0k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hW+lzs0k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 040681F000E9;
	Tue, 21 Jul 2026 21:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668797;
	bh=wwNOZjw3Tk2/UjgVXxIuDeh0nVVQZUHLHfyil6KlQoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hW+lzs0kuVuFp+VN6PKfi9zk+Nh4Q653fa21ywMunKjhyMp13HGU+4SecpKyfp9EM
	 Rn5oeQw6v72feiXMhl4Va2qRYF870U8T31ehGXLDpq8CBc6tOs6H9IAEX1EP/XncZZ
	 oCip1N4VCg46zxgNlB8Nl7J9weKkrOvy1cBJhx8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Chesnokov <Alexander.Chesnokov@kaspersky.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0312/1067] RDMA/hns: Fix arithmetic overflow in calc_hem_config()
Date: Tue, 21 Jul 2026 17:15:13 +0200
Message-ID: <20260721152431.572089009@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 173ab794fa780e..862acdf59867a9 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hem.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hem.c
@@ -355,14 +355,14 @@ static int calc_hem_config(struct hns_roce_dev *hr_dev,
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



