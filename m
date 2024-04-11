Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4060C145B28;
	Thu, 11 Apr 2024 10:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830425; cv=none; b=YH1nUKtGTXq0tt5Bz/YBd6qGfG/kGr+LM5HHwTYUiPeh4SAjyGlgJYzbPOP8kGc5aFB2kaKAv0wXnlteMPMqiRK/f7MpxUdG1id+t0cHnJb4V+ViJaSxcaTWjFyDt6zbiVSh/0rZIuyZrqkHHZmgjs8hPqmEGhErTEcyHJsfLcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830425; c=relaxed/simple;
	bh=QQRBeBcWW3ysp89Ye/6oBNL/v4G5KU1HsZZ0SV8RLzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oyA+l8SwD6nCfnfwPQFL/HXIyFhdkzRZSMm7/Y2sld/gig1JHVFq4KLqAUr3ZVIy4CjqpISU7b983a/8NX+2q7FQuYCiVnuKfvaLsneszOXHZxe0DpgaDJXp2XEZdofYYZ7eT0ce/1aamv4iiHvwwqOlV8b3SwwI6z/u83WgNJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KZ8/4GD7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KZ8/4GD7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FFACC433C7;
	Thu, 11 Apr 2024 10:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830425;
	bh=QQRBeBcWW3ysp89Ye/6oBNL/v4G5KU1HsZZ0SV8RLzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KZ8/4GD7bSSnhrgEPmk6EpGBHP+sdHeHStrT+O9gAh6Flkh6VoxOdOEsDn/pI+gXA
	 bygHGGHkIIDLXhiubdRtpeFC4lvLTdIhbqeYVfxMQ/PwuFXKLDK8oherft01S4CVGP
	 l4wYtEvUFDGac9NYjhy1Tc0fkj24xso+7e092tAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Zanussi <tom.zanussi@linux.intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 093/143] crypto: iaa - Fix async_disable descriptor leak
Date: Thu, 11 Apr 2024 11:56:01 +0200
Message-ID: <20240411095423.708290998@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095420.903937140@linuxfoundation.org>
References: <20240411095420.903937140@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tom Zanussi <tom.zanussi@linux.intel.com>

[ Upstream commit 262534ddc88dfea7474ed18adfecf856e4fbe054 ]

The disable_async paths of iaa_compress/decompress() don't free idxd
descriptors in the async_disable case. Currently this only happens in
the testcases where req->dst is set to null. Add a test to free them
in those paths.

Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index aa65c1791ce76..64a2e87a55b3c 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -1328,7 +1328,7 @@ static int iaa_compress(struct crypto_tfm *tfm,	struct acomp_req *req,
 
 	*compression_crc = idxd_desc->iax_completion->crc;
 
-	if (!ctx->async_mode)
+	if (!ctx->async_mode || disable_async)
 		idxd_free_desc(wq, idxd_desc);
 out:
 	return ret;
@@ -1574,7 +1574,7 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 
 	*dlen = req->dlen;
 
-	if (!ctx->async_mode)
+	if (!ctx->async_mode || disable_async)
 		idxd_free_desc(wq, idxd_desc);
 
 	/* Update stats */
-- 
2.43.0



