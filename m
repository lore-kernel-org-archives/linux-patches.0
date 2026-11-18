Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050470;
	b=B3/T/t7rmMsnUDBc7Mit169ghlOFacY8/BeU1/ih2rk2nFEWQ0LeZW+W9kCbZd8WtZF2
	 yabGvGkH+bwV2f4my1E/qQDqamZ53wfGUz9+u9Vlc4Urwy7bTK0qdVvTmQkWpBqpsMyJr
	 hzFJjZpK2AKWj9gVFddcrzEC/jZQyFNYBbdw3HHeNV5Bn24/Sfmuu9ZuuoJvC85O7NrRD
	 kAM10xd8P33Zl1IcZBkIh59L/EkggoHdyoSwDiz4s/T1ZtwVS6oHzp8cvKJ1NOM2liE32
	 kMTZj9UzzIyg8OhX65Xa39vWa7UfIwrXL/MNuL2Oif2EkXVAEve+DFFzhAoNTa42vQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050470;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GyOUhKtvIplUhyyrOjsPHAsoVOneytSGXNmJlxKWZWI=;
	b=1v40lsnre6Y6g/bO+dciIkpWT9UG46tcH4A78FpYEviraFJK2313wHg8+dew0xOvJNST
	 YMl7vPRqtdLMT7MhOWEOnw8ZXgESoX9mrcMODQ+IpcTul1m97QFqiF8v7B836NtHC1Vl/
	 mvgkh75aCYzN9dD2KHS5EzVFP46iIlpN5dLgzc9b338i2mJpr2s3wk4dcOgtt/Bh0sH/W
	 5TPHzvsguAiF0MMlLdseK8zgAYRKM0H4KQLhUpQKVRbm/v8+QIKjDtxlHLgQKwdOCHc4o
	 6vqNasYCIinCUBwJsWKmNDUpsFGGM83ckXKRxqrPiV8s3kiyuDBeVgpyT2KIZlyyw+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CK66xitC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 667D9606A31C;
	Thu, 19 Nov 2026 01:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CK66xitC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B91781F000C6;
	Thu, 19 Nov 2026 01:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050470;
	bh=GyOUhKtvIplUhyyrOjsPHAsoVOneytSGXNmJlxKWZWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CK66xitCEiXP0bobWdKWl8T/beBI1OKK67UoYvpIyErEHEbKhpcgKVqGvxSaNRSIr
	 SaKr4KlibDtwxtTZ5iX/DsqIdnVZQ8FxmJyrqqfsdR773gDR78syZU8BBYrt2jseYq
	 5Lxf+W0n6mPp5vc6mpJXr7gCMR0g2OM+d4h7+Xvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nandor Kracser <nandor@riptides.io>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2720/2857] tls: avoid field-spanning write when copying crypto info
Date: Wed, 18 Nov 2026 16:02:34 +0100
Message-ID: <20261118150339.549012086@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nandor Kracser <nandor@riptides.io>

[ Upstream commit c43c1c24f3cdc0d2d3f59e5686573ac3129637aa ]

do_tls_setsockopt_conf() copies the cipher-specific part of the crypto
info to crypto_info + 1, where crypto_info points at the 4-byte info
member of union tls_crypto_context. When optval is a kernel sockptr,
copy_from_sockptr_offset() is a memcpy(), and FORTIFY_SOURCE bounds the
destination by that member:

  [    6.948348] memcpy: detected field-spanning write (size 52) of single field "dst" at include/linux/sockptr.h:49 (size 0)
  [    6.948480] WARNING: include/linux/sockptr.h:49 at tls_setsockopt+0x9b2/0xa30, CPU#1: init/1
  [    7.001355] Call Trace:
  [    7.003146]  do_sock_setsockopt+0xb0/0x190
  [    7.003975]  __sys_setsockopt+0x76/0xc0
  [    7.005368]  do_syscall_64+0xda/0x4b0

tls_setsockopt() gets a kernel sockptr whenever a cgroup setsockopt BPF
program is attached, even one that leaves the option alone, because
__cgroup_bpf_run_filter_setsockopt() passes optval on in a kernel
buffer. With a no-op program on the root cgroup, a plain TLS_TX
setsockopt() with AES-GCM-256 triggers the warning above on an x86_64
build with CONFIG_FORTIFY_SOURCE.

Copy into the union at offset sizeof(struct tls_crypto_info) instead.
crypto_ctx already points at the right union for both the first set
and the TLS 1.3 rekey (tmp) case, and the address is unchanged.

Fixes: a7b75c5a8c41 ("net: pass a sockptr_t into ->setsockopt")
Signed-off-by: Nandor Kracser <nandor@riptides.io>
Link: https://patch.msgid.link/20261021073233.16720-1-nandor@riptides.io
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index 1555b67e45a61..3293f84bd0456 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -762,8 +762,8 @@ static int do_tls_setsockopt_conf(struct sock *sk, sockptr_t optval,
 		goto err_crypto_info;
 	}
 
-	rc = copy_from_sockptr_offset(crypto_info + 1, optval,
-				      sizeof(*crypto_info),
+	rc = copy_from_sockptr_offset((u8 *)crypto_ctx + sizeof(*crypto_info),
+				      optval, sizeof(*crypto_info),
 				      optlen - sizeof(*crypto_info));
 	if (rc) {
 		rc = -EFAULT;
-- 
2.53.0



