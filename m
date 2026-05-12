Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D4CC3EDE5D;
	Tue, 12 May 2026 18:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609026; cv=none; b=fsLIyCTSnHhqO/S+vbm5A/hKDmeUvdP188gewfaJL8ZePZJRTW9MRgpnC+Z3mJMym2bRf58mE/5dHyoXVZJPB/6Mn07HDc1J7SQMJ38nBq5UHvAFTIuuJJimxqsJzGQ1fL7wt1lIiL1Sy3LaOnsmSzXBUHoaYkTmDN1BiG615sM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609026; c=relaxed/simple;
	bh=YWpY0cazMgHjsjAZrTBPdEBCoUWoUWNK4SjYFHhoDws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FxUQ1uqEurjcwcjrrAX84lVuCv3dZCf/0S9chQg6ayaeG6zZ8kskgdMQnpIOYT3k+O2DI2vsTwEFCJvwNjPuORJpso5NRJYretNRkAsrDgojy/tvWB/yuDzFo5WFS9DhsFcamftHxG1Ygkmj9oZCjdpvIie5ya9FKT1uzYESzbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p4EF8RN9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p4EF8RN9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E475C2BCB0;
	Tue, 12 May 2026 18:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609025;
	bh=YWpY0cazMgHjsjAZrTBPdEBCoUWoUWNK4SjYFHhoDws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p4EF8RN9Z6ftk+1+RcVvWQccnlkAEVpHZn83DTwfk0quWATudOrNMHqVDd05D0eCp
	 gkwM8wSnAki+AXfmjC8awQMzTHigI1KmLc11i0Soeex+QziKHWkg8Y7fYiQJXo43XY
	 hGxt8sR7TjzYbXdAzVJoAkTh+6DRnS9SjYZ4/QHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.0 037/307] ALSA: usb-audio: Avoid potential endless loop in convert_chmap_v3()
Date: Tue, 12 May 2026 19:37:12 +0200
Message-ID: <20260512173940.908650817@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 6e7247d8f5fefeceb0bb9cc80a5388a636b219cd upstream.

The convert_chmap_v3() has a loop with its increment size of
cs_desc->wLength, but we forgot to validate cs_desc->wLength itself,
which may lead to potential endless loop by a malformed descriptor.

Add a proper size check to abort the loop for plugging the hole.

Fixes: ecfd41166b72 ("ALSA: usb-audio: Validate UAC3 cluster segment descriptors")
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20260427152224.15276-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/stream.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/usb/stream.c
+++ b/sound/usb/stream.c
@@ -352,6 +352,8 @@ snd_pcm_chmap_elem *convert_chmap_v3(str
 		if (len < sizeof(*cs_desc))
 			break;
 		cs_len = le16_to_cpu(cs_desc->wLength);
+		if (cs_len < sizeof(*cs_desc))
+			break;
 		if (len < cs_len)
 			break;
 		cs_type = cs_desc->bSegmentType;


