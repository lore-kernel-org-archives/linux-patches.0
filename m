Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F02C5471425;
	Tue, 21 Jul 2026 19:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663508; cv=none; b=acKixECKJH3VsZgUTFw74c73HJp7E23HDyt8nwTsOeFVCFScTGfte2c8K1hFImSJtMfF5PsE/bJGeMf0BbTutKFqhJOE8Y2eBz2WL9IAIUTTsvfSaF8q/JCR8i/zKnC+mytNA1ZHMYuM+1EJhruu6GIR/PTstg8JCy4JPK0cXf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663508; c=relaxed/simple;
	bh=VcdVLA7RPT4t+psWrG74amAE7ZMheCPi+Ob5sXOftSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gMJtNbC4QDeG+OY//Ct0u8IFGojpZdPTJrygWjjGSWst8JatEZIGU4R6PNqsHfgalqTt4AOweGWXZekeU9S6vegxadDS/S+aUqbISgE2e7tR/5ZtgwKOrJFN2uOw7eGGvkfOqmhayAWykQkNwv4VahrV6rzOi86zHth+52a3Cqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HFDFMXvK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HFDFMXvK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6162E1F000E9;
	Tue, 21 Jul 2026 19:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663506;
	bh=nARTMkCPy47pPxn/59Z/gmUqZe4hlORD1rPDvPlyHCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HFDFMXvKShUSrFPvmbD8WLlOSZRKV7Gh2opsOy/W9FiDFdlFVKU9X00ElilTRwHC4
	 ABcRijISZS02qse5HSFg0nIUzzTRbhigeUKR4T3pSN+ZHis+YAEcJWn2teZjfzCFem
	 6yC/IWh2EhZI+c/CSczFJeKUl5vP3IZuoY8PUHJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.12 0849/1276] fbdev: vesafb: fix memory leak in vesafb_probe()
Date: Tue, 21 Jul 2026 17:21:32 +0200
Message-ID: <20260721152505.051721623@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

commit b15d708995c01bbffe7dcd634a31959f6805bed3 upstream.

Since commit 73ce73c30ba9 ("fbdev: Transfer video= option strings to
caller; clarify ownership") the string returned from fb_get_options()
is expected to be freed by the caller. But the string is not freed in
vesafb_probe(). Fix that by freeing the option string after setup.

Fixes: 73ce73c30ba9 ("fbdev: Transfer video= option strings to caller; clarify ownership")
Cc: stable@vger.kernel.org
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/vesafb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/video/fbdev/vesafb.c
+++ b/drivers/video/fbdev/vesafb.c
@@ -267,6 +267,7 @@ static int vesafb_probe(struct platform_
 	/* ignore error return of fb_get_options */
 	fb_get_options("vesafb", &option);
 	vesafb_setup(option);
+	kfree(option);
 
 	if (si->orig_video_isVGA != VIDEO_TYPE_VLFB)
 		return -ENODEV;


