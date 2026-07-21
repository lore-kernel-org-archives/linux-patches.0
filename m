Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D7153B1034;
	Tue, 21 Jul 2026 20:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666094; cv=none; b=hJF19MxoMbTnCu5VXFIdtm02mJDz6mj7FceT1wooNKbkp5I9kkuKn5o41qke3NZBc/TOWNQJG9rrBOJkQi0gIEEhFCi+K3ZrzxEisGGvySceoXJh8IncHQ2yOeAO82tFhYRp2awUm5ExG38MHmPqpzMH6XNiODSvbr5tCZWPAqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666094; c=relaxed/simple;
	bh=xSnX6ohhmF8QaakIok0F7S9AZTh3MHgubm5owUn46D4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C7nf2eojdYALWVMktGBW513UOyZ3Fctce8oYyNI7/9tNpYygJUh6rLiigjdwVCAWwhMspk4YEU7z5AKe42Tep7/dyhP4g/oPb8p/eRKVbssoWXtqfVchRjka9SsDHwAGDbEA7KzK4Elozi89NyF5ILaIr4j3IyeCaI0ynmc6JB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tgeToRor; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tgeToRor"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72EDC1F000E9;
	Tue, 21 Jul 2026 20:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666092;
	bh=kemcmAw3lstuINHjVFEPIqOQjNXKJGtlTM6nvDvDwyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tgeToRorkblUHFF+6zvNMGUDXQccNNNXDVSRVQ5Pi4r+drAWXUbpMiXi3WCr+zdS0
	 ECg29HPMpNKulfVGs8N012arx908xwdkLndt47iBdIYCzyZGyw9LxkYtrFsisTJADy
	 3re/ypnXG7Qily430Dz8ql5zaBB2qU3kp1dsFuCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0508/1266] ALSA: seq: Clear variable event pointer on read
Date: Tue, 21 Jul 2026 17:15:45 +0200
Message-ID: <20260721152453.214227604@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 9d71decaddd69d..1fddeb91c9f46f 100644
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



