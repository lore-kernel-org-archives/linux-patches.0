Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F256E1448F2;
	Thu, 13 Jun 2024 12:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280527; cv=none; b=JNyazrrNuUJyBbKVDu5Y4+Fri06LwUIkB/pbxl3CtT893xx4+EUis2/A9s4k6NNdPMDX46j6KPcD8lMJ/6FnnZ/mN0c/57GgpaaD/Afe7YE6pkvqxwWLmcKDYMk2CLXvBGlwBfTq+1iCm15jFh+V3mb3NuslaOssEYE8jrh9fuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280527; c=relaxed/simple;
	bh=LAOvfE1yr09/pUeE/mueuh/clxWJBZ9KQkqhgNsHbFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cDUuFB6ZSE+WrcKjEM8z9ZOwIQHOSH6b27AINu9h3MSfq7hOu2wEMFic1HWOPL7tO7Tb1OR13t82DJkBO9QrFP7naYgXAxjEDCTp1kirlirCXnqdo1KOwBqPbgN9VBaBd6YljS74agm1lvyub2UMYamB4PRkSQxGyiXA9ihobWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DrqenJbl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DrqenJbl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74294C2BBFC;
	Thu, 13 Jun 2024 12:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280526;
	bh=LAOvfE1yr09/pUeE/mueuh/clxWJBZ9KQkqhgNsHbFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DrqenJbl1RIrcV8FtX+WyV5nSR06+wholD7G8sf0+65pn8ZeI/xKAAAMn5uDrSD/9
	 VgSX6oTKoFJETU/BmRZcjWove01NqOeyL5YOqtaj0A8w86ImaKUWCYQraXIUfMnb4A
	 JUVAYW2QlkBrY1gFMSNOD1rCvck/5q91OHilNm/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Beulich <jbeulich@suse.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.6 084/137] tpm_tis: Do *not* flush uninitialized work
Date: Thu, 13 Jun 2024 13:34:24 +0200
Message-ID: <20240613113226.555386140@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113223.281378087@linuxfoundation.org>
References: <20240613113223.281378087@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Beulich <jbeulich@suse.com>

commit 0ea00e249ca992adee54dc71a526ee70ef109e40 upstream.

tpm_tis_core_init() may fail before tpm_tis_probe_irq_single() is
called, in which case tpm_tis_remove() unconditionally calling
flush_work() is triggering a warning for .func still being NULL.

Cc: stable@vger.kernel.org # v6.5+
Fixes: 481c2d14627d ("tpm,tpm_tis: Disable interrupts after 1000 unhandled IRQs")
Signed-off-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tpm/tpm_tis_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
index 176cd8dbf1db..fdef214b9f6b 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -1020,7 +1020,8 @@ void tpm_tis_remove(struct tpm_chip *chip)
 		interrupt = 0;
 
 	tpm_tis_write32(priv, reg, ~TPM_GLOBAL_INT_ENABLE & interrupt);
-	flush_work(&priv->free_irq_work);
+	if (priv->free_irq_work.func)
+		flush_work(&priv->free_irq_work);
 
 	tpm_tis_clkrun_enable(chip, false);
 
-- 
2.45.2



