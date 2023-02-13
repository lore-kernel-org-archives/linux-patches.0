Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E542B8F57
	for <patches@lists.linux.dev>; Mon, 13 Feb 2023 14:52:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A7F4C433D2;
	Mon, 13 Feb 2023 14:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676299973;
	bh=p3H2E9thase8LieM17RkzBYGSiH14zxP2urYCbe1wxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rZciIyliUUyPfqWSc+mFpEd50+GUjfBluAxroY5ybjtI+6Fh7sJlh5swp0UjJcqIZ
	 +lwAIA6p7DaWzT0tOj2590/qMZZc+Ir8c2o4ZefYvyfGQh7j94ZhZqxsNb5nf2Uies
	 BYEMYm9S0t4pDnC5FUGyywCIFdL1tZMp7BMQ6SC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bastien Nocera <hadess@hadess.net>,
	Tobias Klausmann <klausman@schwarzvogel.de>,
	Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH 6.1 015/114] HID: logitech: Disable hi-res scrolling on USB
Date: Mon, 13 Feb 2023 15:47:30 +0100
Message-Id: <20230213144742.977473257@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
References: <20230213144742.219399167@linuxfoundation.org>
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

commit 690eb7dec72ae52d1d710d14a451844b4d0f4f19 upstream.

On some Logitech mice, such as the G903, and possibly the G403, the HID
events are generated on a different interface to the HID++ one.

If we enable hi-res through the HID++ interface, the HID interface
wouldn't know anything about it, and handle the events as if they were
regular scroll events, making the mouse unusable.

Disable hi-res scrolling on those devices until we implement scroll
events through HID++.

Signed-off-by: Bastien Nocera <hadess@hadess.net>
Tested-by: Tobias Klausmann <klausman@schwarzvogel.de>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216885
Fixes: 908d325e1665 ("HID: logitech-hidpp: Detect hi-res scrolling support")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230203101800.139380-1-hadess@hadess.net
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-logitech-hidpp.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -3978,7 +3978,8 @@ static void hidpp_connect_event(struct h
 	}
 
 	hidpp_initialize_battery(hidpp);
-	hidpp_initialize_hires_scroll(hidpp);
+	if (!hid_is_usb(hidpp->hid_dev))
+		hidpp_initialize_hires_scroll(hidpp);
 
 	/* forward current battery state */
 	if (hidpp->capabilities & HIDPP_CAPABILITY_HIDPP10_BATTERY) {


