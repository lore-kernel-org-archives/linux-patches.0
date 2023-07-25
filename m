Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5F7F1ED4F
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:48:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3F9FC433C8;
	Tue, 25 Jul 2023 11:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690285698;
	bh=RXu3wIgm3cvrMDjA/AHMiw/ZCZenbT74Y9iCUd9Bfa0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2pplGlTmdH1IYJdcNHTmgNAHAjLhiukqBcdiya97h1eHb2txGJKlzt6qnTDKFHXu2
	 rydmwd1vBsfTDge6Av7OXRGKFTyo6M1UKUsejjmd/wvc6XBduW6UfAJY6xGxxm+qhG
	 m95uLPfTEt1oZ9UJtrzSwjQ3pjZkKex7pfI/g3CI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tanmay Patil <t-patil@ti.com>,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 299/313] net: ethernet: ti: cpsw_ale: Fix cpsw_ale_get_field()/cpsw_ale_set_field()
Date: Tue, 25 Jul 2023 12:47:32 +0200
Message-ID: <20230725104534.086478688@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104521.167250627@linuxfoundation.org>
References: <20230725104521.167250627@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tanmay Patil <t-patil@ti.com>

[ Upstream commit b685f1a58956fa36cc01123f253351b25bfacfda ]

CPSW ALE has 75 bit ALE entries which are stored within three 32 bit words.
The cpsw_ale_get_field() and cpsw_ale_set_field() functions assume that the
field will be strictly contained within one word. However, this is not
guaranteed to be the case and it is possible for ALE field entries to span
across up to two words at the most.

Fix the methods to handle getting/setting fields spanning up to two words.

Fixes: db82173f23c5 ("netdev: driver: ethernet: add cpsw address lookup engine support")
Signed-off-by: Tanmay Patil <t-patil@ti.com>
[s-vadapalli@ti.com: rephrased commit message and added Fixes tag]
Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/cpsw_ale.c | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpsw_ale.c b/drivers/net/ethernet/ti/cpsw_ale.c
index e7c24396933e9..f17619c545ae5 100644
--- a/drivers/net/ethernet/ti/cpsw_ale.c
+++ b/drivers/net/ethernet/ti/cpsw_ale.c
@@ -60,23 +60,37 @@
 
 static inline int cpsw_ale_get_field(u32 *ale_entry, u32 start, u32 bits)
 {
-	int idx;
+	int idx, idx2;
+	u32 hi_val = 0;
 
 	idx    = start / 32;
+	idx2 = (start + bits - 1) / 32;
+	/* Check if bits to be fetched exceed a word */
+	if (idx != idx2) {
+		idx2 = 2 - idx2; /* flip */
+		hi_val = ale_entry[idx2] << ((idx2 * 32) - start);
+	}
 	start -= idx * 32;
 	idx    = 2 - idx; /* flip */
-	return (ale_entry[idx] >> start) & BITMASK(bits);
+	return (hi_val + (ale_entry[idx] >> start)) & BITMASK(bits);
 }
 
 static inline void cpsw_ale_set_field(u32 *ale_entry, u32 start, u32 bits,
 				      u32 value)
 {
-	int idx;
+	int idx, idx2;
 
 	value &= BITMASK(bits);
-	idx    = start / 32;
+	idx = start / 32;
+	idx2 = (start + bits - 1) / 32;
+	/* Check if bits to be set exceed a word */
+	if (idx != idx2) {
+		idx2 = 2 - idx2; /* flip */
+		ale_entry[idx2] &= ~(BITMASK(bits + start - (idx2 * 32)));
+		ale_entry[idx2] |= (value >> ((idx2 * 32) - start));
+	}
 	start -= idx * 32;
-	idx    = 2 - idx; /* flip */
+	idx = 2 - idx; /* flip */
 	ale_entry[idx] &= ~(BITMASK(bits) << start);
 	ale_entry[idx] |=  (value << start);
 }
-- 
2.39.2



