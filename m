Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A69EE3F788A;
	Sat, 12 Sep 2026 11:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213251; cv=none; b=D4KBWnsXKfPGCU2TfmwfD2DZnJDPjvkzJlqxKxQbjqUElLdfONGOC0A5ec+XLICM5hwG/BMw4IFwe889x5UVmeeuF6UJC9R44efEyO0FQGXIsJrKlnPyFT9E1xzUG+dejKQ/fZwvWR/lJ3oforZcqsJfR7KlbWpASTYynVhviyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213251; c=relaxed/simple;
	bh=T8De91tI/WpKB8hiqgvLUTyULziaWHMIBR6k9KAMjns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KF+iOJcBapNTOJKSeoHUHKqNxFUW612WeT4eXjocwF3qh2WgP6X7aVDLM9hrcDxz+ox23wgk0x6viN42Emzxx+dikjiIKIEDzTmZJvlCk7BsGfnHd8vzubP5xSJPXv5nukZE4A26nWETJ2jv/OBbWBMrFJVxbDpf7WXP/SYyZJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LB5Rre8b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LB5Rre8b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79E011F000FF;
	Sat, 12 Sep 2026 11:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213250;
	bh=CzuxmKcjAd3ynQa27/kTZ9HDBC7LpmjCY557bjIAZY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LB5Rre8bu41nfmqEzpsP+sHPzv4MQQ0o+6fNv558C9L0ZfQ2DvF7uOb+wDJ0Kr6as
	 CZFRb1qJ/MKCVwUmMSwR3A2/E2IQL+twclVeC/0uxjHY32OXG9RQ15eypttfk4w7OZ
	 aQK8P2XV/EU6NIDOG5lRzzJzHFXO3d0OnqO6/MEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 0082/1376] ALSA: rawmidi: Return the error from snd_rawmidi_input_params()
Date: Sat, 12 Sep 2026 08:41:48 +0200
Message-ID: <20260912065609.387905061@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: HyeongJun An <sammiee5311@gmail.com>

commit f4a23e17d84fd2a152d9e12369761934e1af0ee8 upstream.

The snd_rawmidi_input_params() computes err for the three invalid mode
combinations and for resize_runtime_buffer(), applies the new framing
and clock type only when err is zero, and then returns 0 anyway.  A
caller that asked for parameters the kernel rejected is told the change
succeeded, and the substream keeps its old buffer.

The open_mutex conversion turned the early returns into assignments.
It handled the output sibling correctly, which still returns err, and
left this one behind.

Fixes: 94b98194b62e ("ALSA: rawmidi: Take open_mutex around parameter changes")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Link: https://patch.msgid.link/20260902125058.19499-1-sammiee5311@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/rawmidi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/core/rawmidi.c
+++ b/sound/core/rawmidi.c
@@ -779,7 +779,7 @@ int snd_rawmidi_input_params(struct snd_
 		substream->framing = framing;
 		substream->clock_type = clock_type;
 	}
-	return 0;
+	return err;
 }
 EXPORT_SYMBOL(snd_rawmidi_input_params);
 


