Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69FB03C9ED0;
	Thu, 16 Jul 2026 13:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209969; cv=none; b=nCw2ZRER4fmQb06ksvcK5AmrgfnA7HVkv1Wv3UISBLfRVSQnssZr9B5fxjWvR86BL2OwjEK4bmzDZ2KUBbVV+RagABqSj+Snno5cn8CyXuOy5DangknvYr1QwjNEhfjVPrgcB4dchW2vWpy1e8HFIbOqUGREtIRqGUf0LVnPbJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209969; c=relaxed/simple;
	bh=A7Kq3g6JWxAGKo3Miwlq5+wtZRLhXJvVYAo6ckzlRfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VyyNJkEPR8uYqmYsgXSEGBTOhIbx5o3njyPllrltLOHIQnpnTGQQkJyKuqLlra4G9HfprQgkCYAlBuaGOR2Lh8vMuUMKToNuQJJil0shHkN8E+2gkOJ9FQUcmhA8DYRL5iVyvxPEBMGS7N01k5QSJNpSWcARQrDuSSDJvjKm8KQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oAZ7salM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oAZ7salM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A3251F000E9;
	Thu, 16 Jul 2026 13:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209957;
	bh=OGBKTU7EZ+zFZ3P5wyW4aO5vXc4ys/d5ngJBC5XL3ho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oAZ7salMrchs51MVBt1zGCjt/neM6Bp1yuxU9bdjnpbGY1EANTRVF6Le7eXll3O6G
	 yr7YAjqH9vUtJXetdougUiqHfeXh13HAeJRa1EmSGSSqvm8UvleKT/urwz19fHpClT
	 Jjz19XkmkwIBPNh0JhRo/T4IvvSjh7mPp5ebr6Eg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahsan Atta <ahsan.atta@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Damian Muszynski <damian.muszynski@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 7.1 382/518] crypto: qat - handle sysfs-triggered reset callbacks
Date: Thu, 16 Jul 2026 15:30:50 +0200
Message-ID: <20260716133056.188206783@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -223,10 +223,22 @@ static void adf_resume(struct pci_dev *p
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
 


