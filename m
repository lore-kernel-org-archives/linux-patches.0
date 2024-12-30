Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 681AE1537C8;
	Mon, 30 Dec 2024 15:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574063; cv=none; b=opKFoBrsQt3IwpQwbXKDy2SfS/mBzI6/sUveIbd9LvpN6snF8NaTprmPysQW1LOm3S0TYkhujLNhLOj6hv71CwEDNuDxyYFY+B3rN+Jk2j1YmIgKlSdLuI+f7Y+kK43RMSRWrvMTvObS2M0RZVK59gpnmzQWUTiuJSQgp5Qwn8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574063; c=relaxed/simple;
	bh=q5lmounCd0rx0okzLDFcAuSx3x7cOs3OOvH3FfqLGzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M4dStQRkMDJqvYEhcQ7DPD5/A1PZBJIEPJscLz7dnvBoBZb/8R1TfVsSDjLzoKPZJmAoAwoXfCtWF8XWOvMeeXfngPwrZmMlYOOQ8lIT1l2HcEaE24dNFQ7dGxG83q0rixGTB4akBmSO23fgmDkUyBuWZe1IZL2BDf3fdcsbWF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ez4dNi7W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ez4dNi7W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4240C4CED0;
	Mon, 30 Dec 2024 15:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574063;
	bh=q5lmounCd0rx0okzLDFcAuSx3x7cOs3OOvH3FfqLGzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ez4dNi7WYg1ZuN9l1o+ZNCBV4lrhwR9ut5w9EJIOzyQx0Tou4CZZ/tcLM+5FbcnVy
	 C+39dEG3whujlr5s38gW3VAJw55XLPQZpcXBQCze5i4G6vvq0wW2Ds+AeJc37GSzqe
	 5XpENfk2mPNBZ0J50YvJVacC42xNX6krhvid0uoY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.12 028/114] dmaengine: mv_xor: fix child node refcount handling in early exit
Date: Mon, 30 Dec 2024 16:42:25 +0100
Message-ID: <20241230154219.149310579@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
References: <20241230154218.044787220@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1388,6 +1388,7 @@ static int mv_xor_probe(struct platform_
 			irq = irq_of_parse_and_map(np, 0);
 			if (!irq) {
 				ret = -ENODEV;
+				of_node_put(np);
 				goto err_channel_add;
 			}
 
@@ -1396,6 +1397,7 @@ static int mv_xor_probe(struct platform_
 			if (IS_ERR(chan)) {
 				ret = PTR_ERR(chan);
 				irq_dispose_mapping(irq);
+				of_node_put(np);
 				goto err_channel_add;
 			}
 


