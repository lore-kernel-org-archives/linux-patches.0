Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81F051C9B81;
	Tue, 15 Oct 2024 12:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728996845; cv=none; b=lY/fSGi2Wots5vanHfMrSplsBlQijI0zrzlT+52yZrbkz/h2VKqDvCVdjg0cnqG4/lAId19krp4AzXc+EuS3p754v8advkEqlT0HXHUfWGr42QInbwSO9+uo/lHO2lBw50CyDG4h6gfl/KmItNRgb/W2UEPSmExUiyawIC63eYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728996845; c=relaxed/simple;
	bh=rZ24U9Z+r77LaDkxz1y7eVJlIJcP/NPR9JCxsdH9mL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c3JbLLx/iFC1MKnhX/jseWWct6Fk9jU1epn/ZYOMy7NAfFLHQSButqUDbUrhG2AfClqhQY1Xvf2F08n5H44miC4nE7o8reYILKD4jyjcUnFaC2WBIRc+cIY32FMqMvzr8Tedp07S2Fjrl9qyPdblD78yAuoY3c2ZVhbLyj4yRMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=roQZtqCj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="roQZtqCj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 895A4C4CECF;
	Tue, 15 Oct 2024 12:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728996845;
	bh=rZ24U9Z+r77LaDkxz1y7eVJlIJcP/NPR9JCxsdH9mL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=roQZtqCjzjtZwFiCedO0AqsHB7YTWgebEmQap/Qn1om03POslUl7GAXbU+0Rnalag
	 wGhW9cBBl97nRROApYQIblFJuMtAsHRIav1iNJW//njHaYVkwQ9CKDI4aNaxyXQQ9P
	 /aznaltOWTCM1G7aBfeCrKP0l+km53LxuR8nzZ4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Narron <richard@aaazen.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 016/518] minmax: reduce min/max macro expansion in atomisp driver
Date: Tue, 15 Oct 2024 14:38:40 +0200
Message-ID: <20241015123917.459918472@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


