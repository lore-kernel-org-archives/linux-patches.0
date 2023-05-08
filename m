Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9786C168CF
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:14:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1270C433D2;
	Mon,  8 May 2023 11:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683544461;
	bh=AXPSzDBj0414A/tKiQ3LRBf6i+Gs7dhtv4ADb3Ig66I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QvixXW99zKW8WPSycoEgDBwlcii/RbNuOYiTcFeLVt5P4KMQkz6fk0Vp6N+rlDVv+
	 DMQtZ03AlUYHnmjRTROLsGI0fo7aEFexJ8Zp8B+FBftMwEsGoU++Ppvd5xj6VFE9QO
	 5vWVOJSJGtxA2B1ZSWeozythZ1725nFgjiH4sbPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kal Conley <kal.conley@dectris.com>,
	Magnus Karlsson <magnus.karlsson@intel.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 388/694] selftests: xsk: Deflakify STATS_RX_DROPPED test
Date: Mon,  8 May 2023 11:43:43 +0200
Message-Id: <20230508094445.604718602@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kal Conley <kal.conley@dectris.com>

[ Upstream commit 68e7322142f5e731af222892d384d311835db0f1 ]

Fix flaky STATS_RX_DROPPED test. The receiver calls getsockopt after
receiving the last (valid) packet which is not the final packet sent in
the test (valid and invalid packets are sent in alternating fashion with
the final packet being invalid). Since the last packet may or may not
have been dropped already, both outcomes must be allowed.

This issue could also be fixed by making sure the last packet sent is
valid. This alternative is left as an exercise to the reader (or the
benevolent maintainers of this file).

This problem was quite visible on certain setups. On one machine this
failure was observed 50% of the time.

Also, remove a redundant assignment of pkt_stream->nb_pkts. This field
is already initialized by __pkt_stream_alloc.

Fixes: 27e934bec35b ("selftests: xsk: make stat tests not spin on getsockopt")
Signed-off-by: Kal Conley <kal.conley@dectris.com>
Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
Link: https://lore.kernel.org/r/20230403120400.31018-1-kal.conley@dectris.com
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/xskxceiver.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
index 5f1471f84d4bb..b6910df710d1e 100644
--- a/tools/testing/selftests/bpf/xskxceiver.c
+++ b/tools/testing/selftests/bpf/xskxceiver.c
@@ -631,7 +631,6 @@ static struct pkt_stream *pkt_stream_generate(struct xsk_umem_info *umem, u32 nb
 	if (!pkt_stream)
 		exit_with_error(ENOMEM);
 
-	pkt_stream->nb_pkts = nb_pkts;
 	for (i = 0; i < nb_pkts; i++) {
 		pkt_set(umem, &pkt_stream->pkts[i], (i % umem->num_frames) * umem->frame_size,
 			pkt_len);
@@ -1124,7 +1123,14 @@ static int validate_rx_dropped(struct ifobject *ifobject)
 	if (err)
 		return TEST_FAILURE;
 
-	if (stats.rx_dropped == ifobject->pkt_stream->nb_pkts / 2)
+	/* The receiver calls getsockopt after receiving the last (valid)
+	 * packet which is not the final packet sent in this test (valid and
+	 * invalid packets are sent in alternating fashion with the final
+	 * packet being invalid). Since the last packet may or may not have
+	 * been dropped already, both outcomes must be allowed.
+	 */
+	if (stats.rx_dropped == ifobject->pkt_stream->nb_pkts / 2 ||
+	    stats.rx_dropped == ifobject->pkt_stream->nb_pkts / 2 - 1)
 		return TEST_PASS;
 
 	return TEST_FAILURE;
-- 
2.39.2



