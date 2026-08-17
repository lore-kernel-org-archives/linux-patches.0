Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF40B3F3265;
	Mon, 17 Aug 2026 13:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975161; cv=none; b=KSye9Gjv59MTyDOLTD6cEP1Yv6kk5yFHijyj6sAaieFFg4+8bTEjY9uGTTlz/Tkh3xjc/BW1XIidwBGUpohk/hugYTgYDTF62oMBrI3RUL4j7LVz3SBxQhx+pPUCPOWfofRY2HGPJRfC6LVtA8F/+wzlb4FxZ23o5VfSEC2OxSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975161; c=relaxed/simple;
	bh=9w+vvly4ZOWlQYZP+6FJMe0IkhqacOs4y5CDMfq34aU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BVNRLR1VpdZ+DVS2WR//lQcAWqDmKnTN3OYFedhyPSF4W/Ceo1Mk9Hia4+i3836W6XRg5vozmPFh3ebf+CFvF1hY6SsN+7Qe9+QHDzVI0mf1JF7SpXazb0VAmQt6sCn8VaBZXBi8TJGs2xTmsbKw0KemKBVcwjQbjt17tIRCRM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bbjm9po3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bbjm9po3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F4841F000E9;
	Mon, 17 Aug 2026 13:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975159;
	bh=rqfQksABQoXKy2eCJKQfGScOmT5UeoOZS0A/M8LyQdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bbjm9po3stKrdU/eYkQINp6S5tD0dl0fwSE4x3f1gnE3/HjdZNUQ64BWEH7AERhMY
	 FvwC3fSrf9AdHjOhmmQ77jKTWAHQipBDWhsj8wFlvXByaQe2GWavK75oQM4uzI8MWp
	 aI1++JjP2/VOkN5DFjHEQ5Qh86YMouYK9X9s0kq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+565b1138cfbe549d4422@syzkaller.appspotmail.com,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 183/250] ALSA: usb: Fix UAF at delayed release of MIDI2 EPs
Date: Mon, 17 Aug 2026 15:32:24 +0200
Message-ID: <20260817132544.063190746@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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
@@ -677,6 +677,14 @@ static int parse_midi_2_0_endpoints(stru
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
@@ -727,6 +735,7 @@ static int create_midi2_ump(struct snd_u
 
 	ump->private_data = rmidi;
 	ump->ops = &snd_usb_midi_v2_ump_ops;
+	ump->private_free = free_ump_private_data;
 
 	rmidi->eps[STR_IN] = ep_in;
 	rmidi->eps[STR_OUT] = ep_out;


