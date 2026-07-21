Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E83935C682;
	Tue, 21 Jul 2026 22:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671655; cv=none; b=SpddDTt7WXebwqxgnjKoc5HK9jZ1ktgfaNLXqjdsjYaFowAR/cAtUCtk4X6zkicApYJDRIcTpJCpOt6kkz7upser1QBm7UpJ/k+9pIjk8YCkGGjK7g2fNtGqQyiA2o9ITJA3UCkbOam6JyZq8YKkDV0GUdtIhb2otThQjeXFjdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671655; c=relaxed/simple;
	bh=Jrip5FcNmuiyhQ2l4Hn21oVmP8cgkzeWm4Om2SP1Ecg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I1BKeWrRKIL6UueVMh+iaVmzF6dHqwvHP4sVtQ3ElUR+AsoLfOz3CdoH3S0+sQkBdgqBxjRPk3tZuy74ktG7UAR9/kzaaCM2P4++t5riqFZ2MXBC24r52jRUX8B7CFU+0zXKAZAs9mHE53sndBkoX4H69T2uu7X9d/SsMaog+gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y0UnUZ7d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y0UnUZ7d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83DE91F000E9;
	Tue, 21 Jul 2026 22:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671654;
	bh=xdpkCm1RpTn/9Fc3wg749WvwQKC87oyf8QKD06VciXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y0UnUZ7diqiuP4kNLs/8BYD+o80iunM+6NyS9HuBt986qqDAyPvbio5fn1VEMGZs3
	 jj5lIY7NbFlM/LyJuM5kzs2e3YMeKZSVB+/kG18/6eqKezcV+0Fb+ZOmt+idHpnVsz
	 ud9hwa6V/sQ2F16Jiwfff5CRvgYxZp23PGPYXkIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 311/843] ALSA: seq: Clear variable event pointer on read
Date: Tue, 21 Jul 2026 17:19:06 +0200
Message-ID: <20260721152413.020119908@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index d756b7df90457c..37657f7d57997f 100644
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



