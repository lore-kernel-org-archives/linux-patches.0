Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD869BA48
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:29:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D158C4339C;
	Tue,  7 Mar 2023 18:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678213751;
	bh=J3f4qv5kjF2i82DUy43TciALYCtsEwkz6/MXBKiSoLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OvVoKqVVEnm6AsOzAPG8YmBHys44NpR9Q5jojoYRrMIX/SuOp31suJthNE2mJGH1x
	 Etr26pX7tS7xPkF4vFYbA1xNCR1ALaHn2PQ3sJ1f51+WJ5NzsL14uHC99XnhF45yDl
	 bQDG1aPPxbvMa1MF7LUAR5MPNlsQFri6kGtNtIkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Weili Qian <qianweili@huawei.com>,
	Zhou Wang <wangzhou1@hisilicon.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Kees Cook <keescook@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 567/885] crypto: hisilicon: Wipe entire pool on error
Date: Tue,  7 Mar 2023 17:58:21 +0100
Message-Id: <20230307170027.064822655@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kees Cook <keescook@chromium.org>

[ Upstream commit aa85923a954e7704bc9d3847dabeb8540aa98d13 ]

To work around a Clang __builtin_object_size bug that shows up under
CONFIG_FORTIFY_SOURCE and UBSAN_BOUNDS, move the per-loop-iteration
mem_block wipe into a single wipe of the entire pool structure after
the loop.

Reported-by: Nathan Chancellor <nathan@kernel.org>
Link: https://github.com/ClangBuiltLinux/linux/issues/1780
Cc: Weili Qian <qianweili@huawei.com>
Cc: Zhou Wang <wangzhou1@hisilicon.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Tested-by: Nathan Chancellor <nathan@kernel.org> # build
Link: https://lore.kernel.org/r/20230106041945.never.831-kees@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/sgl.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/hisilicon/sgl.c b/drivers/crypto/hisilicon/sgl.c
index 2b6f2281cfd6c..0974b00414050 100644
--- a/drivers/crypto/hisilicon/sgl.c
+++ b/drivers/crypto/hisilicon/sgl.c
@@ -124,9 +124,8 @@ struct hisi_acc_sgl_pool *hisi_acc_create_sgl_pool(struct device *dev,
 	for (j = 0; j < i; j++) {
 		dma_free_coherent(dev, block_size, block[j].sgl,
 				  block[j].sgl_dma);
-		memset(block + j, 0, sizeof(*block));
 	}
-	kfree(pool);
+	kfree_sensitive(pool);
 	return ERR_PTR(-ENOMEM);
 }
 EXPORT_SYMBOL_GPL(hisi_acc_create_sgl_pool);
-- 
2.39.2



