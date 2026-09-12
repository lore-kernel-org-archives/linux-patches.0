Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D52163B3C10;
	Sat, 12 Sep 2026 18:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237109; cv=none; b=AElY5Hj+KswOUSaHv3qWknJ/Qu8ObV1NjAiL9UEtTj8xwp4l7Ls49OsKZ31LohsigySLvNPiMbjshDFaI8AmY5y7meqqf8B+mzTHfS2pO58WM0ERTyrFQqXsq56fpsIoi3FUnZudKPF0wQVBUHM5kXrxzSJiT5a6lxEWBfZGDic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237109; c=relaxed/simple;
	bh=wfkNNnPPsHQiwo93zqaEfg6uI5sURxI1q2OvXfHdYMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ILuXMg51Yn6OZZrvbqZ5S4nkLNcJ7WnkjBYs2Md+2P/pekLhialFfcpxt77TsNzsi8JygtI9T//Ru0+/5oD2DocIJX5cSlnFry7pLJZLJcw8tGDl798iFJqxo8sguYWlZejONz3smuulAC8M7ePn2xnNkcTXv2LwManImwqzUMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PVENH/o+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PVENH/o+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47A3F1F000FF;
	Sat, 12 Sep 2026 18:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237108;
	bh=jg8MXfbe70iNAS34EMXybxp9YDg+PW08VUagp3ktXIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PVENH/o+5Bhzege0qRAQVeC3KxTT87SoyYHwR6cfOFwioHRsp0EaQz8RbCzBZm/vi
	 eVLb1+7/8qc1oLtIUxn5RBQPwahVzgaycjkxlpEEYCs7tceggMs3+OZ4JmkAFKica+
	 QSWAYBcRfuuakK+LSagjMTJG/uxYgcYF76aPIEVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 192/935] ALSA: mts64: Check card index validity at probe
Date: Sat, 12 Sep 2026 08:53:42 +0200
Message-ID: <20260912065531.220891852@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

commit d18a260720f86a5f8b5fcfefc4ba2e9dd01c10f8 upstream.

Although mts64 driver has a check of the given devptr->id value, it
doesn't check for a negative id, which is often given as "none" or
such value when bound via sysfs.  This may lead to OOB access for
index[] and other parameters.

Add a sanity check for the card index and warn/correct it if it's a
value out of the range.

Cc: stable@vger.kernel.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260806153227.1460166-6-tiwai@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/drivers/mts64.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/sound/drivers/mts64.c
+++ b/sound/drivers/mts64.c
@@ -919,6 +919,12 @@ static int snd_mts64_probe(struct platfo
 	p = platform_get_drvdata(pdev);
 	platform_set_drvdata(pdev, NULL);
 
+	if (dev < 0) {
+		dev_warn(&pdev->dev,
+			 "Invalid card index %d, using default 0\n", dev);
+		dev = 0;
+	}
+
 	if (dev >= SNDRV_CARDS)
 		return -ENODEV;
 	if (!enable[dev]) 


