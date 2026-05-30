Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2ADF261B9E;
	Sat, 30 May 2026 17:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163555; cv=none; b=gkHSdHLFKin9HPDr9A3QNxtFSfLM9z8ZUCCrFw6NETaUk4GPpHow+ymntBNJD7m8ZyRhfT8R/j4bE/gUjE001wPd5ypUmUrDeyju4vNwFF/61cmv6kFHtJzEkw/yDnX43b8kG/d9W0NSw47RYI3ZI+TydoBeR+yKQFyFeCuk/+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163555; c=relaxed/simple;
	bh=dLMjPKUrWOEUQYq1X7gQboVPfBQ0+LQx3qaYSDYOEEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oGTKB+J8xhoR0Q8BLvtL/gVXL5KQqwsLY74q9QGcX2CfP4wa51Jf1jEyD/O6uOWwWNegyrIhJ3yk0ImFqMvtAEF7IPHbyKOEeGWqdEcbaUnhd6zjg73ouSpHZiHQwXoFkCyLVm2U2c3j3+zY48YcDxtAHVBLhwIYJmU6jldf1Ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BIr11EBW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BIr11EBW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22BBC1F00893;
	Sat, 30 May 2026 17:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163554;
	bh=4lWp+KprSDtIC82REbXzGkRIAgZ2bluQgy9qmW4AiJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BIr11EBWntIyl9FBSQzngMccCpdXDBcgUx7n+c1HiY9pTnrZeLBXEWfD44oV+qNJv
	 RfedRACNBSQEvsm8cBIACnbKhwvpRuiPfKriputaX/NoixT/ve4SR5buZgJcpGCbK/
	 1N1YvKqhVd10EpRKeUokuHJUYHHF12sY1xoLFIkU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 264/776] ALSA: caiaq: Fix potentially leftover ep1_in_urb at error path
Date: Sat, 30 May 2026 17:59:38 +0200
Message-ID: <20260530160247.363153194@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 


