Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E73FF5C605;
	Tue, 23 Jan 2024 01:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974368; cv=none; b=uVUnt+bWSS7gzwQkn379RzcssX+C9ea9vc7WBYu2CXIjpM/PIGBUXbeglJRJTVqTkjfgxHk/796nMh7tA0BMKzCo3reFgHgPnG/JMsu4RA8z4cOfEAzAQ261oV7syJQGEhkX8q2SP7IxBe+T2JruUVUrXSBdEYd8oloTxn11Ufw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974368; c=relaxed/simple;
	bh=DBDMNQxPB4hGWU4nDpSaZd7MJNTGvuEQpnVKM14CnuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SH7/G/jjNozmdAHT/+Rg8SJ+33JR/L7eQKrWdNkDePuAxY+0d5AZ/vOCDoBLNZ/nckJg+blWaDz9EzCeZCYikrhO6NqxRy/9/CcjMg/cSd/K+k9ZZZW8HDteFDLtjqZRq/hgBAFWgftcUdkzW7pZ+sdeXQychg3uofy9Wat7zQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pfxrSEi/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pfxrSEi/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3708C43399;
	Tue, 23 Jan 2024 01:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974367;
	bh=DBDMNQxPB4hGWU4nDpSaZd7MJNTGvuEQpnVKM14CnuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pfxrSEi/UXn4Ye6Q3RlZGjZN8igtHp+qX4rdRKQJ32HFdt/C87OEgDwlvt3AGDfT3
	 lZi1fRWxAmuLgSUBeFHbNagR07U6ApvO3vpSD2V2/BGhVkmFCwR2TweBIMpfAc06bl
	 p36eifHwmtzxz6rt5DolD7UrRxQrKPJVodYevJVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait@windriver.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 068/583] crypto: sahara - handle zero-length aes requests
Date: Mon, 22 Jan 2024 15:51:59 -0800
Message-ID: <20240122235814.226364439@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ovidiu Panait <ovidiu.panait@windriver.com>

[ Upstream commit d1d6351e37aac14b32a291731d0855996c459d11 ]

In case of a zero-length input, exit gracefully from sahara_aes_crypt().

Fixes: 5de8875281e1 ("crypto: sahara - Add driver for SAHARA2 accelerator.")
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/sahara.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index a109f9bdbe04..96f59d57c36b 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -676,6 +676,9 @@ static int sahara_aes_crypt(struct skcipher_request *req, unsigned long mode)
 	struct sahara_dev *dev = dev_ptr;
 	int err = 0;
 
+	if (!req->cryptlen)
+		return 0;
+
 	if (unlikely(ctx->keylen != AES_KEYSIZE_128))
 		return sahara_aes_fallback(req, mode);
 
-- 
2.43.0



