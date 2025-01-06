Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A526E156C5E;
	Mon,  6 Jan 2025 15:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178051; cv=none; b=Gg2QVoY76Do85WAvuN7ZhWXHwgPgONGYAUstgOXvdG+JJwAJZZTTiL08YUTQTa9/oyjILLWY/ls44o6tbKuDnYcQx61kn0UCwBHOnrhUP3ekoKU27ztM9OeNCl6qOMNQNsPLY4uGVdH+1yahdQ0uALnXNkcdhud+YTv1aAIcPKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178051; c=relaxed/simple;
	bh=H2PDREubuBe+07y60SKblAqrfu7d9MmfDVsU8F/ECk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TUY78QjNsTEGLQcZBvwEaMGKjeAtSpxj4iFQfCklfzhatP7j/HOVCl7Fhn3pGSX2EEedC2QSCe54CDMCVcpAmYbgO4JPLq8vmSH0tjRhn3Q6B6v/LnqVKnh64f6+d4b+rI2mizy3BKOSnHFwx4DQWHeegGr2rT4NbloIp9baSR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y6oeqE2M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y6oeqE2M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 305A1C4CED2;
	Mon,  6 Jan 2025 15:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178051;
	bh=H2PDREubuBe+07y60SKblAqrfu7d9MmfDVsU8F/ECk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y6oeqE2M6a8JfOsKO4NPqwKsCeXalt2HxZOuo5Ux68l46nzQtS8JT1nzFi1ErjN4u
	 8M8Z/Tzpw77ieBiq/uGsFp4aP3UKG1NctPyln3gO3J+X1cqCffhFBgXIn8cGypLFF3
	 Gqcn6egFRR0mnhV8iBq406dkIJPoWh5b5kCTt6Ow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kun Hu <huk23@m.fudan.edu.cn>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 118/156] ALSA: seq: oss: Fix races at processing SysEx messages
Date: Mon,  6 Jan 2025 16:16:44 +0100
Message-ID: <20250106151146.172507223@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
User-Agent: quilt/0.68
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

commit 0179488ca992d79908b8e26b9213f1554fc5bacc upstream.

OSS sequencer handles the SysEx messages split in 6 bytes packets, and
ALSA sequencer OSS layer tries to combine those.  It stores the data
in the internal buffer and this access is racy as of now, which may
lead to the out-of-bounds access.

As a temporary band-aid fix, introduce a mutex for serializing the
process of the SysEx message packets.

Reported-by: Kun Hu <huk23@m.fudan.edu.cn>
Closes: https://lore.kernel.org/2B7E93E4-B13A-4AE4-8E87-306A8EE9BBB7@m.fudan.edu.cn
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20241230110543.32454-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/seq/oss/seq_oss_synth.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/core/seq/oss/seq_oss_synth.c
+++ b/sound/core/seq/oss/seq_oss_synth.c
@@ -66,6 +66,7 @@ static struct seq_oss_synth midi_synth_d
 };
 
 static DEFINE_SPINLOCK(register_lock);
+static DEFINE_MUTEX(sysex_mutex);
 
 /*
  * prototypes
@@ -497,6 +498,7 @@ snd_seq_oss_synth_sysex(struct seq_oss_d
 	if (!info)
 		return -ENXIO;
 
+	guard(mutex)(&sysex_mutex);
 	sysex = info->sysex;
 	if (sysex == NULL) {
 		sysex = kzalloc(sizeof(*sysex), GFP_KERNEL);


