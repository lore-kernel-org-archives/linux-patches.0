Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAC5946D561;
	Tue, 21 Jul 2026 15:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649303; cv=none; b=XrLRxqxoTlMXYDzwCJ9nvpaG+qZtL0xU+1FiZRP60HjYARXcXpX2V9Wz+snETB9wSRF/15+9mRluTpIywm6RXRLaPrqdSybiujT9L4uF80AcReM0YJpHNpGSG1uoBlEfEHFDXpiLTPMPxnvPZEgyHinQzZe+DA7Qp9LykAOJxlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649303; c=relaxed/simple;
	bh=FbZe4YuD0YR8w6rPsGeWhBunLhp537qL2KCsVn0uJhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N43jzNvsVPpXr0XTA+X0KJHDBWWTz2UDvjbsJcxWyH+1k/FQj0UBZzXeseU9cfs9+fgTyCyAXZ8aOVEdQ064xolGYZzoaq+TXCsaSGonIgmTZ6dyMYhgpR17wJ+S3GhPpY5fx2OntkjPhJqxLVmlw22z3TKr/9tnaHuDHvYqnEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aZZNPF8v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aZZNPF8v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 540CE1F00A3D;
	Tue, 21 Jul 2026 15:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649302;
	bh=YtNa78wxuBHAynEMVij9n2x43Bc4m0k1FVPF2NtzGUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aZZNPF8vVUtPOQNXokzvve5/7aHuiApkyA6AVYPQANGXgQtsUdVltkXyPs21ustnC
	 BaildRWvOsn0M11i9Zt3R+xCVowKt+M8gr4B6tof7CoNqYw17QR43Mds1AMNDskeVd
	 PRom1mcHh2mjN+3E9bcVRtm+eyBQj6pIE7Gg+zU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0527/2077] ALSA: seq: Clear variable event pointer on read
Date: Tue, 21 Jul 2026 17:03:20 +0200
Message-ID: <20260721152605.237326104@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 5719637575a911..ce0dd53399bfac 100644
--- a/sound/core/seq/seq_clientmgr.c
+++ b/sound/core/seq/seq_clientmgr.c
@@ -441,6 +441,7 @@ static ssize_t snd_seq_read(struct file *file, char __user *buf, size_t count,
 
 			memcpy(&tmpev, &cell->event, aligned_size);
 			tmpev.data.ext.len &= ~SNDRV_SEQ_EXT_MASK;
+			tmpev.data.ext.ptr = NULL;
 			if (copy_to_user(buf, &tmpev, aligned_size)) {
 				err = -EFAULT;
 				break;
-- 
2.53.0



