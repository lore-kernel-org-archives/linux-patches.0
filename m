Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E9792BE7CD;
	Fri,  9 Oct 2026 14:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556077; cv=none; b=fX6faePeJABkIZq5kV2ahDAilA76CwZmDbto5Biqu8dkr5sNYaz9U2bQoQMYPIhsTO3TbOEuq3NtuMlxxWWtpcbJuOy1aKkihwsA0nQgg/ORdGtsMeTcg19H09k+C2AYyU0ErKyP06eE/pl12peYEPT7PYFJj53/hyK847bViFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556077; c=relaxed/simple;
	bh=Zug2IdbzYwRFGTmtSKCnGrh45mjEgO+ssxwXc5hDVLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MfXVY+4BDzFnfDwkBwCHMiz9cev984CQZ4Tg4rihg638HdlwYsQj+FKis30ina/eXEJ/HV4jq9gFBzV/sbFzzh6CNpPvj19ttSyGUXFEt9HIJWBTG1ZRv2IOEiLAhwQQv24RZhWKfEjrRPn5F6eBB3jqeGmb/KgSY6EkXEm4ri4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oNo08sqr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oNo08sqr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86FC31F000FF;
	Fri,  9 Oct 2026 14:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556076;
	bh=NM6OCZWEu+g/WZVIfygZGRbcVmM6Z5TU4NZ9Rb+C7Sc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oNo08sqrVnHpU0JaaNMhmOBE+2l5PmZaPnvIn2G0u9TxF8DVKq8Kh6ZDljJZj13Do
	 2QG5MWwufxQRUJOrfgOlop6xJkYfLUg08aw+6YI0UEWmpZll7CNvvWVp1cuVJfbHQU
	 UOoOYTYRvc9MVS02vATXEWbi6VdplX1xMmZFPDBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	syzbot+c35f34092a4bc9855be6@syzkaller.appspotmail.com,
	Edward Adam Davis <eadavis@sina.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 170/403] usb: gadget: midi2: Fix the jack descriptor array sizes
Date: Fri,  9 Oct 2026 16:08:51 +0200
Message-ID: <20261009140956.083757860@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1634,8 +1634,8 @@ struct f_midi2_usb_config {
 
 	/* MIDI 1.0 jacks */
 	unsigned char jack_in, jack_out, jack_id;
-	struct usb_midi_in_jack_descriptor jack_ins[MAX_CABLES];
-	struct usb_midi_out_jack_descriptor_1 jack_outs[MAX_CABLES];
+	struct usb_midi_in_jack_descriptor jack_ins[MAX_CABLES * 2];
+	struct usb_midi_out_jack_descriptor_1 jack_outs[MAX_CABLES * 2];
 };
 
 static int append_config(struct f_midi2_usb_config *config, void *d)


