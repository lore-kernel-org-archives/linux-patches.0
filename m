Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36448315785;
	Mon,  4 May 2026 14:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904329; cv=none; b=YrDf6APsfPDBM3xaTpKkWzDDtJQKzJR0ooINOWGvkGMe4xxCzW6lvrS74Db+PBpA6vicA2vbvMVF6lS55TOhWSZ4klLKmiqRY5hvlEiGeUFt8JlLJweCeSKEXsu2yP4Ni7OTHvrz32AKokjLWE/uKbtmSf0F3BsIkWfzg2bmx3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904329; c=relaxed/simple;
	bh=GLSs3PybfFJEkHiLzuhsDQRJJ68//RknywCbVrXZdMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rfQt1y6z5hzJdsCUqA9PPr+rl4f6gq87lNSwLxlvYKh8f88V6rY5eW2C7fmrZxYbxSVNEAJo1MwoO0VMTSWCS91gpgOkRzn7kaOUzGFLV0A8B8nLpKx6sosvvJ8N81k2B5AD0rWBzTcK32t9AQj1fORoDSGJCJC8cIMLx4MV70I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tSD7rkm/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tSD7rkm/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C18C3C2BCB8;
	Mon,  4 May 2026 14:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904329;
	bh=GLSs3PybfFJEkHiLzuhsDQRJJ68//RknywCbVrXZdMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tSD7rkm/737eW65GxABoeDczNE2HSho2jnfw243eg3Aj8MFRow2DthFcldHtxmF/g
	 K7GbF2USNeMGS9d7jvWn+3avBHtFTnPO07iOrjrsww787/b6Q8SMHyOyaZHLAyt8P8
	 iQVMhWLsWA0TKe9f8b4gzyjbj4QxohgATcue/tE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 265/275] ALSA: caiaq: Fix potentially leftover ep1_in_urb at error path
Date: Mon,  4 May 2026 15:53:25 +0200
Message-ID: <20260504135152.885340177@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

commit 0a7b5221b5b51cc798fcfc3be00d02eade149d69 upstream.

The previous fix for handling the error from setup_card() missed that
an internal URB cdev->ep1_in_urb might have been already submitted
beforehand.  In the normal case, this URB gets killed at the
disconnection, but in the error path, we didn't do it, hence there can
be a potential leak.

Fix it in the error path for setup_card(), too.

Fixes: 28abd224db4a ("ALSA: caiaq: Handle probe errors properly")
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20260427123819.890185-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/caiaq/device.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/usb/caiaq/device.c
+++ b/sound/usb/caiaq/device.c
@@ -514,7 +514,7 @@ static int init_card(struct snd_usb_caia
 	card->private_free = card_free;
 	err = setup_card(cdev);
 	if (err < 0)
-		return err;
+		goto err_kill_urb;
 
 	return 0;
 


