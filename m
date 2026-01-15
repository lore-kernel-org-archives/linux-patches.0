Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2730839E6EA;
	Thu, 15 Jan 2026 17:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498634; cv=none; b=FJbVv9+qoYW2nltLI4TxI7qMWTNzB2baju9iyY6F8u+RiFrSrIxl0THEq6S8qU69Pv83X+g8ht22FV84o1HQqlsjFimFB8d7jBvUg2ny09F+fwaN+qBaU3Gr19sWOjwUsiBOHp1eT09W0A3nMglxBnUrpNHdSZig7jB1GS39U3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498634; c=relaxed/simple;
	bh=8pnAoc2JnD9lvhv4HMr+xLDNCuEHgVT2rIZT5l16fO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n53bqcZppsxABGiIXuVP2i2FlpZfDxph7klmkbGKcSkTV9dlub5zklsIBodjilWdIWrpa6v1hWS3R6eqNnIHuMlT0Yf6GApxUMnkyhOH1WXCaDAXwSPE50B0z2llaxiy6QCVUV1oF9no+FARanj/JwpTUff9D6oh6gw3pPYQ62Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ynb2CKGp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ynb2CKGp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EEF6C116D0;
	Thu, 15 Jan 2026 17:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498634;
	bh=8pnAoc2JnD9lvhv4HMr+xLDNCuEHgVT2rIZT5l16fO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ynb2CKGpeotBmOcquPB6hG1//epZzkcTVaYOTHtN+oTWd9qos24eQnu5i9c43cbpc
	 9UMolzH/OwE5Jf+5LXX00o62N9hGs0XPxnA7feZZbycO/cjGtqh6I+tSaTUQTyX5EQ
	 a+SXVuILegxF0zLpCvoze4FKl/C0apxXb/Ml/xFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 501/554] atm: Fix dma_free_coherent() size
Date: Thu, 15 Jan 2026 17:49:27 +0100
Message-ID: <20260115164304.452467615@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Thomas Fourier <fourier.thomas@gmail.com>

commit 4d984b0574ff708e66152763fbfdef24ea40933f upstream.

The size of the buffer is not the same when alloc'd with
dma_alloc_coherent() in he_init_tpdrq() and freed.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: <stable@vger.kernel.org>
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Link: https://patch.msgid.link/20260107090141.80900-2-fourier.thomas@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/atm/he.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/atm/he.c
+++ b/drivers/atm/he.c
@@ -1590,7 +1590,8 @@ he_stop(struct he_dev *he_dev)
 				  he_dev->tbrq_base, he_dev->tbrq_phys);
 
 	if (he_dev->tpdrq_base)
-		dma_free_coherent(&he_dev->pci_dev->dev, CONFIG_TBRQ_SIZE * sizeof(struct he_tbrq),
+		dma_free_coherent(&he_dev->pci_dev->dev,
+				  CONFIG_TPDRQ_SIZE * sizeof(struct he_tpdrq),
 				  he_dev->tpdrq_base, he_dev->tpdrq_phys);
 
 	dma_pool_destroy(he_dev->tpd_pool);


