Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D95C12B94;
	Tue, 17 Mar 2026 16:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765896; cv=none; b=u+KIq5ITzIlfkub9SPZNwHqZkng43nx+Abt3E6f2PMz164P/02ngblDa5J/jtYwUn4Rq/ezedpI8rm8idRaSieDubo2d4M8VjJzGVyfU8IwKWflknbZ4r9hfX3Rqb7jNh6Regox6I544ut93262uY5wCVLSVf1OMS0/dcFDTypI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765896; c=relaxed/simple;
	bh=uORlzAev+/MMJtt84Bf3aA0n7Or4oCswgWdDZUksQys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WjtoAEVoO1yz/fOeA6airZC4PLNU2cF3aC+SXAVuCwoKlH/ZN0cQLQBWe+KDnOXVJ+r7ViTTAdUXmGpQt7YMyIua9+E6sCB4odDbHApLqLdntWIJoW07gKk1p/PfbTHb7/i+O5rdGzvuW7WKEUMs/yuYse2e/p5gyFjf0OEmpLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LrlDvyn3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LrlDvyn3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65DEEC4CEF7;
	Tue, 17 Mar 2026 16:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765895;
	bh=uORlzAev+/MMJtt84Bf3aA0n7Or4oCswgWdDZUksQys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LrlDvyn34pLrtbSqo/kze3BA5x8S9ZVTKcc28WCg8WQ3KgDH6N/FTJZtB8y3hlO5U
	 RcW/xBOrq73RU0poX3zVA9gIYLSZNkMwSLWFucmWdUb58Da4QutDKoAskPTmhwPYD8
	 Bi0NSVBfpjrwhLV//7Gz+PquB7bkc/dttLCNFaKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+8f29539ef9a1c8334f42@syzkaller.appspotmail.com,
	syzbot+ae893a8901067fde2741@syzkaller.appspotmail.com,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.19 119/378] ALSA: usb-audio: Check endpoint numbers at parsing Scarlett2 mixer interfaces
Date: Tue, 17 Mar 2026 17:31:16 +0100
Message-ID: <20260317163011.397274581@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit df1d8abf36ca3681c21a6809eaa9a1e01ef897a6 upstream.

The Scarlett2 mixer quirk in USB-audio driver may hit a NULL
dereference when a malformed USB descriptor is passed, since it
assumes the presence of an endpoint in the parsed interface in
scarlett2_find_fc_interface(), as reported by fuzzer.

For avoiding the NULL dereference, just add the sanity check of
bNumEndpoints and skip the invalid interface.

Reported-by: syzbot+8f29539ef9a1c8334f42@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/69acbbe1.050a0220.310d8.0001.GAE@google.com
Reported-by: syzbot+ae893a8901067fde2741@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/69acf72a.050a0220.310d8.0004.GAE@google.com
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20260309104632.141895-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/mixer_scarlett2.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/usb/mixer_scarlett2.c
+++ b/sound/usb/mixer_scarlett2.c
@@ -8251,6 +8251,8 @@ static int scarlett2_find_fc_interface(s
 
 		if (desc->bInterfaceClass != 255)
 			continue;
+		if (desc->bNumEndpoints < 1)
+			continue;
 
 		epd = get_endpoint(intf->altsetting, 0);
 		private->bInterfaceNumber = desc->bInterfaceNumber;


