Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F276315785;
	Mon,  4 May 2026 14:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904625; cv=none; b=on4DyM1/WOX0gyHySoeOSHM+JNIzJ1YXmPofXT3/B/RDW093tjZPlahG0EIXgvT6Nj0Crcom5eTv5EeOPe7LYLY4NtXJz1IUmn7mETiwmOptotfcZaOhNcRVKPRXRDKageY88R8tnWQIjkE7OH9eqkjFvs2VVtcAhBtObJtjbtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904625; c=relaxed/simple;
	bh=J54Z9jk1cohSxctF2CIshdbUMRjlvY+RBrloeP9QoVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V+S35kuGj0q/VauwUwbHbDUm5APxxggnUggklGaANdrjImyI4FnW86TdqnjY/ZnT5UmMsW8Kki5mYg3by3pFV/hzoE1yU3MVPUC+irMIqmatlCLPQpHtiHspsgA9RSTE1Sw15IMiV+AzwekVKPeBnmmhM1m+z+ZBh2Z2XMunhtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O2Gwa2aR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O2Gwa2aR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AB31C2BCF6;
	Mon,  4 May 2026 14:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904625;
	bh=J54Z9jk1cohSxctF2CIshdbUMRjlvY+RBrloeP9QoVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O2Gwa2aRWhWQRfVv7JDoJxgLKTdDs20pjM31Zc5AYx/HkCtoWu2eV337uwkTS0tY/
	 cbqGyC2hdfuEkjZoBoRUlpdgbk6bJa6jjjJs2xphtg1yRV+OrW/eh35jRhrqTvLSCa
	 vpOGBpw/FfOF/NZDi1TbI5fromsP6ZFtFlNNape8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gunnar Kudrjavets <gunnarku@amazon.com>,
	Justinien Bouron <jbouron@amazon.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.12 112/215] tpm: Use kfree_sensitive() to free auth session in tpm_dev_release()
Date: Mon,  4 May 2026 15:52:11 +0200
Message-ID: <20260504135134.240916720@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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
@@ -283,7 +283,7 @@ static void tpm_dev_release(struct devic
 	kfree(chip->work_space.context_buf);
 	kfree(chip->work_space.session_buf);
 #ifdef CONFIG_TCG_TPM2_HMAC
-	kfree(chip->auth);
+	kfree_sensitive(chip->auth);
 #endif
 	kfree(chip);
 }


