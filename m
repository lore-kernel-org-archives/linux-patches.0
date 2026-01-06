Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3188929BD9A;
	Tue,  6 Jan 2026 17:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720979; cv=none; b=JVkOlw8dKa7MS3umxux/Xh1F1zW5E+uwLQMT2jl5YLFbwiRLuHG1NWWg1YCQzHf7NM7q1lATIarhP+Ygdp3ZhqFJP/fBA2K5xNCUSkbGxMZCcIGdSHdtvx0m/gv6r6zAabD/nbfnszI/eXxdcbZhiGR4FwxYwEPwwVRKnuDBnMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720979; c=relaxed/simple;
	bh=kWdFU81tVCvLvRIjYByYa5xQqhm/3giYqN8+n3fk5BM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CcBxBosyEsfdfa/ptrKay47HHBFe6CtTRuLopmEBkZRdX2WfDoUSglwvbnIv0Egi1lIOoinSEfqzh5BN8w2BsLeHxOrC4TZjMw9vr0tRu+K8tORdlHxifcT44o2EKOFaxMgTcGgcQxMa7cJ7ucEdDkZVLZEuWxwynu5A8TTAjMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fysCSjIb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fysCSjIb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 951CFC116C6;
	Tue,  6 Jan 2026 17:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720979;
	bh=kWdFU81tVCvLvRIjYByYa5xQqhm/3giYqN8+n3fk5BM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fysCSjIbLLyRn11P3LBcWYgQVOZs/JGANhwXt0XuK4EUEyvNKXlck1Cq1WTeNlX0C
	 ggjSGmbMlrbrr6egO99pLAz8QcglgMW3J+vQe/3sYpxsyHZZvnQ5xWioWhqUnuTfb4
	 XdVWnk7EeSsWNl87jGs30qP5BoEoml9aegLd68+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.12 400/567] fbdev: pxafb: Fix multiple clamped values in pxafb_adjust_timing
Date: Tue,  6 Jan 2026 18:03:02 +0100
Message-ID: <20260106170506.139248445@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

commit 0155e868cbc111846cc2809c1546ea53810a56ae upstream.

The variables were never clamped because the return value of clamp_val()
was not used. Fix this by assigning the clamped values, and use clamp()
instead of clamp_val().

Cc: stable@vger.kernel.org
Fixes: 3f16ff608a75 ("[ARM] pxafb: cleanup of the timing checking code")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/pxafb.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/video/fbdev/pxafb.c
+++ b/drivers/video/fbdev/pxafb.c
@@ -418,12 +418,12 @@ static int pxafb_adjust_timing(struct px
 	var->yres = max_t(int, var->yres, MIN_YRES);
 
 	if (!(fbi->lccr0 & LCCR0_LCDT)) {
-		clamp_val(var->hsync_len, 1, 64);
-		clamp_val(var->vsync_len, 1, 64);
-		clamp_val(var->left_margin,  1, 255);
-		clamp_val(var->right_margin, 1, 255);
-		clamp_val(var->upper_margin, 1, 255);
-		clamp_val(var->lower_margin, 1, 255);
+		var->hsync_len = clamp(var->hsync_len, 1, 64);
+		var->vsync_len = clamp(var->vsync_len, 1, 64);
+		var->left_margin  = clamp(var->left_margin,  1, 255);
+		var->right_margin = clamp(var->right_margin, 1, 255);
+		var->upper_margin = clamp(var->upper_margin, 1, 255);
+		var->lower_margin = clamp(var->lower_margin, 1, 255);
 	}
 
 	/* make sure each line is aligned on word boundary */


