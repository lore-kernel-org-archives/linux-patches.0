Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C6B14F4D18;
	Tue, 13 Oct 2026 12:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894728; cv=none; b=t793Eju6ptfIhVqBwrLG3FMi3MeAQjvuO1oCpTzaQZvwOuO+8Q6jJn8Flb3xxbeDyyiH+oyMkeMClkI5VnC7xFArjYEbq2TiHJSDbMalcZ91QNrjXFJy7wrXIiHzvleGkB1+g0Y6Czyf3O4d+h9lawEtukqpIq7t7ooXmmSsiHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894728; c=relaxed/simple;
	bh=lqStQ4a4RDA1SL8zDktwuhnsSdIQkg7J+jrA2wfNnZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fck5w66wSUdx8snKSX8A32awA+CKNaHnQ2qoZk+e30NZljQz94H/+kv4Zd8pB0syNpQbdM4BKBBCn4xsUh5Hvabe7yES+tV9CQ3qO7AJx9DXPCmIEzOrDIjmdD07fPJLXgXVu7GvAiSx0sb+5aHaXT3vnTyZ3fVMWNcVz4VPqCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f2Iak3eC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f2Iak3eC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D700B1F000FF;
	Tue, 13 Oct 2026 12:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894727;
	bh=KgWv0xdsNrWmQznHO4mh/UdgB80fHXfZ9eruRQZ2laE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f2Iak3eCoeMW1ymqyMeK5v0Oz5dq9etQe75nEdVdBNgIIIjlZoquJ91XB2REZinj4
	 u1UOIF0D2sGw0wNJJllCKy3DNtxC/w8Tgj6IIZmaWGYhs4PSI+7O6kHji7C4AyAQzO
	 RYuO4BOn3FLJ5dFIT6lNV5n6R50QEQtUe6Nz6c4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Surendran Kanagaraj <surenkj@amazon.com>,
	Gunnar Kudrjavets <gunnarku@amazon.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.12 035/497] tpm: Disable TPM on null key name mismatch
Date: Tue, 13 Oct 2026 13:33:22 +0200
Message-ID: <20261013112908.721989273@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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
@@ -1025,6 +1025,7 @@ static int tpm2_load_null(struct tpm_chi
 	/* Deduce from the name change TPM interference: */
 	dev_err(&chip->dev, "null key integrity check failed\n");
 	tpm2_flush_context(chip, tmp_null_key);
+	rc = -ENODEV;
 
 err:
 	if (rc) {


