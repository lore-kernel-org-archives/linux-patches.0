Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CD155102B;
	Tue, 23 Jan 2024 00:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970576; cv=none; b=sxQ+EyT8CiTcLc0AgQd7Co3bOZ0gcKfdbuGzz397QkT1RULJaISZuZA+nVt5hSSZSY0S3XpHQ8im5LYFgUvTSbgyOeQDLVEuok92eyuCBnzUdnlEGWgkVrAT/saLEEA06GlGs36CgijZRAhbUoVprYc72Wvh9Lo2ib70cQBwucQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970576; c=relaxed/simple;
	bh=bYXqQFH6li2betpIstf1yLTiOC+NIjMlrb5OAES5CEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I+zONs7WmEH4I9YPm8nFcF6dzdF1lbYuYC8I3j0K07RwwLzawTIyN52p182Ip+3pPYOjrmATGmvnfPP0eb29L43NU1CopmdLsZiE27OPtd/x3nDhgM7rsQWZUU0Z+x2uT8Un9zK4f5rsgx8AGvH+4ouBoOXbctLMaBY1fuB3flU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UEZZuw+y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UEZZuw+y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77B7BC433C7;
	Tue, 23 Jan 2024 00:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970576;
	bh=bYXqQFH6li2betpIstf1yLTiOC+NIjMlrb5OAES5CEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UEZZuw+yUJeN5UokcqSYwk6EF1p2vKFV6vEQFC9dLYmwpfs2I2misrht73kH2O3tC
	 X56TCpT7WtUhLkfR2vm3O3nMy6vKEYNsdJ8WSPuOGRhQIr/QoaY1DlVoFHA+9Ffhwt
	 6XOoe5lJYotkXHCpzYCLSwZMJMqv87MOFjwtdX5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait@windriver.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 056/417] crypto: sahara - handle zero-length aes requests
Date: Mon, 22 Jan 2024 15:53:44 -0800
Message-ID: <20240122235753.633543715@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 89fd54bc0127..4b32e96e197d 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -677,6 +677,9 @@ static int sahara_aes_crypt(struct skcipher_request *req, unsigned long mode)
 	struct sahara_dev *dev = dev_ptr;
 	int err = 0;
 
+	if (!req->cryptlen)
+		return 0;
+
 	if (unlikely(ctx->keylen != AES_KEYSIZE_128))
 		return sahara_aes_fallback(req, mode);
 
-- 
2.43.0



