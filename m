Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3C4E4F55B6;
	Wed, 30 Sep 2026 16:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787212; cv=none; b=IEUoH1Q3DZKv9QO9DtE3T+uP8ubBHkUvdEdyy90wwZgRe2U/HkYA8iwlRzM9qAMcJH3qgMfd773J/1yOpw6Vxh4XIOP6UrI9ihGmhSHe7yCP2BNtdtxHM41CTwtMTF7z5Tvnpw6n6OlsTK/ykS1IXROhmmsZzY6x1/wj1KOLxdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787212; c=relaxed/simple;
	bh=7MJanDDZCj+JxFjMTLK5NtsFYa6BSAKZ8Wt94rZRj/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c3wnXDvWJAi+ap9mPK4DYvinPXF+w4CUIhmgccIkw9RQswsxqDc/UQ8Lx9pH4SohgjUzxpETCRRaO2hS95Mv1S+8z8O129xa4gOwSl3j+uqQR9bS0ztRm/PhXIdUtOcgs5RXkyueIoIZY6JYestDnJO0hk+Nc2nYp5WntKlGAC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GI53EKyt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GI53EKyt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F8EE1F000FF;
	Wed, 30 Sep 2026 16:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787211;
	bh=2Eidy5OdI9GUzlrushbgIiKhuxCMVveudr+rO6Mm2Uw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GI53EKytJPI9Yj92SCvk2VvvgN/rL60ELg8GodMFhxgmb7fIMUmgRopz/JYnxJdY4
	 o3AFn0+Fmy3Z025CqjXKA37IZpKSaodmGmrRMZCBZuRn/vBD9629lRdRNx+QpRUMva
	 TZcPPJ+2f/k93VkajRRkW1baYCY/kyPr0mxas+HY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Carlini <nicholas@carlini.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 149/457] bpf: Fix bounds check for skb-backed dynptrs
Date: Wed, 30 Sep 2026 17:24:14 +0200
Message-ID: <20260930152349.267742745@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index f7dd3db9459c6..039f3c38743ca 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -4372,7 +4372,10 @@ skb_header_pointer_careful(const struct sk_buff *skb, int offset,
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



