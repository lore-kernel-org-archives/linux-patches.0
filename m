Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7F643DC4D5;
	Mon,  4 May 2026 14:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903313; cv=none; b=r8OUOWoEXp2ppD8iAFNDECza1l3D7V2seEX2fDbnAceTh8Nka0rB6ImD8vhuMKNjg2Nw5Ck3RUhtbBvEGNGVvzf8Vh9PaW8oAEfkXjABJ9xSGSQJ1OczMx+YB7h2x8MIId8BCavy5AN1fLGRT66VyNxoSsqcvxvyaaMQBjEldaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903313; c=relaxed/simple;
	bh=LLXAFMSsCGwsQq2VAPAI5jwdBQ6r0im3gz4bFx1RBW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VDrjDBIQGdpQMDdI7FDgJK+jVX7ZSsHH5gfCAA0xz/pbS9VrlG+rQPZ4D9PanaXVc9DwdJzCaT6fPhd0i6Xt/9KgcWORzo6McFIDFg1s0k4ob7PO76gkGS0HzJmgQBAtAOrP5IxaKvnooSPzLglocf4oK+orpZrufyMaKWC1ILw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BpHhqEsc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BpHhqEsc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75FDFC2BCB8;
	Mon,  4 May 2026 14:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903312;
	bh=LLXAFMSsCGwsQq2VAPAI5jwdBQ6r0im3gz4bFx1RBW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BpHhqEscy9SIfHU8brXnhepz7s0VWNId/PswIzLWnY0JKnplllSuGoO+lcQzQDosk
	 Tn5Ss9aEr2MGIxVdsDK7YQGKKAio4RvAoT2x2llXTaCAwTIUIBBD39vaqVG0RQu298
	 fQLvRQL4iwQrUj17r8aWVB03SfJBeO5j0lk3V0Y4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gunnar Kudrjavets <gunnarku@amazon.com>,
	Justinien Bouron <jbouron@amazon.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 7.0 186/307] tpm: Use kfree_sensitive() to free auth session in tpm_dev_release()
Date: Mon,  4 May 2026 15:51:11 +0200
Message-ID: <20260504135149.877747178@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gunnar Kudrjavets <gunnarku@amazon.com>

commit c424d2664f08c77f08b4580b5f0cbaabf7c229b2 upstream.

tpm_dev_release() uses plain kfree() to free chip->auth, which contains
sensitive cryptographic material including HMAC session keys, nonces,
and passphrase data (struct tpm2_auth).

Every other code path that frees this structure uses kfree_sensitive()
to zero the memory before releasing it: both tpm2_end_auth_session()
and tpm_buf_check_hmac_response() do so. The tpm_dev_release() path
is the only one that does not, leaving key material in freed slab
memory until it is eventually overwritten.

Use kfree_sensitive() for consistency with the rest of the driver and
to ensure session keys are scrubbed during device teardown.

Cc: stable@vger.kernel.org # v6.10+
Fixes: 699e3efd6c64 ("tpm: Add HMAC session start and end functions")
Signed-off-by: Gunnar Kudrjavets <gunnarku@amazon.com>
Reviewed-by: Justinien Bouron <jbouron@amazon.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tpm/tpm-chip.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -247,7 +247,7 @@ static void tpm_dev_release(struct devic
 	kfree(chip->work_space.context_buf);
 	kfree(chip->work_space.session_buf);
 #ifdef CONFIG_TCG_TPM2_HMAC
-	kfree(chip->auth);
+	kfree_sensitive(chip->auth);
 #endif
 	kfree(chip);
 }


