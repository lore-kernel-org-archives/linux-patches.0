Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC922479860;
	Sat, 12 Sep 2026 11:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213393; cv=none; b=Fvw6YoM+3uCf2kv3x0nm85ijquK8Mdo0FTl5z+KAZCd9kp3ApzWGCu2e8totvS5ptiO3ZP5yz25apzNB3GFM+IqSxEyONEn6lbY45tWxB8ZUXcd8G69L+EG6/e3aohq/1gFbe1scZWPxuE2gpyvWQI5uEVbClxYbtBOupDhspG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213393; c=relaxed/simple;
	bh=RDbckOZSgofmIk0e87QfnkWG77gyOmRGDfeSZUAyub8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EMNWLuFLDEZ6L01MiQnzFIqm1hIx+HNYUVFeDCne03ALHmO5JobeFIzs00ft96Z8f/c/GyVmDzTvZ33hGaIAj4SP+qa2U3O/X7JiKCiCfz55I9Tnhwh6c2i7IHojc0SYsNy5QVTcvcvHPYAQo+SsWenneKOue8R2OwxI8yap3kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FNJA7LP/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FNJA7LP/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E31E1F000FF;
	Sat, 12 Sep 2026 11:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213390;
	bh=YHrkEk1YYfoaMwLxan46k44bipiQSJPeLS3BOht5wYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FNJA7LP/SEURI/4XL73ZUFlFDU7zrHEfN0awNJHZL2dvjaz7dORTIt9Y9RVKdSoFN
	 zTuNIx0WWDAHklf3W05cH45xLyU2LrElWREfz6pVj0RvqQmldbGuucG62X2LSmI9tq
	 TV7t/wS3M2uCR4LTSJTvNY40GorBudxNbak1zGy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.12 0112/1376] batman-adv: fix stale receive device on merged fragments
Date: Sat, 12 Sep 2026 08:42:18 +0200
Message-ID: <20260912065610.051167256@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Zhiling Zou <zhilinz@nebusec.ai>

commit ad46c907d7d9975a285c1e89a4adde652eaa93f5 upstream.

Fragment reassembly reuses the skb from the highest-numbered buffered
fragment as the merged packet. When that fragment was received on a hard
interface which is deleted before the chain completes, the merged skb can
re-enter the receive path with a stale skb->dev and skb_iif.

batadv_batman_skb_recv() passes such merged packets through the normal
receive handlers again. DAT and bridge loop avoidance both derive the ARP
header length from skb->dev, so they can dereference the freed net_device
before the packet reaches the local mesh interface.

Refresh the receive device metadata from the current receive device before
running the packet handlers. This keeps internally reinjected merged
fragments consistent with the normal receive path after hard interface
teardown.

Fixes: 610bfc6bc99b ("batman-adv: Receive fragmented packets and merge")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/main.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/batman-adv/main.c
+++ b/net/batman-adv/main.c
@@ -458,6 +458,10 @@ int batadv_batman_skb_recv(struct sk_buf
 	if (!skb)
 		goto err_put;
 
+	/* Merged fragments re-enter here with reused skb metadata. */
+	skb->dev = dev;
+	skb->skb_iif = dev->ifindex;
+
 	/* packet should hold at least type and version */
 	if (unlikely(!pskb_may_pull(skb, 2)))
 		goto err_free;


