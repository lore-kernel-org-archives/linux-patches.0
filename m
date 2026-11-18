Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053204;
	b=sWz5+y9QtiVHAF0gA10PME4ZNdGesZ5lGOfpjauCvOINdg/sXDwdMsfkr5t9sVdTbvti
	 hXEvYuDTacEP8JNZ5a0ZjpFudISFR1aQ3dnh2lwVkEycMWU3v5FYvy7uhgg0h2Fr4Hxe1
	 vjblwOVMQ6tgRbgcS74mn7FH/yFU9QlzKe0yywR2bovUT1FvIvje+XnzABmgavbwHmBN9
	 OL646mq7vAFG74JINbN+KNryXY7+GcCTBb7bwMLbQDCH2GB9N3o9f622JmtzlziU6pCJM
	 9sVKZ2jze5pY94ofHO4kT2DnWEXfSXi4ntMUusc7dqEj7VH7HSiao0qBvpAVDGhk5KQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053204;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eP+UJteA3MkdQOUPwztIFVXXY5yPft1JxU9KwvYxZvs=;
	b=P7k3sstbTCVkfMR8JofZUjU6N+suuYhASuCwgHIqSr80Jzp13A4WbCqMhXJ0lnu9IghZ
	 hmODhmuIPdT1C0E+G1aSTfn8CdPaCyyBsAAlxmLrlAE19W6FbVWV7Epphpy3X3VjAnSVP
	 tubcfDT7A060hFvewSM8ucJqgrIyCwu3/mUn8c/QlM7gmbu+hQUUiEBIz/lOcVAiut3EW
	 fJ3To9+KhQW0TxMzUi1Zo0IPpwWwlt6TycuGE8q3kCfKf/Evc7fXhYR/OE4QQJ7TOKP/8
	 0P1+0RzM0ToyqdU0BcDrpIR4o7OJl6duSXDIwSFhi27+66jOQxNfPbCn6zlS4JXxRjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="2oBgl/Ki";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EFE0606A31C;
	Thu, 19 Nov 2026 01:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2oBgl/Ki
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90BD41F000C4;
	Thu, 19 Nov 2026 01:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053204;
	bh=eP+UJteA3MkdQOUPwztIFVXXY5yPft1JxU9KwvYxZvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2oBgl/KiEoljv7PSpPpez7pJeFO1BaWjRWvwg2mj6RuBG0KKCojlbkyhJT8hFFeoI
	 aqK95BQb+kC9WSCKO2/JYx3dUz82PhOpgzGyMd0kXNpKxGCsziEexhbksG9C79v3jb
	 0p3wgJnC6YwPu7euUHSvtLMbGhua2xkHdWrtLX7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifei Gao <gyf161023@gmail.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0834/2214] 9p/xen: fix refcount leak in p9_xen_response() on wrong tag
Date: Wed, 18 Nov 2026 15:41:50 +0100
Message-ID: <20261118150045.410652897@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yifei Gao <gyf161023@gmail.com>

[ Upstream commit 4d183e6f153245aca2534e372152583b868dd925 ]

p9_xen_response() looks up the request for an incoming reply with
p9_tag_lookup(), which takes a reference on the returned p9_req_t. When
the tag does not resolve to a request in REQ_STATUS_SENT, the function
warns and continues the loop without dropping that reference, permanently
leaking the p9_req_t and its msize buffers. The reply header, including
the tag, is supplied by the backend, so a malicious or buggy 9P backend
can leak kernel memory on every crafted response.

Drop the reference before continuing.

Fixes: 728356dedeff ("9p: Add refcount to p9_req_t")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Yifei Gao <gyf161023@gmail.com>
Reviewed-by: Stefano Stabellini <sstabellini@kernel.org>
Message-ID: <20260806144255.4167019-1-gyf161023@gmail.com>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/trans_xen.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/9p/trans_xen.c b/net/9p/trans_xen.c
index 6644ae8cc55ad..35c5ba70e05df 100644
--- a/net/9p/trans_xen.c
+++ b/net/9p/trans_xen.c
@@ -225,6 +225,8 @@ static void p9_xen_response(struct work_struct *work)
 		req = p9_tag_lookup(priv->client, h.tag);
 		if (!req || req->status != REQ_STATUS_SENT) {
 			dev_warn(&priv->dev->dev, "Wrong req tag=%x\n", h.tag);
+			if (req)
+				p9_req_put(priv->client, req);
 			cons += h.size;
 			virt_mb();
 			ring->intf->in_cons = cons;
-- 
2.53.0



