Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E4263FAE19;
	Tue, 25 Aug 2026 13:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665739; cv=none; b=ByLMEzPkj45ugZf7r3i8opVMvIBvX7Oe6x7ZTP0hDCw6Xt0WzVlYIgEzWzLs4RVIX2iEJI28+jnZKiqRaQXewtVNdRtCJwjJaML98yMTYT3ZNVMWxJFn1qxi6KtH/dctIj8KCKBQX0hczR45LpxVqfwV15WGcZKM7KwZLp8LGK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665739; c=relaxed/simple;
	bh=NBaksrYyMykkbVk2j8RMQ37cGwSI4wj6rKcXcD0PxHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RvkUXQuORkrTLbbb52wrPQwHJmkInat9oBkV9hiARLidyTp214JryI8sG5gTxNx7w8ovA+XaHvN62GIVj56g5VyzTkn3Ek2y1NuOATuz5hC2Rd135Dsgcv+SK9uJGMCWiYSEo4GTr47oLdUxWSnXQGfLgk0fQZeDmmO3GrTEkBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PwZHVSHF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PwZHVSHF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F25131F000E9;
	Tue, 25 Aug 2026 13:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665738;
	bh=NtRmv/3GeO54tfc1v1R4Xn1qv73yy7W8ogNnyqImhaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PwZHVSHFkovj63jklM9xdr7E/FfujcwjtKdPiciFE9AyObNySVs5Z1jPODBd6PLYM
	 czi0H+jepZWyc4pX/I2YDnPWz5lPd1Eod1F2VgxuTjwMJC1qTEwAf4rgXj+p7Ur+hR
	 LhnihjSSSIgGSCSVlhnSVxno0z5uxr1nlL2hFoTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+2fb5d1f7cc4c1f132bcc@syzkaller.appspotmail.com,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 22/87] ALSA: dummy: Check card index validity at probe
Date: Tue, 25 Aug 2026 15:25:45 +0200
Message-ID: <20260825132542.709370686@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.813800447@linuxfoundation.org>
References: <20260825132541.813800447@linuxfoundation.org>
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


