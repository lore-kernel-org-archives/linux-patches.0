Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DAD447D451;
	Sat, 12 Sep 2026 18:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237119; cv=none; b=G5MvMkvdHIHaiCTkmbBlRXPZoiX5BdTskxTUVrKhOkHZVVULHCSCT3ayrqA7ulwkEcL8BMdjYXHjxI8M2n6K4rO+8+lFJ7mkbKFsY5//x6lHHPQQGc40IPuq+2z/JZsBFLz6O163hFDEdVeHoAhLgSLnIdIsF+CU+KRweI8hGeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237119; c=relaxed/simple;
	bh=umub4Vgga63jlhDBa8w05+AKRxy4ublIqTAySxBhKCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MJP1ALWlg2QFPNyLfAbiWff/OjuXedrPKD2r14Cn80TOpWkGi0Cdu4L2meZUV31W/ki0yFG6yKDV+tstSG1lUdEUQ6WuOsb5kYCC8V3/O78WfGe6AAj2kcKh95ijzwp2+p07LQje70/i4vcvlEhSu/84RNi/tk0bZQ4ooo7TbSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GTuERZio; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GTuERZio"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8338D1F000FF;
	Sat, 12 Sep 2026 18:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237118;
	bh=0Zl6afJV/laOCbRew/WnV8O7Jx5pgjon3cgbgKtXT2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GTuERZio48fczfNq/dV4Z3t/XJnFs+JMfQPyuVb9ibNGCfSwI3+/1hXBgC0sPoFiV
	 +IUf2oNDUDMcjU1C21tEYUm8+yK7rOoPiIvEImLcAhMaUrshbGufmdTDCAmwearJ0l
	 3waVffB9jPD93B5IhELUSqsqPPXo68xp4gi3c92I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 194/935] ALSA: portman2x4: Check card index validity at probe
Date: Sat, 12 Sep 2026 08:53:44 +0200
Message-ID: <20260912065531.265038746@linuxfoundation.org>
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
@@ -715,6 +715,12 @@ static int snd_portman_probe(struct plat
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


