Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2AA047141B;
	Tue, 21 Jul 2026 20:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664600; cv=none; b=Z7pKhs9go+oTEEcsif/WVFhvYCqKoJJz0vC2Pr/rz8o5VNHSOQGZ0oEESvQEqAer22N5DpihB87JJeIjq6QfDx91ULXlIXPoeKnMFfGx98SYnq7GjCBz3IpHaoehq1vPV2f8wRd+kO52/bKpX8e30o0z/Ji3ufJKzFHXJQpb9Lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664600; c=relaxed/simple;
	bh=3ORndPQErkOFlcDGUk2kV7pOhR1rKljqDMve2HQABWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ru6nLbUCci5rgBvCvSLYYceo5q+owgpjRHTTxS/lwrBQG8Jqf9WZWb/n972NnW/Aner/0k+S8MfvLjUqAc9N24/Bgc+kSg4onHVu51Akrvv1Ocp0veOzojo0rts70V5vy9xGjHghNRPVkinNCnSNkUns8B9qM1ZFUhvL+I4O0Ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JTCJL7W6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JTCJL7W6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54B471F00A3A;
	Tue, 21 Jul 2026 20:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664598;
	bh=Bo4jH4jKwlRY4UZzpxCK1X/ugHfoQwfYz7yIL+0AR9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JTCJL7W6L7OLakwgjiMOpBjNrbAV9nVIMcCYo9mxmQIlYJ2TyMQe0ky4MiSqjMInQ
	 3oAay8zDDgLJAGkSRoeQmgSj63Ca1aFZWrwz+DJdUYkB1IZPTykd5arf7V6KfHnCPm
	 c8UpcSHFbuMyo2O3BqvB62ZDMov1CBiS3vubvsb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.12 1262/1276] crypto: ccp - Fix SNP panic notifier unregistration
Date: Tue, 21 Jul 2026 17:28:25 +0200
Message-ID: <20260721152514.333699092@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/crypto/ccp/sev-dev.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1785,8 +1785,14 @@ static int __sev_snp_shutdown_locked(int
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


