Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B724935A3AD;
	Mon,  4 May 2026 14:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903894; cv=none; b=EkwLBSpXT40OBqdQ4oHVK861/AR9V+xa1W9qXXmNnPvsmduzugYfvhOdnep+cLA3fA8b2XRQAJygb2+s9gQ16bO04R/TJEOEEmqtIO2nRiBaYc3HPQlQyUijHtjZIQniRzL3/d5B9i933ScpSDQz4W7OAO1MMzFBCPp0PISc4UA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903894; c=relaxed/simple;
	bh=jXZVN2P7obYCWzwTL2Apwe/TKz1yTr56+Suc4/5iE8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lxOc3N3kgWUoVWoWLu3109EpPs4ZnjUuezVIHWdl9txVz8u/TfEQ1HdqK2BXrtUMf6Cw37ITWj6aQCp/QfxdgaF5LMuOcNOPJ6SGpP8o5BJr5DZjhzaUL22+ovGUtdu+EclM2FKD4KQsw5hjNXf/hJQxk9gXElrW7z52zxKFalA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hnfezN1R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hnfezN1R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CC3BC2BCB8;
	Mon,  4 May 2026 14:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903894;
	bh=jXZVN2P7obYCWzwTL2Apwe/TKz1yTr56+Suc4/5iE8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hnfezN1R6VZYUlt2xuVtEvNxfXZGa5xb93Mckgr11+YFUBLTcqS+AzRBU34V74EiB
	 utBwvhEij+JFNIwXzz9y9HrtSKzjs/96HMXCLlZ1QDcOICPMXjwIPoYajRFlNEudIU
	 WEPVcyAUNNFdm7O6PjpnOknHMU63U90a0MZQMnZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 104/275] ALSA: pcmtest: fix reference leak on failed device registration
Date: Mon,  4 May 2026 15:50:44 +0200
Message-ID: <20260504135146.777053388@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

commit 4ff036f95238f02c87e5d7c0a9d93748582a8950 upstream.

When platform_device_register() fails in mod_init(), the embedded struct
device in pcmtst_pdev has already been initialized by
device_initialize(), but the failure path returns the error without
dropping the device reference for the current platform device:

  mod_init()
    -> platform_device_register(&pcmtst_pdev)
       -> device_initialize(&pcmtst_pdev.dev)
       -> setup_pdev_dma_masks(&pcmtst_pdev)
       -> platform_device_add(&pcmtst_pdev)

This leads to a reference leak when platform_device_register() fails.
Fix this by calling platform_device_put() before returning the error.

The issue was identified by a static analysis tool I developed and
confirmed by manual review.

Fixes: 315a3d57c64c5 ("ALSA: Implement the new Virtual PCM Test Driver")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Link: https://patch.msgid.link/20260415193138.3861297-1-lgs201920130244@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/drivers/pcmtest.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/sound/drivers/pcmtest.c
+++ b/sound/drivers/pcmtest.c
@@ -756,8 +756,10 @@ static int __init mod_init(void)
 	if (err)
 		return err;
 	err = platform_device_register(&pcmtst_pdev);
-	if (err)
+	if (err) {
+		platform_device_put(&pcmtst_pdev);
 		return err;
+	}
 	err = platform_driver_register(&pcmtst_pdrv);
 	if (err)
 		platform_device_unregister(&pcmtst_pdev);


