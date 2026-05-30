Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 902572D7D2E;
	Sat, 30 May 2026 17:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163994; cv=none; b=soRT+yQpZr2eDeFU0ijjQh7LE0gsjIRtt9Csdhotlhec8bMLYygN0onYdRcGZusjB4TkE5OrN5ouZpGyuggoAx+yWUcsJ50NUg/nlSoU5S5G/KESeFJuqMu8E0harHwEg3Z7HTjHnMQtddATKVRblc9bDc6y8aEL2ibLj7YUQCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163994; c=relaxed/simple;
	bh=7xOyHRh8j9gr39DZHJSt5uC1l5q4URwN6Ut9aVYn1H8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FAoVfHGnjWVsZW3yXfP4KQDCP06BMgxEkSvl1IvQzm10PwaoTPgBpHcrRpjWT8GLIjHS6p1QBjnAE/b+xw4pHrznA/wAYH9/YpIxrCSS4eQENW/2tErIlB/fvuj4PSJwUr6l0JCE8w1UGZQNd/4WYR9snlWBPe4SkgOioej0TUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dgm7fFP1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dgm7fFP1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94D351F00893;
	Sat, 30 May 2026 17:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163993;
	bh=pD5jXhOgKGmrnwHPDXkaL6czfN49H3TAF2GL4j5UXTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dgm7fFP1j9hL8PDuXfYZtKDqRetTyRFQoCf/5dGIoZTPkxKLv1ZXQh67xRAZmGGJK
	 kFDB7s+4n5frTt9326zuqsrDLAWo0XVkB8w5zPs0vJSJR/tShJqmA04L3jA43iEuSz
	 8kVKv43E9RtaR/Sh0W66wB3SxukLGb/h7sjyU/Rg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+619b9ef527f510a57cfc@syzkaller.appspotmail.com,
	Sun Jian <sun.jian.kdev@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 422/776] bpf: reject short IPv4/IPv6 inputs in bpf_prog_test_run_skb
Date: Sat, 30 May 2026 18:02:16 +0200
Message-ID: <20260530160251.368981430@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 86c3aca9fa144..f3ae76919c71f 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -645,19 +645,23 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
 
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



