Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCAEC408039;
	Tue, 21 Jul 2026 19:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661959; cv=none; b=jwv6u5a/l34ALEjEDY4Gej4dai9wcB9id3p+rN7195fIUP1CR9M1n10Km1fKRA4ah3I2TMUJKO59ZkeuPJmPbXt3r3UOEJhn2jcvw9d1taSyj9/AZ+7nFAFxJ2+hXX7wI9P5eNZ5ogqipYvEAargD4Q03xscNGCIrVpNW/GG/f4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661959; c=relaxed/simple;
	bh=33pgDXm+3gErc3u7ZnqPMDoUKND5ro7lbtP1PhuU078=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VvOljtWNI+Ko9pZBQqlfIikSig925PS//g+IlrhnPjosI9htuyaJmKZpDAW/dNPFPosFXclgvNwUpnoGOAu/FlRNfo6vBfUd5GdospHf5hDrhNc+9fL5jx8OATpcWR1LKx8fmvAScSF0LZpi0SKLEkTc9UOr65xGZ9AYF+xlSlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K7SgyPJp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K7SgyPJp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E31B1F00A3A;
	Tue, 21 Jul 2026 19:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661958;
	bh=6Jw3qSVXUI6iuG5fHnMiZEIGDHoqooQyw0/isMQ0S6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K7SgyPJpQaV89Lm2Y9ZXUvbmOEoKECIIoSQD1CQ5w3mH2vYIPjzdq0kxhJtWh523E
	 zUtae0+wnx3pmNcqiRnfkPc9nM4V5DTRX7Sf+MpQqmH27D4sBdMLLKyc1w0/njzBXh
	 G93WwW3+nkbDnb/hxFOvPq1fTZVX3tql1r7Bti+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0262/1276] ALSA: seq: Clear variable event pointer on read
Date: Tue, 21 Jul 2026 17:11:45 +0200
Message-ID: <20260721152451.947345263@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Kyle Zeng <kylebot@openai.com>

[ Upstream commit 705dd6dcbc0ea87351c660c1a6443f85f1001c76 ]

snd_seq_read() copies a queued variable-length event header to userspace
before expanding the payload. Queued variable-length events use
SNDRV_SEQ_EXT_CHAINED internally, and data.ext.ptr points at the first
extension cell.

The read side strips SNDRV_SEQ_EXT_* bits from data.ext.len before the
copy, but it leaves data.ext.ptr untouched. A userspace sequencer client
can therefore write a direct variable event to itself and read back the
extension-cell kernel address from the returned header.

Clear the temporary header pointer before copy_to_user(). The original
queued event remains unchanged and is still passed to
snd_seq_expand_var_event(), so payload expansion keeps using the
internal chain.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Link: https://patch.msgid.link/20260607004129.61345-1-kylebot@openai.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/seq/seq_clientmgr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/core/seq/seq_clientmgr.c b/sound/core/seq/seq_clientmgr.c
index 0ddf84b36c13f7..18755d26662766 100644
--- a/sound/core/seq/seq_clientmgr.c
+++ b/sound/core/seq/seq_clientmgr.c
@@ -488,6 +488,7 @@ static ssize_t snd_seq_read(struct file *file, char __user *buf, size_t count,
 
 			memcpy(&tmpev, &cell->event, aligned_size);
 			tmpev.data.ext.len &= ~SNDRV_SEQ_EXT_MASK;
+			tmpev.data.ext.ptr = NULL;
 			if (copy_to_user(buf, &tmpev, aligned_size)) {
 				err = -EFAULT;
 				break;
-- 
2.53.0



