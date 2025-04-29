Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D164E2AE96;
	Tue, 29 Apr 2025 18:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949903; cv=none; b=j5gDZNU+8wDOVhL2+DAg7EgDjJ1jkGsC+PYxSPQ9Crj4sHuxBX7o2Jq31KdRo5LlWDHuU1I7f9lS3yhf7+IKqSlD8zqoswvEEBnatKuohV9RssE8HcduAfEhl7qtrMvrmMwLFxX+tKmD+aPC5NzTx0jIxJ6fLZK2MpkFmwPrILc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949903; c=relaxed/simple;
	bh=fRCZfAp8lrLvFJlGfg8Puyr48Q3X7WayRhieLUeVzMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a/Yo0q5zkngWO//VXpoCOJr3vI/6NckcVj16f6424vYYmPiOOx/eIat5cW38nPoqxC+N7uPdJPhGdsxWds14YEYDc7c7X17vfJqiexmyAp1L5c0V/24uBTTYCZZAw8ROwpp/40dAOuaPhNbjLroOTEmDhbBS9np6iBbR+HKqWck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YEhOMZOn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YEhOMZOn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42099C4CEE3;
	Tue, 29 Apr 2025 18:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949903;
	bh=fRCZfAp8lrLvFJlGfg8Puyr48Q3X7WayRhieLUeVzMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YEhOMZOnQZdjxSnWXCIqpLoWmjNBM8nan7zb79TMEpCGbcViX2RKyGUX7vxy1jdxo
	 qMZoLhUBHn54svsloYuGlfIpb4WZN9RnVv95L3eCQd0rWi2TPlFVl0JluT5wPaZhY6
	 BFldYPdj4MuAr54RtFsLTSS6YJWssDspAOnJVq38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.1 064/167] net: selftests: initialize TCP header and skb payload with zero
Date: Tue, 29 Apr 2025 18:42:52 +0200
Message-ID: <20250429161054.365774969@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


