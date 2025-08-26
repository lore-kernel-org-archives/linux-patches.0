Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F5B9277C8C;
	Tue, 26 Aug 2025 11:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207030; cv=none; b=UEqppsX0EkriMQPJ53JTekLAASVDVT01lMZly6x4IHl0CsaYbXROMifcgrRAUDNFb/EwNSlwy2aSmfvpRsp+voln/2FZtEcntBQqQxEhfUpONl5hglkgqbraArupKrXwazikWWAqBiUMbb2ZfWR7EHtjXRww/XI8ejDfZLF26MM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207030; c=relaxed/simple;
	bh=Um4glkktq2BsM/0gj8OeeGJRIt1KoX2UOBHr9Zh2xtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zi9AVFBrOZ79TVuFbXE7XW1p5qqReOkhiqPZfFl9xUthkWyjWRJQwuH0Nzg38etFXoD1MgySjOdzbqJCUSCIL5UTvR30IJM0vVPdCwh3vaGf2CLA3/yQzTZdh/2td6NLYZlrzpYgE6GNkvMDtCHNSqDyqUixJg6ZrwIpbyxRb7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FYPB9ZPk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FYPB9ZPk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A55E0C4CEF1;
	Tue, 26 Aug 2025 11:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207030;
	bh=Um4glkktq2BsM/0gj8OeeGJRIt1KoX2UOBHr9Zh2xtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FYPB9ZPkQaFX3/I33tWhubNUr7mK8Bs7spO0bI+fSQXH8RL7Y2tdzJGVPgUaAPVkJ
	 RHyYuxznB08aNt6diUP0SevUoNS9q4W06krE0f0QIZmzqRwfDp8HXQxyaKsngthS3W
	 PqNyJw2zY0S65BrZsmB1TF+XcM+Gu04CjkN/cA+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.16 024/457] crypto: ccp - Fix SNP panic notifier unregistration
Date: Tue, 26 Aug 2025 13:05:08 +0200
Message-ID: <20250826110937.930223934@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ashish Kalra <ashish.kalra@amd.com>

commit ab8b9fd39c45b7760093528cbef93e7353359d82 upstream.

Panic notifiers are invoked with RCU read lock held and when the
SNP panic notifier tries to unregister itself from the panic
notifier callback itself it causes a deadlock as notifier
unregistration does RCU synchronization.

Code flow for SNP panic notifier:
snp_shutdown_on_panic() ->
__sev_firmware_shutdown() ->
__sev_snp_shutdown_locked() ->
atomic_notifier_chain_unregister(.., &snp_panic_notifier)

Fix SNP panic notifier to unregister itself during SNP shutdown
only if panic is not in progress.

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Cc: stable@vger.kernel.org
Fixes: 19860c3274fb ("crypto: ccp - Register SNP panic notifier only if SNP is enabled")
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/ccp/sev-dev.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 8fb94c5f006a..17edc6bf5622 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1787,8 +1787,14 @@ static int __sev_snp_shutdown_locked(int *error, bool panic)
 	sev->snp_initialized = false;
 	dev_dbg(sev->dev, "SEV-SNP firmware shutdown\n");
 
-	atomic_notifier_chain_unregister(&panic_notifier_list,
-					 &snp_panic_notifier);
+	/*
+	 * __sev_snp_shutdown_locked() deadlocks when it tries to unregister
+	 * itself during panic as the panic notifier is called with RCU read
+	 * lock held and notifier unregistration does RCU synchronization.
+	 */
+	if (!panic)
+		atomic_notifier_chain_unregister(&panic_notifier_list,
+						 &snp_panic_notifier);
 
 	/* Reset TMR size back to default */
 	sev_es_tmr_size = SEV_TMR_SIZE;
-- 
2.50.1



