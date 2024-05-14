Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F112D69D2F;
	Tue, 14 May 2024 10:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683412; cv=none; b=CEi4h1CUClkY7msxiAx+zR66I9TxZaH0QfGgjum5cIogESpimrDu8tSRkzc0AYtv4RSB+KuI6yZ1kCQQLQDa+3Wa7pbbsKjxVYhuxZzDZgICnvFbmPe0qGVMTnjGerOURUyI8dhaqlRxavjuQUsyRznXmzlZZDWWpUcQ+xAECGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683412; c=relaxed/simple;
	bh=EHzDHpay2D8hlnoOmJ+nB5b3ImK7/R9Htzpas16XlqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jqnzHAsxvgUN7Upg7FPKnuxboEa22Vf7zDWA7WGpCLOfDbqknwD4flTeHwUcmvV9p9o0y2vXg5pWb4YNZw5WzYEA+6STa8PJMKzZYYV2u+QTpQOYWHPJWBv9B5HmKj9kldHk0TQ2NCEgQ3T3LpyNGKFCjrP0s7kFa3rjj9UhUYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=etPrKJsC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="etPrKJsC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76CFDC2BD10;
	Tue, 14 May 2024 10:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683411;
	bh=EHzDHpay2D8hlnoOmJ+nB5b3ImK7/R9Htzpas16XlqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=etPrKJsCgEzKLmOwzBW2+R7/Unk6XOOB3XA4eGtbtMqSvVkFKE/LBsZMa6nouqZpo
	 DgAVVjYwUTZl0KF+z68vw5GhCymm+jJiaWOescs/mDeW4t3jAibgUFOYprRW4tYBFY
	 iUnEaeTsYkLlkTG64eX1ASevckHck/Wa2ysocucw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Michal=20Such=C3=A1nek?= <msuchanek@suse.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 181/336] powerpc/crypto/chacha-p10: Fix failure on non Power10
Date: Tue, 14 May 2024 12:16:25 +0200
Message-ID: <20240514101045.436919558@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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



