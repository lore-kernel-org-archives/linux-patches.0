Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065001;
	b=mT2AEo4J5efFnAuKqVP3bB7MQ4IfgdC6v7AlXOgAUoV5Dv9PM8KEoFIfQvT4If4qGCCi
	 beZz7BViO54zo57G4tinIokh/kmL5bsdK+ZeGQr8h1rlpZICIHO/Me7AsvjU3jlowyoxj
	 c2uIdBw+3ND4lT/P18ydLaXEwmEwvRzr0vslEOLWaIX5iy9ZD6L3gaVOro7YFOQde7aTL
	 47Y+2GcTTpCvBTKQHnXPwrEcUVBUhjTBHkMZ2GnFhmYxwxEVKxRJxPcDfXqFWE6Io8rPR
	 YpdVVst4EWQjoS831EED2HQrk/SA0tSKVbMzjaWTKtjb0bj6Lguk1O/qOsmQu3RSDuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065001;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6Ta/zYbXdpzaIIDQcTbTTA2KhTtgt295s5fupNTWQuA=;
	b=UjbTTGYIfovaZ7YXpl2L0GePSfRCUzMeIc0pIDplBiXN4rXCO+bYIlXTgOCEEL5PW2uC
	 avtjh/+dlK12LNfEGhibq1+fgAYxdBauZnhfBR5swIpHUq8rMurLTMebFgp9PmVlsnSOR
	 /sNQH+pi4Z7I59JuACc9JH2VWgrq/RwlfL5lEGgG30oXAXsJOtEvfHdN4ATc48CgHxN+t
	 l0bCnzkX8BBwdBlfIchkvZaLWnbgQQ/wZFBOLjfJS/T6uP6fJ0ND6fEobxK27+omArIIu
	 Z3ZulzA3SiaH2JqF7kMukBW0GF/WeH1KGBkI0426wVpqe+Lt9WIP50uTUQQRRaNj6TA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EduE87H+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8066606A333;
	Sat,  7 Nov 2026 15:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EduE87H+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B4AB1F0089F;
	Sat,  7 Nov 2026 15:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065000;
	bh=6Ta/zYbXdpzaIIDQcTbTTA2KhTtgt295s5fupNTWQuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EduE87H+nw8LAokPZgMfzGu9tPbXRa1TT/M6PXxu9S5EU1/e9nKHz/TYbgD2cK5P2
	 pWnOpYgrSaRDQSOef1jKhjjfr0Vli5QaHHleRit8o3aFs+o8kvJ5+vy67GxMQ7aeZf
	 myAty2WfvRXJU3QVcxfTOiNeolprRX79NkFLjasc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Deep Shah <deepshah146@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0869/1257] RDMA/uverbs: Fix uobject leak in DMABUF release
Date: Sat,  7 Nov 2026 08:52:45 -0500
Message-ID: <20261107135003.326465710@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Deep Shah <deepshah146@gmail.com>

[ Upstream commit 4a953ee228f5544a3e5515eed88bf09d1a5adb94 ]

uverbs_dmabuf_release() treats a NULL uobj->context as an aborted
allocation, but normal ufile cleanup also clears it. Closing the uverbs
FD before the dma-buf FD therefore skips uverbs_uobject_release() and
leaks the uobject and ufile references.

Clear dmabuf->priv before dma_buf_put() on allocation failure and use
that NULL pointer to identify an abort. Otherwise, always call
uverbs_uobject_release(). This also avoids reading a freed uobject if
release is deferred until after the allocation has been aborted.

Fixes: 0ac6f4056c4a ("RDMA/uverbs: Add DMABUF object type and operations")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Deep Shah <deepshah146@gmail.com>
Link: https://patch.msgid.link/20261015083637.200958-2-deepshah146@gmail.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/uverbs_std_types_dmabuf.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_std_types_dmabuf.c b/drivers/infiniband/core/uverbs_std_types_dmabuf.c
index 33bafadc695df..8d8c997a48834 100644
--- a/drivers/infiniband/core/uverbs_std_types_dmabuf.c
+++ b/drivers/infiniband/core/uverbs_std_types_dmabuf.c
@@ -68,9 +68,10 @@ static void uverbs_dmabuf_release(struct dma_buf *dmabuf)
 	struct ib_uverbs_dmabuf_file *priv = dmabuf->priv;
 
 	/*
-	 * This can only happen if the fput came from alloc_abort_fd_uobject()
+	 * This can only happen if the fput came from the error unwind of
+	 * UVERBS_METHOD_DMABUF_ALLOC. The abort cleans up the uobject.
 	 */
-	if (!priv->uobj.context)
+	if (!priv)
 		return;
 
 	/*
@@ -161,6 +162,8 @@ static int UVERBS_HANDLER(UVERBS_METHOD_DMABUF_ALLOC)(
 	return 0;
 
 err_revoked:
+	/* Tell uverbs_dmabuf_release() that the uobject is being aborted */
+	uverbs_dmabuf->dmabuf->priv = NULL;
 	dma_buf_put(uverbs_dmabuf->dmabuf);
 err:
 	rdma_user_mmap_entry_put(mmap_entry);
-- 
2.53.0



