Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C276A3EEAE2;
	Mon, 17 Aug 2026 13:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974378; cv=none; b=qBUyJAyp2Uj8tGq06Xv8mkibRdYJtXN3LGdxRh9pqqyJxstYR9R83d267LoMr5rXujnhaX6f7/ATSOHLjoLEQQuaYniS0FAeFYMEOUxuEk2A3w2qqOCRcnUcgzqx50dGMCRSN7/nqlJM4vineHEDMEMGtrpkzmpmdsxZiA/pk0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974378; c=relaxed/simple;
	bh=35mnFRVyTfaPYHNffOp4VqjSFg0ESNlszN39yXPhbQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uUuSXd3FmnoN1EgpyNzBGZmTONubIdu19usCykUM8qmR+Go/T2GhFQL4LxmgcG4liuUNGXbvJGnCbWyJTuAagM1AMgklDlo9FdJ8wiy3mq3TUHnpChV7S0f+8doMJaCagrobWiMqOjxCyg6w9tb0QNda/87CYuIiCGdWUKsH6sE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P/p9Z7h0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P/p9Z7h0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AA851F000E9;
	Mon, 17 Aug 2026 13:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974373;
	bh=egj4d/NRg1Mvj22J+83o+7BbxfKZU9ELmVDVlfcReRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P/p9Z7h0OilLt+ehxPScCbZUUHeRW2ohXNsd8zyLG9x8YIAOkfnBKImFuzVLepGON
	 5KcgSUAIL0T8khPMnO/bcig9UD8Um9nNYQwpffXdyEcDP5wfkdOCjSVmBXtLPckLUK
	 5xaj5wVb6UWdOyGm9x1w1/uQOM1Es99FoVukwrgc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Xing <kernelxing@tencent.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Jakub Kicinski <kuba@kernel.org>,
	"=?UTF-8?q?Ricardo=20B . =20Marli=C3=A8re=20 ?=" <ricardo@marliere.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 166/271] selftests/xsk: account reclaimed invalid Tx descriptors
Date: Mon, 17 Aug 2026 15:31:31 +0200
Message-ID: <20260817132543.718701261@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
User-Agent: quilt/0.69
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

[ Upstream commit f49d99eaee7c32badc7ddfaecbb01ce4d037d695 ]

Invalid Tx descriptors are now returned through the completion ring,
regardless of whether they form a standalone packet or belong to an
invalid multi-buffer packet.

The selftests previously counted only descriptors belonging to valid
packets, with a special exception for some invalid multi-buffer packets
in verbatim streams. This undercounts completion entries when a
standalone invalid descriptor or another invalid packet is reclaimed by
the kernel.

Keep valid_pkts as the number of packets expected on the Rx side, but
count every descriptor submitted to the Tx ring in valid_frags, as every
such descriptor is now expected to be returned through the completion
ring.

Make fragment counting in verbatim mode follow the packet boundary
instead of stopping at the first invalid fragment. Update custom stream
generation so an invalid middle fragment terminates the generated Rx
packet while Tx completion accounting still covers the complete invalid
packet.

Also add explicit end fragments after invalid middle descriptors. This
exercises the kernel drain logic and verifies that subsequent valid
packets are not interpreted as continuations of the invalid packet.

[ rbm: in testapp_invalid_desc_mb() hunk, use umem_size instead of umem_sz
]

Reviewed-by: Jason Xing <kernelxing@tencent.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Acked-by: Stanislav Fomichev <sdf@fomichev.me>
Link: https://patch.msgid.link/20260719135609.147823-7-maciej.fijalkowski@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Ricardo B. Marlière (SUSE) <ricardo@marliere.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/bpf/prog_tests/test_xsk.c       | 26 ++++++++++---------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/test_xsk.c b/tools/testing/selftests/bpf/prog_tests/test_xsk.c
index 1c48a3b5ee736..31bf8a3fcd666 100644
--- a/tools/testing/selftests/bpf/prog_tests/test_xsk.c
+++ b/tools/testing/selftests/bpf/prog_tests/test_xsk.c
@@ -414,14 +414,14 @@ static u32 pkt_nb_frags(u32 frame_size, struct pkt_stream *pkt_stream, struct pk
 	}
 
 	/* Search for the end of the packet in verbatim mode */
-	if (!pkt_continues(pkt->options) || !pkt->valid)
+	if (!pkt_continues(pkt->options))
 		return nb_frags;
 
 	next_frag = pkt_stream->current_pkt_nb;
 	pkt++;
 	while (next_frag++ < pkt_stream->nb_pkts) {
 		nb_frags++;
-		if (!pkt_continues(pkt->options) || !pkt->valid)
+		if (!pkt_continues(pkt->options))
 			break;
 		pkt++;
 	}
@@ -652,11 +652,11 @@ static struct pkt_stream *__pkt_stream_generate_custom(struct ifobject *ifobj, s
 			if (!frame->valid || !pkt_continues(frame->options))
 				payload++;
 		} else {
-			if (frame->valid)
+			if (frame->valid) {
 				len += frame->len;
-			if (frame->valid && pkt_continues(frame->options))
-				continue;
-
+				if (pkt_continues(frame->options))
+					continue;
+			}
 			pkt->pkt_nb = pkt_nb;
 			pkt->len = len;
 			pkt->valid = frame->valid;
@@ -1236,10 +1236,9 @@ static int __send_pkts(struct ifobject *ifobject, struct xsk_socket_info *xsk, b
 			}
 		}
 
-		if (pkt && pkt->valid) {
+		if (pkt && pkt->valid)
 			valid_pkts++;
-			valid_frags += nb_frags;
-		}
+		valid_frags += nb_frags;
 	}
 
 	pthread_mutex_lock(&pacing_mutex);
@@ -2075,13 +2074,16 @@ int testapp_invalid_desc_mb(struct test_spec *test)
 		{0, 0, 0, false, 0},
 		/* Invalid address in the second frame */
 		{0, XSK_UMEM__LARGE_FRAME_SIZE, 0, false, XDP_PKT_CONTD},
-		{umem_size, XSK_UMEM__LARGE_FRAME_SIZE, 0, false, XDP_PKT_CONTD},
+		{umem_size * 2, XSK_UMEM__LARGE_FRAME_SIZE, 0, false, XDP_PKT_CONTD},
+		{0, MIN_PKT_SIZE, 0, false, 0},
 		/* Invalid len in the middle */
 		{0, XSK_UMEM__LARGE_FRAME_SIZE, 0, false, XDP_PKT_CONTD},
 		{0, XSK_UMEM__INVALID_FRAME_SIZE, 0, false, XDP_PKT_CONTD},
+		{0, MIN_PKT_SIZE, 0, false, 0},
 		/* Invalid options in the middle */
 		{0, XSK_UMEM__LARGE_FRAME_SIZE, 0, false, XDP_PKT_CONTD},
 		{0, XSK_UMEM__LARGE_FRAME_SIZE, 0, false, XSK_DESC__INVALID_OPTION},
+		{0, MIN_PKT_SIZE, 0, false, 0},
 		/* Transmit 2 frags, receive 3 */
 		{0, XSK_UMEM__MAX_FRAME_SIZE, 0, true, XDP_PKT_CONTD},
 		{0, XSK_UMEM__MAX_FRAME_SIZE, 0, true, 0},
@@ -2093,8 +2095,8 @@ int testapp_invalid_desc_mb(struct test_spec *test)
 
 	if (umem->unaligned_mode) {
 		/* Crossing a chunk boundary allowed */
-		pkts[12].valid = true;
-		pkts[13].valid = true;
+		pkts[15].valid = true;
+		pkts[16].valid = true;
 	}
 
 	test->mtu = MAX_ETH_JUMBO_SIZE;
-- 
2.53.0



