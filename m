Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C03A407594;
	Mon, 20 Apr 2026 13:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691633; cv=none; b=ReCdYbDtzSB3muqWfItB1rhZVCgqDIKVsIWDt04YbyiPyqnF214IZrb/8bxlC/7aiirNgJ1wm02jFLWEyvwjlqwxf40gNbOJ8bwqUU4TB9PsvcZ7CN4nlJJbSMksscst8jh/UFaQBaBYph4vMDtbdIy6M9xjeHmEVj2UchcAO2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691633; c=relaxed/simple;
	bh=EtbMov6KIzXcNw5LizLdDoNZDbLQdqxksZ2tpEZYjdw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mjnlTE+fOym5v3xpXhjqxqrmQ0kX4YTmvs3dKMZVVSPKw5hcLBbnw+d1aK2Xw28Gr0fETuiOAmQTmQe22VZBi9o+OVp4+/m28vLVKKzs8zd8yz8jI9H81OPg5E8wfFBdvwJMj0gJTxHxlt2i7o0WUB3bNT5+kTFKp45lXljYwIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BPbWJhrc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BPbWJhrc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B26EEC2BCB4;
	Mon, 20 Apr 2026 13:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691633;
	bh=EtbMov6KIzXcNw5LizLdDoNZDbLQdqxksZ2tpEZYjdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BPbWJhrcMizaShOlUcriXfokMb3hxJvdHf8WhTGWHbGzyzQ+tyypwWuq5R3U+OZOQ
	 0aF1AD+taw0RCoYPGXbGYwSnjbqecMWmRDjd4zBDnuNJIAEGgi75fZORABVfGXKb+K
	 TpOJ8HwDHE2uV2t2slQ6QuXzPz/bQ7odvsGYwAOp+cOS+KaYIucX2+N/D/2H//i+OY
	 OEpO48ko2okxAb72tcq4YTzIXcETV4OE3BQqga0JH1eaf8qyKmcFyaQu4Y+VRfaHOR
	 SHezaApa02RPc1lQY+xQ/g5ripcJbKGKVmsCpBHFIc41c18xD56cYJpC4Bz4+RPYF3
	 bVWXxzUP12DXA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	magnus.karlsson@intel.com,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	daniel@iogearbox.net,
	netdev@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] xsk: tighten UMEM headroom validation to account for tailroom and min frame
Date: Mon, 20 Apr 2026 09:18:57 -0400
Message-ID: <20260420132314.1023554-143-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.23
Content-Transfer-Encoding: 8bit

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

[ Upstream commit a315e022a72d95ef5f1d4e58e903cb492b0ad931 ]

The current headroom validation in xdp_umem_reg() could leave us with
insufficient space dedicated to even receive minimum-sized ethernet
frame. Furthermore if multi-buffer would come to play then
skb_shared_info stored at the end of XSK frame would be corrupted.

HW typically works with 128-aligned sizes so let us provide this value
as bare minimum.

Multi-buffer setting is known later in the configuration process so
besides accounting for 128 bytes, let us also take care of tailroom space
upfront.

Reviewed-by: Björn Töpel <bjorn@kernel.org>
Acked-by: Stanislav Fomichev <sdf@fomichev.me>
Fixes: 99e3a236dd43 ("xsk: Add missing check on user supplied headroom size")
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Link: https://patch.msgid.link/20260402154958.562179-2-maciej.fijalkowski@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

 net/xdp/xdp_umem.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
index 9f76ca591d54f..9ec7bd948acc7 100644
--- a/net/xdp/xdp_umem.c
+++ b/net/xdp/xdp_umem.c
@@ -202,7 +202,8 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
 	if (!unaligned_chunks && chunks_rem)
 		return -EINVAL;
 
-	if (headroom >= chunk_size - XDP_PACKET_HEADROOM)
+	if (headroom > chunk_size - XDP_PACKET_HEADROOM -
+		       SKB_DATA_ALIGN(sizeof(struct skb_shared_info)) - 128)
 		return -EINVAL;
 
 	if (mr->flags & XDP_UMEM_TX_METADATA_LEN) {
-- 
2.53.0

