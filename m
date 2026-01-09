Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F2482F12D4;
	Fri,  9 Jan 2026 11:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959746; cv=none; b=O4Abh2h3qY6+vaTKRX3r/LqDAuCkVvbVj7S6A3Qg8nr2VN4mBSaZ4b41o5NkMhKj4uK8i5SUH5FLdp5bO4vX+/KiCyVnvR+Q0AoTWHkQ857l6Y5ZPmrDkH/fuqUJg767JElvoN6dSVkFwgyJaoOwJJv8pORD6NngJ6t3djWi9Zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959746; c=relaxed/simple;
	bh=TDFUFgZsMbrnCYXAO/Y6mv8cBrImIbRzpvIpfbgVJRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=avnQaXVhmKCBrzUutoKhDd5aOlL/8LNDEYR8WhQ/ySqAdX/XkKnj04ev2+vA0P+y0WqAT+Zsrk1mvl4vA7pfndnHAHpwgXcJdEeWML84Ic0TkHS52fhBFqoIbfAPqrP3Ec8Li0lAa5O4uHffuT6W5V8TWIZ+UvCzW7fF9wohgYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BrSVSo0r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BrSVSo0r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE1EAC4CEF1;
	Fri,  9 Jan 2026 11:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959746;
	bh=TDFUFgZsMbrnCYXAO/Y6mv8cBrImIbRzpvIpfbgVJRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BrSVSo0rFIhjAcq8oW4H6TNVOSkKLBktGBAadcLACPbLsxq5dum9YTgg1CrNc48ks
	 YKBdbG1EgF0yy1bp8fm49MRHZOc4aOZuK2zgSSfuap7MJiBPE5y9z8uRWlDFp0zQpI
	 gDdLP5gzqc2Mh0tAiBnseXUfcOYY1H3A7q/CJ2yQ=
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
Subject: [PATCH 6.6 160/737] bpf: Check skb->transport_header is set in bpf_skb_check_mtu
Date: Fri,  9 Jan 2026 12:34:59 +0100
Message-ID: <20260109112140.014265364@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0564ee6ac8731..da1a617b7db94 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6295,9 +6295,12 @@ BPF_CALL_5(bpf_skb_check_mtu, struct sk_buff *, skb,
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



