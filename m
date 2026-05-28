Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E9A73290B0;
	Thu, 28 May 2026 19:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998021; cv=none; b=tMu4G+cqe7QyNKZV01qZAgM48s3oQkpL+5fRqeuOtxOMOmmGfI5PcCRFeqgEvwro6rDklgThX1ewhBYaOo4rHWAY5ZnpAc050b5+WSTbdf62vNBxPHj3wAON1nJHZUhMiYApE0dJghkVI38WcpIqedSC364FlY0D34yzcmkCBDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998021; c=relaxed/simple;
	bh=IXkblRs4YWogT288QdryI3mo+rNP4JXMURESDZrnEks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uTimJ5aNX+4CL1id31I+3yyxjcjULuIqr8haenT5V8mDKbKV8CxedV+54Sk2dTOcEPHptE7ubg4ZVfD143iiAptHLjwYFjsGPMgDZR40q5rJwLXMxfbtNxa/zTO3IF1d8XMYuyYU2Sb6Yilsckd4CRFMCW9X4lhfKp1jq/5wKzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mqJ8j6Hr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mqJ8j6Hr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 071931F000E9;
	Thu, 28 May 2026 19:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998018;
	bh=dTog7fjAAsDv/cfYLbBPzqqeS6Kg743Mi2GIfsF+jYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mqJ8j6HrAvC3wu0toPYXbzNGjaFzsoZpPWPczrHs4HrB0S9aPwFbzUAn2UsXj8Y5z
	 8BuaUDD94YOrnrraD4HG0OwJd1Wh+dIhIoKWSoVHcq8u/zlUqO9C4CMleJzOV1K0AV
	 xlaKcqMvSz7QeTf5tMj9CXhM5w5H7R6f9vo27IeU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiakai Xu <xujiakai24@mails.ucas.ac.cn>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.0 024/461] ALSA: pcm: Dont setup bogus iov_iter for silencing
Date: Thu, 28 May 2026 21:42:33 +0200
Message-ID: <20260528194647.585500785@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

commit e4d3386b74fba8e01280484b67ee481ece00201e upstream.

At transition to the iov_iter for PCM data transfer, we blindly
applied the iov_iter setup also for silencing (i.e. data = NULL), and
it leads to a calculation of bogus iov_iter.  Fortunately this didn't
cause troubles on most of architectures but it goes wrong on RISC-V
now, causing a NULL dereference.

Handle the NULL data case to treat the silencing in interleaved_copy()
for addressing the bug above.  noninterleaved_copy() has already the
NULL data handling, so it doesn't need changes.

Reported-by: Jiakai Xu <xujiakai24@mails.ucas.ac.cn>
Closes: https://lore.kernel.org/20260515051516.3103036-1-xujiakai24@mails.ucas.ac.cn
Fixes: cf393babb37a ("ALSA: pcm: Add copy ops with iov_iter")
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20260517165121.31399-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/pcm_lib.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/sound/core/pcm_lib.c
+++ b/sound/core/pcm_lib.c
@@ -2138,6 +2138,9 @@ static int interleaved_copy(struct snd_p
 	off = frames_to_bytes(runtime, off);
 	frames = frames_to_bytes(runtime, frames);
 
+	if (!data)
+		return fill_silence(substream, 0, hwoff, NULL, frames);
+
 	return do_transfer(substream, 0, hwoff, data + off, frames, transfer,
 			   in_kernel);
 }


