Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23FF12BEFEB;
	Thu, 25 Jun 2026 13:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782392761; cv=none; b=WBgzp6z66DyC3x7Q2O7SKl6wUOMrJrS5WSLF8hFEW0G1ZcKyaX8Mymzp27vl2VmwQxs6lrwt4+/giurB2pA6hTnOcC6Zz9zyPOatI4ve9cyS1ovo3RqcnTfg0nydzJCEUWKYNbrHZ1BbVY2I5xedA7dzlmixBUIe6fYqggn+Wz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782392761; c=relaxed/simple;
	bh=RTC6KG+Eh7aLMX6oXWV5bQDLpVefm1TjVKgrkz6MVOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P4aicPRViSStv3mOjovgcaiCKHcV2z/X4bpzguBtnPK7tGFE109cTx0bueFxBgrdryN4HzjLy+RJ40bV0d/yOtBsAsVF8qcqK94h9dzLwLAHMLd5TpvDaQb1YxLI6HT4CQIKlTuHtmxECGbx9xO/DK2TxdKG5tY5j/lLy0q1w0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1mFxLKxU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1mFxLKxU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6348C1F000E9;
	Thu, 25 Jun 2026 13:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782392760;
	bh=vM2qVM0ha5iuij0nsKC9DoTWSTF4tpVYQ66h55PEHK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1mFxLKxUxZBF2PUMNk0qOsPziBSznWi61js4iZHRMF+5LvY/tE600tKwWaEp38zmq
	 X+GF/XKeu3PO/2opNPB42VPXyZfvGSuKuJFVw3T9tm1Ktz4h4Ve6RavUhS9k4N0JH7
	 QB+LZNIr/ZOXOGngwigAeWzPzPOkl9y7HOGhl/Jk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>
Subject: [PATCH 6.18 15/60] rose: hold loopback neighbour reference across timer callback
Date: Thu, 25 Jun 2026 14:03:00 +0100
Message-ID: <20260625125647.776640491@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260625125645.554579168@linuxfoundation.org>
References: <20260625125645.554579168@linuxfoundation.org>
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

From: Bernard Pidoux <bernard.f6bvp@gmail.com>

commit d270a7a5793af84555c40dd1eb80f1d497fdf53c upstream.

rose_loopback_timer() dereferences rose_loopback_neigh throughout its
body but holds no reference on it.  A concurrent rose_loopback_clear()
followed by rose_add_loopback_neigh() could free and reallocate the
neighbour while the timer body is running, causing a use-after-free.

Take a reference with rose_neigh_hold() at the start of the callback
(bailing out if the pointer is already NULL) and release it with
rose_neigh_put() at the single exit point.  The neigh cannot be freed
while the callback holds a reference.

Fixes: d860d1faa6b2 ("net: rose: convert 'use' field to refcount_t")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rose/rose_loopback.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/net/rose/rose_loopback.c
+++ b/net/rose/rose_loopback.c
@@ -66,10 +66,15 @@ static void rose_loopback_timer(struct t
 	unsigned int lci_i, lci_o;
 	int count;
 
+	if (rose_loopback_neigh)
+		rose_neigh_hold(rose_loopback_neigh);
+	else
+		return;
+
 	for (count = 0; count < ROSE_LOOPBACK_LIMIT; count++) {
 		skb = skb_dequeue(&loopback_queue);
 		if (!skb)
-			return;
+			goto out;
 		if (skb->len < ROSE_MIN_LEN) {
 			kfree_skb(skb);
 			continue;
@@ -109,6 +114,10 @@ static void rose_loopback_timer(struct t
 			kfree_skb(skb);
 		}
 	}
+
+out:
+	rose_neigh_put(rose_loopback_neigh);
+
 	if (!skb_queue_empty(&loopback_queue))
 		mod_timer(&loopback_timer, jiffies + 1);
 }


