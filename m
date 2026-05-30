Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA8832E92B3;
	Sat, 30 May 2026 16:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160319; cv=none; b=gM+Y7YbyhywTevYJsG9m/IdsMY/f4u85dTauIgGZKpSH1eVdplBFZpvjF0eySwsb65/UMz3fXqf1Loj0VRU8HiL74aGtiQ7tdf2sOLGdFlqRh1qaQc4E5l0mti34BxEEpwryC3+JSmGwPTVPJega08eYXYvZ5UtueqOQ8DeV768=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160319; c=relaxed/simple;
	bh=sEcEqCxregrSv3BJf9118HlJmPKKM1Ktouz33bTXfpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WurdUzmqbYdNgaqDbspvxKK/8xBQaj6RJiRPCwmvIU4p7pYZPM0Whq6viymTiX0p6QTigLHYlDAtqiVVJq1Gv639aetiBhhjOrtsz3v6eptwctPpRYM8pm/pyNkUrlaC5R6XrXRzv3Y/qAwnPLGuW3iJhwjCrE84y3Qt+7RFQnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CH+Cy+HV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CH+Cy+HV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC0DA1F00893;
	Sat, 30 May 2026 16:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160318;
	bh=9HoEzXF4g3/Gxy7TUzwKLXstKcq2aiu+Z2fQUzoI1nc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CH+Cy+HV2SdVYfba6K5sIE67XXMSNnSay7PNduxYS3Jf6edEkNtXtErXkxZZ5TeJe
	 e2ZgWOG64GrBwhO/aEEdkbZd+mR0Skux11oPZ0pwR/l5DW+BJVl08/5GGz9QExdPyE
	 hXj9YAVcN03mjOxDQKsIQYnptzTnvVy1gs3gKtzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 272/969] ALSA: caiaq: Fix potentially leftover ep1_in_urb at error path
Date: Sat, 30 May 2026 17:56:36 +0200
Message-ID: <20260530160307.992024287@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 


