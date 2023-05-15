Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FBB6FBE7
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:28:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B81D3C433D2;
	Mon, 15 May 2023 17:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684171713;
	bh=BE7ELUA4gaaOBghrqXf85jQ2nHqcGPkpDzfkDnW3uqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xQUQnVmYlFKUlwO69tSGF1TT1ZvgZvII0UoqvurUL0CaoNBLDcQczhJT/OigXGvfo
	 tYTlQ/YGoKBjef1m9xCmHwEe6LNrjDybfa5xR09SlrJnuBzmVkLlcVz4WsTA/rX6QX
	 tAap7qUbBw+7L7NOQif319MK0+shgPkLN75ofjKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 055/134] crypto: api - Add scaffolding to change completion function signature
Date: Mon, 15 May 2023 18:28:52 +0200
Message-Id: <20230515161704.979690467@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161702.887638251@linuxfoundation.org>
References: <20230515161702.887638251@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit c35e03eaece71101ff6cbf776b86403860ac8cc3 ]

The crypto completion function currently takes a pointer to a
struct crypto_async_request object.  However, in reality the API
does not allow the use of any part of the object apart from the
data field.  For example, ahash/shash will create a fake object
on the stack to pass along a different data field.

This leads to potential bugs where the user may try to dereference
or otherwise use the crypto_async_request object.

This patch adds some temporary scaffolding so that the completion
function can take a void * instead.  Once affected users have been
converted this can be removed.

The helper crypto_request_complete will remain even after the
conversion is complete.  It should be used instead of calling
the completion function directly.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: 4140aafcff16 ("crypto: engine - fix crypto_queue backlog handling")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/crypto/algapi.h | 7 +++++++
 include/linux/crypto.h  | 6 ++++++
 2 files changed, 13 insertions(+)

diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index 5f6841c73e5a7..0ffd61930e180 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -256,4 +256,11 @@ enum {
 	CRYPTO_MSG_ALG_LOADED,
 };
 
+static inline void crypto_request_complete(struct crypto_async_request *req,
+					   int err)
+{
+	crypto_completion_t complete = req->complete;
+	complete(req, err);
+}
+
 #endif	/* _CRYPTO_ALGAPI_H */
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 855869e1fd327..987eeb94bb70b 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -167,6 +167,7 @@ struct crypto_async_request;
 struct crypto_tfm;
 struct crypto_type;
 
+typedef struct crypto_async_request crypto_completion_data_t;
 typedef void (*crypto_completion_t)(struct crypto_async_request *req, int err);
 
 /**
@@ -586,6 +587,11 @@ struct crypto_wait {
 /*
  * Async ops completion helper functioons
  */
+static inline void *crypto_get_completion_data(crypto_completion_data_t *req)
+{
+	return req->data;
+}
+
 void crypto_req_done(struct crypto_async_request *req, int err);
 
 static inline int crypto_wait_req(int err, struct crypto_wait *wait)
-- 
2.39.2



