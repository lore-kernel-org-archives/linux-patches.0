Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0187FBF3
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:58:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55992C433EF;
	Mon, 15 May 2023 16:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169908;
	bh=JW545nhLk1RCYnKAJDDWHqWoYnPRADpqDVQ/UZpANlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rWKoO8PpgAqzQTVDDnPoa15uIN5o2wgGqVk6GLf3AIhPMmXAf2B9fqb9pdFbAl5rS
	 yxXg6bIUkDv8Q1HBD3rt1G8mYKPpNppNIcFDxFP0P3hK5b6oaOqI7zF6UIpQtvHTSA
	 pPsDj84XRnpltK7EkmcQHMWfHl59PSwH8Gr4gSEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>
Subject: [PATCH 6.3 209/246] firewire: net: fix unexpected release of object for asynchronous request packet
Date: Mon, 15 May 2023 18:27:01 +0200
Message-Id: <20230515161728.871413483@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.610123835@linuxfoundation.org>
References: <20230515161722.610123835@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

commit f7dcc5e33c1e4b0d278a30f7d2f0c9a63d7b40ca upstream.

The lifetime of object for asynchronous request packet is now maintained
by reference counting, while current implementation of firewire-net
releases the passed object in the handler.

This commit fixes the bug.

Reported-by: Dan Carpenter <error27@gmail.com>
Link: https://lore.kernel.org/lkml/Y%2Fymx6WZIAlrtjLc@workstation/
Fixes: 13a55d6bb15f ("firewire: core: use kref structure to maintain lifetime of data for fw_request structure")
Link: https://lore.kernel.org/lkml/20230510031205.782032-1-o-takashi@sakamocchi.jp/
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firewire/net.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/firewire/net.c b/drivers/firewire/net.c
index af22be84034b..538bd677c254 100644
--- a/drivers/firewire/net.c
+++ b/drivers/firewire/net.c
@@ -706,21 +706,22 @@ static void fwnet_receive_packet(struct fw_card *card, struct fw_request *r,
 	int rcode;
 
 	if (destination == IEEE1394_ALL_NODES) {
-		kfree(r);
-
-		return;
-	}
-
-	if (offset != dev->handler.offset)
+		// Although the response to the broadcast packet is not necessarily required, the
+		// fw_send_response() function should still be called to maintain the reference
+		// counting of the object. In the case, the call of function just releases the
+		// object as a result to decrease the reference counting.
+		rcode = RCODE_COMPLETE;
+	} else if (offset != dev->handler.offset) {
 		rcode = RCODE_ADDRESS_ERROR;
-	else if (tcode != TCODE_WRITE_BLOCK_REQUEST)
+	} else if (tcode != TCODE_WRITE_BLOCK_REQUEST) {
 		rcode = RCODE_TYPE_ERROR;
-	else if (fwnet_incoming_packet(dev, payload, length,
-				       source, generation, false) != 0) {
+	} else if (fwnet_incoming_packet(dev, payload, length,
+					 source, generation, false) != 0) {
 		dev_err(&dev->netdev->dev, "incoming packet failure\n");
 		rcode = RCODE_CONFLICT_ERROR;
-	} else
+	} else {
 		rcode = RCODE_COMPLETE;
+	}
 
 	fw_send_response(card, r, rcode);
 }
-- 
2.40.1



