Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAF4654BFE;
	Tue, 14 May 2024 11:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685383; cv=none; b=Md9eiXp9jKYK2sLgP9969qhvUZLg2rlJjGBrhjXNnUhsO/sqZFCg7TeAjXiKdaMZtNcK/9qvqbJkTcUAv9Ta9qYKyANMW9dVqqC4L984iV318ie75FtwAnr2qcP0nT5evTpvycXwxXGMEXS3lXBHm+xZqMGxetyxfOIqtZGaxqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685383; c=relaxed/simple;
	bh=F3aTIZGQiwdxDX7sWyLR2X806P7vNYAdUdeI4cEN4YQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n1Q6up8loIap7YbgrcGbEmlAnv4OxKMC+9mPFuBs+u7IYBXHfHWd5C+ktEWMIHlnk74f8Zg64+Q7sLUSWBnayfmsY+dJ1v1jTqu5xeT0QTXH4lNpR1oh0wWRIioHdsQEZoxYegU6O/VRR1I3AYJwajgLnVDokRQdOozLF2g2cCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hxd0tmQz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hxd0tmQz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05EE8C2BD10;
	Tue, 14 May 2024 11:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685383;
	bh=F3aTIZGQiwdxDX7sWyLR2X806P7vNYAdUdeI4cEN4YQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hxd0tmQz5od93ePvc+2KHoC2yMERsdNfcE9WNPpu4ubYdKH1QAXjLTvL5j1/pz473
	 O6H35b/cb14Va3NN/3ATFBA6u9RLV9DP44/gOmWN1K2cy32kx69EPde1zu+38I9Pi1
	 7+W0O8glNzKvYlY4JW9QPhKXbfms5o+W9V12VRPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Michal=20Such=C3=A1nek?= <msuchanek@suse.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 162/301] powerpc/crypto/chacha-p10: Fix failure on non Power10
Date: Tue, 14 May 2024 12:17:13 +0200
Message-ID: <20240514101038.373772040@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit 69630926011c1f7170a465b7b5c228deb66e9372 ]

The chacha-p10-crypto module provides optimised chacha routines for
Power10. It also selects CRYPTO_ARCH_HAVE_LIB_CHACHA which says it
provides chacha_crypt_arch() to generic code.

Notably the module needs to provide chacha_crypt_arch() regardless of
whether it is loaded on Power10 or an older CPU.

The implementation of chacha_crypt_arch() already has a fallback to
chacha_crypt_generic(), however the module as a whole fails to load on
pre-Power10, because of the use of module_cpu_feature_match().

This breaks for example loading wireguard:

  jostaberry-1:~ # modprobe -v wireguard
  insmod /lib/modules/6.8.0-lp155.8.g7e0e887-default/kernel/arch/powerpc/crypto/chacha-p10-crypto.ko.zst
  modprobe: ERROR: could not insert 'wireguard': No such device

Fix it by removing module_cpu_feature_match(), and instead check the
CPU feature manually. If the CPU feature is not found, the module
still loads successfully, but doesn't register the Power10 specific
algorithms. That allows chacha_crypt_generic() to remain available for
use, fixing the problem.

  [root@fedora ~]# modprobe -v wireguard
  insmod /lib/modules/6.8.0-00001-g786a790c4d79/kernel/net/ipv4/udp_tunnel.ko
  insmod /lib/modules/6.8.0-00001-g786a790c4d79/kernel/net/ipv6/ip6_udp_tunnel.ko
  insmod /lib/modules/6.8.0-00001-g786a790c4d79/kernel/lib/crypto/libchacha.ko
  insmod /lib/modules/6.8.0-00001-g786a790c4d79/kernel/arch/powerpc/crypto/chacha-p10-crypto.ko
  insmod /lib/modules/6.8.0-00001-g786a790c4d79/kernel/lib/crypto/libchacha20poly1305.ko
  insmod /lib/modules/6.8.0-00001-g786a790c4d79/kernel/drivers/net/wireguard/wireguard.ko
  [   18.910452][  T721] wireguard: allowedips self-tests: pass
  [   18.914999][  T721] wireguard: nonce counter self-tests: pass
  [   19.029066][  T721] wireguard: ratelimiter self-tests: pass
  [   19.029257][  T721] wireguard: WireGuard 1.0.0 loaded. See www.wireguard.com for information.
  [   19.029361][  T721] wireguard: Copyright (C) 2015-2019 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.

Reported-by: Michal Suchánek <msuchanek@suse.de>
Closes: https://lore.kernel.org/all/20240315122005.GG20665@kitsune.suse.cz/
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20240328130200.3041687-1-mpe@ellerman.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/crypto/chacha-p10-glue.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/crypto/chacha-p10-glue.c b/arch/powerpc/crypto/chacha-p10-glue.c
index 74fb86b0d2097..7c728755852e1 100644
--- a/arch/powerpc/crypto/chacha-p10-glue.c
+++ b/arch/powerpc/crypto/chacha-p10-glue.c
@@ -197,6 +197,9 @@ static struct skcipher_alg algs[] = {
 
 static int __init chacha_p10_init(void)
 {
+	if (!cpu_has_feature(CPU_FTR_ARCH_31))
+		return 0;
+
 	static_branch_enable(&have_p10);
 
 	return crypto_register_skciphers(algs, ARRAY_SIZE(algs));
@@ -204,10 +207,13 @@ static int __init chacha_p10_init(void)
 
 static void __exit chacha_p10_exit(void)
 {
+	if (!static_branch_likely(&have_p10))
+		return;
+
 	crypto_unregister_skciphers(algs, ARRAY_SIZE(algs));
 }
 
-module_cpu_feature_match(PPC_MODULE_FEATURE_P10, chacha_p10_init);
+module_init(chacha_p10_init);
 module_exit(chacha_p10_exit);
 
 MODULE_DESCRIPTION("ChaCha and XChaCha stream ciphers (P10 accelerated)");
-- 
2.43.0



