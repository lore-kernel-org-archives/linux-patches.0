Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 500C1318EC5;
	Thu,  2 Jul 2026 16:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010998; cv=none; b=uLRBptsf87/4VdJR5by6VLFvnQ7Uq9XyZB/BcB4/RLidTr4m0Z9CJuop6TumDuclVvQ6rqXEfvAQ2pCVmtXxjhidyCf0JX5bh0evBrz9+FfyMkJVWybwnMMD+VYiXv8RolD+N3uNMk2ZO1Z3j3XSjoD2aMEqi65A6DhLDJ4FjaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010998; c=relaxed/simple;
	bh=NQtKL1xkCrAXl6afsY3aC1KJ5oODsUxIoVLbOAp/+N8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iehFS7dKcXkvR1sgZGPT6yF7dDAmDPWtk41nkq8wKIZYamyQZ2BROq+dfNTz9F+jY/YIjwX9wpl6jxOraoSZJox0XryLdbHxTU5m+B+oOQZIomKYLu3XJwNZ6Os3L4kOyvSVhetUBTWsat5RXy/aV7SmUJUPa4OfwEAjq2vq4tQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nRfARHpJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nRfARHpJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B71671F000E9;
	Thu,  2 Jul 2026 16:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010997;
	bh=Tg1Gnmux8MtZCR5FqVvWKGded2fORlvZ0Hl3GtBilnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nRfARHpJpP2p+iGUVm9a/qaKJXAsa08WqYAxu2pej4Qm/Olqrl4B3MQvR9k7EQ0zQ
	 wk2IaWnNeaAhZXyQFQaxA2COAUGXtX5eNh/95beNEOLBYWK4f6oHujM7j8hMuldyue
	 f27e7KhLcrbNGPXVDEHQhNdYVYnBZOMNU0wE7hDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Willem de Bruijn <willemb@google.com>,
	Brian Vazquez <brianvv@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 117/175] inet: add indirect call wrapper for getfrag() calls
Date: Thu,  2 Jul 2026 18:20:18 +0200
Message-ID: <20260702155118.220367445@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155115.766838875@linuxfoundation.org>
References: <20260702155115.766838875@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 5204ccbfa22358f95afd031a3f337e6d9a74baea ]

UDP send path suffers from one indirect call to ip_generic_getfrag()

We can use INDIRECT_CALL_1() to avoid it.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Brian Vazquez <brianvv@google.com>
Link: https://patch.msgid.link/20241203173617.2595451-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: eca856950f7c ("ipv4: account for fraggap on the paged allocation path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ip_output.c  | 13 +++++++++----
 net/ipv6/ip6_output.c | 13 ++++++++-----
 2 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 305d0e2786a2a8..fb1d8be8c6757c 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1168,7 +1168,10 @@ static int __ip_append_data(struct sock *sk,
 			/* [!] NOTE: copy will be negative if pagedlen>0
 			 * because then the equation reduces to -fraggap.
 			 */
-			if (copy > 0 && getfrag(from, data + transhdrlen, offset, copy, fraggap, skb) < 0) {
+			if (copy > 0 &&
+			    INDIRECT_CALL_1(getfrag, ip_generic_getfrag,
+					    from, data + transhdrlen, offset,
+					    copy, fraggap, skb) < 0) {
 				err = -EFAULT;
 				kfree_skb(skb);
 				goto error;
@@ -1212,8 +1215,9 @@ static int __ip_append_data(struct sock *sk,
 			unsigned int off;
 
 			off = skb->len;
-			if (getfrag(from, skb_put(skb, copy),
-					offset, copy, off, skb) < 0) {
+			if (INDIRECT_CALL_1(getfrag, ip_generic_getfrag,
+					    from, skb_put(skb, copy),
+					    offset, copy, off, skb) < 0) {
 				__skb_trim(skb, off);
 				err = -EFAULT;
 				goto error;
@@ -1253,7 +1257,8 @@ static int __ip_append_data(struct sock *sk,
 				get_page(pfrag->page);
 			}
 			copy = min_t(int, copy, pfrag->size - pfrag->offset);
-			if (getfrag(from,
+			if (INDIRECT_CALL_1(getfrag, ip_generic_getfrag,
+				    from,
 				    page_address(pfrag->page) + pfrag->offset,
 				    offset, copy, skb->len, skb) < 0)
 				goto error_efault;
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 9a08ee6f52da0f..2e2cd0e0d48a5d 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1695,8 +1695,9 @@ static int __ip6_append_data(struct sock *sk,
 				pskb_trim_unique(skb_prev, maxfraglen);
 			}
 			if (copy > 0 &&
-			    getfrag(from, data + transhdrlen, offset,
-				    copy, fraggap, skb) < 0) {
+			    INDIRECT_CALL_1(getfrag, ip_generic_getfrag,
+					   from, data + transhdrlen, offset,
+					   copy, fraggap, skb) < 0) {
 				err = -EFAULT;
 				kfree_skb(skb);
 				goto error;
@@ -1740,8 +1741,9 @@ static int __ip6_append_data(struct sock *sk,
 			unsigned int off;
 
 			off = skb->len;
-			if (getfrag(from, skb_put(skb, copy),
-						offset, copy, off, skb) < 0) {
+			if (INDIRECT_CALL_1(getfrag, ip_generic_getfrag,
+					    from, skb_put(skb, copy),
+					    offset, copy, off, skb) < 0) {
 				__skb_trim(skb, off);
 				err = -EFAULT;
 				goto error;
@@ -1781,7 +1783,8 @@ static int __ip6_append_data(struct sock *sk,
 				get_page(pfrag->page);
 			}
 			copy = min_t(int, copy, pfrag->size - pfrag->offset);
-			if (getfrag(from,
+			if (INDIRECT_CALL_1(getfrag, ip_generic_getfrag,
+				    from,
 				    page_address(pfrag->page) + pfrag->offset,
 				    offset, copy, skb->len, skb) < 0)
 				goto error_efault;
-- 
2.53.0



