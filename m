Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 245C1155300;
	Mon,  6 Jan 2025 15:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177553; cv=none; b=FeZsPq/WxcnxPzN8noARgquSxFEv1TC1yR62uVHNxiIU23w/a9Janj0qyyzjwZI8epRxQYBSrko0jWyvYhs2uqtmK7+bx4gMBSocc/P1lUYDt93hN7tTxmxh2mGT322TYrxG25XaWWwsu3lR37gqZtJ8sEBOVZt/Mn+EhW46OlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177553; c=relaxed/simple;
	bh=JS93mSs7LtOPthhP06x149uN/9aTMZpkD8tqMV2StXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JGceFhs7A8YqkEC9Ne2MYjZvpKjJnnUSPMkfUSjVGQK6L7iu2ObUiYFbnSYRqtfGUvWLAAxlfOf/nC6spyQJ5aFgrEytdXGOtNZGsdm7LtmHZda7P0kRzwzdFvrVq/pbvqchW+oYNQ8Ut6T8EPyzjnw4ogAKG8BwQPGPJz+fak8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nk8NvDEE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nk8NvDEE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18C47C4CED2;
	Mon,  6 Jan 2025 15:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177551;
	bh=JS93mSs7LtOPthhP06x149uN/9aTMZpkD8tqMV2StXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nk8NvDEEvo9ss4p3lMX1QzByLrU7Gtq9eaI+Jq2pjjQG+SAeXX6H6545Se9Zn8+PR
	 1dmReXB8bhwxNpUgxvyWXbca1/xr9S5PtCaTXBG52T2V83ZATB/bb1VM6CzfTfjxSs
	 3mbHeiIDOSrAl1nRmTJvWGIQhMkbHirmvJGWpbIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kun Hu <huk23@m.fudan.edu.cn>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 201/222] ALSA: seq: oss: Fix races at processing SysEx messages
Date: Mon,  6 Jan 2025 16:16:45 +0100
Message-ID: <20250106151158.369457894@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


