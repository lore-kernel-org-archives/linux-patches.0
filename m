Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A602D1E7640;
	Tue, 15 Oct 2024 11:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992152; cv=none; b=Bz1T0Y8f2EtfOLO3DRPJpkGd/CwC0pMr/SvlfFmi2q9MEzhoXAxOdVCUbsWzfCWtyVoq8YkUshVSdrrbnCSPg7zrqy8S4hfFYXx8ovD8/vYqB+ZF6npjjovEotxY+Ik776frrKWU0NQ4ju9Jvy07dX3w19LnQMJz5lYTnRadOfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992152; c=relaxed/simple;
	bh=uAxf0fMjCRNDRBdJytFEh82R5sRxvUuOCp4J+AaY9VI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oHFq0M0zMm0UBatUuiGBdP2FwrRkIsfzJo0ezlE8jOi1hXjW7BFoPX8fMkBx1SC9eh5bpYmb8hXyAtD3eEcndVwt8zxVnd+e2pCkURAGQ0cd21cHpUyWHEOISscZ0GAGj6KdD1h2fO0l6bD7iyQdyvWHHjZALCTQRrrI5KCtjaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rnF5JgGk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rnF5JgGk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5BB8C4CEC6;
	Tue, 15 Oct 2024 11:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992152;
	bh=uAxf0fMjCRNDRBdJytFEh82R5sRxvUuOCp4J+AaY9VI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rnF5JgGkNVLMAZlls+39l60yhF8QUfJC8304ovunY4kZ1SjL/9dalMX5DVl9cUd+d
	 7nwy/+4A8X0YH0X7PicTHHxJjrJJDrtvHsL8xdy/VcpUvx+Q2L326rxNsZUCkTBKFD
	 Zg1e6dbKO5aiYHWb7guYx553shAUve5BwqMdMDKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Narron <richard@aaazen.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.15 033/691] minmax: reduce min/max macro expansion in atomisp driver
Date: Tue, 15 Oct 2024 13:19:41 +0200
Message-ID: <20241015112441.651031602@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

commit 7c6a3a65ace70f12b27b1a27c9a69cb791dc6e91 upstream.

Avoid unnecessary nested min()/max() which results in egregious macro
expansion.

Use clamp_t() as this introduces the least possible expansion, and turn
the {s,u}DIGIT_FITTING() macros into inline functions to avoid the
nested expansion.

This resolves an issue with slackware 15.0 32-bit compilation as
reported by Richard Narron.

Presumably the min/max fixups would be difficult to backport, this patch
should be easier and fix's Richard's problem in 5.15.

Reported-by: Richard Narron <richard@aaazen.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Closes: https://lore.kernel.org/all/4a5321bd-b1f-1832-f0c-cea8694dc5aa@aaazen.com/
Fixes: 867046cc7027 ("minmax: relax check to allow comparison between unsigned arguments and signed constants")
Cc: stable@vger.kernel.org
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/media/atomisp/pci/sh_css_frac.h |   26 +++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

--- a/drivers/staging/media/atomisp/pci/sh_css_frac.h
+++ b/drivers/staging/media/atomisp/pci/sh_css_frac.h
@@ -30,12 +30,24 @@
 #define uISP_VAL_MAX		      ((unsigned int)((1 << uISP_REG_BIT) - 1))
 
 /* a:fraction bits for 16bit precision, b:fraction bits for ISP precision */
-#define sDIGIT_FITTING(v, a, b) \
-	min_t(int, max_t(int, (((v) >> sSHIFT) >> max(sFRACTION_BITS_FITTING(a) - (b), 0)), \
-	  sISP_VAL_MIN), sISP_VAL_MAX)
-#define uDIGIT_FITTING(v, a, b) \
-	min((unsigned int)max((unsigned)(((v) >> uSHIFT) \
-	>> max((int)(uFRACTION_BITS_FITTING(a) - (b)), 0)), \
-	  uISP_VAL_MIN), uISP_VAL_MAX)
+static inline int sDIGIT_FITTING(int v, int a, int b)
+{
+	int fit_shift = sFRACTION_BITS_FITTING(a) - b;
+
+	v >>= sSHIFT;
+	v >>= fit_shift > 0 ? fit_shift : 0;
+
+	return clamp_t(int, v, sISP_VAL_MIN, sISP_VAL_MAX);
+}
+
+static inline unsigned int uDIGIT_FITTING(unsigned int v, int a, int b)
+{
+	int fit_shift = uFRACTION_BITS_FITTING(a) - b;
+
+	v >>= uSHIFT;
+	v >>= fit_shift > 0 ? fit_shift : 0;
+
+	return clamp_t(unsigned int, v, uISP_VAL_MIN, uISP_VAL_MAX);
+}
 
 #endif /* __SH_CSS_FRAC_H */


