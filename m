Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10E7130FA7
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:21:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 807DAC433C7;
	Wed, 20 Sep 2023 12:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695212470;
	bh=fqo+nnr+B6VTFziIEgluQh9devR26/3V8GtjcLnGSMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pTIKP5KH3HJWYei/vfSUyJ4w/1vsYOpHoz0YeRoe3I6V1Rmi1JIT+rZCCtWisa04U
	 IKJ4C00sNvyG9b0HgmO15OasKOg+zEasonlAU8aOyQwFln1OLTI88g53K4JI5eTPl3
	 RK9njwlyoU+A7pmy551t5jVyu05A3TTlvj/k8mf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes@sipsolutions.net>,
	Dmitry Antipov <dmantipov@yandex.ru>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 14/83] wifi: ath9k: fix fortify warnings
Date: Wed, 20 Sep 2023 13:31:04 +0200
Message-ID: <20230920112827.240504993@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112826.634178162@linuxfoundation.org>
References: <20230920112826.634178162@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Antipov <dmantipov@yandex.ru>

[ Upstream commit 810e41cebb6c6e394f2068f839e1a3fc745a5dcc ]

When compiling with gcc 13.1 and CONFIG_FORTIFY_SOURCE=y,
I've noticed the following:

In function ‘fortify_memcpy_chk’,
    inlined from ‘ath_tx_complete_aggr’ at drivers/net/wireless/ath/ath9k/xmit.c:556:4,
    inlined from ‘ath_tx_process_buffer’ at drivers/net/wireless/ath/ath9k/xmit.c:773:3:
./include/linux/fortify-string.h:529:25: warning: call to ‘__read_overflow2_field’
declared with attribute warning: detected read beyond size of field (2nd parameter);
maybe use struct_group()? [-Wattribute-warning]
  529 |                         __read_overflow2_field(q_size_field, size);
      |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In function ‘fortify_memcpy_chk’,
    inlined from ‘ath_tx_count_frames’ at drivers/net/wireless/ath/ath9k/xmit.c:473:3,
    inlined from ‘ath_tx_complete_aggr’ at drivers/net/wireless/ath/ath9k/xmit.c:572:2,
    inlined from ‘ath_tx_process_buffer’ at drivers/net/wireless/ath/ath9k/xmit.c:773:3:
./include/linux/fortify-string.h:529:25: warning: call to ‘__read_overflow2_field’
declared with attribute warning: detected read beyond size of field (2nd parameter);
maybe use struct_group()? [-Wattribute-warning]
  529 |                         __read_overflow2_field(q_size_field, size);
      |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In both cases, the compiler complains on:

memcpy(ba, &ts->ba_low, WME_BA_BMP_SIZE >> 3);

which is the legal way to copy both 'ba_low' and following 'ba_high'
members of 'struct ath_tx_status' at once (that is, issue one 8-byte
'memcpy()' for two 4-byte fields). Since the fortification logic seems
interprets this trick as an attempt to overread 4-byte 'ba_low', silence
relevant warnings by using the convenient 'struct_group()' quirk.

Suggested-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20230620080855.396851-2-dmantipov@yandex.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/mac.h  | 6 ++++--
 drivers/net/wireless/ath/ath9k/xmit.c | 4 ++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/mac.h b/drivers/net/wireless/ath/ath9k/mac.h
index fd6aa49adadfe..9b00e77a6fc3c 100644
--- a/drivers/net/wireless/ath/ath9k/mac.h
+++ b/drivers/net/wireless/ath/ath9k/mac.h
@@ -113,8 +113,10 @@ struct ath_tx_status {
 	u8 qid;
 	u16 desc_id;
 	u8 tid;
-	u32 ba_low;
-	u32 ba_high;
+	struct_group(ba,
+		u32 ba_low;
+		u32 ba_high;
+	);
 	u32 evm0;
 	u32 evm1;
 	u32 evm2;
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 6555abf02f18b..84c68aefc171a 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -421,7 +421,7 @@ static void ath_tx_count_frames(struct ath_softc *sc, struct ath_buf *bf,
 	isaggr = bf_isaggr(bf);
 	if (isaggr) {
 		seq_st = ts->ts_seqnum;
-		memcpy(ba, &ts->ba_low, WME_BA_BMP_SIZE >> 3);
+		memcpy(ba, &ts->ba, WME_BA_BMP_SIZE >> 3);
 	}
 
 	while (bf) {
@@ -504,7 +504,7 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 	if (isaggr && txok) {
 		if (ts->ts_flags & ATH9K_TX_BA) {
 			seq_st = ts->ts_seqnum;
-			memcpy(ba, &ts->ba_low, WME_BA_BMP_SIZE >> 3);
+			memcpy(ba, &ts->ba, WME_BA_BMP_SIZE >> 3);
 		} else {
 			/*
 			 * AR5416 can become deaf/mute when BA
-- 
2.40.1



