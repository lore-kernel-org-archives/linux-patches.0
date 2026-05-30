Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20F0E1A9F90;
	Sat, 30 May 2026 18:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166878; cv=none; b=jY6SlwMBIRuca3aX/6ugo0VcNZ6IH5giV9PT942PxkMoke6PR2hG8log+JTA/DWVXRyZTH00A7ieBkans/o0auzXVTH/fUg2HI5/KE7lQExbIBIWbrl7mqPGnVv13AuKJV8GR1DNkiGoFiIjhgqLcZykDPVuBF6zvaB8Ako5GBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166878; c=relaxed/simple;
	bh=Bwj8IcuT7tGP6l/XN4MWA10YoNRHmU/vRZcHP9tntD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uYORkDcBZrILIrUjYk98U9T4/kUxlWpJcms2S/1cyvBytCgqQo7x8zC46U8k3U+nEYTvxirXWdCoJNBorsyG9rP0VMjnD5EfKWwj5Tgk4S2xCG+TRkc1I05Hwnn6Qib1SgSXDxEsur/hajFeFaFoCvRIoILyKJPHHh4NBiykloY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iv0efIOl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iv0efIOl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6661A1F00893;
	Sat, 30 May 2026 18:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166877;
	bh=SH4Yb84BIbTJnkIjC5GlWjdKxq1SW4sKIAgNuyLRymQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iv0efIOlOUlSxhD+24D2iZdUBB4+zeyP/jvY4qi4i2MkzTxc2ohe9dN5K5IFp9rVB
	 PuW7B9aYPR6z76Ze0+ibjKUYWWRKuVScY3zmIEJeOL/+pDjIX/HQoGioTmrQzU7plB
	 IMZPgZbaOACT+RO4ghVF1oYKQrmIXN37TwHKL1oQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingfang Deng <qingfang.deng@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 498/589] flow_dissector: do not dissect PPPoE PFC frames
Date: Sat, 30 May 2026 18:06:19 +0200
Message-ID: <20260530160237.705043867@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qingfang Deng <qingfang.deng@linux.dev>

[ Upstream commit d6c19b31a3c1d519fabdcf0aa239e6b6109b9473 ]

RFC 2516 Section 7 states that Protocol Field Compression (PFC) is NOT
RECOMMENDED for PPPoE. In practice, pppd does not support negotiating
PFC for PPPoE sessions, and the flow dissector driver has assumed an
uncompressed frame until the blamed commit.

During the review process of that commit [1], support for PFC is
suggested. However, having a compressed (1-byte) protocol field means
the subsequent PPP payload is shifted by one byte, causing 4-byte
misalignment for the network header and an unaligned access exception
on some architectures.

The exception can be reproduced by sending a PPPoE PFC frame to an
ethernet interface of a MIPS board, with RPS enabled, even if no PPPoE
session is active on that interface:

$ 0   : 00000000 80c40000 00000000 85144817
$ 4   : 00000008 00000100 80a75758 81dc9bb8
$ 8   : 00000010 8087ae2c 0000003d 00000000
$12   : 000000e0 00000039 00000000 00000000
$16   : 85043240 80a75758 81dc9bb8 00006488
$20   : 0000002f 00000007 85144810 80a70000
$24   : 81d1bda0 00000000
$28   : 81dc8000 81dc9aa8 00000000 805ead08
Hi    : 00009d51
Lo    : 2163358a
epc   : 805e91f0 __skb_flow_dissect+0x1b0/0x1b50
ra    : 805ead08 __skb_get_hash_net+0x74/0x12c
Status: 11000403        KERNEL EXL IE
Cause : 40800010 (ExcCode 04)
BadVA : 85144817
PrId  : 0001992f (MIPS 1004Kc)
Call Trace:
[<805e91f0>] __skb_flow_dissect+0x1b0/0x1b50
[<805ead08>] __skb_get_hash_net+0x74/0x12c
[<805ef330>] get_rps_cpu+0x1b8/0x3fc
[<805fca70>] netif_receive_skb_list_internal+0x324/0x364
[<805fd120>] napi_complete_done+0x68/0x2a4
[<8058de5c>] mtk_napi_rx+0x228/0xfec
[<805fd398>] __napi_poll+0x3c/0x1c4
[<805fd754>] napi_threaded_poll_loop+0x234/0x29c
[<805fd848>] napi_threaded_poll+0x8c/0xb0
[<80053544>] kthread+0x104/0x12c
[<80002bd8>] ret_from_kernel_thread+0x14/0x1c

Code: 02d51821  1060045b  00000000 <8c640000> 3084000f  2c820005  144001a2  00042080  8e220000

To reduce the attack surface and maintain performance, do not process
PPPoE PFC frames.

[1] https://lore.kernel.org/r/20220630231016.GA392@debian.home
Fixes: 46126db9c861 ("flow_dissector: Add PPPoE dissectors")
Signed-off-by: Qingfang Deng <qingfang.deng@linux.dev>
Link: https://patch.msgid.link/20260415022456.141758-1-qingfang.deng@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/flow_dissector.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index c3d64e2d59295..86eb489ee76e0 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -1229,16 +1229,13 @@ bool __skb_flow_dissect(const struct net *net,
 			break;
 		}
 
-		/* least significant bit of the most significant octet
-		 * indicates if protocol field was compressed
+		/* PFC (compressed 1-byte protocol) frames are not processed.
+		 * A compressed protocol field has the least significant bit of
+		 * the most significant octet set, which will fail the following
+		 * ppp_proto_is_valid(), returning FLOW_DISSECT_RET_OUT_BAD.
 		 */
 		ppp_proto = ntohs(hdr->proto);
-		if (ppp_proto & 0x0100) {
-			ppp_proto = ppp_proto >> 8;
-			nhoff += PPPOE_SES_HLEN - 1;
-		} else {
-			nhoff += PPPOE_SES_HLEN;
-		}
+		nhoff += PPPOE_SES_HLEN;
 
 		if (ppp_proto == PPP_IP) {
 			proto = htons(ETH_P_IP);
-- 
2.53.0



