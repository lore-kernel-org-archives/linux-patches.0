Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037450;
	b=AkBX0V93OVDKa1rp689KmdGL/NZZjTkl1fv3dW1OLq9IIQqpPvzCu4vUA1O+5CJZAB5x
	 QNQ55mrZWvCEipYnNsN+wb9N+G/8H4/lm1+Yi89ey/HvLQAq1vqOxVYKr/Z4EJGJBG7kF
	 WfL9MDhzAAn+TJYfFOb0gMvs4ilDqc3FouUb6ztdP3TuAaQgC01WiMnAXBLgmS6pOmCBW
	 b5BqK2L9EYtpBHRQwwYsScTUO2uHhjDZekt/Lh5/5IeCF09xChm9uc6XY+NZg5GeWR3RM
	 Wogdv2vaTkSUoHGXKO0zLeOFvTY7txMrTDSsgvSLwfyT/H4YtBhfGZWtxAZsveTVSvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037450;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Pk+fF8qDE4bDRlFogPbMOZZCEERRB/GnstjBAPQHJhg=;
	b=bnDoDJDyTSr8C186tMvp3gdsebscgf0YMneGssNaZkNeBTq1BGpXY5XYyXSOnj9fncFm
	 TUqqFzZeLfdXr9/dtDUbfifKuQmhmG/fO0qSUENQohCyP1xO2cMJdEXIJ9Ude5kGsK1rB
	 Agw1nK213AX55WxwFf9H1jgi+aOKPEWPBiOKS4acjVruemCctGy+AxaufBJu1MX3lziMI
	 LFE3u/YKFlF5kxx/fpNMw2Hgq32oNOJbtT8AtC2T8GaDRZpDrDzp/ejoiKy7rZaEFmssZ
	 x+piyjntDCcD+hChFf7oKyYSPkc/8PEf217LNf+WBA4Xm5Ln50k+YAPcbLxJEEwvLrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ru2i7Ghd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E163606A32A;
	Wed, 18 Nov 2026 21:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ru2i7Ghd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97B231F000C4;
	Wed, 18 Nov 2026 21:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037450;
	bh=Pk+fF8qDE4bDRlFogPbMOZZCEERRB/GnstjBAPQHJhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ru2i7Ghd3FxCvZe/+ebGKoI0iYtprAVCDMH2kl7FqNhzrITDplW00s//DbG7sSRlk
	 SJokcIIe6Vgc+5br7Di3fiYQgF/pu2rNcw/bD04V6BxN6CIaDQQZ2+c+IpEzmxwWWS
	 iVFz8I8ZAHOK8r80tzjMT1Hz/0Ucp7kiYpEex7Hw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifei Gao <gyf161023@gmail.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1403/3318] 9p/xen: fix refcount leak in p9_xen_response() on wrong tag
Date: Wed, 18 Nov 2026 15:33:45 +0100
Message-ID: <20261118150402.707878083@linuxfoundation.org>
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
index 7709be0fa5417..3008b3db923a9 100644
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



