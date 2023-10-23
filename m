Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62EFE15E83
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e7zgYtju"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D055AC433CC;
	Mon, 23 Oct 2023 11:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698060916;
	bh=QnufI5Zrtvr82ZdIqP01giSz7C+Uai8KXHO/JyMWhB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e7zgYtjuHP4Rv5Ib+P0JtW97Ptb3sc2ABIuPLutGsCD3O6/xmk7yJPQEtAYCCwwAx
	 hKcWEAhrpW2SJveeGcXYdzTa8JWQxNa1Q0WaPCqF/QmvycasuAUMa3nPvTfg/UDBjy
	 4hlXshsiV34It/3dxlhqXAEgbsTimMSXj6ETgolI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=E9=BB=84=E6=80=9D=E8=81=AA?= <huangsicong@iie.ac.cn>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 012/137] nfc: nci: fix possible NULL pointer dereference in send_acknowledge()
Date: Mon, 23 Oct 2023 12:56:09 +0200
Message-ID: <20231023104821.322732743@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104820.849461819@linuxfoundation.org>
References: <20231023104820.849461819@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit 7937609cd387246aed994e81aa4fa951358fba41 upstream.

Handle memory allocation failure from nci_skb_alloc() (calling
alloc_skb()) to avoid possible NULL pointer dereference.

Reported-by: 黄思聪 <huangsicong@iie.ac.cn>
Fixes: 391d8a2da787 ("NFC: Add NCI over SPI receive")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20231013184129.18738-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/nfc/nci/spi.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/nfc/nci/spi.c
+++ b/net/nfc/nci/spi.c
@@ -151,6 +151,8 @@ static int send_acknowledge(struct nci_s
 	int ret;
 
 	skb = nci_skb_alloc(nspi->ndev, 0, GFP_KERNEL);
+	if (!skb)
+		return -ENOMEM;
 
 	/* add the NCI SPI header to the start of the buffer */
 	hdr = skb_push(skb, NCI_SPI_HDR_LEN);


