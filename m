Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91DB530BF64;
	Tue, 26 Aug 2025 11:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207558; cv=none; b=cB0aa7b9jlDjCHPLDWt9B1AhP2+i0dH+lRf+KPTPeELEYXENNc0l3DznYQw5rNH+mTBGtvN0qTd8kLTA9F9TruDpEgSdb3ZjVCINTga0Y37i2VmRBWOJYEmkGcq3m7xzEFub0BQp6cfl+0HQxplr+60KSBxTMphr4+oQMCVBE18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207558; c=relaxed/simple;
	bh=+UbxadlMm3M2skAAoZkU7SfemTjDdrNhL8J3/P8WQyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T/kzwncssiZZPYCzBUSlIh7cHpvQCB51Ig2afS3gSxPomHCcWLUbbgsTZxIZDbeLlXlBXv+649oG35y4/pqnzAJFPn7b83MULhSHHTjYzWL9h7URRlGdEsqY7ITnOEXaJTpMBSESt/ADFiqXHRxVXR+zNQunKttFQQQwcVC6zPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U1tpAKqU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U1tpAKqU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B179C113CF;
	Tue, 26 Aug 2025 11:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207558;
	bh=+UbxadlMm3M2skAAoZkU7SfemTjDdrNhL8J3/P8WQyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U1tpAKqUor+o2Rhd8xDkpV9G6fWEYfWJCd25uo/1XWZ0MdPhOisf5R3dUiX7xig1H
	 fi/L25dmNZ9vayz+ENfsjoJpMZD/F//vCAg1gI6PKTgoVXncDcHujNQlkCnD+EVLCS
	 QQU23jRTxbZ8L4frqK8oKLz8imOhh5n+AhQbLeko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.16 229/457] crypto: acomp - Fix CFI failure due to type punning
Date: Tue, 26 Aug 2025 13:08:33 +0200
Message-ID: <20250826110943.032923009@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@kernel.org>

commit 962ddc5a7a4b04c007bba0f3e7298cda13c62efd upstream.

To avoid a crash when control flow integrity is enabled, make the
workspace ("stream") free function use a consistent type, and call it
through a function pointer that has that same type.

Fixes: 42d9f6c77479 ("crypto: acomp - Move scomp stream allocation code into acomp")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
[Giovanni: Backport to 6.16.y. Removed logic in crypto/zstd.c as commit
f5ad93ffb541 ("crypto: zstd - convert to acomp") is not going to be
backported to stable.]
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/deflate.c                    |    7 ++++++-
 include/crypto/internal/acompress.h |    5 +----
 2 files changed, 7 insertions(+), 5 deletions(-)

--- a/crypto/deflate.c
+++ b/crypto/deflate.c
@@ -48,9 +48,14 @@ static void *deflate_alloc_stream(void)
 	return ctx;
 }
 
+static void deflate_free_stream(void *ctx)
+{
+	kvfree(ctx);
+}
+
 static struct crypto_acomp_streams deflate_streams = {
 	.alloc_ctx = deflate_alloc_stream,
-	.cfree_ctx = kvfree,
+	.free_ctx = deflate_free_stream,
 };
 
 static int deflate_compress_one(struct acomp_req *req,
--- a/include/crypto/internal/acompress.h
+++ b/include/crypto/internal/acompress.h
@@ -63,10 +63,7 @@ struct crypto_acomp_stream {
 struct crypto_acomp_streams {
 	/* These must come first because of struct scomp_alg. */
 	void *(*alloc_ctx)(void);
-	union {
-		void (*free_ctx)(void *);
-		void (*cfree_ctx)(const void *);
-	};
+	void (*free_ctx)(void *);
 
 	struct crypto_acomp_stream __percpu *streams;
 	struct work_struct stream_work;


