Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6B623DEAF2;
	Mon,  4 May 2026 14:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903598; cv=none; b=LCBl3UdmWvQ9eHiiGkf82uq+ZymHr+fYYMwDNf3WUamTY3YFw/QjOZWK79zQhmXwJe2EnsFPox6zIIZpuWs1/NdYumOJ0jQwiWT0BDyQWYXwslOMgU/mPQTUDDFHH8E8MgLec6JZTeyYCG5BBIOro2VTvtsRkkIF3GaV8lb798s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903598; c=relaxed/simple;
	bh=J/VJyibvHVYpNcYp2FL4BWdfXndNv8bhEyR4WbEiUzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NhfKD0IqqZsifZRzSDEZs5eCs/EX0q2GWqit8vHCm5gDQ+EMdpE2eWtozXgNvIP0SHkrorbtN7mSj7mJBV8IKpVZKdv7pPVBQgYO+rFkjoVyN1oIa0eenkKlNg5l9R1e/YT+x2RJOpiGRCQ3wN0qRBCUTaX9VOh5O+QqVMl3tDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w/RvuI30; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w/RvuI30"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FCDDC2BCB8;
	Mon,  4 May 2026 14:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903598;
	bh=J/VJyibvHVYpNcYp2FL4BWdfXndNv8bhEyR4WbEiUzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w/RvuI3001fOk1RDBt0V0M8QzIsORCd0X/SLpN0U0kwxjHjPt3EuM6M4WYlXZMfhN
	 Cy/V6Cx64VHPUoqpYPk7uIeOVtGwAYPfHqgxMAvLN46tw2gSPIUawcWJZhGs001vgs
	 oL/TM34leUjY7c2mwQgEs33fSkIQjalCMbAcxjaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.0 296/307] ALSA: caiaq: Fix potentially leftover ep1_in_urb at error path
Date: Mon,  4 May 2026 15:53:01 +0200
Message-ID: <20260504135153.921940521@linuxfoundation.org>
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
 


