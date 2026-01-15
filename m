Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B8EA26CE04;
	Thu, 15 Jan 2026 17:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499701; cv=none; b=T/HYDJuZhbqBWdEmGQpvY7XzQT6DfX9JHvJ09hqnqvDScnExRqX45VKzvQNhT+V7+oFKovtXCEbb3gAkkZz5TLdQGpYDebxeh2aTYAKoCPWElbM8RESNzdJTIwShqsRNCmr8/jZZhri892lEkrh5taW9FbSbE2l68+RVwrZmiIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499701; c=relaxed/simple;
	bh=tFuGs4Q0XxOtoPoVRqsBQp2myFnAAgFiEp2/f44J+Sw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IqjzNn5a0gjB3S1jB4Y7xgofByLNoaaJorn1EnEBCpgfxTXNqS/ou6j52k61oYxGvhsDKyOt9y3YXyCdTy6RVksdGUi8wBhIA2N74w+eGZsZL+aGjDKpZCQVYUPNKaI+Jxq7Ym2v6T/CGk/hPg4dO9+dLKQLoZ5DpG6xszCRhnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OFwJcXDG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OFwJcXDG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DED65C116D0;
	Thu, 15 Jan 2026 17:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499701;
	bh=tFuGs4Q0XxOtoPoVRqsBQp2myFnAAgFiEp2/f44J+Sw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OFwJcXDGXMM05hC9O8+jY/mHHR4kVkGyDKEEnY/i0SIGNafrt0+0sA+BOGX33kRJm
	 BSoF5/FMejIXs/qaVPAB/79keSbBRjwxkRPVUqqbrlBUcr8A986NzfSw4QB8t6X0Hm
	 VOhxctwjGU59eMiysegTjuEknRjcZu1q6ccKWi1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.10 320/451] fbdev: pxafb: Fix multiple clamped values in pxafb_adjust_timing
Date: Thu, 15 Jan 2026 17:48:41 +0100
Message-ID: <20260115164242.476538105@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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


