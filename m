Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4119931B839;
	Mon, 27 Oct 2025 18:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590587; cv=none; b=tbcuxE9XZNRpTkw7IyP6cyURSVFGXzCmbTreUjr4ZtDP8xWKiHfAkgcKqxeo/K9kp3ApMozjm6XkwipECKGPDHaMWfRpO9yg8g/S4q/6igRr1dGZKniXMVfm4SPGyMk2zXljJYKM2Ecno5EkNG9k9cfyh4SCwmet6+8OEa9E/Uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590587; c=relaxed/simple;
	bh=zahkFdUByJKg+CkC1RiNtwJKIpiDd6NxFDN/BQDofwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JUfSD20OQFMiqib4WkYhzHgPUm1kHd1N3iNLeIVi5yTFNSnDE5WOQSTih4bvO4c4OTcTbxWmqyPYQCFOU0q+3qHXRYbVCPY4/jPHSg5nF8ZXQVqmrOtZoV4RNqsb3hdYwIVg2NH19ZwSc2UKrkP9OKUi3/Qhds8uLuyfqPdjskQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EEphgnX9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EEphgnX9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6B71C113D0;
	Mon, 27 Oct 2025 18:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590587;
	bh=zahkFdUByJKg+CkC1RiNtwJKIpiDd6NxFDN/BQDofwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EEphgnX9RQN+/CC4eWocSYLfr6s5o4bvdY2mRql/JI5EF89Q637MaxVx3z7/qph4E
	 12+m1tEV6xN0/3umzJ6bOWKEiLL7JNTwiBqSI9Zl9FcDpOHRUAWNNNEtE0eqOjdRWn
	 DSEtQZbUctpmfkm+PC2io1yh2RjzbnnYuHSu3RKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gunnar Kudrjavets <gunnarku@amazon.com>,
	Justinien Bouron <jbouron@amazon.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 099/224] tpm_tis: Fix incorrect arguments in tpm_tis_probe_irq_single
Date: Mon, 27 Oct 2025 19:34:05 +0100
Message-ID: <20251027183511.638963450@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gunnar Kudrjavets <gunnarku@amazon.com>

[ Upstream commit 8a81236f2cb0882c7ea6c621ce357f7f3f601fe5 ]

The tpm_tis_write8() call specifies arguments in wrong order. Should be
(data, addr, value) not (data, value, addr). The initial correct order
was changed during the major refactoring when the code was split.

Fixes: 41a5e1cf1fe1 ("tpm/tpm_tis: Split tpm_tis driver into a core and TCG TIS compliant phy")
Signed-off-by: Gunnar Kudrjavets <gunnarku@amazon.com>
Reviewed-by: Justinien Bouron <jbouron@amazon.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/tpm/tpm_tis_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
index 60f4b8b9c6f14..b538db3052b77 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -700,8 +700,8 @@ static int tpm_tis_probe_irq_single(struct tpm_chip *chip, u32 intmask,
 	 * will call disable_irq which undoes all of the above.
 	 */
 	if (!(chip->flags & TPM_CHIP_FLAG_IRQ)) {
-		tpm_tis_write8(priv, original_int_vec,
-			       TPM_INT_VECTOR(priv->locality));
+		tpm_tis_write8(priv, TPM_INT_VECTOR(priv->locality),
+			       original_int_vec);
 		rc = -1;
 	}
 
-- 
2.51.0



