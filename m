Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB7B335C69A;
	Tue, 21 Jul 2026 21:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669012; cv=none; b=Bvn9gRZr+aACXCRjaB/XIbxtOqZOyl8BSxK7CBZfwMWjhS+arWTzsq5o/xf7tWMdx03OTmvl41ZRXpnA5f9sAR3Ke0jIJ3rgDOWS4KYVQ+lttyIsrC1Cp/vc+Zfv2dBBXK5sQyGJz4SQuetm+M0YQyBuQEeAHrktuXk+aBiG+H4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669012; c=relaxed/simple;
	bh=ud/r7CPo3PvmB20QBSF0hAbADovZ3nGGftgdfu/bTiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eVQfVrFm64i1Zz8igCYD2hZsWn9hdy69VN/v9tbrYdP/adCGsRipVxq/jtPom85j7sBdE7a10Y3gmLufF0MKIdS28THHRe20Dcvv7jirj31Ok9uky/pR8DFue2dmCPX/9Ow26Y9QlKqkcqa6bGWcOWCGiaxQUMLw0+dmF4mrIbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0P6UK2rF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0P6UK2rF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2730A1F000E9;
	Tue, 21 Jul 2026 21:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669010;
	bh=7PoBFkn+wHpYDxQp6FQgy8LeNNSRIh0lLiI5nq5SlsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0P6UK2rFK2jgIQ8QVD2S3cBgJw0u4G0W4W/fG9sXr9VWnQwnYAlxUgAjTLdclgfnF
	 tXGFI2Him7VF9FtVFx3V1gP0NlMRPJiGBPHq8KRnT4EAp6zf+6jZCASm5/41MZfl4B
	 B1e7xgjYAATgHK3z1zMRO0jZ0A+92ilyMBzVQgM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0394/1067] ALSA: seq: Clear variable event pointer on read
Date: Tue, 21 Jul 2026 17:16:35 +0200
Message-ID: <20260721152433.445742581@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index bd05f14b6804bf..1efc407e7784b0 100644
--- a/sound/core/seq/seq_clientmgr.c
+++ b/sound/core/seq/seq_clientmgr.c
@@ -464,6 +464,7 @@ static ssize_t snd_seq_read(struct file *file, char __user *buf, size_t count,
 
 			memcpy(&tmpev, &cell->event, aligned_size);
 			tmpev.data.ext.len &= ~SNDRV_SEQ_EXT_MASK;
+			tmpev.data.ext.ptr = NULL;
 			if (copy_to_user(buf, &tmpev, aligned_size)) {
 				err = -EFAULT;
 				break;
-- 
2.53.0



