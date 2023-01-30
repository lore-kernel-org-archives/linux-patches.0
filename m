Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6BC828EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:02:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D485C433D2;
	Mon, 30 Jan 2023 14:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087334;
	bh=c/QYEqgrzbqsUCWWawIeMmxbv5hBaLQ1yfyDF10poHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NbAZX4iZBH9y9k5ljV1Ov/M04UlNAg1UBZ81gngtdVwkask59YzwjCsV1GTUJXCn5
	 BJVo610wPaXhTYjyzUEMKqykwJ11b4YWopI01FqhtlVqvGHHHDukyS8AO0h+4Rtp2g
	 uzb8tLZ42ZvMGT4aSIQBNRrYe1HWw1cWZ3UeZOxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 133/313] selftests/net: toeplitz: fix race on tpacket_v3 block close
Date: Mon, 30 Jan 2023 14:49:28 +0100
Message-Id: <20230130134342.854192122@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Willem de Bruijn <willemb@google.com>

[ Upstream commit 903848249a781d76d59561d51676c95b3a4d7162 ]

Avoid race between process wakeup and tpacket_v3 block timeout.

The test waits for cfg_timeout_msec for packets to arrive. Packets
arrive in tpacket_v3 rings, which pass packets ("frames") to the
process in batches ("blocks"). The sk waits for req3.tp_retire_blk_tov
msec to release a block.

Set the block timeout lower than the process waiting time, else
the process may find that no block has been released by the time it
scans the socket list. Convert to a ring of more than one, smaller,
blocks with shorter timeouts. Blocks must be page aligned, so >= 64KB.

Fixes: 5ebfb4cc3048 ("selftests/net: toeplitz test")
Signed-off-by: Willem de Bruijn <willemb@google.com>
Link: https://lore.kernel.org/r/20230118151847.4124260-1-willemdebruijn.kernel@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/toeplitz.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/net/toeplitz.c b/tools/testing/selftests/net/toeplitz.c
index 90026a27eac0..9ba03164d73a 100644
--- a/tools/testing/selftests/net/toeplitz.c
+++ b/tools/testing/selftests/net/toeplitz.c
@@ -215,7 +215,7 @@ static char *recv_frame(const struct ring_state *ring, char *frame)
 }
 
 /* A single TPACKET_V3 block can hold multiple frames */
-static void recv_block(struct ring_state *ring)
+static bool recv_block(struct ring_state *ring)
 {
 	struct tpacket_block_desc *block;
 	char *frame;
@@ -223,7 +223,7 @@ static void recv_block(struct ring_state *ring)
 
 	block = (void *)(ring->mmap + ring->idx * ring_block_sz);
 	if (!(block->hdr.bh1.block_status & TP_STATUS_USER))
-		return;
+		return false;
 
 	frame = (char *)block;
 	frame += block->hdr.bh1.offset_to_first_pkt;
@@ -235,6 +235,8 @@ static void recv_block(struct ring_state *ring)
 
 	block->hdr.bh1.block_status = TP_STATUS_KERNEL;
 	ring->idx = (ring->idx + 1) % ring_block_nr;
+
+	return true;
 }
 
 /* simple test: sleep once unconditionally and then process all rings */
@@ -245,7 +247,7 @@ static void process_rings(void)
 	usleep(1000 * cfg_timeout_msec);
 
 	for (i = 0; i < num_cpus; i++)
-		recv_block(&rings[i]);
+		do {} while (recv_block(&rings[i]));
 
 	fprintf(stderr, "count: pass=%u nohash=%u fail=%u\n",
 		frames_received - frames_nohash - frames_error,
@@ -257,12 +259,12 @@ static char *setup_ring(int fd)
 	struct tpacket_req3 req3 = {0};
 	void *ring;
 
-	req3.tp_retire_blk_tov = cfg_timeout_msec;
+	req3.tp_retire_blk_tov = cfg_timeout_msec / 8;
 	req3.tp_feature_req_word = TP_FT_REQ_FILL_RXHASH;
 
 	req3.tp_frame_size = 2048;
 	req3.tp_frame_nr = 1 << 10;
-	req3.tp_block_nr = 2;
+	req3.tp_block_nr = 16;
 
 	req3.tp_block_size = req3.tp_frame_size * req3.tp_frame_nr;
 	req3.tp_block_size /= req3.tp_block_nr;
-- 
2.39.0



