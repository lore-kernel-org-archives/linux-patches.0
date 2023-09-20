Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1634A2E63B
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:10:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D898C433C8;
	Wed, 20 Sep 2023 12:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695211801;
	bh=/wqa7FwaYV25dU3kQ2YI/8pH/P+1gQ7UxBTvFZHlMbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QW7Qj0H4OnnGA2eIW8w1nc6JQZSfBmOaJ10K3BtESXc8Sh9J+qyvgOZUzFUmvA82U
	 WFL2q8UpCLwitlJG1dJ6s5Z8k3Asi1uEI9sk4IkT6b3yyv8sI4I0LUinDSN5XwiVth
	 +0O5xNLRUBz4qsrk3hzIlCLwNhS+YE8xBcYafHjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 4.19 041/273] Revert "net: macsec: preserve ingress frame ordering"
Date: Wed, 20 Sep 2023 13:28:01 +0200
Message-ID: <20230920112847.690892221@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112846.440597133@linuxfoundation.org>
References: <20230920112846.440597133@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sabrina Dubroca <sd@queasysnail.net>

commit d3287e4038ca4f81e02067ab72d087af7224c68b upstream.

This reverts commit ab046a5d4be4c90a3952a0eae75617b49c0cb01b.

It was trying to work around an issue at the crypto layer by excluding
ASYNC implementations of gcm(aes), because a bug in the AESNI version
caused reordering when some requests bypassed the cryptd queue while
older requests were still pending on the queue.

This was fixed by commit 38b2f68b4264 ("crypto: aesni - Fix cryptd
reordering problem on gcm"), which pre-dates ab046a5d4be4.

Herbert Xu confirmed that all ASYNC implementations are expected to
maintain the ordering of completions wrt requests, so we can use them
in MACsec.

On my test machine, this restores the performance of a single netperf
instance, from 1.4Gbps to 4.4Gbps.

Link: https://lore.kernel.org/netdev/9328d206c5d9f9239cae27e62e74de40b258471d.1692279161.git.sd@queasysnail.net/T/
Link: https://lore.kernel.org/netdev/1b0cec71-d084-8153-2ba4-72ce71abeb65@byu.edu/
Link: https://lore.kernel.org/netdev/d335ddaa-18dc-f9f0-17ee-9783d3b2ca29@mailbox.tu-dresden.de/
Fixes: ab046a5d4be4 ("net: macsec: preserve ingress frame ordering")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://lore.kernel.org/r/11c952469d114db6fb29242e1d9545e61f52f512.1693757159.git.sd@queasysnail.net
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/macsec.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -1315,8 +1315,7 @@ static struct crypto_aead *macsec_alloc_
 	struct crypto_aead *tfm;
 	int ret;
 
-	/* Pick a sync gcm(aes) cipher to ensure order is preserved. */
-	tfm = crypto_alloc_aead("gcm(aes)", 0, CRYPTO_ALG_ASYNC);
+	tfm = crypto_alloc_aead("gcm(aes)", 0, 0);
 
 	if (IS_ERR(tfm))
 		return tfm;


