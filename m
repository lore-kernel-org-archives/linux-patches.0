Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5767C42EEDD;
	Mon, 17 Aug 2026 14:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978666; cv=none; b=ofGr5Oxp5R8J5vtSO8G8CmSxHqHpNeUovLEKd4oKNE/eEd707tfacye3MSl6n2n/JziHwk2uFEoEV8lAi+LeBNmEZhQWg2sW4jNCQtrJXjrSbFk6LvZQfnNSOQdLr6lqk82l/23Zd2d2YG2Hy/JehUakkJG3BIZCO5SH+Ceg/SQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978666; c=relaxed/simple;
	bh=EQfQqqJteCZ/J6kdzn8Bhfz/43BJkcGCJOgfcC0OT6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ANbsvRqzmoLq0iQ4MWVrp5uhyUN4OeGB8Dby+mWS0NMYkx1bPoTo1HRRvr/Zxd5VAw4Oknc8qmZDcKx7QJnuKUsscixDAGXiTQHaVuNfRqVHqNKq5eOL9INAj9RxDbtxh74e66vuz2Mds84T1H+3SVOXBxOY8a12Cj2HfjnznLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mZgOwlcV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mZgOwlcV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF3551F000E9;
	Mon, 17 Aug 2026 14:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978665;
	bh=Upakjp+85oAsiY897aPBc2ixrOrJBqtT0bVTzIZAWzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mZgOwlcVEOeVXOJZNUQreQ9Y2D9IcKao5Y3F+nmbiOAJkkqpVhBPmxNC/zy6MZTwe
	 4X+3pI+6mSIXpgou4tQV/Kkfieo0K3+ZQo+w19gkt0Kkt2r6ze0M1z1k19nbko4/ED
	 k1Ny63IQsSh/lx9+0vHGO0J8ofYQBe/42c/8FNF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+565b1138cfbe549d4422@syzkaller.appspotmail.com,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 114/156] ALSA: usb: Fix UAF at delayed release of MIDI2 EPs
Date: Mon, 17 Aug 2026 15:34:08 +0200
Message-ID: <20260817132539.091426803@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132534.666299318@linuxfoundation.org>
References: <20260817132534.666299318@linuxfoundation.org>
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

commit f8a80cfb68613fb7e6452b66447dbc63f435d140 upstream.

The recent fix for UAF in ump_to_endpoint() caused another UAF because
it tries to dereference the UMP endpoint object, but this might be
executed at a delayed context where the endpoint has been already
released.

Add private_free to clear the associated data for avoiding the further
dereference for delayed releases.

Fixes: 4a05b2d1b464 ("ALSA: usb-audio: fix use-after-free in ump_to_endpoint()")
Reported-by: syzbot+565b1138cfbe549d4422@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=565b1138cfbe549d4422
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20260808152009.1947835-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/midi2.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/sound/usb/midi2.c
+++ b/sound/usb/midi2.c
@@ -695,6 +695,14 @@ static int parse_midi_2_0_endpoints(stru
 	return 0;
 }
 
+static void free_ump_private_data(struct snd_ump_endpoint *ump)
+{
+	struct snd_usb_midi2_ump *rmidi = ump->private_data;
+
+	if (rmidi)
+		rmidi->ump = NULL;
+}
+
 static void free_all_midi2_umps(struct snd_usb_midi2_interface *umidi)
 {
 	struct snd_usb_midi2_ump *rmidi;
@@ -745,6 +753,7 @@ static int create_midi2_ump(struct snd_u
 
 	ump->private_data = rmidi;
 	ump->ops = &snd_usb_midi_v2_ump_ops;
+	ump->private_free = free_ump_private_data;
 
 	rmidi->eps[STR_IN] = ep_in;
 	rmidi->eps[STR_OUT] = ep_out;


