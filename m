Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2BDE19E7E1;
	Thu,  6 Jun 2024 14:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683108; cv=none; b=G5SXEECIoqerQd8XptySbJ/o7F3vacbfHh6+7DnUIHBYHahC/0KfAQ2ZTJFHX2djmUcbIJ9WfTN4IFBt3e+wI4EI1Ve7yAoKz865XrRO+slIbuUSr/DN8wf8NSZoyIyqaePjq1ioWi4oN0zZnq7xShGEEsD1+b9j2hXOO8y8XJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683108; c=relaxed/simple;
	bh=hNeUfJa6Xe+7vWr0Mi9l4Llh/CGw8iSrVXbLF2CXApI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JCJ5+yYRoaWBcLHPzcFF6GrIa5zpcSI8zb+e5fzoiwKGJ+zQmQAirEX7k21OJc5ZtmsGam94V6LlhaYVVVONSQ4P1Do9podUiUDE6qqQjrXYLQd+raKveltniWG4AUWt4UeL2d7VFUF7JatFJmXjHQWpzOCROB46wiBoYZJHqYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sMyoEn/y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sMyoEn/y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C328FC32781;
	Thu,  6 Jun 2024 14:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683107;
	bh=hNeUfJa6Xe+7vWr0Mi9l4Llh/CGw8iSrVXbLF2CXApI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sMyoEn/yZSJhWatSZHniZI+Y1A2SXhKxcb20KAeqw/BHK7sL7FgHrzQG75z7Q7fdh
	 HMOvs3WylukJoiIInqPXPspN2TT5lPFGzJ3tuWSS6hHMATVe5kGqmQAUvIUFNzv6wm
	 +O8Z6NaKWXeTMHXWT/UfS+pJAC61kh4ELkaR5GNM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@google.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.6 032/744] KEYS: asymmetric: Add missing dependency on CRYPTO_SIG
Date: Thu,  6 Jun 2024 15:55:04 +0200
Message-ID: <20240606131733.488130928@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 crypto/asymmetric_keys/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/asymmetric_keys/Kconfig b/crypto/asymmetric_keys/Kconfig
index 59ec726b7c77..3f089abd6fc9 100644
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
-- 
2.45.1



