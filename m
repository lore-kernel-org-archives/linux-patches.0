Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61A5D28505E;
	Thu, 16 Jul 2026 14:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211276; cv=none; b=e7+JmX6+Q8TCgdg8icWp6XUvD8/VQHQMD/Z15/JNuSmHNr8u+DWmxW+5I2Pqcj4X3M4SVXttoIePyu3sdvqV1r/dgi6VE8ApJHxcNZhMeSVC+yShPNPIePR1vO8lbVjLnJkY9MuPnZX2BD98TyTIqjTQEgN8wUdW9EvQNDYmaK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211276; c=relaxed/simple;
	bh=viu8+gt9DJ5oaalC2qpundP2NGv3+75BQYv15u4CDdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DmYWQtLTWYYFX0XdqoWLF9tRDUEimd/0UBK+rB0Jt26ekE9uM2FrFPaD1kl+g8fUM9l7ul4s6Jz9dpfAuRSw2GM9Xkix9CQxNUw1mw7jr8Z4ZHM0FXu/DbBojmlDOYSU8sxPgcyIZRaNrOhdtaiGlwxtJ8RVqBhQTJNq9X3DMAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DbcHnGXY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DbcHnGXY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C66381F000E9;
	Thu, 16 Jul 2026 14:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211275;
	bh=MLK5triibmTh46L1Dm48xTJUE6pqzM+S+ZqdQqdALlE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DbcHnGXYWftR/3Npe0xvKvBEnh+yEepB7tCZFdKqH9cIMyMHHiGMKzCVhBjxElZvx
	 CyDhNKMDoRDi/aTLBf0QJ4uWBHNJ0JmuCNK4TKyol993E+I3CvJsXNYelSJx+y1SaK
	 O8M+y9CZPLrNdjmM2mPPIIldzGuAwtwzaKH8sGJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahsan Atta <ahsan.atta@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Damian Muszynski <damian.muszynski@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.18 364/480] crypto: qat - handle sysfs-triggered reset callbacks
Date: Thu, 16 Jul 2026 15:31:51 +0200
Message-ID: <20260716133052.676487013@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

From: Ahsan Atta <ahsan.atta@intel.com>

commit 4627ef7019bc532f992c0723e881811ce12f0a02 upstream.

A reset requested through /sys/bus/pci/devices/.../reset invokes the
driver reset_prepare() and reset_done() callbacks. The QAT driver does
not implement those callbacks today, so the reset proceeds without
quiescing the device or bringing it back up afterward, which leaves
the device unusable.

Hook reset_prepare() and reset_done() into adf_err_handler so the
common shutdown and recovery flow also runs for reset. Skip device
quiesce if the device is already in a down state.

Cc: stable@vger.kernel.org
Signed-off-by: Ahsan Atta <ahsan.atta@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Damian Muszynski <damian.muszynski@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/intel/qat/qat_common/adf_aer.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/crypto/intel/qat/qat_common/adf_aer.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_aer.c
@@ -222,10 +222,22 @@ static void adf_resume(struct pci_dev *p
 	dev_info(&pdev->dev, "Device is up and running\n");
 }
 
+static void adf_reset_prepare(struct pci_dev *pdev)
+{
+	reset_prepare(pdev);
+}
+
+static void adf_reset_done(struct pci_dev *pdev)
+{
+	reset_done(pdev);
+}
+
 const struct pci_error_handlers adf_err_handler = {
 	.error_detected = adf_error_detected,
 	.slot_reset = adf_slot_reset,
 	.resume = adf_resume,
+	.reset_prepare = adf_reset_prepare,
+	.reset_done = adf_reset_done,
 };
 EXPORT_SYMBOL_GPL(adf_err_handler);
 


