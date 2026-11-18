Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055979;
	b=r3j8yf0qUQaGuzwdqpr9edh3n0v1KBrlGxH6FWrrfPoukL2QCofKFerhGdpuLf+S/JiF
	 nj//j1Xdt33O2lV0uypU6CA/+CW9CCELpeoKhAMCnY+KLwc+0+noWQ1hcIxR0DkEnP80a
	 z9SPSCMefbfbhVB4Kqb+TNFsT+boLve4DM2MjVVatJWfVBTUu8jAIwJ6zpFhNVEzEvu6g
	 YvvTjZhOBAIYqeZiT2ACKD9W36rzZsmumRCkRO79/TbddsRsCpwHbCXA4cBDda7DNGYHu
	 Z1sA93aRWqOq/tzvivdXH6L7UONIVP+VlN+p1hgyKeZ0ADaWwGzVkxh6w9YhyvQFTtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055979;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+WbyUHiTVr2oP7NsQ6Rm3O7xGFNHmvZoRIbUCljAMG8=;
	b=bPzLrlkE9uWRmf3L55kRjniSDExiVbzP3J9BqoHd11MwNj+mtTYi/OyS9h903h0CCJcJ
	 2oTqVzW3M9ajzQBKPBF6M421hlNJGQX3JW1aDmRoLVmd+MvsHB9bSUALq7BrbQNJL/LBL
	 0fGpcwYrCZpui9ygOg1kdMqnC+2QFVRf+6PeSlqxZyrOX8KviKQAnPa54q41GX6/Q0jT1
	 69PQ5jtzyIsok2U+GkAqx62hohUWXs+eoboMu0ppKsDh6o7Rr4r+aj7zEUS7x4PJ49psv
	 qUX8SSG11B/LGJTmi3Cn1efV2OkX6Ame3YLv0w2GaujeGinJAJLfopBf1caZ4BePtnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ma3yMnbB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29806606A32A;
	Thu, 19 Nov 2026 02:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ma3yMnbB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 832431F000C4;
	Thu, 19 Nov 2026 02:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055979;
	bh=+WbyUHiTVr2oP7NsQ6Rm3O7xGFNHmvZoRIbUCljAMG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ma3yMnbB6EFDhskk8Rs3L8y49va+eWaR5xemylZrt6DvN5TFSiq/PfKrSapueHpbh
	 zlLYZIbDBSAXZT2YJfE74nQ1P666CN3o1U0kxgvoXaS75YRqsVQCt+1wsIhQCuK+XM
	 pcFKpU6iAYk6vNlXg6tbt6M8u4JrZmhZpHWH6L+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1825/2214] ALSA: hda: intel: Cancel delayed work at shutdown, too
Date: Wed, 18 Nov 2026 15:58:21 +0100
Message-ID: <20261118150124.456672999@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 1a675dcce235d..0a12ba8165824 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2422,12 +2422,17 @@ static void azx_remove(struct pci_dev *pci)
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



