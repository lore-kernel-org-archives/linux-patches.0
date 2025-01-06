Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0092381728;
	Mon,  6 Jan 2025 15:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178818; cv=none; b=r1Ef4EL7Jf+PjedTAMunIfRvIrkLy+AmrVckAyUg1TNaw4gwMA49Knzrm3sxGH5VXBkOshf8G+bbe55YinGDmpfpbraCybpkcmludw/nIdkjVzD0da6ude6JwCFNxIQK22NsPNISV4rcyMYUPFRJWh7tltZvbI6Ae5WqTeBx1Qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178818; c=relaxed/simple;
	bh=7sRa/boHvfusDat9KwL4g0BpdA7BL+iDL9qbmM2i5Nc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h5Vt4RnRR5Hne74jD9P1aACRb31GmEXtl0eo8y+NTWupQgCiUtFo5Yzrqj4MWIqx9z373bm4GxCDl0ZeOlNYgOIjHij3zp3bClbrDffxC5hsbCgWSDcfYqtIF89c1RDUDhwdh9iGGVXUvNRNLQAGjyr7HdxAWD/Q+GiUH86yQmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zRUPSpp+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zRUPSpp+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BD20C4CED2;
	Mon,  6 Jan 2025 15:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178817;
	bh=7sRa/boHvfusDat9KwL4g0BpdA7BL+iDL9qbmM2i5Nc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zRUPSpp+qbkCvWwli24jfxiYwipdH+m03rBTXrtDiFIlXHglhwIzxvJZ2o3JNENGK
	 5D0/bdo0uD2j5k8RNspPfZ/xqKzD4jJP5jZXlTnLOnS2NP9Frs/Dex5E8Ykejy3tQR
	 0huv5EFWqkOTJhc9oZqF7zOCdci1GaZp5HHHxulI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.15 071/168] dmaengine: mv_xor: fix child node refcount handling in early exit
Date: Mon,  6 Jan 2025 16:16:19 +0100
Message-ID: <20250106151141.147892828@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

commit 362f1bf98a3ecb5a2a4fcbdaa9718c8403beceb2 upstream.

The for_each_child_of_node() loop requires explicit calls to
of_node_put() to decrement the child's refcount upon early exits (break,
goto, return).

Add the missing calls in the two early exits before the goto
instructions.

Cc: stable@vger.kernel.org
Fixes: f7d12ef53ddf ("dma: mv_xor: add Device Tree binding")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://lore.kernel.org/r/20241011-dma_mv_xor_of_node_put-v1-1-3c2de819f463@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/mv_xor.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/dma/mv_xor.c
+++ b/drivers/dma/mv_xor.c
@@ -1393,6 +1393,7 @@ static int mv_xor_probe(struct platform_
 			irq = irq_of_parse_and_map(np, 0);
 			if (!irq) {
 				ret = -ENODEV;
+				of_node_put(np);
 				goto err_channel_add;
 			}
 
@@ -1401,6 +1402,7 @@ static int mv_xor_probe(struct platform_
 			if (IS_ERR(chan)) {
 				ret = PTR_ERR(chan);
 				irq_dispose_mapping(irq);
+				of_node_put(np);
 				goto err_channel_add;
 			}
 


