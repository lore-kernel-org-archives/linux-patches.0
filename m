Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0FAC315785;
	Mon,  4 May 2026 14:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904537; cv=none; b=K3P9sgBprNxIWBBv14GGpjdqVRHltKzfX9Uh4nwD+vi24qC2JjElQH4zyoMZQq18JlvcZtv+r1010UyeaZui65CC8LIQUeVKbe7+pagEhx5lo2E8TGXPG/NkA7CZibAGxBJLCFvnWeJ4YPDKa9jE962kxYG0ikT/WFOjQv7QDIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904537; c=relaxed/simple;
	bh=/SBitkrimu1MfgfMlqP7N7iz4FbstsdVA2WNcD1FhC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s3cCPzGRjCTdr9o4E3AZ1v27OHHPGv/bc9twI9GsfQpyT8wTdFdsmTX4ge5syYIvM1XsONH4E9SqytH5tc1R2G7NyAOTihWNejR9ED0nKTqdA5hbIJml4nOGYnfTeZ/caqyDP9QNK1PYJN1keYryPOZ7KxaU5Vewf3jwpzqVKrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ns9fhvao; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ns9fhvao"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46C6EC2BCB8;
	Mon,  4 May 2026 14:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904537;
	bh=/SBitkrimu1MfgfMlqP7N7iz4FbstsdVA2WNcD1FhC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ns9fhvao9Z4WAn9pUmdZp1ztv6sfMr7S/4DGSkD6sM0givE9dXicp2X+c+xlej/Wd
	 Z2VMslr+VcGNbvr6BC7t0ZQudWY40pGaccbFQH6NEFjGcJA1krz43iZYAVqHt5HqMh
	 l1EoV82flM101pM10Mp3ru6Yt/RB9R5ESbQxPL3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 078/215] ALSA: pcmtest: fix reference leak on failed device registration
Date: Mon,  4 May 2026 15:51:37 +0200
Message-ID: <20260504135133.014115179@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -755,8 +755,10 @@ static int __init mod_init(void)
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


