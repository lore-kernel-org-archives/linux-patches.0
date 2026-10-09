Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3BF445C713;
	Fri,  9 Oct 2026 14:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556652; cv=none; b=LasA8gCpNYFgXUmAAl1IoMPDYgHXyJ2vR9IwTP9tpNeUsTq9NKcGkIrHCRvewYCLPSf3s3UHhapY3qbjCWyj++j2sWozJKrv7ik778nOa5xAkBWVbM0p34Sx5dMbEoksVOVl1wrEobe69Mz+j7GOmsU2nRX07TPpmPa5sZxlAWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556652; c=relaxed/simple;
	bh=21ohszfQX1+Rkf0IFWdIWMFtehO5ybx69qIQLASl1vU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dp5CXdSrnv4YiapCVsvB0ToZMHjjeSjuRb31prB9NTddJm6a4P55T1dZeU1UTs5Jl9soaX9KU0EMr0i4RxWHkeLjHbtINlUvNwBVr8M1UdSAJ7ORRzoG1FzUkzJOr4nSqU8ee0C3Eq5srfjSB3+FVgG85rd7vcZtTdFtxnfhYig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V6TOEto8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V6TOEto8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11C961F000FF;
	Fri,  9 Oct 2026 14:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556650;
	bh=PN0UVl5i5f01GYAWKg3Ul1TqLigltLS8Abx/FMsW5s0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V6TOEto8GyKDvdMjwSwcoB4NeZbk6LAzgZ51uCc3TeC1j0AqHjKkIkHc1KeczXjXO
	 2QTWGWeW3/0S98Dr+DyCGGdtI4b+lYco0WHsWehJ6Qyd0lplVKpFShoS7I8r0Uw9Xy
	 W9kEE8Si5GqBwiVtQ/LeEkLhB90o0Ffa5m5bhZLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	syzbot+c35f34092a4bc9855be6@syzkaller.appspotmail.com,
	Edward Adam Davis <eadavis@sina.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.2 215/428] usb: gadget: midi2: Fix the jack descriptor array sizes
Date: Fri,  9 Oct 2026 16:09:12 +0200
Message-ID: <20261009140950.847906491@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1633,8 +1633,8 @@ struct f_midi2_usb_config {
 
 	/* MIDI 1.0 jacks */
 	unsigned char jack_in, jack_out, jack_id;
-	struct usb_midi_in_jack_descriptor jack_ins[MAX_CABLES];
-	struct usb_midi_out_jack_descriptor_1 jack_outs[MAX_CABLES];
+	struct usb_midi_in_jack_descriptor jack_ins[MAX_CABLES * 2];
+	struct usb_midi_out_jack_descriptor_1 jack_outs[MAX_CABLES * 2];
 };
 
 static int append_config(struct f_midi2_usb_config *config, void *d)


