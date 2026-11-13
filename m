Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590237;
	b=j4hhKXJNu/GBB//yM2Y1qj7qWZMzUs4UIscjF0eZNcgb1RCuZ0ILHaz1EytiNYoFsYGO
	 XLf+neB+bQtpRj9EyzxLCnAzWhRHD18GM5M92aNZWNX4rcdY9ZYsk9Mc1HlEPYHEt+mAp
	 9VaGQrosychkWCZI0ZG6rx0Qq6oQhoHDOFAETG6vchU7FGNcm2iyb6XEKnap326TxJPdK
	 VVU0okxB1rLhYmFuAN/x1Wf+o+5e6tSLgaXs1FByDjaH4MgKWwPGehFn6/+r5VEjsg+dW
	 jCaaZ57PElwVu12HdLNIL7sMcS4sP+riz8XS22OKf57OyM/ZIejK8Nn3iBBHvYGEp1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590237;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=P7pTqfz0VRAtFSvavtqhV94qZs3NgUsCzlbx6zIQmUI=;
	b=NSJvhKk+fRmgA4xP6zkM5U8GrRLxTQNMut0OPC1xqFaBYUy7khj+nsOUWrkMQVwFb5h2
	 PbtCTjif2sauHhhNLp7mkJ/cY4L3U3Auo1FU3Ffb7Obg3fnjYfRjgFJ993mqxQ/wrCskd
	 X9fhamm63wwc+Bl9+by6uOj2GDWpYhfrigySvV1MTwFwoe/92GyPJnJK2XY4K5Cb/iil6
	 aHzcJaKBONU7xf45XlBCTsM5tZ5ojqVcfsW0pNaEyAWQXB3Wl0TYll/kMu9khC/6fg3Ke
	 NQu1fLYuSir2haKXFv/YCzPk3EkZTOVtvb6OON903y4emAbM5OZENiWFTcWRGSO41ag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PGMTGcm+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E48AA606C0BD;
	Fri, 13 Nov 2026 17:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PGMTGcm+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9054D1F000C4;
	Fri, 13 Nov 2026 17:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590236;
	bh=P7pTqfz0VRAtFSvavtqhV94qZs3NgUsCzlbx6zIQmUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PGMTGcm+g4PcsxXA3rJeWLANqFwZyVttrHeLjNAj+kgrochWz5M9x7K7PdA6CnWWh
	 HCzzALwmPiR28ChSkTmcsQmlR/E77fsCEkYZ/8D8QEDxnmpfBCR0blR0Huu7lu7QfT
	 gZslfi4bm7vKdE/uxDExeyVCBZtZr6SkF+JeIB4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifei Gao <gyf161023@gmail.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 183/686] 9p/xen: fix refcount leak in p9_xen_response() on wrong tag
Date: Fri, 13 Nov 2026 10:45:16 -0500
Message-ID: <20261113153827.208104543@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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
index 068d57515dd58..92701a16511d4 100644
--- a/net/9p/trans_xen.c
+++ b/net/9p/trans_xen.c
@@ -201,6 +201,8 @@ static void p9_xen_response(struct work_struct *work)
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



