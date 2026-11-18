Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049403;
	b=a6ND5TMa5buYvmUEqunaWRx7xnxMGuq7psE0qArjL49Rp86zh5ctTacKrXeMp+aVWa7a
	 Ndh07ynEZhTIIbUgbeJeKrn2xZTYVbCEt5vffBNgs0LNQnPSigrLcoVf3hyEa9QHWBwHE
	 5TKTwCOi60/v/a4XO6Bba6YvPSt71EB2QLm+/zr1ImJ+zmUa1OsXVHQ2emqn7K5vskz1x
	 eoSXPJ1J1WEBno6K+WWVGxaO3Wkc3X65Ik4eIenRx1LCDHIdYJ91sZqmgZYX/XKNF4Glx
	 1ZeAu4PiUzZdSdygENNMv+waQ5sLkaYEFzpFS8hGfpHhokR4PkKEM1cnaEJeAaMH/1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049403;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=q6jMbQrQ3415DWLv8fXALkUexaaz7PwKz9vyM1Z2q7U=;
	b=GQk0KoFYvqbt5XoxMOTiUEyw2fk1Ur1dQkfq3Rl6Jdkomg6oo3XdeC/gqz1P4egrIvhE
	 nYnswZQXnz2hH+UC5aTNjMydOQAMo0IR51+msSSxBVb+y2oA4eg7bBGXixil6vi6JQWDN
	 +jveJr7O78tUk2huASEuhAXaXQFwjwtKC3eBma/vjcJKy8EZOPVtNiNSz4gSY1RQjCuay
	 0qvkiKIJfRSC5JrozYIC06rRfVive2yo0MmkTi+oRkobQTLQswKHerhYrs+j+RoMf42FP
	 DGvTm+5zZEI/Mn2Bu31FcHi5Wigm3jrgDuEFhKx10+9gt9Q78ahWtyzlTsQwSBsVkxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cblDuSxl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89809606A320;
	Thu, 19 Nov 2026 00:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cblDuSxl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD4301F000C4;
	Thu, 19 Nov 2026 00:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049403;
	bh=q6jMbQrQ3415DWLv8fXALkUexaaz7PwKz9vyM1Z2q7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cblDuSxl2hm0NlOlT6vp9XDdmm1tt5UlbtakYJBdPFna+pyHH+azBizwU/PYTQs2E
	 HTHYjcRhQyaUSZ+5Q+M9ebxeGSNgfsUzpmZdYMJNtonVggt9j7PqmWnREaMxs9/adl
	 uqM5aOB/WXciQhW354dlXrcONw07bUPo7yk1xFgg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2339/2857] ALSA: hda: intel: Cancel delayed work at shutdown, too
Date: Wed, 18 Nov 2026 15:56:13 +0100
Message-ID: <20261118150325.750456280@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit b83b78df0e53d9dd872d24e49a99658815b12770 ]

The shutdown procedure needs to cancel the delayed probe work in case
where the probe work stalls or is slow but still possible to
reactivated.

Fixes: c0f1886de7e1 ("ALSA: hda: intel: Allow repeatedly probing on codec configuration errors")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://patch.msgid.link/20261008192553.300025-2-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_intel.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index 3058479c42dc6..64c45140e942e 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2460,12 +2460,17 @@ static void azx_remove(struct pci_dev *pci)
 static void azx_shutdown(struct pci_dev *pci)
 {
 	struct snd_card *card = pci_get_drvdata(pci);
+	struct hda_intel *hda;
 	struct azx *chip;
 
 	if (!card)
 		return;
 	chip = card->private_data;
-	if (chip && chip->running)
+	if (!chip)
+		return;
+	hda = container_of(chip, struct hda_intel, chip);
+	cancel_delayed_work_sync(&hda->probe_work);
+	if (chip->running)
 		__azx_shutdown_chip(chip, true);
 }
 
-- 
2.53.0



