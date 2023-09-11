Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21BEC11706
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:59:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96D1CC433C7;
	Mon, 11 Sep 2023 14:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694444358;
	bh=TyXKBzDPyX+1LfhuRgM5Mq5C45oByi295AR6crWR8vo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PqJIYQQjtuXfKJ5Z6ounnUPa/W78BeZUhIF4epXofFx5PMAHU+WuRVkAMzwSwRh5d
	 /v5Mx6L47W2GWlS6bU6ttas/KEFuD01oEpZlQ4gKO3a0upRKfF7T4KtMrXYukmSB1r
	 JYpmRaMgMgbto6SEbd4xqivzQPKuAmnfA/QgqCMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frederick Lawler <fred@cloudflare.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.4 700/737] crypto: af_alg - Decrement struct key.usage in alg_set_by_key_serial()
Date: Mon, 11 Sep 2023 15:49:19 +0200
Message-ID: <20230911134710.077434458@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frederick Lawler <fred@cloudflare.com>

commit 6b4b53ca0b7300ba2af98a49dbce22054bf034fe upstream.

Calls to lookup_user_key() require a corresponding key_put() to
decrement the usage counter. Once it reaches zero, we schedule key GC.
Therefore decrement struct key.usage in alg_set_by_key_serial().

Fixes: 7984ceb134bf ("crypto: af_alg - Support symmetric encryption via keyring keys")
Cc: <stable@vger.kernel.org>
Signed-off-by: Frederick Lawler <fred@cloudflare.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/af_alg.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -320,18 +320,21 @@ static int alg_setkey_by_key_serial(stru
 
 	if (IS_ERR(ret)) {
 		up_read(&key->sem);
+		key_put(key);
 		return PTR_ERR(ret);
 	}
 
 	key_data = sock_kmalloc(&ask->sk, key_datalen, GFP_KERNEL);
 	if (!key_data) {
 		up_read(&key->sem);
+		key_put(key);
 		return -ENOMEM;
 	}
 
 	memcpy(key_data, ret, key_datalen);
 
 	up_read(&key->sem);
+	key_put(key);
 
 	err = type->setkey(ask->private, key_data, key_datalen);
 


