Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1525B3DEAEC;
	Mon,  4 May 2026 13:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903149; cv=none; b=o+1oF749M7P6BrNmovGlMLJq9uFPeOyrIVZJw0tt9B2byw5Y8+jRxO7dXHphizfvbU7R3tNxZZi18MAvchPawQ+FtP2XREtJkFZ6WczuZCaA76r/zsMvwJl01qw+vk/TWX3GuXbD308IBUmPtq0Xh2RMbmg9xRWEBIuec1IcR0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903149; c=relaxed/simple;
	bh=ts+8KJVlF7VdvogxBzteqFPxwzim+L4NKqCAOd3U2CE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SZXD2jiA8cPrJgYsoyio5Iun8Bz1st4I39AKb+lDgailvzKP1X4JPSMXYi+zFk+dZxh8iZDzkcUZDa2Kc/26Zys4nxfoF680Y0yrXb/EjN5wstgGrqYDvQuHWc4ZUVweyblFfBd86dn4d0gWHtXu1jAMfm7j/GNg6ACUe7qpyFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JHG+hBI2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JHG+hBI2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B44CC4AF09;
	Mon,  4 May 2026 13:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903149;
	bh=ts+8KJVlF7VdvogxBzteqFPxwzim+L4NKqCAOd3U2CE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JHG+hBI28LZ/OkddOOtgTyaVVeiiT0OWi1Syv1VRUDmCUvdbrTqDY2GdbIepmpicK
	 LOEuQkt3uKujENsaKZksxvCZbwfy0zzw044jZ+g74hzO1zYCXEgXwSog1pv4tvMzl5
	 vt0CXf1qX6oUt6f6lYvR4eK711LIFWrnnIW0v8q0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.0 122/307] ALSA: pcmtest: fix reference leak on failed device registration
Date: Mon,  4 May 2026 15:50:07 +0200
Message-ID: <20260504135147.388221948@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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


