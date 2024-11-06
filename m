Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B60D7198E96;
	Wed,  6 Nov 2024 12:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896327; cv=none; b=aLfAG2EnZ3lD92G5phvTZcjZ+ZgNVIv5lbFGCIJno753v9KwFw9e22N1KlgvRf3Qahu1evPVGs4gd+iqy5vzt1/eQ+xWiG5gJGzKBtTmYlhVYr1DUmCiYsORDNFA1FCUQFVz50oxxIGT/oqcORy/DMVsLZHlzPFlkuetPD+Y6h8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896327; c=relaxed/simple;
	bh=ikr/4SULpgYzJyHzm3LA8byPZ5RfXIe7wguxK8oBORM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k3WJ5tki2Dh/e/jwK1aX0pA9+escgfBtSn/huo71s269za5Xc7qKSXumz9xXrDmV+tUCdvr9yD2Z/mNg9zUtaG9DES73heHIopR3qFtqnuQM5Ke9zvC7NeqEVqNaGMhLRnu+2EhCnszqbELCbohY+K4wEmWjATm8MKpFkWhtGRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZMzQkJCT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZMzQkJCT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37B3EC4CECD;
	Wed,  6 Nov 2024 12:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896327;
	bh=ikr/4SULpgYzJyHzm3LA8byPZ5RfXIe7wguxK8oBORM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZMzQkJCTqfT8IR/RubFjdaQiadxGLRaykwKlCXTLz3yd6DyZ3gPmU+TJo/60HlxnR
	 Ih9WcG+VXgxAGIF9pptFCc26oCz7X6UfwV8L/xQQO/cqn4Rd5mT2tMbRQhHtUnqmvb
	 li9Maog5zDtIeIzJ9zV34ttNcs26E1wwmrX2wQNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Berger <stefanb@linux.ibm.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 167/245] tpm: Return tpm2_sessions_init() when null key creation fails
Date: Wed,  6 Nov 2024 13:03:40 +0100
Message-ID: <20241106120323.349514594@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jarkko Sakkinen <jarkko@kernel.org>

[ Upstream commit d658d59471ed80c4a8aaf082ccc3e83cdf5ae4c1 ]

Do not continue tpm2_sessions_init() further if the null key pair creation
fails.

Cc: stable@vger.kernel.org # v6.10+
Fixes: d2add27cf2b8 ("tpm: Add NULL primary creation")
Reviewed-by: Stefan Berger <stefanb@linux.ibm.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/tpm/tpm2-sessions.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tpm/tpm2-sessions.c b/drivers/char/tpm/tpm2-sessions.c
index 44f60730cff44..9551eeca6d691 100644
--- a/drivers/char/tpm/tpm2-sessions.c
+++ b/drivers/char/tpm/tpm2-sessions.c
@@ -1347,14 +1347,21 @@ static int tpm2_create_null_primary(struct tpm_chip *chip)
  *
  * Derive and context save the null primary and allocate memory in the
  * struct tpm_chip for the authorizations.
+ *
+ * Return:
+ * * 0		- OK
+ * * -errno	- A system error
+ * * TPM_RC	- A TPM error
  */
 int tpm2_sessions_init(struct tpm_chip *chip)
 {
 	int rc;
 
 	rc = tpm2_create_null_primary(chip);
-	if (rc)
-		dev_err(&chip->dev, "TPM: security failed (NULL seed derivation): %d\n", rc);
+	if (rc) {
+		dev_err(&chip->dev, "null key creation failed with %d\n", rc);
+		return rc;
+	}
 
 	chip->auth = kmalloc(sizeof(*chip->auth), GFP_KERNEL);
 	if (!chip->auth)
-- 
2.43.0



