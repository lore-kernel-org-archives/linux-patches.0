Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5223D3D8129;
	Mon,  4 May 2026 14:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904540; cv=none; b=lcyIHgO+sP4wCzY0r3/UsLw9aCaxefFAzJBAjsEI2vJUzOGrX2nLPAb8ykWG6m8OEP2xYAQgt+PwFSwAqHA5X1wwXbxXxYo60SblveufuvucfTR3NhozxgHhmkjf+hhzs5s7Ywe8+ZfxUmUEw5Sg0aEgWO+1b3SVnlJCvG7Wfyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904540; c=relaxed/simple;
	bh=ZjM8Qii3tQbgDxdoRRT6GiM9Ivy5bbOYzW6V2ZfBObw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OAYRg5PpRzbdJ6Y+cEpUnKNPYhTSnRSeMe6mSDN2PluCnEDU6XPGlslMEKczW6IJB+pzQIw8YcgBHJGCRCKuxmRDtq8Fx4LaEJOaNa7/DKcqXSM6z2u59qZWmD8KwXm25+pP6CSIL3lyvUllfZQ4lBr23ghqJNGmfiKNVKOi78g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vqVJ3tAU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vqVJ3tAU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC64BC2BCB8;
	Mon,  4 May 2026 14:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904540;
	bh=ZjM8Qii3tQbgDxdoRRT6GiM9Ivy5bbOYzW6V2ZfBObw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vqVJ3tAUtBPAskkw64hGOM/uPt8AAhNXSQSmsL4iyGPqWFUiX2iNlqxW+i2L61XmP
	 gQK9J9/ck8b69KkM3HTyAFP5ZAvTT8NDJtS7ZvdS9ukGF1mo4YSr2cQ9ykzTQs6IRm
	 +umMIpzoYFAtfONmT4He/qIpjSxME8dpt5hrIYDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 079/215] ALSA: pcmtest: Fix resource leaks in module init error paths
Date: Mon,  4 May 2026 15:51:38 +0200
Message-ID: <20260504135133.049806140@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cássio Gabriel <cassiogabrielcontato@gmail.com>

commit d5d5f80416a3a749906c04d56575e2290792654b upstream.

pcmtest allocates its pattern buffers and creates its debugfs tree
before registering the platform device and driver, but mod_init()
does not release those resources when a later init step fails.

As a result, a debugfs directory creation failure leaks the pattern
buffers, while platform_device_register() and
platform_driver_register() failures leave both the pattern buffers
and the debugfs tree behind. The recent fix for failed device
registration only dropped the embedded device reference.

Add the missing cleanup for the debugfs tree and pattern buffers in
the remaining module init error paths.

Fixes: 315a3d57c64c ("ALSA: Implement the new Virtual PCM Test Driver")
Cc: stable@vger.kernel.org
Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Link: https://patch.msgid.link/20260421-alsa-pcmtest-init-unwind-v1-1-03fe0c423dbb@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/drivers/pcmtest.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/sound/drivers/pcmtest.c
+++ b/sound/drivers/pcmtest.c
@@ -753,15 +753,24 @@ static int __init mod_init(void)
 
 	err = init_debug_files(buf_allocated);
 	if (err)
-		return err;
+		goto err_free_patterns;
 	err = platform_device_register(&pcmtst_pdev);
 	if (err) {
 		platform_device_put(&pcmtst_pdev);
-		return err;
+		goto err_clear_debug;
 	}
 	err = platform_driver_register(&pcmtst_pdrv);
-	if (err)
+	if (err) {
 		platform_device_unregister(&pcmtst_pdev);
+		goto err_clear_debug;
+	}
+
+	return 0;
+
+err_clear_debug:
+	clear_debug_files();
+err_free_patterns:
+	free_pattern_buffers();
 	return err;
 }
 


