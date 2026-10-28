Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211399;
	b=ybbKcoCLVud5UeTzUlgXHkND/4pcQ2Wjbr4dhHICVKJFGVQBVSy7pI4CxwVY/hUVTNP+
	 a5FRxIcO+6DtqPAc3h4tedfqTe61RC2qhgc2OLhHdpNUgfNi9THIrIJtPEBUynqd/IHTd
	 eGBevsHjhxp9CV5jpV+KGr5B+lShm7dhKL4egRBxwyWGFfeCXdIvwZ8ilQ1rxuFHe78cb
	 sNOt7NR3tZmKj7foOzHpQuDTwPiVu1+rssUHV7s2aoThNj+oF/w4ci5BSp6n0uPYeb5qL
	 jnYa0YzGDlnQwd0nQ5mTku8BQAAcsfCyfvJ5VQVU45ZYj1z4QS2+7j8gx2GMV25XE9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211399;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=l7BJCRAGgUtvebaHTZFYBLbXxxRlRJZEwUpFjsxpg4s=;
	b=OvkUJdZ9K9NnIFMu3cYDxUDeV7VUoUNefHW56gGKELHRCQeNLWNe7+ZuBmQW7W5U0kBc
	 3LpLhZHclYS2fPB88nSvkO6+WgwupqLAqXeSTYa10up80Dltb8w3TdKZsBtvfaCihlUnE
	 JR2zGDq09pCTLdd2OV/v99fcZKX3ZCzgJvwq3fMl5PzJN91O82q6LkifCybK6z3S1HUUn
	 reNiu9ZRHkdwDggApnaJq3jfQY4aniFczZX0HAHOJdaPOfEYYGyqWKpjj+E2KSb4bTy/j
	 vD7PzTdLfb1FmsJZFoq8TX3UdKs/55x8d6MsU3+9tMov5noRNLPVFuWu9FRfjrSihHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FMdVun94;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25888606A321;
	Wed, 28 Oct 2026 18:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FMdVun94
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75C521F01825;
	Wed, 28 Oct 2026 18:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211399;
	bh=l7BJCRAGgUtvebaHTZFYBLbXxxRlRJZEwUpFjsxpg4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FMdVun94dJiU2BzL1t406L8I+u0mq/1zoWTx3PSoaF1uJ4cLj4dhK8bEr+EzUBkEP
	 bAPJp4eu6vCz8xDZsGGW2bCXemL5FfqcHWtc/IaASDRNeh2Oy5uNXSwP6kwS2TQlw/
	 a2Lkxa+pmPu3tWdP1+5ZC8/59nthWV+YNgtVEHBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=EC=84=B1=EB=B3=91=EC=B0=AC?= <tjdqudcks0424@naver.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 5.15 362/571] KEYS: Fix add_key() race with keyring restriction
Date: Wed, 28 Oct 2026 17:58:29 +0100
Message-ID: <20261028170016.605423684@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: 성병찬 <tjdqudcks0424@naver.com>

commit dd3ea3fcba7c75493760cdbccd35f029597e8d5e upstream.

__key_create_or_update() snapshots keyring->restrict_link before taking
the destination keyring's semaphore.  keyring_restrict() installs a
restriction while holding that semaphore.

This allows a writer to observe no restriction, wait for the keyring
owner to install a reject-all restriction and return successfully, and
then link a key using the stale NULL snapshot.  The writer only needs
write permission on the destination keyring.

Move the restrict_link read after __key_link_lock() and
__key_link_begin().  The read and the subsequent restriction check are
then serialized with restriction installation by keyring->sem.

The race was reproduced on v7.2.8 in 19 executions where restriction
installation returned before the link completed.  All 19 linked the key
despite the reject-all restriction.  With this change, 312 executions
reached the same ordering and every add_key() call failed with -EPERM.

The issue was found by manual concurrency analysis assisted by AI-based
analysis and independently verified with a QEMU reproducer and kernel
instrumentation.

Fixes: 5ac7eace2d00 ("KEYS: Add a facility to restrict new links into a keyring")
Cc: stable@vger.kernel.org
Signed-off-by: 성병찬 <tjdqudcks0424@naver.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Link: https://lore.kernel.org/r/20260930041802.6114-1-tjdqudcks0424@naver.com
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/keys/key.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/security/keys/key.c
+++ b/security/keys/key.c
@@ -845,9 +845,6 @@ key_ref_t key_create_or_update(key_ref_t
 
 	key_check(keyring);
 
-	if (!(flags & KEY_ALLOC_BYPASS_RESTRICTION))
-		restrict_link = keyring->restrict_link;
-
 	key_ref = ERR_PTR(-ENOTDIR);
 	if (keyring->type != &key_type_keyring)
 		goto error_put_type;
@@ -885,6 +882,9 @@ key_ref_t key_create_or_update(key_ref_t
 		goto error_link_end;
 	}
 
+	if (!(flags & KEY_ALLOC_BYPASS_RESTRICTION))
+		restrict_link = keyring->restrict_link;
+
 	if (restrict_link && restrict_link->check) {
 		ret = restrict_link->check(keyring, index_key.type,
 					   &prep.payload, restrict_link->key);


