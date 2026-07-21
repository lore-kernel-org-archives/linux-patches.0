Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A823E43B490;
	Tue, 21 Jul 2026 22:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674067; cv=none; b=Skjp/00Y6g3fK9swVegUTzYmx8nYBFaSyn9HdLZqghAK+SaFjAN0cw1wPJUOv7iTDb4gH5SUtlZDdU4Klr1g+GwRnxWapRvI1kzjoCNh/dSq5sssCDxTX+k6aBVmT8ApOz+okyqVdDfYgU5eF09gRxD/Tf+bkIL3pTkWygjiGfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674067; c=relaxed/simple;
	bh=XDy+5uPI9lCkvqsgEPnMq+Wt79Z0KTi+8u70yxtzrP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l1PBZEbG4AQ1phrRXE85c5/ldBBJc5ROHmvC+gSyBMWdrgv7cOUGg9CDF1+b3G8Q2uIcXGoYUUlljoQyC9PlCtDnsvSHFu43h+vO3grzw2ajeJMfa2n+/kQ302rpLrbLEWvVjQeBjfsI9Yxv0noTGU7YDgUehNkOj+AIvm1IYwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KxlI6AE/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KxlI6AE/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 797401F00A3F;
	Tue, 21 Jul 2026 22:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674062;
	bh=vBUr4LD6Vh825iANlJ/DSwWNvX/8Dd0jIRqVLfDLzyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KxlI6AE/sqdnRmxUtRdMsNRdi6Evdk2eitkuCzGZwSjJBZ03IQ7/epUfkTNCrw7RO
	 Qsad/yZypndJ8p5PijK7TVc2+zClzCTmUpQW/OT6IVtXx/XowmkvxNqThUFCj0flBv
	 oZW5RZLuL+uRJZ0jwdlwmDD2h0gBiM7KOPm0o4KU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Elder <elder@linaro.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 397/699] net: qualcomm: rmnet: simplify some byte order logic
Date: Tue, 21 Jul 2026 17:22:36 +0200
Message-ID: <20260721152404.651430368@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

From: Alex Elder <elder@linaro.org>

[ Upstream commit 50c62a111c4855510b0d8a2d8e50214172166b61 ]

In rmnet_map_ipv4_ul_csum_header() and rmnet_map_ipv6_ul_csum_header()
the offset within a packet at which checksumming should commence is
calculated.  This calculation involves byte swapping and a forced type
conversion that makes it hard to understand.

Simplify this by computing the offset in host byte order, then
converting the result when assigning it into the header field.

Signed-off-by: Alex Elder <elder@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: f0f1887a9e30 ("net: qualcomm: rmnet: validate MAP frame length before ingress parsing")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/qualcomm/rmnet/rmnet_map_data.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
index 21d38167f96180..0bfe69698b278f 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
@@ -197,12 +197,10 @@ rmnet_map_ipv4_ul_csum_header(void *iphdr,
 			      struct rmnet_map_ul_csum_header *ul_header,
 			      struct sk_buff *skb)
 {
-	struct iphdr *ip4h = (struct iphdr *)iphdr;
-	__be16 *hdr = (__be16 *)ul_header, offset;
+	__be16 *hdr = (__be16 *)ul_header;
+	struct iphdr *ip4h = iphdr;
 
-	offset = htons((__force u16)(skb_transport_header(skb) -
-				     (unsigned char *)iphdr));
-	ul_header->csum_start_offset = offset;
+	ul_header->csum_start_offset = htons(skb_network_header_len(skb));
 	ul_header->csum_insert_offset = skb->csum_offset;
 	ul_header->csum_enabled = 1;
 	if (ip4h->protocol == IPPROTO_UDP)
@@ -239,12 +237,10 @@ rmnet_map_ipv6_ul_csum_header(void *ip6hdr,
 			      struct rmnet_map_ul_csum_header *ul_header,
 			      struct sk_buff *skb)
 {
-	struct ipv6hdr *ip6h = (struct ipv6hdr *)ip6hdr;
-	__be16 *hdr = (__be16 *)ul_header, offset;
+	__be16 *hdr = (__be16 *)ul_header;
+	struct ipv6hdr *ip6h = ip6hdr;
 
-	offset = htons((__force u16)(skb_transport_header(skb) -
-				     (unsigned char *)ip6hdr));
-	ul_header->csum_start_offset = offset;
+	ul_header->csum_start_offset = htons(skb_network_header_len(skb));
 	ul_header->csum_insert_offset = skb->csum_offset;
 	ul_header->csum_enabled = 1;
 
-- 
2.53.0



