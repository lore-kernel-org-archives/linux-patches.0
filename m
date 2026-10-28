Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211980;
	b=KS6ZDeC8jMB0AjySxBqJit1AUxhpkd9hwmnBdb3+8uyWQzKrdyhJR+5y3vqTyQtZmxhp
	 e8YusQ3BeIBwKJG3G8NgTXAI58I7zip3AlxYxnKMIbWCqhI2dgJKXFDbmsmvRt4xcFmld
	 rh9WnB4eBV/xKWn/avK2bn0Tt8PtR8UA3+cs/yhXABmUUeSGh2CbQ0/XdJZ9IpR6eZVvG
	 lKmV1sNY/TBBS53IfCV0wVEnC1/iJnxxPQdABuaGpyYQUt0f+U+8xCKlzseRymXbesPsn
	 3lzS1ZGN2FujeTGNpP3oRz6j+iZ71QzMnCeiuzWcUPez7ixBdYEpVAQZFwe1UTDRQ3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211980;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=im/9taO+WhsXrbhsOq9PMUFu1FBxGYtOppFpapQYxgU=;
	b=qTb8fnDj3l8GC/Dl5MJul/Cw1fGiQ6aHu1nI4Nm3aVPQhM6qHL38CJhwD+wefnQIvIAy
	 E8TC1MQcYINEeVr2VF0D8xbT6zXfbH6bvKgApkhN4yuqgOvRwSjcdEfdCTHzYvQshAt5A
	 iP1TkqkWoKUQPgdpXk7L7HIFRfqfezuVXlGGOhiuGLjgfX9FfeMD79xXeekDu5H1Sj88c
	 pd+H24uvC+IUL75nypV20AmGdrY92ZpOeFWKrIXeP3uqqosr7/eIHfX+06D8PslyXM2eJ
	 /Og19u+tPvTXuvZTQDC66c8t5S1m/8DUcbbBjYN/GIrMR1uJuO5Yyd+N42qQhl7ml7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="v2/bbJIA";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 449B0606A31A;
	Wed, 28 Oct 2026 18:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v2/bbJIA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 948541F01825;
	Wed, 28 Oct 2026 18:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211980;
	bh=im/9taO+WhsXrbhsOq9PMUFu1FBxGYtOppFpapQYxgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v2/bbJIAFSXLvsN8ddLLkOQ/iE45LEfGAH5wZF7D/XmP2ax6njtFC0NTg4fJy/sxc
	 UPA1iw7TlMQCwoinRYenJUSXletEXL0rzzCmdUZm9l5gwDslChdf46W1MJmWfTIxnh
	 gfzIPgsb8T0K6CzcXVyTPIO+YevEtDnQssaaFhqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srish Srinivasan <ssrish@linux.ibm.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 5.15 569/571] keys/trusted_keys: return immediately after TPM unseal failure
Date: Wed, 28 Oct 2026 18:01:56 +0100
Message-ID: <20261028170021.540778683@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srish Srinivasan <ssrish@linux.ibm.com>

commit f92d0ccb05bf9089072cb067dda0dffd5394c4ef upstream.

trusted_tpm_unseal() proceeds to pcrlock() when the TPM unseal operation
fails. If pcrlock() succeeds, its return value overwrites the unseal error,
causing key instantiation to succeed.

Return immediately when unseal fails to preserve the original error.

Cc: stable@vger.kernel.org # v5.15+
Fixes: 5d0682be3189 ("KEYS: trusted: Add generic trusted keys framework")
Signed-off-by: Srish Srinivasan <ssrish@linux.ibm.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Link: https://lore.kernel.org/r/20260912062950.279104-2-ssrish@linux.ibm.com
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/keys/trusted-keys/trusted_tpm1.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/security/keys/trusted-keys/trusted_tpm1.c
+++ b/security/keys/trusted-keys/trusted_tpm1.c
@@ -959,8 +959,10 @@ static int trusted_tpm_unseal(struct tru
 		ret = tpm2_unseal_trusted(chip, p, options);
 	else
 		ret = key_unseal(p, options);
-	if (ret < 0)
+	if (ret < 0) {
 		pr_info("key_unseal failed (%d)\n", ret);
+		goto out;
+	}
 
 	if (options->pcrlock) {
 		ret = pcrlock(options->pcrlock);


