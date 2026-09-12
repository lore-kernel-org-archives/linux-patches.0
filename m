Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 652B2344DBD;
	Sat, 12 Sep 2026 19:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241611; cv=none; b=l3N2SIAtoLLHbDvmdP3RTrAIkjisSmRVUkI/8I80S2EVDrkthCTxr9kFSX0wKaG0jUkmstXl4VmL43pR7dI0oSS9Z9QmnsdamRjFSCRj1IFf/8HI3EezWS5XkxjeCi0TG8yyZfwSY03w59w/GcUpW0xFs551n3nfv+w2jLlg8XI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241611; c=relaxed/simple;
	bh=LgAd2LAXid8OlO9DJeXupTVgAslp0+uFVpJIxeIk8nQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U4reX9tHqoBKxegqCV1H8TNi7MqemACv/gu7RpiKmt45f8AmVOQABvsFErZkFQf9qqLa/rdLur8n9JHum3jaKa8RYePVc0VL0TwHpcawqPPJB5q4T7WI4KneCG7/7PYwZ+cdjMhXyfZTHpBycOjJ7DoBweJJOwzPgrT4pFyydeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NVGvrRf+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NVGvrRf+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 202091F000FF;
	Sat, 12 Sep 2026 19:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241610;
	bh=hiQAnGefaJUcqvmzAUjE5MTEctBOTJc+1FDG29JKwgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NVGvrRf+C0RwJjU0wbPauRUcJ8yxYGTTvAaIupPe/iEt3OCNh0+PWnNLfYgwM81/7
	 yrKHLrNLXYNC3jIh1R67nqoyV9RKKkVaH+X6CAvW8gUpadldcnHK0SjMZ0QWjRxsyS
	 F5d2fVLe3SDKWeLM2Tk9KCvMPDT2InG1pahfn+9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 171/798] ALSA: portman2x4: Check card index validity at probe
Date: Sat, 12 Sep 2026 08:56:39 +0200
Message-ID: <20260912065520.940203416@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

commit 3690ef20469d5959378260e2752f2314a2572913 upstream.

Although portman2x4 driver has a check of the given devptr->id value,
it doesn't check for a negative id, which is often given as "none" or
such value when bound via sysfs.  This may lead to OOB access for
index[] and other parameters.

Add a sanity check for the card index and warn/correct it if it's a
value out of the range.

Cc: stable@vger.kernel.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260806153227.1460166-7-tiwai@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/drivers/portman2x4.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/sound/drivers/portman2x4.c
+++ b/sound/drivers/portman2x4.c
@@ -716,6 +716,12 @@ static int snd_portman_probe(struct plat
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


