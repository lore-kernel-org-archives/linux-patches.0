Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06B9E355026;
	Tue, 16 Dec 2025 11:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885902; cv=none; b=hhiVtBB95clC0eUngqmh1IZdBZJtrTOWutbGTCXTHu3O4H+MQovclpnMcwU2BiY4s9NTZc7C/1+BkoA2gARlZfBc3ZqDKsX8oIHrKW8cOudJwQnLFMeRLn/RNiMvvDngRNcA/Zbk0lWd5O/4ebAYXQvXhz+JZ7jhn6IlqdkZJ7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885902; c=relaxed/simple;
	bh=mMMMQXR1uit5zSwFfzr3/n1V+XfbTcHByhBpTMLi15c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fxNB9y9LBJ6vQ56lzlNaSNIuu4vkCQ3w2IvfNzz+J4RFs2Bw/5wvGrHaFpGT1hkP/n6bcSkec2GL4S9k0sbgR2mSxH38WWpQ1GmpwcYQwOiPd0p0hVlrecxdzDFUIjjN20U1uT+xihXFs91g7mTfHXyQEEXdg+xC4zLpPGnuRPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E9H+ObgY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E9H+ObgY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62363C4CEF1;
	Tue, 16 Dec 2025 11:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885901;
	bh=mMMMQXR1uit5zSwFfzr3/n1V+XfbTcHByhBpTMLi15c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E9H+ObgYg2dkUAQPfrxRTGqu7NpcVPM3IfXUafwnLL0t28moN7x7atpeBxs5Njjhp
	 Z4f69QyL4SF9ZTg0RIBCDwXjfD8mObXAwdqepl4d8mNMcY/fipXoPbOR/AGo2ix86a
	 +n4uaWsE9YfJnXR4NHCLaXkTS2tE+L7gA4e8IG2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Kaiyan Mei <M202472210@hust.edu.cn>,
	Yinhao Hu <dddddd@hust.edu.cn>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 245/507] bpf: Check skb->transport_header is set in bpf_skb_check_mtu
Date: Tue, 16 Dec 2025 12:11:26 +0100
Message-ID: <20251216111354.372695964@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin KaFai Lau <martin.lau@kernel.org>

[ Upstream commit d946f3c98328171fa50ddb908593cf833587f725 ]

The bpf_skb_check_mtu helper needs to use skb->transport_header when
the BPF_MTU_CHK_SEGS flag is used:

	bpf_skb_check_mtu(skb, ifindex, &mtu_len, 0, BPF_MTU_CHK_SEGS)

The transport_header is not always set. There is a WARN_ON_ONCE
report when CONFIG_DEBUG_NET is enabled + skb->gso_size is set +
bpf_prog_test_run is used:

WARNING: CPU: 1 PID: 2216 at ./include/linux/skbuff.h:3071
 skb_gso_validate_network_len
 bpf_skb_check_mtu
 bpf_prog_3920e25740a41171_tc_chk_segs_flag # A test in the next patch
 bpf_test_run
 bpf_prog_test_run_skb

For a normal ingress skb (not test_run), skb_reset_transport_header
is performed but there is plan to avoid setting it as described in
commit 2170a1f09148 ("net: no longer reset transport_header in __netif_receive_skb_core()").

This patch fixes the bpf helper by checking
skb_transport_header_was_set(). The check is done just before
skb->transport_header is used, to avoid breaking the existing bpf prog.
The WARN_ON_ONCE is limited to bpf_prog_test_run, so targeting bpf-next.

Fixes: 34b2021cc616 ("bpf: Add BPF-helper for MTU checking")
Cc: Jesper Dangaard Brouer <hawk@kernel.org>
Reported-by: Kaiyan Mei <M202472210@hust.edu.cn>
Reported-by: Yinhao Hu <dddddd@hust.edu.cn>
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Link: https://lore.kernel.org/r/20251112232331.1566074-1-martin.lau@linux.dev
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index b20d5fecdbc95..47366ec94e589 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6414,9 +6414,12 @@ BPF_CALL_5(bpf_skb_check_mtu, struct sk_buff *, skb,
 	 */
 	if (skb_is_gso(skb)) {
 		ret = BPF_MTU_CHK_RET_SUCCESS;
-		if (flags & BPF_MTU_CHK_SEGS &&
-		    !skb_gso_validate_network_len(skb, mtu))
-			ret = BPF_MTU_CHK_RET_SEGS_TOOBIG;
+		if (flags & BPF_MTU_CHK_SEGS) {
+			if (!skb_transport_header_was_set(skb))
+				return -EINVAL;
+			if (!skb_gso_validate_network_len(skb, mtu))
+				ret = BPF_MTU_CHK_RET_SEGS_TOOBIG;
+		}
 	}
 out:
 	*mtu_len = mtu;
-- 
2.51.0



