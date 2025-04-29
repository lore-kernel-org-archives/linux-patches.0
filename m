Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E901155A4E;
	Tue, 29 Apr 2025 18:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950371; cv=none; b=tmegMYDVBEilqXcITioyrK1O/UDr06GgTDFzFS9WQlCgFfFVn3E1W9TZdY7oT63MEBFq1FMxVjJmTf7Hlh6ZoHdHpKI4rL0vF28P+Y/xhLPsACfouVLnL8KXDJjG+g7OxjZk9yC7ikwiZvrjLeg15CAVhpjA1zjtIbdFH3Ngf5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950371; c=relaxed/simple;
	bh=Sc5t6OHf5Fsj3EnW9lnjBqwHWnHU6Kjq1VYCjhveSeU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q1VjUOHHs3+KVXC2cyYeuXvC3tSrT1HwqIBnceNNs1isRzAiZ68LRwg88cdU6/9eXNuTbyISYCRXjaUm0q6hcR6Zr2YXluMx4kkVZz6/BF/EliKoQblp6ByObRHU6uv6gMzhXHIEjI1D0tFQbDrS4n8UJbbVayZh8bp6kp/9jbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=orTd6UBt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="orTd6UBt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2E34C4CEE3;
	Tue, 29 Apr 2025 18:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950371;
	bh=Sc5t6OHf5Fsj3EnW9lnjBqwHWnHU6Kjq1VYCjhveSeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=orTd6UBtHL+qh8GkG2/03mtI4rIfp2kS5/bs3nqKP5rYodTuwMGep44wXAaQe+Q++
	 +AbUTndctiYiXa5NwCE+AQR7YlPFbsSzVhb7FmJnQc0I83dtoUAuELyagCqMWkwjPD
	 D+4zdeS6LQ+6YVeJpnt74V7pHTqAv5MYwKzv4MSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 075/204] net: selftests: initialize TCP header and skb payload with zero
Date: Tue, 29 Apr 2025 18:42:43 +0200
Message-ID: <20250429161102.492848066@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Oleksij Rempel <o.rempel@pengutronix.de>

commit 9e8d1013b0c38910cbc9e60de74dbe883878469d upstream.

Zero-initialize TCP header via memset() to avoid garbage values that
may affect checksum or behavior during test transmission.

Also zero-fill allocated payload and padding regions using memset()
after skb_put(), ensuring deterministic content for all outgoing
test packets.

Fixes: 3e1e58d64c3d ("net: add generic selftest support")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Cc: stable@vger.kernel.org
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250416160125.2914724-1-o.rempel@pengutronix.de
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/selftests.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

--- a/net/core/selftests.c
+++ b/net/core/selftests.c
@@ -100,10 +100,10 @@ static struct sk_buff *net_test_get_skb(
 	ehdr->h_proto = htons(ETH_P_IP);
 
 	if (attr->tcp) {
+		memset(thdr, 0, sizeof(*thdr));
 		thdr->source = htons(attr->sport);
 		thdr->dest = htons(attr->dport);
 		thdr->doff = sizeof(struct tcphdr) / 4;
-		thdr->check = 0;
 	} else {
 		uhdr->source = htons(attr->sport);
 		uhdr->dest = htons(attr->dport);
@@ -144,10 +144,18 @@ static struct sk_buff *net_test_get_skb(
 	attr->id = net_test_next_id;
 	shdr->id = net_test_next_id++;
 
-	if (attr->size)
-		skb_put(skb, attr->size);
-	if (attr->max_size && attr->max_size > skb->len)
-		skb_put(skb, attr->max_size - skb->len);
+	if (attr->size) {
+		void *payload = skb_put(skb, attr->size);
+
+		memset(payload, 0, attr->size);
+	}
+
+	if (attr->max_size && attr->max_size > skb->len) {
+		size_t pad_len = attr->max_size - skb->len;
+		void *pad = skb_put(skb, pad_len);
+
+		memset(pad, 0, pad_len);
+	}
 
 	skb->csum = 0;
 	skb->ip_summed = CHECKSUM_PARTIAL;


