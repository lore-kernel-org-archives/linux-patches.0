Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A03B3C199A;
	Sat, 30 May 2026 18:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165844; cv=none; b=UjxIoIs/Vk0R3onj+FgxQ66Q4lK71NjpSf2peWpTBQdRdXk+18ByNYwvJGWAleGUlcjh2ktnFLE6rvyBAai+t1GC3BQ4hqhSLF/09kGVudtTA1pOQIc9O/RU48G1u7Ld3rokEehsjRnArJ9rN47C0puiv9VIfLTAcvCOdu+oKTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165844; c=relaxed/simple;
	bh=PwyEGmu9+6kDtBq+bva0qXIjLp7rknJSAQE830LhZZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ORy0eXniD0Vc9vf3EoO96Y5fuy8dVUm/zP9pbPt7+NaFdWwPiD1xfFCTWmcjbvarpVVzE7uSi8v4Uv/glhVN0MieWVo89Ieu6bWbFAH1wcQ7mqsr4aw1oNuYMPRWlra3noIpwGmj4t6EfMw9rXH99jhiX+DLbFynCePmastHgB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yv0+p5qJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yv0+p5qJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7D3E1F00893;
	Sat, 30 May 2026 18:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165842;
	bh=+r7RcU66lXmSWRxt8FEAsAOvLX+QiA0Rn28+PW8FFs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yv0+p5qJNHc3f98fWmECscZIdUU92nucbElHO7Nyg7JysJWozCnwNrEJr4TVtX1Bn
	 8c2WNqRosjLLM0JYCPFUvdjnmVZDOSO0eBrWP/2vxfI7jyy1jidb5QnOmF3XKsZUfK
	 qfavX38HVtGdExISntTBijetJn5nWyiqqPfMFKvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 198/589] ALSA: caiaq: Fix potentially leftover ep1_in_urb at error path
Date: Sat, 30 May 2026 18:01:19 +0200
Message-ID: <20260530160230.116051421@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -528,7 +528,7 @@ static int init_card(struct snd_usb_caia
 	card->private_free = card_free;
 	err = setup_card(cdev);
 	if (err < 0)
-		return err;
+		goto err_kill_urb;
 
 	return 0;
 


