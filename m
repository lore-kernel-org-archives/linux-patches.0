Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D7AFDDA9;
	Mon, 27 May 2024 19:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836411; cv=none; b=BAgNgi41ryP4/OsIFfq90QPCFo2QgYnw3fV9719Onlbw71b2BxOgsjJBpiCs5nlmfoLMF7ekx2M5Qvtof4oaB4iNf0c5Qx0ZySFRZSbYJH//+DJSuVo4+27N7fcejVgJyYKp4axEaDSgEQtMMR1koSMMrd+NNLefvzVorhe0ImY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836411; c=relaxed/simple;
	bh=AvW51SVkt4ya0Rd9YoSLXMyLuA22UcjxExHSes/aRn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mNwevCX5tld9w4AEq/rUns9Tl3ZTns77uK5G0UPxpVsyCGCJWaDs9VOvO1ZLzuyx/Evvj9VsHcHyQnW3n3hvMbPeuwCalQ2t7Ba4tTQZkJyBeBBzmhKs7D8RnPASk6rHqphC/R8RKxqPVMjoMhLqHhsCG0x+6bk6yWTzQq3sjfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r7THi77c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r7THi77c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EABBFC2BBFC;
	Mon, 27 May 2024 19:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836411;
	bh=AvW51SVkt4ya0Rd9YoSLXMyLuA22UcjxExHSes/aRn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r7THi77cwb6Nae4gThuk9kZp628l1oVrT3rdIfTaX94Ul3AedFlAFmQI4zbQtW0x2
	 XTW52s/71+PAuP17wYt5z8crQp8uya5vNFcs0L3JIiJmEgIYXHf1QRBWPy5cdYVC02
	 qXgYAFfk2GxZ7fvQiGk2L2ua8ZLzMCLPHCkqLCWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@google.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.9 041/427] KEYS: asymmetric: Add missing dependency on CRYPTO_SIG
Date: Mon, 27 May 2024 20:51:28 +0200
Message-ID: <20240527185605.532204335@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@google.com>

commit dcaa86b904ea3761e62c849957dd0904e126bf4a upstream.

Make ASYMMETRIC_PUBLIC_KEY_SUBTYPE select CRYPTO_SIG to avoid build
errors like the following, which were possible with
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y && CONFIG_CRYPTO_SIG=n:

    ld: vmlinux.o: in function `public_key_verify_signature':
    (.text+0x306280): undefined reference to `crypto_alloc_sig'
    ld: (.text+0x306300): undefined reference to `crypto_sig_set_pubkey'
    ld: (.text+0x306324): undefined reference to `crypto_sig_verify'
    ld: (.text+0x30636c): undefined reference to `crypto_sig_set_privkey'

Fixes: 63ba4d67594a ("KEYS: asymmetric: Use new crypto interface without scatterlists")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/asymmetric_keys/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/crypto/asymmetric_keys/Kconfig
+++ b/crypto/asymmetric_keys/Kconfig
@@ -15,6 +15,7 @@ config ASYMMETRIC_PUBLIC_KEY_SUBTYPE
 	select MPILIB
 	select CRYPTO_HASH_INFO
 	select CRYPTO_AKCIPHER
+	select CRYPTO_SIG
 	select CRYPTO_HASH
 	help
 	  This option provides support for asymmetric public key type handling.


