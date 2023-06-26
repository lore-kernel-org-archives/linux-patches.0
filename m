Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20A5213AC5
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:27:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9414FC433C0;
	Mon, 26 Jun 2023 18:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687804039;
	bh=coU3S6NZ3US8khyX0V8a6mSlT1k8zxflUbRmHtwsImw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V3ms4lvw9rN3ZpHb2mphEG6y8EqZt7yu8ygsSsy8h3kVyhQ0V+9oS78XXN+U6DSzI
	 6avU3lU6fYlRBZepFsZEEVfTWdLwSV2ceUDLnNbHR/24OmiT2neQFBDF1jEdvarQnB
	 4zNX+RoEidwOeENTLBjCHKDNhtMNkbM3aTRpqWpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lino Sanfilippo <l.sanfilippo@kunbus.com>,
	=?UTF-8?q?Michael=20Niew=C3=B6hner?= <linux@mniewoehner.de>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.1 008/170] tpm, tpm_tis: Claim locality in interrupt handler
Date: Mon, 26 Jun 2023 20:09:37 +0200
Message-ID: <20230626180800.898029056@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180800.476539630@linuxfoundation.org>
References: <20230626180800.476539630@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lino Sanfilippo <l.sanfilippo@kunbus.com>

commit 0e069265bce5a40c4eee52e2364bbbd4dabee94a upstream.

Writing the TPM_INT_STATUS register in the interrupt handler to clear the
interrupts only has effect if a locality is held. Since this is not
guaranteed at the time the interrupt is fired, claim the locality
explicitly in the handler.

Signed-off-by: Lino Sanfilippo <l.sanfilippo@kunbus.com>
Tested-by: Michael Niewöhner <linux@mniewoehner.de>
Tested-by: Jarkko Sakkinen <jarkko@kernel.org>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tpm/tpm_tis_core.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -772,7 +772,9 @@ static irqreturn_t tis_int_handler(int d
 		wake_up_interruptible(&priv->int_queue);
 
 	/* Clear interrupts handled with TPM_EOI */
+	tpm_tis_request_locality(chip, 0);
 	rc = tpm_tis_write32(priv, TPM_INT_STATUS(priv->locality), interrupt);
+	tpm_tis_relinquish_locality(chip, 0);
 	if (rc < 0)
 		return IRQ_NONE;
 


