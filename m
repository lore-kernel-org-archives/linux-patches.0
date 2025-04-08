Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 588AB26B089;
	Tue,  8 Apr 2025 12:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115410; cv=none; b=UXLBXrv/EgyD95MWRTwhHbikg6qqyv2lWbfSaEPzVnnR9Rgo//Qc9BZlXRhdF98ssV3ebt3pHkejwkidbvj6PhY+i34fl5v/bTyp49e7OO9Zdr6E6EdgQEhjODd2Sh3psDydHEqEbC7LdmKBJD+CczQ4BUVPbbgvOmy/nBjUjQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115410; c=relaxed/simple;
	bh=2oZCovXTtu9FpXEdJJbSVbNANcFHaAi+4tMCFZR3jW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ItKyH+7dD3Hl5idFK5pJFqMMrCyAvN09zYHyXHKz0q2XzYbUMslppJ5+Cg9gHbmEc+GUTB4Vdp2jqgnEJ8gwEKAMt8WjWahE8f5anjTetvhZb3wZYgN4ArG2rnuQol5SI9S+K0xiDOf9837cGcpWBvyIYZtI0gb7gOkPUA6WnXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vxcqDXMS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vxcqDXMS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEB97C4CEE5;
	Tue,  8 Apr 2025 12:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115410;
	bh=2oZCovXTtu9FpXEdJJbSVbNANcFHaAi+4tMCFZR3jW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vxcqDXMSXlRgnXlSYRvZ5hexrgH/n0xHZxZy7GY/XobFjKJLTWtAS9h9mlY3fNivy
	 Dc0aUfwxVhdgBgRCEShyzB+7rzZ/GWBsTHXLZaS41H19QEMHSf0yaXmKZfog8nhIB6
	 S+k3FT6iyR7eotv4ciK3ziWGP180UV9xLC2rV0fw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Penkler <dpenkler@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 425/499] staging: gpib: Fix NULL pointer dereference in detach
Date: Tue,  8 Apr 2025 12:50:37 +0200
Message-ID: <20250408104901.826870272@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Penkler <dpenkler@gmail.com>

[ Upstream commit 6a6c153537f093c3bc79ea9633f3954d3450d0ba ]

When the detach function is called after a failed attach
the usb_dev initialization can cause a NULL pointer
dereference. This happens when the usb device is not found
in the attach procedure.

Remove the usb_dev variable and initialization and change the dev
in the dev_info message from the usb_dev to the gpib_dev.

Fixes: fbae7090f30c ("staging: gpib: Update messaging and usb_device refs in agilent_usb")
Signed-off-by: Dave Penkler <dpenkler@gmail.com>
Link: https://lore.kernel.org/r/20250118145046.12181-2-dpenkler@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 8491e73a5223 ("staging: gpib: Fix Oops after disconnect in agilent usb")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/gpib/agilent_82357a/agilent_82357a.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/staging/gpib/agilent_82357a/agilent_82357a.c b/drivers/staging/gpib/agilent_82357a/agilent_82357a.c
index 942ab663e4001..d072c63651629 100644
--- a/drivers/staging/gpib/agilent_82357a/agilent_82357a.c
+++ b/drivers/staging/gpib/agilent_82357a/agilent_82357a.c
@@ -1442,12 +1442,10 @@ static int agilent_82357a_go_idle(gpib_board_t *board)
 static void agilent_82357a_detach(gpib_board_t *board)
 {
 	struct agilent_82357a_priv *a_priv;
-	struct usb_device *usb_dev;
 
 	mutex_lock(&agilent_82357a_hotplug_lock);
 
 	a_priv = board->private_data;
-	usb_dev = interface_to_usbdev(a_priv->bus_interface);
 	if (a_priv) {
 		if (a_priv->bus_interface) {
 			agilent_82357a_go_idle(board);
@@ -1459,7 +1457,7 @@ static void agilent_82357a_detach(gpib_board_t *board)
 		agilent_82357a_cleanup_urbs(a_priv);
 		agilent_82357a_free_private(a_priv);
 	}
-	dev_info(&usb_dev->dev, "%s: detached\n", __func__);
+	dev_info(board->gpib_dev, "%s: detached\n", __func__);
 	mutex_unlock(&agilent_82357a_hotplug_lock);
 }
 
-- 
2.39.5



