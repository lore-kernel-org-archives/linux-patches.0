Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DEBB2F3632;
	Fri, 21 Nov 2025 13:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731497; cv=none; b=hYxsZZ3zOkdY679SjPXdSYHpqGQjx+NDNX5Qz15+Zor4bFlB8crBOQh6QcYQbW4v0Bksmj2cJbY0D/jRzSmNCztxtZVQMPzAX7QSdU0PAdXBSx7PqmoQdc79rsWisTM3Ro6o51NWhco4qbCET4fTxUNv0s0SvmnjRL3yKK+VkR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731497; c=relaxed/simple;
	bh=C3T6DwGyt6yTbiLtP52POH4N7ff3CYog7A3Gy2z+egU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qf0qbi9FfIUaxrdiMeOAxWlfb/GOB6cFl09kHCdF0zPsOoAEx5RxcdCLGeEbog/A4Xvm59vdWV4PKHtUdusxWB8CxKVM+zBbZROJVsC51ePvcK88X1ZnZEWpkkLUKhL/rookRBEIrnA0hhCBq94ZGwHFrjm1C6Pn4i7AAlnVakU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pARI3j6r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pARI3j6r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBBC3C4CEF1;
	Fri, 21 Nov 2025 13:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731497;
	bh=C3T6DwGyt6yTbiLtP52POH4N7ff3CYog7A3Gy2z+egU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pARI3j6rSDpRi+fEQ3S6Uq6tJ1aq8PEB8ZrAOFRUsgmRZM9Qx/ndNPymWLUKSsw1G
	 tdL3S1CFACYynu0KAEXL2BwKUxWi1S0uNL1uGdhT6tI+F6W2v4bptsNSj65uMi5YaR
	 Y9+NRecY/7m2qzs5eAaW1XH7BfTBg5BZokgMDfuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+bfd77469c8966de076f7@syzkaller.appspotmail.com,
	Lizhi Xu <lizhi.xu@windriver.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.17 194/247] ALSA: usb-audio: Fix potential overflow of PCM transfer buffer
Date: Fri, 21 Nov 2025 14:12:21 +0100
Message-ID: <20251121130201.686829291@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 05a1fc5efdd8560f34a3af39c9cf1e1526cc3ddf upstream.

The PCM stream data in USB-audio driver is transferred over USB URB
packet buffers, and each packet size is determined dynamically.  The
packet sizes are limited by some factors such as wMaxPacketSize USB
descriptor.  OTOH, in the current code, the actually used packet sizes
are determined only by the rate and the PPS, which may be bigger than
the size limit above.  This results in a buffer overflow, as reported
by syzbot.

Basically when the limit is smaller than the calculated packet size,
it implies that something is wrong, most likely a weird USB
descriptor.  So the best option would be just to return an error at
the parameter setup time before doing any further operations.

This patch introduces such a sanity check, and returns -EINVAL when
the packet size is greater than maxpacksize.  The comparison with
ep->packsize[1] alone should suffice since it's always equal or
greater than ep->packsize[0].

Reported-by: syzbot+bfd77469c8966de076f7@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=bfd77469c8966de076f7
Link: https://lore.kernel.org/690b6b46.050a0220.3d0d33.0054.GAE@google.com
Cc: Lizhi Xu <lizhi.xu@windriver.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20251109091211.12739-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/endpoint.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -1386,6 +1386,11 @@ int snd_usb_endpoint_set_params(struct s
 	ep->sample_rem = ep->cur_rate % ep->pps;
 	ep->packsize[0] = ep->cur_rate / ep->pps;
 	ep->packsize[1] = (ep->cur_rate + (ep->pps - 1)) / ep->pps;
+	if (ep->packsize[1] > ep->maxpacksize) {
+		usb_audio_dbg(chip, "Too small maxpacksize %u for rate %u / pps %u\n",
+			      ep->maxpacksize, ep->cur_rate, ep->pps);
+		return -EINVAL;
+	}
 
 	/* calculate the frequency in 16.16 format */
 	ep->freqm = ep->freqn;


