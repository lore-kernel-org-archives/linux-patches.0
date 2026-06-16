Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0024B47D923;
	Tue, 16 Jun 2026 18:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635536; cv=none; b=VbNgsuxWH4XMw1m4IZr07fzMCJ3YW0Esah81QkKUvomB+m8axOH1snTwowFbZnqD5wIq8wAeNmt06vSySO1/PO+Z8TfZBvMiKe3KSkhiDBV6c+zKd42zSO/Jog7CUDV/g6K+64CdpGqGMz2KcodylO/J8BXwrt887cFiWUYSJds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635536; c=relaxed/simple;
	bh=BZBI1/0o2gp0lB6buHRLdCM8/uiYkC7bRbSvwvo5EJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UhtNelFs+bNPoGf0mPtEYQVvyY6Pmjp+QMCZw0YHuWsN9zfIX8N3wb324wZ0orCHeT//vSqCW1AakL0XRKy8zh6UrU1k21G9qSLEkAw6/qEk90NBgxFUfqVKAq+BqUgXzgutEuR0EmePn5bywzH3Ko1mB1QPcHQdw+H9MPFnMNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hAaYUKqH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hAaYUKqH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F25D1F000E9;
	Tue, 16 Jun 2026 18:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635530;
	bh=6S87i8PXX23z9mLWMRCUBBOn1YImpmt9i0Zrf0xE2Kw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hAaYUKqHZNxzRDTZabty+pvajycx4C5RS1l4bz1kqswyyChxqjapTS1Sp0WL1LjcS
	 SMMdpLIYp/S0/roPY/K1RfPWp8UYTuPONLppcAzqyxKehQjeTw1gbXaej2O/UvO4tU
	 oPAd+5PT3O+TH7Xrg6Tt6ksr8yxqqDv9MFXuh6GQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.10 067/342] Input: elan_i2c - validate firmware size before use
Date: Tue, 16 Jun 2026 20:26:03 +0530
Message-ID: <20260616145051.371504537@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 76b0d0baa9ae9c60e726bbe1b6ff0bec2c993634 upstream.

Ensure that the firmware file is large enough to contain the expected
number of pages and the signature (which resides at the end of the
firmware blob) before accessing them to prevent potential out-of-bounds
reads.

Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/ae2dOgiFvXRm4BHo@google.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/mouse/elan_i2c_core.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/input/mouse/elan_i2c_core.c
+++ b/drivers/input/mouse/elan_i2c_core.c
@@ -608,6 +608,11 @@ static ssize_t elan_sysfs_update_fw(stru
 		return error;
 	}
 
+	if (fw->size < data->fw_signature_address + sizeof(signature)) {
+		dev_err(dev, "firmware file too small\n");
+		return -EBADF;
+	}
+
 	/* Firmware file must match signature data */
 	fw_signature = &fw->data[data->fw_signature_address];
 	if (memcmp(fw_signature, signature, sizeof(signature)) != 0) {


