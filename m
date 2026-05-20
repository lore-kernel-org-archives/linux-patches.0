Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EAA036CE19;
	Wed, 20 May 2026 18:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300257; cv=none; b=OpoA7NUb3IMKbURjc+jixnbSe17k1y7CMy2k8pxmFTfchmVczGrz99hpn8WkhbeNCCxWCxRCRoKPjqzK+xmzNDLlOvacevLyCNQeGhOU7b7QNYCIoCRGFFMkSIycS3w1ZekWQ2D3Fxr8XI0lTBXf3ri8pYyii5Z+QShSH35mpoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300257; c=relaxed/simple;
	bh=2owwJlION4ImDexhD/U+Aya/JhsUsN2Ka8BgNCFDjbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oMHxvHdr9GV067g/vqEVkOD9YhC4EknmTG3IqVk0geV2qynep5sS20CV+mrqGrSB5lmmKuHCkZLbUzeGupkZy/8wrrch6BmDcYrFMT+3GUSLwfyWmPwWalSgAr/g5txKc3waGFoqe4Hs8+xtMcCIEEmkVcw76W3SWeo81BT12rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v4S9/LXH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v4S9/LXH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B08711F000E9;
	Wed, 20 May 2026 18:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300256;
	bh=iiOIDfXiozVkY+lrDgPR+TP9BSzV0oTCpBUh1iWG6AU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v4S9/LXHqlO+crW25OcXfFpKbKi290zzjTqppWaVISlV2TBiAjmPsmG3AlC4EaYCM
	 VuFT8ny5EG79+8jxSDYKPKi3tomdSvYBKc+Igj/F5ORvRbplNZMoT4tPHVs8+cr/ia
	 YPrFImUqmwCu+9rFags/u/IeRYMTZi0a6Pr94ICs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+619b9ef527f510a57cfc@syzkaller.appspotmail.com,
	Sun Jian <sun.jian.kdev@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 105/666] bpf: reject short IPv4/IPv6 inputs in bpf_prog_test_run_skb
Date: Wed, 20 May 2026 18:15:16 +0200
Message-ID: <20260520162113.497779646@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sun Jian <sun.jian.kdev@gmail.com>

[ Upstream commit 12bec2bd4b76d81c5d3996bd14ec1b7f4d983747 ]

bpf_prog_test_run_skb() calls eth_type_trans() first and then uses
skb->protocol to initialize sk family and address fields for the test
run.

For IPv4 and IPv6 packets, it may access ip_hdr(skb) or ipv6_hdr(skb)
even when the provided test input only contains an Ethernet header.

Reject the input earlier if the Ethernet frame carries IPv4/IPv6
EtherType but the L3 header is too short.

Fold the IPv4/IPv6 header length checks into the existing protocol
switch and return -EINVAL before accessing the network headers.

Fixes: fa5cb548ced6 ("bpf: Setup socket family and addresses in bpf_prog_test_run_skb")
Reported-by: syzbot+619b9ef527f510a57cfc@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=619b9ef527f510a57cfc
Signed-off-by: Sun Jian <sun.jian.kdev@gmail.com>
Link: https://lore.kernel.org/r/20260408034623.180320-2-sun.jian.kdev@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bpf/test_run.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 18257cf6bb488..7f12abc8a80cb 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -1061,19 +1061,23 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
 
 	switch (skb->protocol) {
 	case htons(ETH_P_IP):
-		sk->sk_family = AF_INET;
-		if (sizeof(struct iphdr) <= skb_headlen(skb)) {
-			sk->sk_rcv_saddr = ip_hdr(skb)->saddr;
-			sk->sk_daddr = ip_hdr(skb)->daddr;
+		if (skb_headlen(skb) < sizeof(struct iphdr)) {
+			ret = -EINVAL;
+			goto out;
 		}
+		sk->sk_family = AF_INET;
+		sk->sk_rcv_saddr = ip_hdr(skb)->saddr;
+		sk->sk_daddr = ip_hdr(skb)->daddr;
 		break;
 #if IS_ENABLED(CONFIG_IPV6)
 	case htons(ETH_P_IPV6):
-		sk->sk_family = AF_INET6;
-		if (sizeof(struct ipv6hdr) <= skb_headlen(skb)) {
-			sk->sk_v6_rcv_saddr = ipv6_hdr(skb)->saddr;
-			sk->sk_v6_daddr = ipv6_hdr(skb)->daddr;
+		if (skb_headlen(skb) < sizeof(struct ipv6hdr)) {
+			ret = -EINVAL;
+			goto out;
 		}
+		sk->sk_family = AF_INET6;
+		sk->sk_v6_rcv_saddr = ipv6_hdr(skb)->saddr;
+		sk->sk_v6_daddr = ipv6_hdr(skb)->daddr;
 		break;
 #endif
 	default:
-- 
2.53.0



