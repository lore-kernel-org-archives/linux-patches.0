Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055346;
	b=XmVKJtBH9Atkx7oPIb4PyJ9vVDAEexoZFP3n0U1OZ8xXwekohgaPw2X9i4fDhBln/J9E
	 ZpHSmvqlBax96PYf4TQ03mlw497MMizL2n1DSEkuDP3IjFepMdJlUPpSincrzhN2x9yxY
	 l70nQvsL6lMx4qDW9mqqJFvdov+HfWxmA4LM0aV0b+1nDoV2HlYT8nY0q+ntQLYmmGeFG
	 ueF9trfh0LHhId+PdSI+Z2FFy9/IEMG/hbiXTPUx2u+oxTv4KfyqRGShw1t/0XoMpCNz2
	 MZcV4n0pM/LEI4NW/dgbheUiVyujpyc3yKsfgWpi9jcw1wfnRYPe0ejMi9J8rguHFMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055346;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Cicl6zH5iA4HkU8q9DLCAHc3WNY4dkWGXrKrj+ZIhag=;
	b=ochqsuecqZf/08tSv5lmzwg1Ls76z/os30Eyw6+504fr2i1l6k2vfCtI2G+Vev0arAEo
	 MIcqXrOi1yF9/yRX3dHrusKu9X+JCOGYnj+rwl1fZjy2UM4D9EC8yvHk4nwkX9xvIqT2V
	 kAlwXSwa2Tvsih18ggJSH8mWRAenwills8DKpx7nxiQCH31G/+mQ9xFLSsanMnw/tMV5n
	 /N/cNbnfCDtAezzsgl7s0wdqTYsDi2+F3LJ4Kcw6obSKjxyFHHlkavJ0/R/S4YGD2rh2r
	 KY6l9qhaYYgIQ+F7Dk4UtiSDaw5HxixyIfvXsGN8spWpvBf9hqvJnb2AN/Ke4OIMLhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VNOdzJ4c;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67A76606A339;
	Thu, 19 Nov 2026 02:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VNOdzJ4c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF8331F000C4;
	Thu, 19 Nov 2026 02:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055346;
	bh=Cicl6zH5iA4HkU8q9DLCAHc3WNY4dkWGXrKrj+ZIhag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VNOdzJ4czzbDiJUlX2rhCEaNDYnPfKOTqYJWLZNSKyEqZAsNYax1A7pV1dQiPvA4r
	 2Hskwl0DTRQSkkTJImRMYxVOXdMGTU0i9M6UJoVoTEADgnr61iLYhN1wAehEiLjYrG
	 2rTgNj97i+QNLmJ00KapikbaqmXerLmSzHtaSdwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1558/2214] RDMA/siw: Fix qp use-after-free in siw_get_base_qp()
Date: Wed, 18 Nov 2026 15:53:54 +0100
Message-ID: <20261118150114.414014883@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit ef15197f81ffedf29560edf2221199d92fd83dc2 ]

The reference taken by siw_qp_id2obj() is dropped before the address
of the embedded ib_qp is taken from the QP.  If that reference was
the last one the QP is freed and the pointer returned to the iwarp
core is dangling; the core only pins the QP with iw_add_ref() after
the call has returned.

Copy the pointer while the reference is still held.

Fixes: 6c52fdc244b5 ("rdma/siw: connection management")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20260916184400.2093106-1-vulab@iscas.ac.cn
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/siw/siw_main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/siw/siw_main.c b/drivers/infiniband/sw/siw/siw_main.c
index f853f3c23540a..dd4c2dcd377c2 100644
--- a/drivers/infiniband/sw/siw/siw_main.c
+++ b/drivers/infiniband/sw/siw/siw_main.c
@@ -244,8 +244,11 @@ static struct ib_qp *siw_get_base_qp(struct ib_device *base_dev, int id)
 		/*
 		 * siw_qp_id2obj() increments object reference count
 		 */
+		struct ib_qp *base_qp = &qp->base_qp;
+
 		siw_qp_put(qp);
-		return &qp->base_qp;
+
+		return base_qp;
 	}
 	return NULL;
 }
-- 
2.53.0



