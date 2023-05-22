Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84267171A1
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:15:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 149F2C4339C;
	Mon, 22 May 2023 19:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684782936;
	bh=IuTtyFBu4N55U8E9MNmWvWMJoJz2+mgCR8GNGvGzuak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TmkggWvti0y+LeBWhtDbJRyxYDGmukd0/1s/H4jzzkf722DsvaYKVjXIHEXu5n1Jt
	 mY4+KSyDue/lC7hZeEoc+0lpMFB5Tf15CCgRsX2EjAzuD+s8jGdrD4XSgn6JbbHtdj
	 JMd4Yds3daa40SMKN4AIZaU3EsRD8hF1/G6mja74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bastien Nocera <hadess@hadess.net>,
	Benjamin Tissoires <benjamin.tissoires@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 080/203] HID: logitech-hidpp: Reconcile USB and Unifying serials
Date: Mon, 22 May 2023 20:08:24 +0100
Message-Id: <20230522190357.206594559@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190354.935300867@linuxfoundation.org>
References: <20230522190354.935300867@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bastien Nocera <hadess@hadess.net>

[ Upstream commit 5b3691d15e04b6d5a32c915577b8dbc5cfb56382 ]

Now that USB HID++ devices can gather a serial number that matches the
one that would be gathered when connected through a Unifying receiver,
remove the last difference by dropping the product ID as devices
usually have different product IDs when connected through USB or
Unifying.

For example, on the serials on a G903 wired/wireless mouse:
- Unifying before patch: 4067-e8-ce-cd-45
- USB before patch: c086-e8-ce-cd-45
- Unifying and USB after patch: e8-ce-cd-45

Signed-off-by: Bastien Nocera <hadess@hadess.net>
Link: https://lore.kernel.org/r/20230302130117.3975-2-hadess@hadess.net
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-logitech-hidpp.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
index 5eb25812e9479..baa68ae9b9efc 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -834,8 +834,7 @@ static int hidpp_unifying_init(struct hidpp_device *hidpp)
 	if (ret)
 		return ret;
 
-	snprintf(hdev->uniq, sizeof(hdev->uniq), "%04x-%4phD",
-		 hdev->product, &serial);
+	snprintf(hdev->uniq, sizeof(hdev->uniq), "%4phD", &serial);
 	dbg_hid("HID++ Unifying: Got serial: %s\n", hdev->uniq);
 
 	name = hidpp_unifying_get_name(hidpp);
@@ -970,8 +969,7 @@ static int hidpp_serial_init(struct hidpp_device *hidpp)
 	if (ret)
 		return ret;
 
-	snprintf(hdev->uniq, sizeof(hdev->uniq), "%04x-%4phD",
-		 hdev->product, &serial);
+	snprintf(hdev->uniq, sizeof(hdev->uniq), "%4phD", &serial);
 	dbg_hid("HID++ DeviceInformation: Got serial: %s\n", hdev->uniq);
 
 	return 0;
-- 
2.39.2



