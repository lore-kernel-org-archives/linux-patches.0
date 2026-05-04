Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 572743D75D7;
	Mon,  4 May 2026 14:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903897; cv=none; b=md8y2FTJxSsGH4s/ysJVq7LSDeQTas6bwJhdWSSIUDxWQFNA3swdAgYHuzNmLatK13jSpBA2kWMOY1ubluOCSoZ497sf8+Akt4xAQSSEtM5DoZnKq1/YCPOfkfBoQgeYbfovRiqljBbjyb3j9pky4oKZPEbv2Va+SSiSQ4A8Nlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903897; c=relaxed/simple;
	bh=HH4GMPZ8XfF9foxvnFWNBmseXC1xmtJD6CJWs+MG/B8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EHnbAWVbWZkpYL3gYzwPlPMp3jkOHdRReaYysHvvufH52v3puJeqcEAVN5wfHMwyhjhM7/5zVQxPEGtmMs52Gb68cs2xgOMc7K3zHcDeg149QuhRqRPx1xgyv29xNE+hvX/haFN8csdDEIaoGPIY7OTFoH/vrs2SfB/XKc1nG34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CxgISkxg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CxgISkxg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1828C2BCB8;
	Mon,  4 May 2026 14:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903897;
	bh=HH4GMPZ8XfF9foxvnFWNBmseXC1xmtJD6CJWs+MG/B8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CxgISkxgd+WElIMUU0DAn42yYC6vdI8oLn0XTkWUpGDAKDxpF6KkMi24mXwxKwi27
	 5iaEsAzgr7F6W7J5D0DkE8T54GKfJ/997byR0OftoGWXr1BHWbo5JwKtu5T5ukMMk1
	 Ufk7xmXlprs0KPxztHQBRVZYYIsx4A4qFA+4zMYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 105/275] ALSA: pcmtest: Fix resource leaks in module init error paths
Date: Mon,  4 May 2026 15:50:45 +0200
Message-ID: <20260504135146.813719021@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -754,15 +754,24 @@ static int __init mod_init(void)
 
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
 


