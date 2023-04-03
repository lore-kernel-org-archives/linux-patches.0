Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7430E6FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:48:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEC94C4339E;
	Mon,  3 Apr 2023 14:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680533284;
	bh=a7axbQYD8z8Xc7gCC1YfckJxcJAG4ev05FD4JTZNsjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OtoSPjZjgGt43yEtJWwlBt+1KXE75vhrAvvI/O3KNgvmCcS7ftoJQtQs+cyGrw6da
	 MTm/0DgZDKU99ygh6qpkPR3Wb+baHOb8qiTl1TGAiSnY/sgF9QMBIGEDJxVZ69j/oD
	 43ui2asat8wobz7K9IH4hUBvcQFHIBzdnFf9hQms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Benkmann <matthias.benkmann@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 125/187] Input: xpad - fix incorrectly applied patch for MAP_PROFILE_BUTTON
Date: Mon,  3 Apr 2023 16:09:30 +0200
Message-Id: <20230403140420.077047248@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Matthias Benkmann <matthias.benkmann@gmail.com>

[ Upstream commit ffa6206ebf8d39e83d87ac226df68dbbe155819a ]

When commit commit fff1011a26d6 ("Input: xpad - add X-Box Adaptive Profile
button") was applied, one hunk ended up in the wrong function; move it to
where it belongs.

Fixes: fff1011a26d6 ("Input: xpad - add X-Box Adaptive Profile button")
Signed-off-by: Matthias Benkmann <matthias.benkmann@gmail.com>
Link: https://lore.kernel.org/r/20230318162106.0aef4ba5@ninja
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/joystick/xpad.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
index 2959d80f7fdb6..cd36cf7165423 100644
--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -779,9 +779,6 @@ static void xpad_process_packet(struct usb_xpad *xpad, u16 cmd, unsigned char *d
 	input_report_key(dev, BTN_C, data[8]);
 	input_report_key(dev, BTN_Z, data[9]);
 
-	/* Profile button has a value of 0-3, so it is reported as an axis */
-	if (xpad->mapping & MAP_PROFILE_BUTTON)
-		input_report_abs(dev, ABS_PROFILE, data[34]);
 
 	input_sync(dev);
 }
@@ -1059,6 +1056,10 @@ static void xpadone_process_packet(struct usb_xpad *xpad, u16 cmd, unsigned char
 					(__u16) le16_to_cpup((__le16 *)(data + 8)));
 		}
 
+		/* Profile button has a value of 0-3, so it is reported as an axis */
+		if (xpad->mapping & MAP_PROFILE_BUTTON)
+			input_report_abs(dev, ABS_PROFILE, data[34]);
+
 		/* paddle handling */
 		/* based on SDL's SDL_hidapi_xboxone.c */
 		if (xpad->mapping & MAP_PADDLES) {
-- 
2.39.2



