Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027837;
	b=AoxbH+gB3//8FUV51cw2UvLBE0IBR3PytSXzDyGeTO0lB+gUWCw4ZO6aFbyrZL4Q3vgN
	 G9xBPHsQnDdNLUCShfXxiCLEGd0cIK9vXZ5CFbh8mwXl7DCgcArEsLIzwZFqucHEzJ9wT
	 G0OS5UcMmEYFitt2+6CP7rZQhvgkEE9+5CaT8mEl5ebSwMeFqx5kw1JERHlxTJKKUT1aU
	 ZtmXtrpMUIwMj3zaJxAtoaoriCmpGndlb28gBajhrGoWJd4SYjYsDBoTjZKoOT4bh0NTc
	 0zAmalNGNK6jfj5Iu+qe6bBJajeIAc6ZEc+NviQGItsmoydwnbnUPr0xYyQJEaRWJ4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027837;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GaRZKfRRwwjliaRjXL4JZrB7vmi6BxSpvMQIeZ0ZdDo=;
	b=ZMnmFvX+OWkQM6i8QQgiU/L83qbvmWV2dhaOMvLgaOPAyTWmwCdU503Ncu/rE3PH1Nf0
	 w54i9PAQVbkVR73MWpdRU69Rf2SH8d7y6lyyhkLEuvSO1/1JS785l1KLSgRLrQ23zhERS
	 zY9004FeEcQ1rBqTem8W89jiojyMcCe5ydYKbvhxJ7gUwBVrsDZDCOcBsN/dEEvFFTBlB
	 fxRamlQs7XtPLeplBTPxVXLlyOnc/Zk5Hb0z/OTeyVDQM0POYtr1UPNu7MTuMru+dEIJn
	 GrmX63Z+MvUm1CScVN0MjIlz+exr7bzp3FoOIP6jurJ+TMBLzZFX9mJU80uwIdQYkjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HBL+qZO6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E97E1606A325;
	Wed, 18 Nov 2026 18:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HBL+qZO6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 482021F000C5;
	Wed, 18 Nov 2026 18:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027836;
	bh=GaRZKfRRwwjliaRjXL4JZrB7vmi6BxSpvMQIeZ0ZdDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HBL+qZO6gMMccLoOUG6cahh7HK/tNU5+U1Bu1o8dOukPt6Z41Ftlgr7wEiVfy0gQF
	 PDEAHSYkxN+jXSDwXfaqOzZ3dclreggV3mvm3GcoJojCQi9BIeLyORno5589LHpqdl
	 EH+4aNomSvtPJsUNbqZ3VIplUbuP/FkR7ImGxtf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nandor Kracser <nandor@riptides.io>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1931/2151] tls: avoid field-spanning write when copying crypto info
Date: Wed, 18 Nov 2026 16:01:06 +0100
Message-ID: <20261118150232.121966015@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index ab30f5de2c658..2def86a236f8d 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -688,8 +688,8 @@ static int do_tls_setsockopt_conf(struct sock *sk, sockptr_t optval,
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



