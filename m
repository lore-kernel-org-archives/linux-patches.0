Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B218BE0
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:45:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9283C433C7;
	Mon, 28 Aug 2023 10:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693219526;
	bh=rVBPhCM7/BY/BfxcnW/4164KWaQXKvT5U1de6hz20ZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jpno+YiPjrcfQagRKvb8xrCo5O9rSTHwnMSEl3n9hWPiPU+gW30kUnh/SO3UM5Zll
	 i3+bCRPfJDYDcpt4KR6WT1vlHoDrtQk4SjgIqOQoEj6zN6ofkVDPc5pW/UivV9Iyxp
	 Ezz5sLOBsYlzDUibpGZCAS0OiFg0tYjykUrL96yM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Takashi Yano <takashi.yano@nifty.ne.jp>
Subject: [PATCH 5.15 50/89] ALSA: ymfpci: Fix the missing snd_card_free() call at probe error
Date: Mon, 28 Aug 2023 12:13:51 +0200
Message-ID: <20230828101151.853837451@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101150.163430842@linuxfoundation.org>
References: <20230828101150.163430842@linuxfoundation.org>
User-Agent: quilt/0.67
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

commit 1d0eb6143c1e85d3f9a3f5a616ee7e5dc351d33b upstream.

Like a few other drivers, YMFPCI driver needs to clean up with
snd_card_free() call at an error path of the probe; otherwise the
other devres resources are released before the card and it results in
the UAF.

This patch uses the helper for handling the probe error gracefully.

Fixes: f33fc1576757 ("ALSA: ymfpci: Create card with device-managed snd_devm_card_new()")
Cc: <stable@vger.kernel.org>
Reported-and-tested-by: Takashi Yano <takashi.yano@nifty.ne.jp>
Closes: https://lore.kernel.org/r/20230823135846.1812-1-takashi.yano@nifty.ne.jp
Link: https://lore.kernel.org/r/20230823161625.5807-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/ymfpci/ymfpci.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/sound/pci/ymfpci/ymfpci.c
+++ b/sound/pci/ymfpci/ymfpci.c
@@ -150,8 +150,8 @@ static inline int snd_ymfpci_create_game
 void snd_ymfpci_free_gameport(struct snd_ymfpci *chip) { }
 #endif /* SUPPORT_JOYSTICK */
 
-static int snd_card_ymfpci_probe(struct pci_dev *pci,
-				 const struct pci_device_id *pci_id)
+static int __snd_card_ymfpci_probe(struct pci_dev *pci,
+				   const struct pci_device_id *pci_id)
 {
 	static int dev;
 	struct snd_card *card;
@@ -333,6 +333,12 @@ static int snd_card_ymfpci_probe(struct
 	return 0;
 }
 
+static int snd_card_ymfpci_probe(struct pci_dev *pci,
+				 const struct pci_device_id *pci_id)
+{
+	return snd_card_free_on_error(&pci->dev, __snd_card_ymfpci_probe(pci, pci_id));
+}
+
 static struct pci_driver ymfpci_driver = {
 	.name = KBUILD_MODNAME,
 	.id_table = snd_ymfpci_ids,


