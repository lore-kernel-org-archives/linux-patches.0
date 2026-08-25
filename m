Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D9CB481640;
	Tue, 25 Aug 2026 13:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665436; cv=none; b=ekWCK1q3+u8Y3t8z/yxp7VjvPuvbZeuVHFWiVBxgV/i/ckyhF47TaEkSudD6gxRUIB7Wtui59xleKkKwQC3scS39E8N604wKPeTwKmmDbKAQp/l1K8JUI45uIzeRr7boeFyw21spUsRzlVcb9Tnc4eZ5seU9epbex8XK45rQ1sM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665436; c=relaxed/simple;
	bh=24CJ/Xz7ypUFp3v7Hcqd8Iat7s+Cuag2Cd3//CzZjEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c/2kJBcbc+fooQplHsFNcMbvfWvqAuzHXdiIyKuK8oiocok5XuKGWIhadVE1OHyt+xDwVJYX6Do0wQWSYYMhDlTmr5nbNfaZB3AZoxsseSyaU3vMw6N6W31LQPYQU7RneZHZ2D21Ty/widwu3gYkfYcvZuIfW+QukUSdm9Kzp/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M52b/k3A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M52b/k3A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36CA41F000E9;
	Tue, 25 Aug 2026 13:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665434;
	bh=wG2EtDYyFarHg04DXagcjzEhzC63LDXKGGEtw+VEVXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M52b/k3AXizpEbGFLSU1hxgnUHjVWK5ZJjQk9Km/c+1nSEMupfXbc+LrTJt++0ish
	 ZVikT+wFIlhLS6OYPTLnjA7e45VZZC8kpswrXDjOezWZlQnO8yLzmt79uz2m+sgd4P
	 5pqffXG7Gr5aDe1OgBeKJDZcozP4Sf1wkmODaNsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+2fb5d1f7cc4c1f132bcc@syzkaller.appspotmail.com,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 25/77] ALSA: dummy: Check card index validity at probe
Date: Tue, 25 Aug 2026 15:25:47 +0200
Message-ID: <20260825132542.556827371@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.580275153@linuxfoundation.org>
References: <20260825132541.580275153@linuxfoundation.org>
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

commit 02442d5fe8ee365a084b055d4fa81a0c1abfc3fd upstream.

snd_dummy_probe() blindly trusts that the given devptr->id value is
within the proper card index range.  It's OK for the devices the
driver itself creates at the module probe time, but if the device is
bound manually via sysfs interface, this could be -1 as "none", and
this leads to OOB access for index[] and other parameters.

Add a sanity check for the card index and warn/correct it if it's a
value out of the range.

Reported-by: syzbot+2fb5d1f7cc4c1f132bcc@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/6a73bd4d.01d0871a.3a0d52.0005.GAE@google.com
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20260806100433.1287393-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/drivers/dummy.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/sound/drivers/dummy.c
+++ b/sound/drivers/dummy.c
@@ -1025,6 +1025,12 @@ static int snd_dummy_probe(struct platfo
 	int idx, err;
 	int dev = devptr->id;
 
+	if (dev < 0 || dev >= SNDRV_CARDS) {
+		dev_warn(&devptr->dev,
+			 "Invalid card index %d, using default 0\n", dev);
+		dev = 0;
+	}
+
 	err = snd_devm_card_new(&devptr->dev, index[dev], id[dev], THIS_MODULE,
 				sizeof(struct snd_dummy), &card);
 	if (err < 0)


