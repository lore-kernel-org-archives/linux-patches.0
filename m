Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98DA23515D1;
	Wed, 30 Sep 2026 19:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796761; cv=none; b=rM8rxpVk0nEv2/YIsOeyDXAzTFZhYP7IBscr889EtVR73NP0sM/gFLL7WbNu1BBCiugiw9UkDpM3w8Cdik/gdzDgdTTaRWIYMqaM5SpRF4ygD20Nwrrn6PY6g4lV0EbYk0h6A1k0DZZu0n7vx7hwxKXRUCN+gB6CuDnTPIyEwGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796761; c=relaxed/simple;
	bh=o516YH9RzyOMMV2hWvBJZ/ZLTO21AVM8I2Oi5fkoHOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZF5qUoukBp7QVdoW36Qjyx45hpNzTgKk8Bs+XrdA9JBBBNrxtVaeWNW743Mo9l1EsDMw1+MoCSk8/e+rX37CpWH1kF+qqlxVuy66b0kZsoX3fppoSEnCVw2/4gGr9YMpbaGVpPvA/pnRWvpC5ViXr7ddsj3eMgC4OUWypEeFR9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mnERxRIa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mnERxRIa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC4981F000FF;
	Wed, 30 Sep 2026 19:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796760;
	bh=5LQdkoJBVx5msBf6yM0JwH9ZOoPAebMuq0LC1koK0KM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mnERxRIaA46g4E4t4hw2OANQG9nt92Pha1YprgXSKQorAIM3/RKYp/0xrnAWbd4sM
	 CsnQ669sLCP+gFLtDZF+OeM8Uarq4DN2V8XNye8YYg/vxGoM/+J9mmNURZjDOCDWU+
	 V3LH+ob41Av9FPlNoUF42AxnvyCRoWolMtDARhNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Carlini <nicholas@carlini.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1026/1193] bpf: Fix bounds check for skb-backed dynptrs
Date: Wed, 30 Sep 2026 17:28:30 +0200
Message-ID: <20260930152457.028346268@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Emil Tsalapatis <emil@etsalapatis.com>

[ Upstream commit ed6eec97b534979dcf28b40c389cee57bd6561d4 ]

The skb_pointer_if_linear() function checks whether a
memory region of length len starting at offset off into
the skb is in the linear area, and returns a pointer to
the region if so. The check currently subtracts between
skb_headlen and offset of the check, and since skb_headlen
is unsigned the subtraction can underflow. This causes the
bounds check to spuriously pass and generate an arbitrary
pointer of the form *(skb->data + off).

The only user of this helper is currently skb-backed BPF
dynptr code. Returning the wrong pointer leads to the
dynptr erroneously being backed with invalid memory.

Ensure the subtraction cannot underflow, and fail the check if
it would. Use u64 arithmetic to also prevent overflow when
calculating (skb_headlen(skb) - off) since off is unsigned.

Fixes: 6f5a630d7c57 ("bpf, net: Introduce skb_pointer_if_linear().")
Reported-by: Nicholas Carlini <nicholas@carlini.com>
Signed-off-by: Emil Tsalapatis <emil@etsalapatis.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Reviewed-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Link: https://patch.msgid.link/20260922172028.6269-2-emil@etsalapatis.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/skbuff.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 1a91645fa2497..60462d64c6e0e 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -4161,7 +4161,10 @@ skb_header_pointer_careful(const struct sk_buff *skb, int offset,
 static inline void * __must_check
 skb_pointer_if_linear(const struct sk_buff *skb, int offset, int len)
 {
-	if (likely(skb_headlen(skb) - offset >= len))
+	unsigned int uoffset = (unsigned int)offset;
+
+	if (likely(uoffset <= skb_headlen(skb) &&
+		   (unsigned int)len <= skb_headlen(skb) - uoffset))
 		return skb->data + offset;
 	return NULL;
 }
-- 
2.53.0



