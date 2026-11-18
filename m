Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042535;
	b=lWqp7Tyj/r63YYUc3QaUMw77vyA1ejgh5Rp3ai/DJ+UlQ8CbY1dX0efmDeQXnY7ZcRg1
	 PCbe/JiGSqSux+nWPvYaDhTFtqHD1UtriLnde+UyxnAZZzbwD7ecTeADf98c67SaX213B
	 oRkIG0HJrFGnAER17/uw4pbpeXHfcCN923eVQloRxyD5dYebBA97jBvAv9SoLBwujHgul
	 Y0DNWGMqyTHyvLgmxh6hzjk/ngwZ8RTRvpDyXjkzy1psrcOdDEJgM4dEm+eETplgIZsmM
	 kBdkq7Ahk1TakAtBKWVukZzP5QDtot+aYF3ZVRohAfQxVFhISoMyjKRiqnlL2F0US4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042535;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XLQAW2QxwIJ+urR9h9i3g7cJWVbVDP643B1ERCQNLxU=;
	b=PY8EoTGWvAKSRGZbYb6ztUVJPRbw6sPMrDNOPM+7i7kbtuFLZIKamsB6C+8JJpP+37XN
	 oirN9TAOIQx4HjX1J8LhLv0mkCNhhBtprSIHtdFSZZ1bGFrgNK/ngV44vcaXeP2e9tJr/
	 QDj5zk+jl5QtAl44eJg93GAzyHHCsGBH8qqLchlawZJ1pq7QgWjoFFauFccxcZ6AQa8T9
	 gh15d8haXL2majIDBKxSjWn3BSaTtE6cBmk32W3cjzlURzsWoplBCTHDQIHbHIR6L7S88
	 DrhGM7Z1U/bbGJQDeEwqxc2U0E3tP7VM/lqJLQxo6eDBjb/yDssysM4xwoVP/v/5cFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ThsQFBAo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F1CA606A31C;
	Wed, 18 Nov 2026 22:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ThsQFBAo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FF2C1F000C4;
	Wed, 18 Nov 2026 22:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042535;
	bh=XLQAW2QxwIJ+urR9h9i3g7cJWVbVDP643B1ERCQNLxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ThsQFBAo0M9RZRf7m4WBg01anlFVJMm8fwflDtt1lbsHuYnaS3DhjEwLNb/i8FZjX
	 lGhaFPrWIf5eIncgxRhOW4OBQHewGd6+XauPPgWfgxMLepKaeSSJwoqJCzPAXkIiKb
	 ij5RD49BpoOgPD5Ehna1bW3z+SAp9h6IcUukSMe4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ayushman Rout <ayushmanrout27@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3155/3318] bpf: Use memmove() to load bytes from an skb and an xdp_buff
Date: Wed, 18 Nov 2026 16:02:57 +0100
Message-ID: <20261118150454.512883909@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ayushman Rout <ayushmanrout27@gmail.com>

[ Upstream commit b93cf2c8a0552b544e90e25802e4bf989987d29d ]

bpf_dynptr_read() on an skb or xdp dynptr ends in bpf_skb_load_bytes()
or bpf_xdp_load_bytes(). The destination can be a slice of the same
packet, so it can overlap the source, which memcpy() does not allow.
On x86 with FSRM memcpy() copies forward, so a destination above the
source gets the first bytes repeated:

  p = bpf_dynptr_slice_rdwr(&ptr, 8, NULL, 64);
  bpf_dynptr_read(p, 64, &ptr, 0, 0);

leaves bytes 8-71 of the packet as bytes 0-7 repeated, not bytes 0-63.
Reproduced with BPF_PROG_TEST_RUN on both an xdp and a tc program.

Use memmove(), as the store side does since commit 1db084f42884
("bpf: Use memmove() to store bytes in an skb") and commit ab08863c58b1
("bpf: Use memmove() to store bytes in an xdp_buff"). A read that spans
xdp frags still goes through bpf_xdp_copy_buf() and is not changed
here.

bpf_skb_load_bytes_relative() has the same pattern and is reachable
from tc and sk_filter programs, so use memmove() there as well.
Reproduced with BPF_PROG_TEST_RUN on a tc program: loading into a
slice at offset 8 gave wrong bytes before the change and correct
bytes after.

Fixes: 2012c867c800 ("bpf: verifier: Accept dynptr mem as mem in helpers")
Signed-off-by: Ayushman Rout <ayushmanrout27@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261022112312.31563-1-ayushmanrout27@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index ce6014191ed05..5f020d8c9c2b4 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -1764,7 +1764,7 @@ BPF_CALL_4(bpf_skb_load_bytes, const struct sk_buff *, skb, u32, offset,
 	if (unlikely(!ptr))
 		goto err_clear;
 	if (ptr != to)
-		memcpy(to, ptr, len);
+		memmove(to, ptr, len);
 
 	return 0;
 err_clear:
@@ -1846,7 +1846,7 @@ BPF_CALL_5(bpf_skb_load_bytes_relative, const struct sk_buff *, skb,
 	ptr = start + offset;
 
 	if (likely(ptr + len <= end)) {
-		memcpy(to, ptr, len);
+		memmove(to, ptr, len);
 		return 0;
 	}
 
@@ -4132,7 +4132,7 @@ BPF_CALL_4(bpf_xdp_load_bytes, struct xdp_buff *, xdp, u32, offset,
 	if (!ptr)
 		bpf_xdp_copy_buf(xdp, offset, buf, len, false);
 	else
-		memcpy(buf, ptr, len);
+		memmove(buf, ptr, len);
 
 	return 0;
 }
-- 
2.53.0



