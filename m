Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0B651350D0;
	Tue, 23 Jan 2024 00:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969339; cv=none; b=ryZinYMGxdyqRWFAWxJ9/eFNv8yaOYWJZe4RfPFpPKmMysqwrWXyC4kVJJWF3q6JewTfaAiU2qrx4vZcj1CbbM7BVFfWmJGFr9Nu45okch1brR4ZhJv0N0ouATV3Gweg9GhkfGYXLswlDmTaPVf1HMLm5UjSwpS8ueu2fqYq92o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969339; c=relaxed/simple;
	bh=/CmGZblg69YBUJyIPKzVriWtlgP7Cs2lY+vNkUntJpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UpmexSqZ/fmjP7gzk4AuX1zNMJz4zuOQBkBFEXaOj7Rbov21oucN/SKCm7a2WT4O8sHZsoCnn1TtlD+HD3K+EHK9xVjzp9inuduSamHYOEkQETLBx3RAfUNPV1tqt/XO8DQvvTikoESAXmQ0/rtSUL4D8LAhq9sxSXZTHsch+6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JvFy+KUG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JvFy+KUG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 759B9C43399;
	Tue, 23 Jan 2024 00:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969339;
	bh=/CmGZblg69YBUJyIPKzVriWtlgP7Cs2lY+vNkUntJpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JvFy+KUG3V3F8L+QGmqvWqWlFdw4NW1jJNK3+VU38Nw9aZQOT3hnkxPwmKb4/8Rte
	 kpM7e2Zukha0UocNciNUIXxZIJaNScclKI0CGc9jI+pR/pc6B2z4MbsPqhID2Gu1JP
	 Wt8Ots8jGawGBRs/Xt8S6FzF85iM/CQaOakYfxgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Tushar Vyavahare <tushar.vyavahare@intel.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Magnus Karlsson <magnus.karlsson@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 181/641] selftests/xsk: Fix for SEND_RECEIVE_UNALIGNED test
Date: Mon, 22 Jan 2024 15:51:25 -0800
Message-ID: <20240122235823.659042689@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tushar Vyavahare <tushar.vyavahare@intel.com>

[ Upstream commit 2e1d6a04116c373fbd25beddba4267178535bc60 ]

Fix test broken by shared umem test and framework enhancement commit.

Correct the current implementation of pkt_stream_replace_half() by
ensuring that nb_valid_entries are not set to half, as this is not true
for all the tests. Ensure that the expected value for valid_entries for
the SEND_RECEIVE_UNALIGNED test equals the total number of packets sent,
which is 4096.

Create a new function called pkt_stream_pkt_set() that allows for packet
modification to meet specific requirements while ensuring the accurate
maintenance of the valid packet count to prevent inconsistencies in packet
tracking.

Fixes: 6d198a89c004 ("selftests/xsk: Add a test for shared umem feature")
Reported-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Tushar Vyavahare <tushar.vyavahare@intel.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
Link: https://lore.kernel.org/bpf/20231214130007.33281-1-tushar.vyavahare@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/xskxceiver.c | 25 +++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
index b604c570309a..b1102ee13faa 100644
--- a/tools/testing/selftests/bpf/xskxceiver.c
+++ b/tools/testing/selftests/bpf/xskxceiver.c
@@ -634,16 +634,24 @@ static u32 pkt_nb_frags(u32 frame_size, struct pkt_stream *pkt_stream, struct pk
 	return nb_frags;
 }
 
+static bool set_pkt_valid(int offset, u32 len)
+{
+	return len <= MAX_ETH_JUMBO_SIZE;
+}
+
 static void pkt_set(struct pkt_stream *pkt_stream, struct pkt *pkt, int offset, u32 len)
 {
 	pkt->offset = offset;
 	pkt->len = len;
-	if (len > MAX_ETH_JUMBO_SIZE) {
-		pkt->valid = false;
-	} else {
-		pkt->valid = true;
-		pkt_stream->nb_valid_entries++;
-	}
+	pkt->valid = set_pkt_valid(offset, len);
+}
+
+static void pkt_stream_pkt_set(struct pkt_stream *pkt_stream, struct pkt *pkt, int offset, u32 len)
+{
+	bool prev_pkt_valid = pkt->valid;
+
+	pkt_set(pkt_stream, pkt, offset, len);
+	pkt_stream->nb_valid_entries += pkt->valid - prev_pkt_valid;
 }
 
 static u32 pkt_get_buffer_len(struct xsk_umem_info *umem, u32 len)
@@ -665,7 +673,7 @@ static struct pkt_stream *__pkt_stream_generate(u32 nb_pkts, u32 pkt_len, u32 nb
 	for (i = 0; i < nb_pkts; i++) {
 		struct pkt *pkt = &pkt_stream->pkts[i];
 
-		pkt_set(pkt_stream, pkt, 0, pkt_len);
+		pkt_stream_pkt_set(pkt_stream, pkt, 0, pkt_len);
 		pkt->pkt_nb = nb_start + i * nb_off;
 	}
 
@@ -700,10 +708,9 @@ static void __pkt_stream_replace_half(struct ifobject *ifobj, u32 pkt_len,
 
 	pkt_stream = pkt_stream_clone(ifobj->xsk->pkt_stream);
 	for (i = 1; i < ifobj->xsk->pkt_stream->nb_pkts; i += 2)
-		pkt_set(pkt_stream, &pkt_stream->pkts[i], offset, pkt_len);
+		pkt_stream_pkt_set(pkt_stream, &pkt_stream->pkts[i], offset, pkt_len);
 
 	ifobj->xsk->pkt_stream = pkt_stream;
-	pkt_stream->nb_valid_entries /= 2;
 }
 
 static void pkt_stream_replace_half(struct test_spec *test, u32 pkt_len, int offset)
-- 
2.43.0



