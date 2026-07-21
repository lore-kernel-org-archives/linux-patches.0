Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F79346D0A0;
	Tue, 21 Jul 2026 20:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665720; cv=none; b=s9GY3BhnSWBHioq5AGSz3mkLDo1AXb6PW3HFA4ejciyXIV9VkiLqZU6LOvQ3kbeXiK2ozRvPvwwDnSw6CQT7sJtD60+ODRukH5ysU3IXgZKaRbCVgaGWJUBbYZ9aqZD0ZCW9fCHc860s7Z3mj6CE8VA/bOY53h4PSLiElhznz6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665720; c=relaxed/simple;
	bh=5gPCJk6KJKUl2Y4WZUR+rfmvc0h7zAmxOZnXtypIQao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O4rJJKxYu5o9jSuiUSHofJejMsw+kP68dnb8fECTJ3SwAkYBFHqNb/8SPMxBrOWrY9ghwqbLbEkv316JQ6N8Tpn3tuLbJXnZc92z7dW2I/Qj1Zqe8iT5UxLW9XfuURwDvc0cIRXX0+G524AEWmvL5MNl0CVRaZRfvc55QgO4tl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sUc+ajVt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sUc+ajVt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57A711F000E9;
	Tue, 21 Jul 2026 20:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665718;
	bh=o5TSXTcjzK1vb0RQLOKz+T78R0bmEOuI6vOgKYN1Bok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sUc+ajVtyanmcmTYe4H+k/ijG+dwl71+KZCLMo5RJCbW2h8QF9tQyUI86ASeksT9m
	 K0UiPBoroOIMEJgU8Jk2IYHdorSI+nMn9AxTmB9rLZJo8ic/NumaLMYv95mzG5B1fx
	 L9IZ8/GNg1CP6RiZLMBcdTLHe91WCi7Qv99dPie8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Chesnokov <Alexander.Chesnokov@kaspersky.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0408/1266] RDMA/hns: Fix arithmetic overflow in calc_hem_config()
Date: Tue, 21 Jul 2026 17:14:05 +0200
Message-ID: <20260721152450.968094812@linuxfoundation.org>
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
index f13016dc8016a5..d6fcb1a4bd4fca 100644
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



