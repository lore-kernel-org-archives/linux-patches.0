Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAA69143894;
	Sun,  1 Sep 2024 16:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207888; cv=none; b=QEu02Or4RRaoUMkgJZqTIM6l6ZMm60rPfhMJpHzEeJ1k3Dd1DhT3xFts7OzNynZKaWv8vyxtzW97NPgW+7bJI4vo4cNKYxFYjqj4EaOwMmuwUbDiMqTTiBRjdoUqssbnn333u3Ib+QQDmMOHtIatAxSdPpvdIWBnpOpcPWjU/k0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207888; c=relaxed/simple;
	bh=j+FpvGCOC1cAf0JVElFFhNDXR0HNYnFUMiZFQcf6VrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q6bVEyXPGDkVX7ZLHpiDqy7HvtJblJXEIHXlldDnxygXJPueqljQg7aFfb3oxyhrLBQTXt2grfhhgzSxLUnH+Lby8fC4o1Ug5ur5aSatqO/aeKRzCfIZOxq6uqQLhpQjZf/GIkUxwRottjhpk2WKs8dY8OAl7N5OjwUPd4M5bs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AkWBXcGW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AkWBXcGW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 248ACC4CEC3;
	Sun,  1 Sep 2024 16:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207888;
	bh=j+FpvGCOC1cAf0JVElFFhNDXR0HNYnFUMiZFQcf6VrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AkWBXcGWQHMLGtcRR16ss7AffuVO4S+0XJJvRepL2/ZMtNM3famEk2s+iRduS8PXW
	 OFqCXz50OHMwudMNrHlr9yLdYNm1quSzbBpO7L28lv1xAo6r9P8wEHKUn2yMjSq9mI
	 DC9QnHSwvUotRLK2KRJMhuArM6ncZNXxC+vsLgL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 01/93] ALSA: seq: Skip event type filtering for UMP events
Date: Sun,  1 Sep 2024 18:15:48 +0200
Message-ID: <20240901160807.405460507@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160807.346406833@linuxfoundation.org>
References: <20240901160807.346406833@linuxfoundation.org>
User-Agent: quilt/0.67
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

commit 32108c22ac619c32dd6db594319e259b63bfb387 upstream.

UMP events don't use the event type field, hence it's invalid to apply
the filter, which may drop the events unexpectedly.
Skip the event filtering for UMP events, instead.

Fixes: 46397622a3fa ("ALSA: seq: Add UMP support")
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20240819084156.10286-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/seq/seq_clientmgr.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/sound/core/seq/seq_clientmgr.c
+++ b/sound/core/seq/seq_clientmgr.c
@@ -537,6 +537,9 @@ static struct snd_seq_client *get_event_
 		return NULL;
 	if (! dest->accept_input)
 		goto __not_avail;
+	if (snd_seq_ev_is_ump(event))
+		return dest; /* ok - no filter checks */
+
 	if ((dest->filter & SNDRV_SEQ_FILTER_USE_EVENT) &&
 	    ! test_bit(event->type, dest->event_filter))
 		goto __not_avail;


