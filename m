Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8D7434F476;
	Tue, 16 Dec 2025 11:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886149; cv=none; b=Wcp7wGEJOhSF9dxkKPqt7W4yJFXIXvTRTSETCnm4GZAo+qZa0QNY7zwkghCdMMcHmkJ+1m04sJdFFt/Xlmg5djWBgAlnn+K0GSRVYZcarZKuoeopUViHi6BWGq/XGcfknEP2PKvrBe5pRL/UdI+mtX1MfCI9jzPtkPwbsAYeinA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886149; c=relaxed/simple;
	bh=l7bXfy8y5r9+e1R6ULGO2HZa6zuZZsXa9S6OP4RUCzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GwiESrldHLE/GZYMyMUkvB3/w0m5Fqtv6XW1Yvs0tPGHMMYOfZifP5Ot0kg1IS6lpijhP9aem2rQsRwy9wKasfrMfuSEqUzwfeEVioaDfPqMiIQoVTKNSfywkFKRnUc7V+FLkWRJHQ0Hlnk+HA7Yq/9708EbAKZPj5x6m/Otc7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=11DWY20y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="11DWY20y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E002AC4CEF1;
	Tue, 16 Dec 2025 11:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886149;
	bh=l7bXfy8y5r9+e1R6ULGO2HZa6zuZZsXa9S6OP4RUCzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=11DWY20yksS6XaSjNzb+b/BhotHW2Oq6s8saoIj8GHQsyRqMdywHgKQbB3ZvPN9gs
	 vFCtaBDpIg9zBWqc0R11mC0tHNZryvQ6svP8Goa9hT9GcOdQjwuG41tuLpW2k8n4Tb
	 1FQvYj3M7lxglV0T2j6zl8ibVVmKs6jK7MUkOl3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	T Pratham <t-pratham@ti.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 320/507] crypto: ahash - Zero positive err value in ahash_update_finish
Date: Tue, 16 Dec 2025 12:12:41 +0100
Message-ID: <20251216111357.061242912@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit ebbdf6466b30e3b37f3b360826efd21f0633fb9e ]

The partial block length returned by a block-only driver should
not be passed up to the caller since ahash itself deals with the
partial block data.

Set err to zero in ahash_update_finish if it was positive.

Reported-by: T Pratham <t-pratham@ti.com>
Tested-by: T Pratham <t-pratham@ti.com>
Fixes: 9d7a0ab1c753 ("crypto: ahash - Handle partial blocks in API")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/ahash.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index 5248aab939ca7..09a02ed4c4a09 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -423,7 +423,11 @@ static int ahash_update_finish(struct ahash_request *req, int err)
 
 	req->nbytes += nonzero - blen;
 
-	blen = err < 0 ? 0 : err + nonzero;
+	blen = 0;
+	if (err >= 0) {
+		blen = err + nonzero;
+		err = 0;
+	}
 	if (ahash_request_isvirt(req))
 		memcpy(buf, req->svirt + req->nbytes - blen, blen);
 	else
-- 
2.51.0



