Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022319;
	b=HJyHYFhAHpUgu70yKFg0NpjE25MlVJsPFxIYrgIA+Zrcv7UQx+kBZo7OimTWpsxkcwZj
	 /fqCcxl7tY/5kq8ESSRP4mhRUk3ugTX20zxRW8ygfVkooD+MCYGcUMGGGMV+4UGThdmH6
	 IZ6WDKiiTAo5rOurd7eLTptwKxY/J56borlLEoDYoeaFlStY+nqF4Cy9huk+aY0AsYEu0
	 ZHdjp9rnQ/zQtO/9CHC0lzuTsIqaIhLbJHwvMmn5WJ1fIgUM9pJVJn3t98D5EtWlbVgsx
	 nUxM85uLMwGMxdTdYuexFc2m9v0b4ojEhj1YzKC3hIf4r9OqEB6kmaVz8me4VocHV0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022319;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SXzW/Xt7OI5rVvv6WLIqzF0VDHs8I2u0U/jHbwiACqM=;
	b=xxrtD7HoM7jTKWW+U5VFwIKQacjMpbEF7aCI9XPVMHdWaEihL2XxTRqFylYCru19P1Y6
	 x1QK/hdIUqUP+ICvXBwDqSHc6wILtJ8KbAfGYVMuRMzP1zABqrBbag60qPcb6c7rrFA4A
	 ib6g4sa6+Utb1xlKwHfMTrufg4Xq8F3cUIw1xPF8OJpIJfg0bnkDSoZCNKHdyBZOS9euO
	 8N4RaA3Fy5PcWtcJp40zxiK4l4eFFAuCcA4DXoCumStTJbQjQsM3S4aP4lUMLpnxdOnwb
	 auK8qzDzCZ/AeyDHopukRaEppkeyRBggjyZJNZQH3OsbXY4PFY8eBDXA9OZPJjDmUrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=skHaqUWu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF76A606A31C;
	Wed, 18 Nov 2026 17:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=skHaqUWu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 244621F000C6;
	Wed, 18 Nov 2026 17:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022319;
	bh=SXzW/Xt7OI5rVvv6WLIqzF0VDHs8I2u0U/jHbwiACqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=skHaqUWuG7W92fSWQSI7Y59vV6zShgt/EzTKhJHN9fpT2ITBp19Fg2kiqYa3sGdbP
	 WcA/olvdfBRCZX1tv51ADo9PEFmtvd5FjKHX/fOt/XgTab5ocuBP187otJn6IE0Pur
	 096EfxgUQ8SBR6/K7CSnkwhQOtem+MBpOEMhOh/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2618/2651] eth: bnxt: hand XDP frags over to the copybreak skb
Date: Wed, 18 Nov 2026 16:04:18 +0100
Message-ID: <20261118150418.472679624@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 364b88b54fc260d22ee318bae862c2d7d8c31dc6 ]

With a multi-buffer XDP program attached, a packet only has agg
buffers if it filled its head buffer, which in page mode holds most
of a page. The program can still move the start of the packet forward
with bpf_xdp_adjust_head() and leave at most rx_copybreak bytes in the
head. bnxt_rx_pkt() then copies the head into a new skb, puts the head
page back on the ring, and calls bnxt_xdp_build_skb() on the copy.
bnxt_xdp_build_skb() only sets nr_frags and the skb's length
accounting, because it expects an skb built around the head page,
sharing its shinfo with the xdp_buff. The copy ends up with nr_frags
set but no frag descriptors, and the stack later reads and releases
whatever its frags array happens to contain. The real frags leak.

Copy the frag descriptors to the new skb in bnxt_copy_xdp(), so that
bnxt_xdp_build_skb() finds the frags where it expects them. The frags
now belong to the skb, and the head page goes back on the ring as
before.

Pointed out in LLM review of the first patch of the series.
Confirmed by reading the code, the unfixed kernel was not run with
the reproducer below.
Tested on a BCM57504 at MTU 9000 with rx-copybreak raised to 1024
and a frags-capable XDP program moving the start of multi-buffer
frames 3000B forward with bpf_xdp_adjust_head(), receiving 8000B
ICMPv6 echo requests (a head and two agg buffers each). All 60k
frames took the copybreak path with frags attached, the sampled skbs
reached GRO with len=4998 data_len=4492 nr_frags=2, and were freed by
the stack with the page pools' inflight count staying flat, no KASAN
or DEBUG_PAGEALLOC splats.

Fixes: 1dc4c557bfed ("bnxt: adding bnxt_xdp_build_skb to build skb from multibuffer xdp_buff")
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Link: https://patch.msgid.link/20261027234940.1267225-6-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 4c97610a93fc5..1fd6a676085b5 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -1511,6 +1511,14 @@ static struct sk_buff *bnxt_copy_xdp(struct bnxt_napi *bnapi,
 		__skb_pull(skb, metasize);
 	}
 
+	if (unlikely(xdp_buff_has_frags(xdp))) {
+		struct skb_shared_info *sinfo;
+
+		sinfo = xdp_get_shared_info_from_buff(xdp);
+		memcpy(skb_shinfo(skb)->frags, sinfo->frags,
+		       sinfo->nr_frags * sizeof(skb_frag_t));
+	}
+
 	return skb;
 }
 
-- 
2.53.0



