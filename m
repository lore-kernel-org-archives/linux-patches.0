Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEBF92E2DF4;
	Wed, 28 Jan 2026 15:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615173; cv=none; b=gcm1Vii27iDmtPnNdk6y+DGHTSMU35OYl86wtAuSXCU0cYQ+YVOCU9qhaNIBkihwqq3t/8vk3irI4nXJr5J8NoGMSgcuqnH7hTwhRbX6WHI/v1585zIWUOCP4cMs4rC68P1P3QfZ2s0g5jmr2auKxRTk5Jbyn32IK1RuVU9ALJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615173; c=relaxed/simple;
	bh=/8peiElUFtF3In9DDiIF8uTeBXy9I+LeVOsE8E3CiyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t9uhtFJVu0lOCK5ItBov665gtJG7kpEZ636HWyWvzSs/Cq6s6I/fkHUzPvwf6ltD8reUw6vsHVinzqY3bWX+NagRF926wRKv2Jgt6dikaMwMU8m2dtPsADSCRHZGv1gRD/V+KQMUSTvlIGg0FelVZD8RhbZbeDMszXZs0HPkHo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=th5qtfZC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="th5qtfZC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23E0DC4CEF1;
	Wed, 28 Jan 2026 15:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615173;
	bh=/8peiElUFtF3In9DDiIF8uTeBXy9I+LeVOsE8E3CiyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=th5qtfZCml8fkwzsZXzvhMgs3/616tWcXas22WraFUfFIXrtrmaIEwrGMmInkLQNu
	 Cl5+kDeN7o0Wt2ykipxdwBluDaYiOIqgjveo1QviIjxrL/4YRZixCL8nITWA7PHzmN
	 QPDMJtjcLcjn6wjyut1HnmsztmcVLcTDs2rNV9kg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srish Srinivasan <ssrish@linux.ibm.com>,
	Stefan Berger <stefanb@linux.ibm.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 100/169] keys/trusted_keys: fix handle passed to tpm_buf_append_name during unseal
Date: Wed, 28 Jan 2026 16:23:03 +0100
Message-ID: <20260128145337.606589053@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145334.006287341@linuxfoundation.org>
References: <20260128145334.006287341@linuxfoundation.org>
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

From: Srish Srinivasan <ssrish@linux.ibm.com>

[ Upstream commit 6342969dafbc63597cfc221aa13c3b123c2800c5 ]

TPM2_Unseal[1] expects the handle of a loaded data object, and not the
handle of the parent key. But the tpm2_unseal_cmd provides the parent
keyhandle instead of blob_handle for the session HMAC calculation. This
causes unseal to fail.

Fix this by passing blob_handle to tpm_buf_append_name().

References:

[1] trustedcomputinggroup.org/wp-content/uploads/
    Trusted-Platform-Module-2.0-Library-Part-3-Version-184_pub.pdf

Fixes: 6e9722e9a7bf ("tpm2-sessions: Fix out of range indexing in name_size")
Signed-off-by: Srish Srinivasan <ssrish@linux.ibm.com>
Reviewed-by: Stefan Berger <stefanb@linux.ibm.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/keys/trusted-keys/trusted_tpm2.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/security/keys/trusted-keys/trusted_tpm2.c b/security/keys/trusted-keys/trusted_tpm2.c
index 7187768716b78..74cea80ed9be5 100644
--- a/security/keys/trusted-keys/trusted_tpm2.c
+++ b/security/keys/trusted-keys/trusted_tpm2.c
@@ -489,7 +489,7 @@ static int tpm2_load_cmd(struct tpm_chip *chip,
 }
 
 /**
- * tpm2_unseal_cmd() - execute a TPM2_Unload command
+ * tpm2_unseal_cmd() - execute a TPM2_Unseal command
  *
  * @chip: TPM chip to use
  * @payload: the key data in clear and encrypted form
@@ -520,7 +520,7 @@ static int tpm2_unseal_cmd(struct tpm_chip *chip,
 		return rc;
 	}
 
-	rc = tpm_buf_append_name(chip, &buf, options->keyhandle, NULL);
+	rc = tpm_buf_append_name(chip, &buf, blob_handle, NULL);
 	if (rc)
 		goto out;
 
-- 
2.51.0



