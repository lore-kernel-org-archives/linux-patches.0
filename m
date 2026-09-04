Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B96E400DE8;
	Fri,  4 Sep 2026 06:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502966; cv=none; b=L16Jtmlgjqxz3lQn611JTki14ZyIJ1rWQhJzmnH/p1JO7YTTh7iPUJZml+9yzDFwb0qKKhRYLhuSaxE4UY+/uQ56KNqcLH18OwMUkja2y3nw9KXfrQLWd3y26g+5n9TetS1YbjoWl8HDkttFEsLrk7DqtZlTDEsn2CnCfxRBsNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502966; c=relaxed/simple;
	bh=947LgqzfpgHwm//1gjCUt0z9I87KvjC2iCCrs7G/LVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R+Rdq5v1tVmU/i4ltVFG6SZ4BwUocBVLBPfb5EuDt2cEAC8KuPcjbIbUDx1NXgYyg/+pnacAJ4D4IrEIYALDMxxwj3vV3W3bJI3RLos8XfN9086WoIqRwYLOPc4Sr5tT0tfOFjuRoJbO5w0xs5cV2GuhpEeooSNLiUAqdp/u5bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y+zl3a4U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y+zl3a4U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 659731F00A3D;
	Fri,  4 Sep 2026 06:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502964;
	bh=tqv5g1/lzweiAqVNeVRwv65bt5ImRN2rOApbVEVwfEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y+zl3a4Uzbf1GN6ka1Su+VM/4UUL1ZZAHXvzy2tGbKZ1s06RCz8bMoHJ5ZITtygIZ
	 tD0tp56gCkfzoXhBHNeErqsvT1GdasxUgd0w/OSaIbMLWNKyXlvajP3ZSZbe/DLTNr
	 3+OaTh6WCmvXUrFmVNiVAYtTIASNu1ybjNWLX7TE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 365/403] ALSA: mts64: Check card index validity at probe
Date: Fri,  4 Sep 2026 07:02:48 +0200
Message-ID: <20260904045743.107838694@linuxfoundation.org>
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
@@ -918,6 +918,12 @@ static int snd_mts64_probe(struct platfo
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


