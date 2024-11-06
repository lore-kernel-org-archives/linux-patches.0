Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDFE81D5AD7;
	Wed,  6 Nov 2024 12:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895101; cv=none; b=AlKxrL0rqqhA/sE3e3j4basw1D/hVSiM2g0PseMGkb5Eblysl7YSwAWrSQ6WW8z/i5+tYA3xD+FrgyIFfxlsn77VxcOlDy9zUWFdEWHkGIJ5OShf1LDlbyBVCDmL5JLOf5IHZWJQR7StaYECeSTr28FIYP0Pq3tdPplp3J5ci60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895101; c=relaxed/simple;
	bh=V6yUbYcXrkEevjRTx63yR+5SbcTHZ8w+JkG2ZWVb7Gk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LWk93Ei5mraYe6n7hXee3jxmF5Nr6R5i/qizgio3O5ZujDjcOnR/6SV3Xe4pfeLEoIbdYrFwiwnKLMWR9GZIyTWDxoIDwwq+qy5C6BdpV+TrLzpu7dLFVOZD9lU189z9zyZq7RuivUSCuWEJYohur4ZZa+lu5WynRU5q3om8BTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PHenF7tT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PHenF7tT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7838BC4CECD;
	Wed,  6 Nov 2024 12:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895100;
	bh=V6yUbYcXrkEevjRTx63yR+5SbcTHZ8w+JkG2ZWVb7Gk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PHenF7tT6a3sqjiA7Gaft8Xy0SVVexhgUJEY03f3sZd/5se1TIzhpDo8PRGARXt1i
	 d2HWlpLcTopMyrYyJuppQH4q4RGZ1Oy5u14r7UohWNBurDVTg47/GXqIHYxZfmyr0J
	 GwmeSHA5UddP+KvOl88MB5GTKbHn3JN8gCcxZPE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hailey Mothershead <hailmo@amazon.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Hugo SIMELIERE <hsimeliere.opensource@witekio.com>
Subject: [PATCH 4.19 106/350] crypto: aead,cipher - zeroize key buffer after use
Date: Wed,  6 Nov 2024 13:00:34 +0100
Message-ID: <20241106120323.519951776@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

From: Hailey Mothershead <hailmo@amazon.com>

commit 23e4099bdc3c8381992f9eb975c79196d6755210 upstream.

I.G 9.7.B for FIPS 140-3 specifies that variables temporarily holding
cryptographic information should be zeroized once they are no longer
needed. Accomplish this by using kfree_sensitive for buffers that
previously held the private key.

Signed-off-by: Hailey Mothershead <hailmo@amazon.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Hugo SIMELIERE <hsimeliere.opensource@witekio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/aead.c   |    3 +--
 crypto/cipher.c |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -45,8 +45,7 @@ static int setkey_unaligned(struct crypt
 	alignbuffer = (u8 *)ALIGN((unsigned long)buffer, alignmask + 1);
 	memcpy(alignbuffer, key, keylen);
 	ret = crypto_aead_alg(tfm)->setkey(tfm, alignbuffer, keylen);
-	memset(alignbuffer, 0, keylen);
-	kfree(buffer);
+	kzfree(buffer);
 	return ret;
 }
 
--- a/crypto/cipher.c
+++ b/crypto/cipher.c
@@ -38,8 +38,7 @@ static int setkey_unaligned(struct crypt
 	alignbuffer = (u8 *)ALIGN((unsigned long)buffer, alignmask + 1);
 	memcpy(alignbuffer, key, keylen);
 	ret = cia->cia_setkey(tfm, alignbuffer, keylen);
-	memset(alignbuffer, 0, keylen);
-	kfree(buffer);
+	kzfree(buffer);
 	return ret;
 
 }


