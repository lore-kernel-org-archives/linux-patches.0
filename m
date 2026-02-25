Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7168A26FA60;
	Wed, 25 Feb 2026 01:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983848; cv=none; b=iVQgfjzUCwTNKk80tWiTnGz+v8neLSLT7jC8CpsGOFMiWntip7xWIOYe7YrSxoZSS3eKr1UVQs/YHp4ibVaqKNCPJMWm//E+L1QH5MVQp+HlS0Jr/XrPVjqqTS6h9YKUjIRzjGKR3RYwGa0ko3XuMgrbdO8ZftyUjc8GsgG79ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983848; c=relaxed/simple;
	bh=8CNRjdG9BAie1C/ebrf/MF6uaeHryuYKyKUzcsd0wRg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SqY74g0M+KR3HB/5dzKRPFXoUN95OMhIRflOz4FU7N5tge8lEkjdalDbSdCMyZHbeJ1e2eQ84cgA6H6Jf2r4rjwLDoob7ToxbLxzrqZqiwMjUquh/ENkK+XmVXVCMawjptjTXc0OS9G5QfK3ViGvf/z8ZayuT7QDawRzBIj0zp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ljl0ziMo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ljl0ziMo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EE82C116D0;
	Wed, 25 Feb 2026 01:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983848;
	bh=8CNRjdG9BAie1C/ebrf/MF6uaeHryuYKyKUzcsd0wRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ljl0ziMoLnsjosxJq64s4irgtBm7G3rd3ug4z9OUog9vfXG22SyD6UzKMs9c7JCxM
	 fxOFuYuHrUB1W0WNRhJkfWdTD9NJygLTe8Yu7s7wbaqbWU1juadniV9+Q4NH865l30
	 pG3QxXMN29MNaYjq+/2J3nlVD2bDdH7Y2PhbX3f0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Larysa Zaremba <larysa.zaremba@intel.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 125/641] selftests/xsk: fix number of Tx frags in invalid packet
Date: Tue, 24 Feb 2026 17:17:31 -0800
Message-ID: <20260225012352.176018906@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larysa Zaremba <larysa.zaremba@intel.com>

[ Upstream commit 88af9fefed412e4bea9a1a771cbe6fe347fa3507 ]

The issue occurs in TOO_MANY_FRAGS test case when xdp_zc_max_segs is set to
an odd number.

TOO_MANY_FRAGS test case contains an invalid packet consisting of
(xdp_zc_max_segs) frags. Every frag, even the last one has XDP_PKT_CONTD
flag set. This packet is expected to be dropped. After that, there is a
valid linear packet, which is expected to be received back.

Once (xdp_zc_max_segs) is an odd number, the last packet cannot be
received, if packet forwarding between Rx and Tx interfaces relies on
the ethernet header, e.g. checks for ETH_P_LOOPBACK. Packet is malformed,
if all traffic is looped.

Turns out, sending function processes multiple invalid frags as if they
were in 2-frag packets. So once the invalid mbuf packet contains an odd
number of those, the valid packet after gets paired with the previous
invalid descriptor, and hence does not get an ethernet header generated, so
it is either dropped or malformed.

Make invalid packets in verbatim mode always have only a single frag. For
such packets, number of frags is otherwise meaningless, as descriptor flags
are pre-configured in verbatim mode and packet data is not generated for
invalid descriptors.

Fixes: 697604492b64 ("selftests/xsk: add invalid descriptor test for multi-buffer")
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Larysa Zaremba <larysa.zaremba@intel.com>
Link: https://lore.kernel.org/r/20260203155103.2305816-3-larysa.zaremba@intel.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_xsk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_xsk.c b/tools/testing/selftests/bpf/test_xsk.c
index b52f597ea9bd2..55d318c5c5e59 100644
--- a/tools/testing/selftests/bpf/test_xsk.c
+++ b/tools/testing/selftests/bpf/test_xsk.c
@@ -431,7 +431,7 @@ static u32 pkt_nb_frags(u32 frame_size, struct pkt_stream *pkt_stream, struct pk
 	}
 
 	/* Search for the end of the packet in verbatim mode */
-	if (!pkt_continues(pkt->options))
+	if (!pkt_continues(pkt->options) || !pkt->valid)
 		return nb_frags;
 
 	next_frag = pkt_stream->current_pkt_nb;
-- 
2.51.0



