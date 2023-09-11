Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A103C1170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:24:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2054FC433C8;
	Mon, 11 Sep 2023 14:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694442271;
	bh=yUmonun9gFqZ9wFOwQcAhWrkB9t57uv+F93d/hol+ow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hB3DltslCSRXbp1HY95Fizz4405PUJD4W3bFAfbJ/MgKHzTTTpPLbM/xgyBvmQs4J
	 lfCmua7LcBtAU3OJQDkmHRG/n1TnnXKI5vzZzr4uLHTyfdSRRLt66MwKysVpBKgRpH
	 4vs3rKPG3FvD9+RuMkDSAUo/G2GTakyJJITQvgb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frederick Lawler <fred@cloudflare.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.5 707/739] crypto: af_alg - Decrement struct key.usage in alg_set_by_key_serial()
Date: Mon, 11 Sep 2023 15:48:26 +0200
Message-ID: <20230911134710.832701165@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

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
 


