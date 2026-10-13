Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 101804F93A4;
	Tue, 13 Oct 2026 12:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895041; cv=none; b=jSZLUIdiS4eJrdvxC4TcEuLqG7lpL2D/MT81O8LU4Vlb7h0/tybhgxErHQWdoWnPb9UD38JT7Z2VjtK08L+RGioKFQZQclKAhmYHvhB4+49oVvUTUAWgOLDeR51BjolP3CWzs18hXDX+6LQmyRJS9VgQ3EneQrmmH+YhX471XBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895041; c=relaxed/simple;
	bh=hcKDyi1wAjf/3fuH/NJ7eFJcABTiHSLxK+YrcvjrFn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hgbt+O2Yxkx/PxleKjwTOoXTxCG5rJ7QSbvEVfAn/g5jyOfz0nGlsW03nC4mXJ/1se2GvgO6JrZtbX8m8nsQ59NwH+3tcIUZHiibNgXJ2R14LZVSUZHcmco4VQiLawvjJSq98theGIs1OPXed+82egHVey8vht6MA5+b7XaGXR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p7flnWuZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p7flnWuZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5686D1F000FF;
	Tue, 13 Oct 2026 12:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895040;
	bh=qkEZhw1k7yCRgRzFq0x9kPFeIzYRBZkekrW1CqYvfY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p7flnWuZOOJj2iUMKTCtw8Pj0A2b4bQKdHR7D6jwA7eHs20V/8cZ05x75sb+9BGZN
	 DgSSzOPY0e3Or25lVYG6DrLlF3lFK+4SpBJ3ZFeuuSilfXhxGHiXpcMD7DVOpO2fD0
	 3F3dJCwXdsJ1gfXiIypwkZ+M7yb2NHDevsPcx3zo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	syzbot+c35f34092a4bc9855be6@syzkaller.appspotmail.com,
	Edward Adam Davis <eadavis@sina.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 142/497] usb: gadget: midi2: Fix the jack descriptor array sizes
Date: Tue, 13 Oct 2026 13:35:09 +0200
Message-ID: <20261013112911.258782253@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 310c2d4608d8c1a2baa57db1dfd319c5c40cf4a1 upstream.

The jack in/out descriptor arrays in struct f_midi2_usb_config have
the size of MAX_CABLES, which look reasonable -- but it turned out to
be incorrect.  Namely, the entries for those arrays are added from
both inputs and outputs, hence for each loop cycle, it adds two, ended
up with as twice as the expected size.  This inconsistency may result
in potential OOB when a large number of jacks are set up via configfs,
although the max number of cables (the loop count) is limited to
MAX_CABLES.

For addressing it, correct the jack_ins & jack_outs array sizes to
twice, MAX_CABLES * 2.

Fixes: 856fa444b098 ("usb: gadget: midi2: Dynamically create MIDI 1.0 altset descriptors")
Cc: stable <stable@kernel.org>
Reported-by: syzbot+c35f34092a4bc9855be6@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c35f34092a4bc9855be6
Link: https://lore.kernel.org/20260826134606.127250-1-eadavis@sina.com
Cc: Edward Adam Davis <eadavis@sina.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260901145512.785142-1-tiwai@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_midi2.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/gadget/function/f_midi2.c
+++ b/drivers/usb/gadget/function/f_midi2.c
@@ -1636,8 +1636,8 @@ struct f_midi2_usb_config {
 
 	/* MIDI 1.0 jacks */
 	unsigned char jack_in, jack_out, jack_id;
-	struct usb_midi_in_jack_descriptor jack_ins[MAX_CABLES];
-	struct usb_midi_out_jack_descriptor_1 jack_outs[MAX_CABLES];
+	struct usb_midi_in_jack_descriptor jack_ins[MAX_CABLES * 2];
+	struct usb_midi_out_jack_descriptor_1 jack_outs[MAX_CABLES * 2];
 };
 
 static int append_config(struct f_midi2_usb_config *config, void *d)


