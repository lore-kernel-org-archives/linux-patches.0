Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 625C243C7D7;
	Tue, 21 Jul 2026 22:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671428; cv=none; b=psIypw1Ca+uOa3uPFqZratFWMvHGIrbhroncFbNIdy1QUV47pvkX+crPW6Q1b4ahby8NvIKLbJRn6TEQzIefDOUviCmyQVOT4QX53mR8x1Y+F9MmCcv7UgBxDe82EjkFU3eUOivz+I96B+aN0NepWXQV38yAq8kwpOWlTTylbAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671428; c=relaxed/simple;
	bh=NDkaY9oqgFaV7N69yA7UB6np2R9zuAdSBRURdOWQwqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OfmUUU1Qk92m7a+YESKi6aTbuG7578fWCcsfV+Ktru7zgx/DL+pIgIwyJDohHizgbR6khy5rDYOtG6om/PI5GEQXsnj2UOZGBoQj1apmd7zokJNAJs+FU92IVeeePvk4T7SfZwsYpIqhJWfoowQ+Mj7kJgqMsZ2fz4zgQzOEvs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iEii3SaL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iEii3SaL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6AF61F00A3A;
	Tue, 21 Jul 2026 22:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671427;
	bh=RMGa+u9ddqKgK5TMgVE893cxYXdQPX01ZJPeAMXstS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iEii3SaL8CzjhdBYrEXclbAA+T173XK8PSmPoxELdg45eI5yFPdD9zoCXfir+J5tN
	 /B9eyuOpCq07WNaxsMX755sXTPzYgN6yy2++aPVKQt8sCQaBRwZ9tQX5x6JzB/mm00
	 KbqPy1gNKBDEUfvZvqA6zfHork4oyXXWEly2ZesI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Chesnokov <Alexander.Chesnokov@kaspersky.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 242/843] RDMA/hns: Fix arithmetic overflow in calc_hem_config()
Date: Tue, 21 Jul 2026 17:17:57 +0200
Message-ID: <20260721152411.459344585@linuxfoundation.org>
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
index 64ee875cc6d1c8..61ae49219e6baa 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hem.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hem.c
@@ -356,14 +356,14 @@ static int calc_hem_config(struct hns_roce_dev *hr_dev,
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



