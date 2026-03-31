Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19AEF2E1C7C;
	Tue, 31 Mar 2026 17:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976810; cv=none; b=H99xene1WWmsNqEBSeIcwBmLfnXrgrjMDGeFqPsEU4KieNnflWNgxPP+YN8f4Ko75T2bBWAKb+Zv75px1yql7mWwCbZEy1JErSpGE6ZKcVp5gjpnuKaWDV+LCW0eJg9tav82/x1j9PWrwMYn67wOJijAsh7BFKmXvyMoMpVZo24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976810; c=relaxed/simple;
	bh=ynlddpKoIzYwdYuBxp4mzHSCXxYWLP8NibpBVC5mQKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E88se4YWLEuNgW06YToBBmYwtu/tqh6ZkYJw0IrbPFRHLLvcSphcFzuOOB+GIdYV/2tDxdpRAyh3F0M2E3tNfuZLTctpawhAqaKUDwAWoe4fhfe0pawCqtARp93pZnguMmDKl4LLN3djaQ6/6AuYEOHiUO60j5jwLaaJyb1Wr1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cPjCy2cb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cPjCy2cb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F0BFC19423;
	Tue, 31 Mar 2026 17:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976810;
	bh=ynlddpKoIzYwdYuBxp4mzHSCXxYWLP8NibpBVC5mQKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cPjCy2cboMzzMP1vQj8s6RyoH6XxNN4RQLJinspA59sefODZcDqZiKFcaDOqImeN3
	 tdoAitr0RayPAWjBETyF5AQHhf43E/Fk2+UU9m3eBuLiYNZQhxxI4S/jduQspQFBFj
	 3e6Ph4LryzBcXxw4e0M1ygc3tfmc6Qhnzb9VyyRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roshan Kumar <roshaen09@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 6.18 204/309] xfrm: iptfs: validate inner IPv4 header length in IPTFS payload
Date: Tue, 31 Mar 2026 18:21:47 +0200
Message-ID: <20260331161800.960801903@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

From: Roshan Kumar <roshaen09@gmail.com>

commit 0d10393d5eac33cbd92f7a41fddca12c41d3cb7e upstream.

Add validation of the inner IPv4 packet tot_len and ihl fields parsed
from decrypted IPTFS payloads in __input_process_payload(). A crafted
ESP packet containing an inner IPv4 header with tot_len=0 causes an
infinite loop: iplen=0 leads to capturelen=min(0, remaining)=0, so the
data offset never advances and the while(data < tail) loop never
terminates, spinning forever in softirq context.

Reject inner IPv4 packets where tot_len < ihl*4 or ihl*4 < sizeof(struct
iphdr), which catches both the tot_len=0 case and malformed ihl values.
The normal IP stack performs this validation in ip_rcv_core(), but IPTFS
extracts and processes inner packets before they reach that layer.

Reported-by: Roshan Kumar <roshaen09@gmail.com>
Fixes: 6c82d2433671 ("xfrm: iptfs: add basic receive packet (tunnel egress) handling")
Cc: stable@vger.kernel.org
Signed-off-by: Roshan Kumar <roshaen09@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/xfrm/xfrm_iptfs.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/net/xfrm/xfrm_iptfs.c
+++ b/net/xfrm/xfrm_iptfs.c
@@ -997,6 +997,11 @@ static bool __input_process_payload(stru
 
 			iplen = be16_to_cpu(iph->tot_len);
 			iphlen = iph->ihl << 2;
+			if (iplen < iphlen || iphlen < sizeof(*iph)) {
+				XFRM_INC_STATS(net,
+					       LINUX_MIB_XFRMINHDRERROR);
+				goto done;
+			}
 			protocol = cpu_to_be16(ETH_P_IP);
 			XFRM_MODE_SKB_CB(skbseq->root_skb)->tos = iph->tos;
 		} else if (iph->version == 0x6) {


