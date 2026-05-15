Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8036E3B635B;
	Fri, 15 May 2026 16:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860939; cv=none; b=U/ADV5zCDawfOhQw2VQcNDtz2kFybPFczf4COH3quPMW05sK139HhbLYGG+7giUgD8FR4SE0V5pNdpf2OOrOC81n8AtRUnGZGCFmGWce62vtkh0DJf7foVDUygdimWqk3cftMJkUD9IxURN4DD5GRLJSGbmHEb3xF7UeI2ZqDnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860939; c=relaxed/simple;
	bh=+OiaOpSWw+Sw0FI3hzVm104/G6E2ioRihvb1Q/iBDKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N97RVefNBD5d1vO5+77zQr1pxzbW2nOHkGP5RCAdmqwI7+rjN66qOtfXCew52qXjOYaz1ljqRYmdSEAuX19aJhP1UpMV8dxNd6zm2IRHyzuOrNnzyjX+jl2SxDPZNXOyBwse736Px7095Du17dOokxtK9r9p2Dc6FcfRBaqmgQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gDSn7c5e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gDSn7c5e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16651C2BCB3;
	Fri, 15 May 2026 16:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860939;
	bh=+OiaOpSWw+Sw0FI3hzVm104/G6E2ioRihvb1Q/iBDKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gDSn7c5egrOFkCRtP+hGmJrHsbW32n4BMibT3iwkZ8VQ7mNZLxTiSFlaQn8v4o0qS
	 Gb+5rag5bCamS9ScmWGnRqlGCTiTW1nK+bdiZ22f9q8MJZkdz3mtol0/KSPCjPJ+8t
	 x9iL6U1UZM+Ap8DqFInYZpIKKdSFdVALY4JjsmzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 137/474] ALSA: caiaq: Fix potentially leftover ep1_in_urb at error path
Date: Fri, 15 May 2026 17:44:06 +0200
Message-ID: <20260515154717.995205385@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


