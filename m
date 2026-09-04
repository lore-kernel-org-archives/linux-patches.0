Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B91D42E43A;
	Fri,  4 Sep 2026 06:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788503005; cv=none; b=cBSnVP9nHYDw4RB2oSY/HjMl3tMHxhWv92AaemJR1EY0WoYh3fT+OQaxWk42BWLdXU6b9RqKXhv9GDLNntDBREY3YZz6x3X08shV50n6trnH/KsIO6qpv5C6152YKn5k9Mynjc6oRI5XkYA7n+Ds2RDFFtADHTE9vcnd57tCQAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788503005; c=relaxed/simple;
	bh=BIyCrk2k4UsoEmQ94DlZZ+osGPS3BfpzuXkUStsI0v0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VA5kkF/mllTwibih5rxYieJn5ityYR89ewMDNu+AEY8sgnmKWZZKHx9eCSiSsZajYNFJwhwIlXsg1DUOli66ETqeqI9asORvasayE5NhLVzvbFLZX0StukBoY2rDa68CCOXyZdC6UW4BmNI6rsgHMtWAiHbTaPpquoFtO0w8N58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=14F3Hz9J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="14F3Hz9J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02A021F00A3E;
	Fri,  4 Sep 2026 06:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788503004;
	bh=o1dVniFFDyhxvSkvYZXRwAQa6Ce5oNbGYTMvGAV9IaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=14F3Hz9JLWYnw6fwKVkLBdYVgymI19bjjfF59/gy4YSw9C+1ZHTqYut/WPrR3eY0n
	 awpjcYyewEMw7JiSF6UKBphX6Qn+zFs/qBjiIBLoa6bSYGK0tWNhpvaN4LDnUA4P2p
	 LuGj1CAckUKk9kW5bI/YD/CnX6d5XE+cxQ3ZMkjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 367/403] ALSA: portman2x4: Check card index validity at probe
Date: Fri,  4 Sep 2026 07:02:50 +0200
Message-ID: <20260904045743.150144396@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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
@@ -703,6 +703,12 @@ static int snd_portman_probe(struct plat
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


