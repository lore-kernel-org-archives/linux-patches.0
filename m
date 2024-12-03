Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1640A207A3E;
	Tue,  3 Dec 2024 15:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240261; cv=none; b=V/r4VW+l2dnT1NiTWIwEeFQ3kv2GoHJUHdjum8NK2+Wo2XHnhh9ckIdo7rJV7t1C7OKznNKzpYAYInlr19mBC22vhMn2MOoOIBzluyeNOUO88jQM6NQr2ILwdlvmO7imQveQoMNKQon4o3v05S3attF7beAXoExidohVw9QE7iM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240261; c=relaxed/simple;
	bh=wYpR+n46TG2i2RECjbuWZ2ovVLEnyr/2cbrbbMNq6Dw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NqR1uL4nbjrA83IhNx8TQZFy4r3ybWPkXRkBBJf0+RujQDa60O50R4Kd5nYZ4QdkzKEGtMKsfftMyGUa4rzqK+1RiPFpKek9PJfH3nK5bEoh9ssbCa0rKAeINAP66LcGIWXxJroNNkSyKaXDk7vZOBUPrl062thC55WyQmtIX1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JPs07YlQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JPs07YlQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90ED6C4CECF;
	Tue,  3 Dec 2024 15:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240261;
	bh=wYpR+n46TG2i2RECjbuWZ2ovVLEnyr/2cbrbbMNq6Dw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JPs07YlQKYkiO9QovQni0rJLPeO8fIiHx6kO7MKDuQgfLzHQWVljnrb1Nttq+0rAE
	 o69yTnLW8QSUbratrOr3HVWwUct/4COwDIL3KIo0FdMUCo8DJnCB9CYIKerUfShQoB
	 WJjAe84lGG0DfNyeQWZI36VI5DQ1mrAeByFrCzKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 079/826] crypto: cavium - Fix an error handling path in cpt_ucode_load_fw()
Date: Tue,  3 Dec 2024 15:36:46 +0100
Message-ID: <20241203144746.552065480@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 572b7cf08403b6c67dfe0dc3e0f2efb42443254f ]

If do_cpt_init() fails, a previous dma_alloc_coherent() call needs to be
undone.

Add the needed dma_free_coherent() before returning.

Fixes: 9e2c7d99941d ("crypto: cavium - Add Support for Octeon-tx CPT Engine")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/cavium/cpt/cptpf_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/cavium/cpt/cptpf_main.c b/drivers/crypto/cavium/cpt/cptpf_main.c
index ec17beee24c07..54de869e5374c 100644
--- a/drivers/crypto/cavium/cpt/cptpf_main.c
+++ b/drivers/crypto/cavium/cpt/cptpf_main.c
@@ -302,6 +302,8 @@ static int cpt_ucode_load_fw(struct cpt_device *cpt, const u8 *fw, bool is_ae)
 
 	ret = do_cpt_init(cpt, mcode);
 	if (ret) {
+		dma_free_coherent(&cpt->pdev->dev, mcode->code_size,
+				  mcode->code, mcode->phys_base);
 		dev_err(dev, "do_cpt_init failed with ret: %d\n", ret);
 		goto fw_release;
 	}
-- 
2.43.0



