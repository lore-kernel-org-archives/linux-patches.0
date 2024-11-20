Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 709661991AA;
	Wed, 20 Nov 2024 12:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107528; cv=none; b=V4TJ/6JQH2cYBZ3JHuAB0ubO1z5tsnt8SP6lTUO8legr4DGlnRNBdu1HRkC395EURwBElrQ5V+JdmmKXa8rRprA5eKzkCaqk7xsk5UzIjiJPfVKgMvCgb76P7W/lvbsmrh3QBUDv8xfA12m92Fx34kN49ItBqU/WTKFU/GI+VbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107528; c=relaxed/simple;
	bh=uHxujYS0h8Z8iFGNVOqQbIaQdOIZ1Xffxkiw0s3P6F8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UF7mwItvvyzhgZgXQjCprihUk+H4mUBs5AfLq6bsa+oqGdiF1hck5NPUbhZDCYXIP57MacpGnb17si9aUSFBfAEc0qvT/2IlNARI02YhhkKH4DjN01Ks2HLn+pj2c+0dXlFmE37cFQE8NACLp9hAly+NN837u7yyCFc2y5Z2s94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bygBCOap; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bygBCOap"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 355C6C4CECD;
	Wed, 20 Nov 2024 12:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107528;
	bh=uHxujYS0h8Z8iFGNVOqQbIaQdOIZ1Xffxkiw0s3P6F8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bygBCOappx5m7CYM+YA93gXezv1RqA20dHBfe9xsBbwvjiV8lfsYGMH7/cO4IlXBm
	 RE9rcBcoPYHUsB02dSv7lMsOxt1PUHSIPiR0LQ6iiLpZOnQ7EoSCHs/0bgUJ1pyFWT
	 2tNJ0s0o6lsYO9O9GMkWhCNNnTCLcok2i3tSZ8U4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Anton Mitterer <calestyo@scientia.org>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.11 060/107] tpm: Disable TPM on tpm2_create_primary() failure
Date: Wed, 20 Nov 2024 13:56:35 +0100
Message-ID: <20241120125631.030942429@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.681745345@linuxfoundation.org>
References: <20241120125629.681745345@linuxfoundation.org>
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

commit 423893fcbe7e9adc875bce4e55b9b25fc1424977 upstream.

The earlier bug fix misplaced the error-label when dealing with the
tpm2_create_primary() return value, which the original completely ignored.

Cc: stable@vger.kernel.org
Reported-by: Christoph Anton Mitterer <calestyo@scientia.org>
Closes: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1087331
Fixes: cc7d8594342a ("tpm: Rollback tpm2_load_null()")
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tpm/tpm2-sessions.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/char/tpm/tpm2-sessions.c
+++ b/drivers/char/tpm/tpm2-sessions.c
@@ -948,10 +948,13 @@ static int tpm2_load_null(struct tpm_chi
 	/* Deduce from the name change TPM interference: */
 	dev_err(&chip->dev, "null key integrity check failed\n");
 	tpm2_flush_context(chip, tmp_null_key);
-	chip->flags |= TPM_CHIP_FLAG_DISABLE;
 
 err:
-	return rc ? -ENODEV : 0;
+	if (rc) {
+		chip->flags |= TPM_CHIP_FLAG_DISABLE;
+		rc = -ENODEV;
+	}
+	return rc;
 }
 
 /**


