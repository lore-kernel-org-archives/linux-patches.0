Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A04BD241F8
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 14:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bHSSA2fn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA3B1C433C8;
	Mon, 16 Oct 2023 14:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697466268;
	bh=73Q+X8gRwVJodVh8+NHPOYxWeuOvAWFRgAex7T2LS54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bHSSA2fng82E/ZrVec/Id874YW46RkPPGzJK398Y6NYi45bYmoosD5jRWCvui9NiR
	 iDMDo33FOs3dfcMsF9VPf55DR8xEx7utlTLp/AXPUnajlqRKPi3cwcQ08FKCoBOL8T
	 E4h8JZzGcwicWfcnnVLF+VB8Qk3RAPbKto26+qaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Tatu=20Heikkil=C3=A4?= <tatu.heikkila@gmail.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.5 018/191] dm crypt: Fix reqsize in crypt_iv_eboiv_gen
Date: Mon, 16 Oct 2023 10:40:03 +0200
Message-ID: <20231016084015.827734362@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084015.400031271@linuxfoundation.org>
References: <20231016084015.400031271@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

commit 152d0bcdf1efcb54a4fa20f694e9c7bbb6d06cbf upstream.

A skcipher_request object is made up of struct skcipher_request
followed by a variable-sized trailer.  The allocation of the
skcipher_request and IV in crypt_iv_eboiv_gen is missing the
memory for struct skcipher_request.  Fix it by adding it to
reqsize.

Fixes: e3023094dffb ("dm crypt: Avoid using MAX_CIPHER_BLOCKSIZE")
Cc: <stable@vger.kernel.org> #6.5+
Reported-by: Tatu Heikkilä <tatu.heikkila@gmail.com>
Reviewed-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-crypt.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index f2662c21a6df..5315fd261c23 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -753,7 +753,8 @@ static int crypt_iv_eboiv_gen(struct crypt_config *cc, u8 *iv,
 	int err;
 	u8 *buf;
 
-	reqsize = ALIGN(crypto_skcipher_reqsize(tfm), __alignof__(__le64));
+	reqsize = sizeof(*req) + crypto_skcipher_reqsize(tfm);
+	reqsize = ALIGN(reqsize, __alignof__(__le64));
 
 	req = kmalloc(reqsize + cc->iv_size, GFP_NOIO);
 	if (!req)
-- 
2.42.0



