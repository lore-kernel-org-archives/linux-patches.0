Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F305403E9B;
	Tue, 21 Jul 2026 18:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658475; cv=none; b=eiiXf+VOJ3nsXTnmV4OUpu4Wacq8BhM0yMlTh9iD3YZBPNHGIItCAaGXKoLB1mL9eUBqcHd7ApUZPGP/HelV0TqigKL33oxLA9qaTNzdiJDMxZZ8gXQ26iEpaPZAl9U5i27mK1kKU7eK1ytAONwNhDnSVbLRaiaNA8voXvpznrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658475; c=relaxed/simple;
	bh=ftSHzu8PT5SRjpOHq0Y2ICfQ1AyQVQ0GHHT92b5yoFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OxeEPMwlB9aIU09rguBa9xGnOpMVHpw7++Z6MZLVP6+TSBxovFcfqBhx247eOJbT4easgSVlo/9hMNDpYAPsJC7xBnF2qedtjHeHOEuF4MfBox7mXE+OqaRLFtNdrxj0O77IcMqlm7b+MoiNx+oOOEhj6gEV8L0yazUl/nxW9ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wNRKy/kG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wNRKy/kG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60D951F000E9;
	Tue, 21 Jul 2026 18:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658473;
	bh=w/jesBNfMp9Kmkcf9C/7+hig2hbPknkJ8QTDSrVKVmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wNRKy/kGDEKT1f7nYpXVjIn0d8fDCbRW0Z+SnRxyzoIDX0Xv5FCkEwVEzU1TiggWQ
	 0KoiTtYp/F9ycgOKhCTMwVjUMuK/5FgPR7MlD4clOcGZ2arNT74KgQeH161ImN4Zra
	 tSQRojLT4sgaHhXnHRUNSM22YAziL6sqtPnuIK/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.18 1155/1611] fbdev: vesafb: fix memory leak in vesafb_probe()
Date: Tue, 21 Jul 2026 17:21:11 +0200
Message-ID: <20260721152541.401438371@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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


