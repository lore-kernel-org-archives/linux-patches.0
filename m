Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 375F53B71DC;
	Sat, 17 Oct 2026 17:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256521; cv=none; b=SeBXpW9p/NhnnMNk3+W64dy0plW0dpVmInAy3toK2WLy2GB0UyP/Zbr5Zf9WY6sLnXJrbPbLKibqGthAaqNvs0h/BE/wjqrYj6qUKGoeBwdsH0HuYKgP0TNFeVYNI1v0IdEY5cyYzupoObiFeOjsjEiRXUNU4Crta1/v5oVzSKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256521; c=relaxed/simple;
	bh=9MtIg9E6tXuQbCVMHYzoAvQ0AHaAGh9Bl4GyVUAzzTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FGaN6MVIJmZC553lhqE5FcCo3mEpZW6mkJeh2woJkw15mlh4Vi/cfKcUPE4dXMVTudNpN2ed2luXJx1V9QWPiqvWbjF0wp6bSKV+d1WnX0AqaYC3K59iVq7QUZJndZZ0J5UmiYHo9l2clJMoiPLv/mqCtxU8jCOFQnmurrptLvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yRboMX+p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yRboMX+p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 692A91F000C4;
	Sat, 17 Oct 2026 17:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256520;
	bh=lHvvBssDjSc1el3LqOdLE6zc99P2UPPaILy1IqsFp8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yRboMX+pLeKygX7qCixYYYsXgjca+hQDSgr95G87nI/2WUvYQerytGDDPGYSgXA6/
	 QWVZ1B8kOjyY/IjD6g1crX6RcRbDipbR2HPnDNmZqarxV1OQa43Xwx2O1XwPmMQmDq
	 nS4ksuGTTZj0GOdoslZYbVGkVm2QcChi1+SLtFYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	syzbot+c35f34092a4bc9855be6@syzkaller.appspotmail.com,
	Edward Adam Davis <eadavis@sina.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 0264/1674] usb: gadget: midi2: Fix the jack descriptor array sizes
Date: Sat, 17 Oct 2026 17:42:16 +0200
Message-ID: <20261017160437.902741830@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


