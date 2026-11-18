Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021657;
	b=sx6KHUY8sGTLViJtnbGfHpDg70IUBwuY94QoOXt4j9JpoPGUSEgYSqA1X5fIFt3yCAav
	 eRaqj0T4NMuuFGS/+WiccrsKd6aOXmIIRIGG7q4g9xNJVDtNlXIm8dTo2L0ppUUCHvfy+
	 TXdVHxGBzEwHL00SixeieneAz02who9F8UrRsDrn4B2dqEZTR6MhnjN16jbOIWROlMySk
	 ouUTBVk/drt20XlzfZju5fP38wNzrHnlQCMy86FDzzGl+vjY/4s/PU4vp/dUEbxNas3Lu
	 s8fK6ugre3RM2Cgn7vQeUldGFnYvMjLJ7GmyXwVJygf5+1WzTAc2OLmkG2TxOovL8GQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021657;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0vzYh3K9E24XEHa81Go0dalbsKnquRXCIxRxguNIWuk=;
	b=s/EHfU9TgHeTAaOaofO+IgZ3NlwxX2kuLHId9aTG9F0KBMZbKfJiwF8h2IYUzGaY0S5b
	 BQADmonpbLD7RRYkkzYK2K0Ovnz0WVwHg6XYca1GoiHgeQI5hSfbdMop4IwJ2XJw1UbXV
	 H7s9nMjl+cLNJ6wyKuJAQfQaZ/skAb/lzT6qgEmUC7CAKc4mIFXjyyH+caIVnrorkbXni
	 m93/9EekDevRk4WtwQLfU+mz3i2thcDjWNVVQfSzoOrt8MnLwZriDXu2xIQO2oAng3aCk
	 ICZGACm/UQtdm2zOp2fdVZJNftFDW2jDCRYcUj85tCiiDpS9eg28H/YyZC4/0JpExww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Y9+h/OWL";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 127C6606A31C;
	Wed, 18 Nov 2026 17:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y9+h/OWL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E2591F000C4;
	Wed, 18 Nov 2026 17:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021656;
	bh=0vzYh3K9E24XEHa81Go0dalbsKnquRXCIxRxguNIWuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y9+h/OWL5U1QtyjTjGltPqW5DBmnssM9bekFXM55ToBh2JjwWvMolOParIP/KogHd
	 /ZEQz23v93L4HGeTAKMO6MP2guGssUeyI20FKdo3Kkf1dU53TB2eAeH7XFKgOw8Zbl
	 soZq/Z6ISGAI2+HALllQJ03xyTXZIlFldWEblR2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nandor Kracser <nandor@riptides.io>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2385/2651] tls: avoid field-spanning write when copying crypto info
Date: Wed, 18 Nov 2026 16:00:25 +0100
Message-ID: <20261118150411.290687824@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 2d1cde3f61886..f13faafe58d20 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -701,8 +701,8 @@ static int do_tls_setsockopt_conf(struct sock *sk, sockptr_t optval,
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



