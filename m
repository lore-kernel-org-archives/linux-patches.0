Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208066;
	b=5g6ZtdL5gRDoiMCc5p2mUQMaj1bwlvffntyGvWE+JLNjsg87E1cY57vzNZi9jYNybg2/
	 A0QevYu2nkpdHH3XyGAaQmgXzFkYwvuJ/otlAr0LD438Q5X6tv63yuToNiT5rRlgyCoc4
	 VJciWn/+XIh6JngecXinv7Xh9E0g4BBbeRGbXZFGdSE0XiN/SAHjilT6wume7KVCbm/1x
	 VAY72pDGd8rZcfo0d76I1F5J1uczn0s85de+qxDhHwk4BVF2TXvVS60JdtHZ6CBqPaOkG
	 M/Eh4GmmUs9ffEXmd1++6gsuZ7/LllmJ9hox03vwzwhqsDIeDEtS2EYGXv8IHxI5dnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208066;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NODNaJFEL56IKVupwWLYwKrboDiugSjTnVRe5yZUZeE=;
	b=L/rxW6C1EjvpjVQ104KkevKwxhVjl/TPEh7e0wtLFKWSQiS451Bzs0hzVExLK4YyWC3W
	 N6mo11xuw7iAB5TgQVQwSpR3pwSU1ZA60CuxF1A1V5MwhVB9W0WgiUy+nL486kpM/vXLg
	 jf4yR1ymLuENN+Utmgi370pL9ggZCcCFnTer8ODOo0ldKtzpGbpAypDytDJ5TGANFGLQE
	 41JhsG2TLMQgg15t5riV9x6dDFIDDQMini5UJs0MMvtvxR+OztS2ZJZpC3rdmaM1PzNFO
	 RCQlnARp5rz0qAx8X2tDTqx4PV7B5ruCL7xEDnBohitFDvFhkDOZx/kkvvqFjM/OTcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DYft3bab;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98780606A32F;
	Wed, 28 Oct 2026 17:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DYft3bab
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E59611F01828;
	Wed, 28 Oct 2026 17:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208066;
	bh=NODNaJFEL56IKVupwWLYwKrboDiugSjTnVRe5yZUZeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DYft3babKPlOzDZokF+X7xCEJ+NP8nXmcQSLQKzCwW++wJiSvrwgUrsu2Ua/o8hJT
	 RrgOgx4hRtcL/8kkaHoZ4/uozOrE4iqEcM7359gj2XhjXxbJAZ53BlTeBTIXFtisuX
	 yjVaXyhZMRLzxr75mdBUJtIw1FZ6afs8MwVEMlpw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.12 238/247] asymmetric_keys: reject trust keys without IDs
Date: Wed, 28 Oct 2026 18:00:41 +0100
Message-ID: <20261028165953.058104501@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weiming Shi <bestswngs@gmail.com>

commit 9695df3b1db4ac4534274d38ee16e3b9b0bf910e upstream.

The PKCS#8 parser deliberately leaves the asym_key_ids payload slot
empty. key_or_keyring_common() unconditionally dereferences that slot
when a PKCS#8 key is supplied to a key_or_keyring restriction. Both the
plain and :chain forms reach this branch, allowing an unprivileged caller
to trigger a NULL pointer dereference through KEYCTL_RESTRICT_KEYRING
followed by add_key().

 Oops: general protection fault, probably for non-canonical address 0xdffffc0000000000
 KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
 RIP: 0010:key_or_keyring_common (crypto/asymmetric_keys/restrict.c:205 crypto/asymmetric_keys/restrict.c:279)
 Call Trace:
  <TASK>
  __key_create_or_update (security/keys/key.c:884)
  key_create_or_update (security/keys/key.c:1021)
  __do_sys_add_key (security/keys/keyctl.c:134)
  do_syscall_64 (arch/x86/entry/common.c:52 arch/x86/entry/common.c:83)
  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130)
  </TASK>
 Kernel panic - not syncing: Fatal exception

Reject an asymmetric restriction key without key IDs. A PKCS#8 private
key cannot identify the signer of a candidate certificate and is not a
valid trust anchor.

Fixes: 3c58b2362ba8 ("KEYS: Implement PKCS#8 RSA Private Key parser [ver #2]")
Cc: stable@vger.kernel.org
Reported-by: Xiang Mei <xmei5@asu.edu>
Link: https://lore.kernel.org/r/20260429181629.110802-2-bestswngs@gmail.com
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/asymmetric_keys/restrict.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/crypto/asymmetric_keys/restrict.c
+++ b/crypto/asymmetric_keys/restrict.c
@@ -240,10 +240,14 @@ static int key_or_keyring_common(struct
 			if (IS_ERR(key))
 				key = NULL;
 		} else if (trusted->type == &key_type_asymmetric) {
+			const struct asymmetric_key_ids *kids;
 			const struct asymmetric_key_id **signer_ids;
 
-			signer_ids = (const struct asymmetric_key_id **)
-				asymmetric_key_ids(trusted)->id;
+			kids = asymmetric_key_ids(trusted);
+			if (!kids)
+				return -ENOKEY;
+
+			signer_ids = (const struct asymmetric_key_id **)kids->id;
 
 			/*
 			 * The auth_ids come from the candidate key (the


