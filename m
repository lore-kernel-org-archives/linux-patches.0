Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AE7035C682;
	Tue, 21 Jul 2026 22:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671235; cv=none; b=h42Sk5ZIigxVNpKPP59k6yJegq8YUYLA9im9p8OL2M+quUPwyYbXmMUuGr/+zwU3cEi7A3qfK/YBWRbFL0obikx/VpJkP/yDB/tTA6qga1Vr2tNKaAXW/OYeurjJNrMN5CKYV1Cw9oN/hgsyg6TVbw+Ikj+Gr1u5K5bTUYg27RE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671235; c=relaxed/simple;
	bh=o0yWJT2zpOSHfZL2RTtdARK7zvUNJ+oCVcaXnP0kNN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=neepBoIWlYCrMfLSSU3LeMmI3QOFbBiAY+8zplj6k8rb0Mx6gKW8/wB/yanZgi3WqF/W210Xzoop9Y+jmeOC1iCY5ZD77AkGZDnPjKZ12kBM00Bg2JT+9l8GAL1sVCe8cPFf5ZufAbKrns3vLFdIyOFXK1E9GQHJifZ6Zt92cSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sOSPW2NM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sOSPW2NM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8516C1F000E9;
	Tue, 21 Jul 2026 22:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671234;
	bh=Qvjfspn+pN4mS+mzD6VZpopu3ADy7LVyrF1WHs6K+d8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sOSPW2NM34/epxSgXFjPTRJGjJ1NX+X6gzU4DWhI3/tKJ2CXsUtSBe8ZWoFZNleMa
	 nKt/0c8tZ0Z1/tVNnohnqqwnW0OCm7EpMFmnpbrassk/dexhLFxa/UHLXas7W2tlqa
	 vbDVsnTQEqjL3aaXA4DBpZY24vDuK7h8+PMPk2dI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.15 167/843] crypto: drbg - Fix returning success on failure in CTR_DRBG
Date: Tue, 21 Jul 2026 17:16:42 +0200
Message-ID: <20260721152409.775261624@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@kernel.org>

commit 39a31ad9e2a5ed7e9c9c6f711dca96c8c8f5f26b upstream.

drbg_ctr_generate() sometimes returns success when it fails, leaving the
output buffer uninitialized.  Fix it.

Fixes: cde001e4c3c3 ("crypto: rng - RNGs must return 0 in success case")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/drbg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -602,7 +602,7 @@ static int drbg_ctr_generate(struct drbg
 	if (addtl && !list_empty(addtl)) {
 		ret = drbg_ctr_update(drbg, addtl, 2);
 		if (ret)
-			return 0;
+			return ret;
 	}
 
 	/* 10.2.1.5.2 step 4.1 */


