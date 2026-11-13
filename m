Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585373;
	b=qPKRvXSX31c757DVxOQiBdNTbgpS7/pduFgS9gVJtc/lFug0/Btzcsh+Qjps5ogH1AvW
	 9oTsWfc59/cZNa9eNjJGCITZgYxCRVPRzyl3kgnftN3oNa6WZxwxma4Y6QY92pQom643t
	 tAvH2atzJE/sx41CGbAuJABEvXlIwtWz4/2B+akOSeZ+oOvhkJcU12fggstnNYC1wkyvE
	 JJklfaGEG3sSBHwKpdXfJ0nb5A4/MC4vEt7zqGHvBg/F9Ed59F2rK29Uv2Bmi3WUT8qT7
	 /Cj6uOSCHSaQ6VN7AVmTptbiByAjgPGQWXKoOVDeJqUpwYn7OWI8jIKoHPAW3aUF4Ag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585373;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lROL/kCC2rh7hXZ3Xu1tWTod+u7aM9Xf8ISSZ0keH3Q=;
	b=eLoNA6CIcrHuSbVVwViSHdZBABGSEUngZJ7Gm+qaTiJLi2SRGp/oLCsz6vFZaFhmK/ki
	 Fqi04Q8699EiL1I08mhA5II7vRbIdlm6NRyQBArUzM4Y9S3NLxlieTIGeYbIVjufsq1ge
	 01o3klvNFJIMsP94OFnxhJp1ogN8UCanmQD6heYNWGm2YGFG2j+Bc7e72eERW8fuDxMiy
	 k7wvlpdnN0Fjyg64UPV7jxw4hyOJYBgle6bkFdoPt5mf2MDzMr0IiMoaX4WB/NhgYeODZ
	 07C8Rr0gVcUQMyRXLVGi4VyNJtxOXZiLrOkeyC+7Fo0J498WQYKZx0w1iVdc5V6UoWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z4eGoBU0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 468BD606AE26;
	Fri, 13 Nov 2026 15:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z4eGoBU0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2F5B1F000CA;
	Fri, 13 Nov 2026 15:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585372;
	bh=lROL/kCC2rh7hXZ3Xu1tWTod+u7aM9Xf8ISSZ0keH3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z4eGoBU00sQEXS2Z2Sm9B5bhf2ep/Kmq9QBfr8ZHG/EdDH/br9rpNRbNG+LAYs1r7
	 N9mdKHwU2JJMNXqu9om97fniEj57S9Sy6gcEG6/8PT8J8nJeo14NOtKuxQOtDY3EER
	 DPZPw/F/CNH228id8XNIwfhtVUqCCHR0pzkg2AbI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifei Gao <gyf161023@gmail.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 048/507] 9p/xen: fix refcount leak in p9_xen_response() on wrong tag
Date: Fri, 13 Nov 2026 10:45:52 -0500
Message-ID: <20261113153755.181023211@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index f9fb2db7a0663..8eea0da8797f4 100644
--- a/net/9p/trans_xen.c
+++ b/net/9p/trans_xen.c
@@ -203,6 +203,8 @@ static void p9_xen_response(struct work_struct *work)
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



