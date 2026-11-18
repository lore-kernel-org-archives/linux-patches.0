Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046192;
	b=KysOsvhvuxEM2rd7mWNLAkHeedbi5fnVuRlpzB45pOy14xazKkTD5bDdyY4hXv1LIZCP
	 uAPaY/jB0iZVJq/zkClP460S1x60UBbCkmFiovfL+x44CmWL7F5zbpCxbYMBlHh/95tqa
	 Q1f/3yvhc4pF2OR1DEQgYb6WzI7dnZ4tS3feiPeSAZisRwbcc4UaBboJ0mE4o6p1oAAJU
	 OP1BQa+1L2vus65o9RXFrSrTXYwq2V5bIu/UixPZXd2dz5pQlkTCHr9mjNGeQ9z+uTvwh
	 u5U7+9A1SAWYG3Wwq1XRFcOn942PzH7pGiBCKnm4LTrLJK33T0qeyFOHwlj9U/FR0iw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046192;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=59gIEvLmH6pBvpCBWZnlqv3ACRevcfr8SEH+AuiCOJA=;
	b=kHf2HwpsjFHyV8FEHs941R31LzY/xc1wI5IDW6D099Q0Un0e2K+jikzThqeYyZgWQ01u
	 cCqi8zk0IBJfg8ti9mTlGlnEooYkFWHeDb0ZnXfmb6CVTFUvZVyBGo2lnBsi3ahYJSnJp
	 110pCRheitxWZQfgpCLhbt4ImxirgsjI5qjNe3i96kP4h8FtSJSeqP5t3gElXBx4Bmj4w
	 ql6jLnckXWB8f8JdiSAsJQ4PP+x6ycHKoojNPeGFm4oqfBmEMIlPoX0d7qx+nsg//EG++
	 9kiOXDVGrWnA1na+rYhpTywgkjyXklANLf1N08VyIWqgn/eR9Lf2GK8LyyRFY5WQK+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZN1HWo5z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B112F606A31C;
	Wed, 18 Nov 2026 23:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZN1HWo5z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C683F1F000C5;
	Wed, 18 Nov 2026 23:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046192;
	bh=59gIEvLmH6pBvpCBWZnlqv3ACRevcfr8SEH+AuiCOJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZN1HWo5zGjbTnHUCfTqZjw38xJbvtsw1oZjx2RQRvQSVp2epj8tL3EIxPQYTmfzLv
	 CzgPdqK7V6SeuZd+9NyFpQ3v8gLjQgOlz5+AhNtLV9LLeXcTE+PuUHtsLOe2wjfaAF
	 UiUpmdMht95rJDSGN97D4g2T8JizF9pvlUjfyDNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifei Gao <gyf161023@gmail.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1192/2857] 9p/xen: fix refcount leak in p9_xen_response() on wrong tag
Date: Wed, 18 Nov 2026 15:37:06 +0100
Message-ID: <20261118150244.527893881@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 7b3d18f96dce4..4b712a040ef4b 100644
--- a/net/9p/trans_xen.c
+++ b/net/9p/trans_xen.c
@@ -202,6 +202,8 @@ static void p9_xen_response(struct work_struct *work)
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



