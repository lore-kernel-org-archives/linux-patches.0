Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5326049652;
	Mon,  6 Jan 2025 15:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736176905; cv=none; b=eYIzM15IEruY89eFPPf6C+L3VT8bojvgX1JBUwAE2wkdPEgEweLXvDAkzsrCVPLp//ei84cNWgloHgohXxUJSrBSXTDfWnp+jTnh5ZMrLDf8++gV/dl0LklLame7U1Fp18p7NUAVsRtV2FTAgP4X1zu356WuMqHkMVG55XFlH1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736176905; c=relaxed/simple;
	bh=grSTh48NVO20ZKkbK3hWZFEbDmgyI30nw84X7Ab6QAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=awt63tFtPYygPT1JudbTOcRmFzSQW0Gscp6y5YGtRVHf21ndDRSkpDiTb1dv/pGYqMgEUImstGa8drfdTFbFq9gE/g7uV1xGNFkRVVoRpc/2hknBCxYrCty2efCf5X5qTP9AxFBY0hVX25pWgBi5VgnL/GKGOdLWEU4AlgLnDBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ubLoky/d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ubLoky/d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77689C4CED2;
	Mon,  6 Jan 2025 15:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736176904;
	bh=grSTh48NVO20ZKkbK3hWZFEbDmgyI30nw84X7Ab6QAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ubLoky/dBEbm4f3PZDjzLtrWSx9ZLw8lxLzgmZf1uncE3Np8B13GvXFPz+9flTh20
	 d3zsAKJ1zXMpx4t/sZOSCC7Fus9Bnfhvkod8leutYu+0dvXYxG1akRAgQgwKSqrKkw
	 c7C1N7aNLxb2vaciLjIHc5w4hpiLdZBHPn4yD8ec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kun Hu <huk23@m.fudan.edu.cn>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 69/81] ALSA: seq: oss: Fix races at processing SysEx messages
Date: Mon,  6 Jan 2025 16:16:41 +0100
Message-ID: <20250106151132.035686733@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151129.433047073@linuxfoundation.org>
References: <20250106151129.433047073@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


