Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621234;
	b=Y93U8uqsUYXw03fMbvONFWCP8n5rq20lWfAExr/72zNC2jU7g8O5w4lkpINxZhni4sKf
	 grFDMxVSzWiSti3yZSmGMW7ssAWOZQ9eDPEXUnVXDE3bQLlH6zn5X8ZUST2SuesxM+jGs
	 /bMW3Kk63enUG3AiQaKW4hSyErS7yWT+jkL4luXmqlLeJcAC6YyVYoLzmWlwZFm1BHGP0
	 iB4LhBH3rv+m36vkWHuW6jEzAdw0zpN3YgGzw/qtSM1SYRjJmLqIOcapofiPm5BMLcYX5
	 iVPh8Mk1sZqUAUN2kFQPugPt51EeIbyq1d3JfMGDwgKJqCjnJ6+WRT/32hRkzmVA46A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621234;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IcG2hYi5iq6lyWYRv1C9QN8KyPTY6m5D2R2thafX/mU=;
	b=XaTwapWdhEr23FgXKvkquCTT4ci/qVZlWv0fO72cdFtLMuE/qsjmEkaS40kXXEKO7bpD
	 KPawqb5Mxk8650IoIAt3RP9R91Rqob42ssJCpHqpDFQ8x8SsEarHq54hXtPYh/zIJDYyz
	 QVRb/LGWqukk6I4hmafVMZ6lv8mhB7RDUEdYKe3TYaCdvAyus0j0uYBMj5xex2Ma31Fb1
	 WCexrA+WfY1MeO3Ob7EQPOeSdY/n+H/54OvhCZHTTi0hJX90U1SbDTucV3UZVk07xhGdT
	 b3uus6TQa/hHex88lO3DhTIKI5NwXH4erk4WpotbFpscQY8xUk2cC36wIYAAGlllAkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vCgLq8pg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B339C607DEBC;
	Wed, 25 Nov 2026 15:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vCgLq8pg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8205B1F000D0;
	Wed, 25 Nov 2026 15:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621234;
	bh=IcG2hYi5iq6lyWYRv1C9QN8KyPTY6m5D2R2thafX/mU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vCgLq8pgwu9AZRrnqbiPdlb4FW8sCC2Pvq8fx6aEd5Z5n+D9FxXa4E9LGyzFcXHkn
	 lY7zT99punkBM7GeonImDjVy34FbhstWgkqT1DrnYDNIOkVWxDdfp/8JBvY0jwGn4L
	 mUUhSHuFhjEZYjpJ2LFn4hyDPKX/I1gMjSKcBZT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 118/990] bpf: Dont let bpf_skb_adjust_room() raise gso_size to GSO_BY_FRAGS
Date: Wed, 25 Nov 2026 15:24:45 +0100
Message-ID: <20261125143824.851313127@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit 6d8118937ba477e03fa2e94e9bd9abac7291a2a2 ]

When bpf_skb_adjust_room() shrinks a TCP GSO skb, it adds the number of
removed bytes to gso_size. gso_size has 16 bits, and nothing checks the
sum. Thus gso_size can wrap to 0 or to a small size, or it can be
GSO_BY_FRAGS. GSO_BY_FRAGS is not a size. It tells skb_segment() to read
the length of each segment from the frag_list. If the TCP GSO skb has no
frag_list, skb_segment() dereferences a NULL pointer.

Return -ENOTSUPP and do not change the skb if the sum is GSO_BY_FRAGS or
larger. With BPF_F_ADJ_ROOM_FIXED_GSO the helper does not change gso_size,
so it shrinks the skb as before.

Fixes: 2be7e212d541 ("bpf: add bpf_skb_adjust_room helper")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261101190535.1454146-16-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/core/filter.c b/net/core/filter.c
index 8f92e2bf85517..9463c10d0c907 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3701,6 +3701,14 @@ static int bpf_skb_net_shrink(struct sk_buff *skb, u32 off, u32 len_diff,
 			return -ENOTSUPP;
 	}
 
+	/*
+	 * The MSS is raised by len_diff. It has 16 bits, and GSO_BY_FRAGS is
+	 * not a size.
+	 */
+	if (skb_is_gso(skb) && !(flags & BPF_F_ADJ_ROOM_FIXED_GSO) &&
+	    skb_shinfo(skb)->gso_size + len_diff >= GSO_BY_FRAGS)
+		return -ENOTSUPP;
+
 	ret = skb_unclone(skb, GFP_ATOMIC);
 	if (unlikely(ret < 0))
 		return ret;
-- 
2.53.0



