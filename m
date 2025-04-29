Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B63E2522A1;
	Tue, 29 Apr 2025 17:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949370; cv=none; b=NeO1TJXBuN9negzjXIEPWFN7c/7kSFCmmBVG6d73cXzqkMhk6C5XT75J5G9ffpHv9nmhXu+HXo9r24PekJdqfYMo4lLlptbzWZstWmb2ck/lpaoiVUPxn+qjst36Pzb0/7wxBQ2NMBoMu24j4PLLkPlfXbpKjGHwXD0zRx78jrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949370; c=relaxed/simple;
	bh=OLjq3wRhvHgdLSsC4nRAE4pr4R/M2rSHlJoewUsyHq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q8vfcWr05as40MiyZFuHb1hjYK/q1jbIrmoY+TTbzrMj89R7nYR+Of4vZbqX2EMd7SpULfRIehZwoc+UE0WSlkYunB5cYBV53LrfABeMJouWQCvXpO5ZT0k3PBFO/yBqPTNebtfVPH4RK8fELrxw4423LQo+uF26d8rCKSDISb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CGkyfCUy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CGkyfCUy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54B4EC4CEEA;
	Tue, 29 Apr 2025 17:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949370;
	bh=OLjq3wRhvHgdLSsC4nRAE4pr4R/M2rSHlJoewUsyHq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CGkyfCUyiumlmzEwvc+EcKtvZNvTKtkWO7cDAfnBNtgSGgfUAdcWyaE4AIP7tgkKX
	 odMLchMJXoMmQRTTKMcyUDGOUf1E3kYyUUjMli3OmDnI9QaprgA3G5yzzUgw3MZ/dT
	 11OGfArYt1aVbYkW0YUIRcqUqOPrKKnI0ndFrtmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.15 298/373] net: selftests: initialize TCP header and skb payload with zero
Date: Tue, 29 Apr 2025 18:42:55 +0200
Message-ID: <20250429161135.371175732@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


