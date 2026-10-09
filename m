Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F341A343D8A;
	Fri,  9 Oct 2026 14:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555388; cv=none; b=HENaY/MmgnVI0JU6iXPxi0ot8YrSSQSqSVbrSFJO/56iO3bFxXr5fS3ykWNr6GJjhbgjkXdLZWnU4hIVu3SzSz9BSiJnmrT2IxADSwtzBuWM9ezwyNByfVFS3/N30szqwdZhPUQntmulQXQmxmlZ0rA0IEzwoSZbFrkgPzrqc+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555388; c=relaxed/simple;
	bh=K1tBykmUwvmX9owmFytNkxs7+SeaLC3rlZZhoRtL/Lw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q0pqBKFD5LCcxWVc/omunrTrBDCCf7cDleFTF0Vb2s0uEPWURRJrgGZF+j3tdny1YMzCnTfuH4seYd1jvdZCnHXE8kmZb2D1Wyx20dj2WFsnlJSTeUauAoj03vcFE+O3fcfBDWSxXxWNfaYWBk8JcArI0QmrkFiPKudaa+537yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ll9u1Roz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ll9u1Roz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C6781F00899;
	Fri,  9 Oct 2026 14:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555384;
	bh=rs4o/Gwezb0oNfQoCQfzJP6TPcB4k/Y9iNJKG/k+IPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ll9u1RozFDbUg+3zqi49YS/2POEuAtT4Ht1VJDe1i9u/suxQrApBlJ9wa6lc7si7m
	 7O9NuVywaS3zJ2SnXa0AmqTIAETIVBrTh17VycxgPVmLiVSIkvmPhBZ7zdOZKSs0CB
	 cHLFsEqMGKhN/9Oq2bxM2FoK9L5eO1Sptif0jIPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Surendran Kanagaraj <surenkj@amazon.com>,
	Gunnar Kudrjavets <gunnarku@amazon.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.18 040/403] tpm: Disable TPM on null key name mismatch
Date: Fri,  9 Oct 2026 16:06:41 +0200
Message-ID: <20261009140953.045380539@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Surendran Kanagaraj <surenkj@amazon.com>

commit 015fb29a748342a186f37b602ac70017098c8251 upstream.

The null key name check exists to protect against TPM reset attacks, so
a mismatch should stop the device from serving further requests.
Currently it does not disable the chip when it finds a mismatch.

The mismatch is logged:

    tpm tpm0: null key integrity check failed

but the chip keeps serving commands:

    / # tpm2_getcap -c properties-fixed
    TPM_PT_FAMILY_INDICATOR:
      as UINT32:                0x08322e3000
      as string:                "2.0"
    ...

tpm2_load_null() where the null key name check is run sets the chip as
disabled only if the rc is non zero. When the mismatch is seen, rc is
zero at that point and it returns success. The other issue is that the
caller expects the null key handle to be populated when the function
returns 0 which it does here without writing the handle and proceeds
assuming the null key handle is valid.

During the test, I noticed that tpm2_start_auth_session() uses the
uninitialized stack value as the key handle since tpm2_load_null()
returns 0 despite the integrity failure and proceeds with
TPM2_CC_START_AUTH_SESS with this value as salt key handle.

Set rc to -ENODEV on the mismatch. The error path then disables the chip
and returns the correct code to the caller.

Tested in QEMU with swtpm and CONFIG_TCG_TPM2_HMAC=y by making
TPM2_CC_CONTEXT_LOAD fail with TPM2_RC_INTEGRITY and changing the name
of the re-created null key. The chip is now disabled on the mismatch.

Fixes: cc7d8594342a ("tpm: Rollback tpm2_load_null()")
Fixes: 423893fcbe7e ("tpm: Disable TPM on tpm2_create_primary() failure")
Cc: stable@vger.kernel.org # v6.12+
Assisted-by: LLM
Signed-off-by: Surendran Kanagaraj <surenkj@amazon.com>
Link: https://lore.kernel.org/r/20260918000731.48657-1-surenkj@amazon.com
Reviewed-by: Gunnar Kudrjavets <gunnarku@amazon.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tpm/tpm2-sessions.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/char/tpm/tpm2-sessions.c
+++ b/drivers/char/tpm/tpm2-sessions.c
@@ -983,6 +983,7 @@ static int tpm2_load_null(struct tpm_chi
 	/* Deduce from the name change TPM interference: */
 	dev_err(&chip->dev, "null key integrity check failed\n");
 	tpm2_flush_context(chip, tmp_null_key);
+	rc = -ENODEV;
 
 err:
 	if (rc) {


