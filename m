Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D47DC3C9EEF;
	Sat, 30 May 2026 18:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165722; cv=none; b=Kp+skiFYTlliXHMtS9cWUuewb9kPL7ENcpH7z9Son9arKwDIWSodw+gO5Y4p3zfjDiVcjTXhj/Q3LNcFqhIOtqIlaBVVQsCFi7ROtTrDdTYlavtBJWhAJVLKhPYi91MogZ/CYdQlrP+8iLNk4qT8K+iyz1Y/pRyt0ui4VqrMna4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165722; c=relaxed/simple;
	bh=oZ/ZsdMCQQFTQ/z4bBhM+GmtBMwS+6vAJ2jmxlf+xR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RF3R0KDtjYrZmg93CHQ7az8gnIeByVJJpH4sHYfZi3e/wQJlGKYHI4KDyTb4bEPocfTW0878rcZ6Nt5KYiOabBXtaQdaik6ZeEKTbjedn+nLjCWVybq/UTJXnm6fApHPyIleiqYJAC9A6aojMf+jWdqAqXYb+hNcE9s3L5bjOSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zk6pRdYn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zk6pRdYn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8BFF1F00898;
	Sat, 30 May 2026 18:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165721;
	bh=ZagiXw1RBR8z9cmipvIzmbfwp7W+6S/6Cm7OedzoUJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zk6pRdYnKR4BY/helhAYII8MVVRn9kp3m1sCQ3QuNof0xePg2HIrwdh7OI69qUJa4
	 My6+THkAI8udLsizRUxEROnlAqX3+6Z8Khxycd7hDGgQ/ErWsIvTplhaHy+BOG2f8D
	 794+VFL1NXoQ29/x9Rybr7qyoy9Hcp28u6KTgr88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 162/589] ALSA: seq_oss: return full count for successful SEQ_FULLSIZE writes
Date: Sat, 30 May 2026 18:00:43 +0200
Message-ID: <20260530160229.043350314@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cássio Gabriel <cassiogabrielcontato@gmail.com>

commit bbc6c0dda54fc0ad8f8aed0b796c23e186e1a188 upstream.

snd_seq_oss_write() currently returns the raw load_patch() callback
result for SEQ_FULLSIZE events.

That callback is documented as returning 0 on success and -errno on
failure, but snd_seq_oss_write() is the file write path and should
report the number of user bytes consumed on success. Some in-tree
backends also return backend-specific positive values, which can still
be shorter than the original write size.

Return the full byte count for successful SEQ_FULLSIZE writes.
Preserve negative errors and convert any nonnegative completion to the
original count.

Cc: stable@vger.kernel.org
Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Link: https://patch.msgid.link/20260324-alsa-seq-oss-fullsize-write-return-v1-1-66d448510538@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/seq/oss/seq_oss_rw.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/sound/core/seq/oss/seq_oss_rw.c
+++ b/sound/core/seq/oss/seq_oss_rw.c
@@ -101,9 +101,9 @@ snd_seq_oss_write(struct seq_oss_devinfo
 				break;
 			}
 			fmt = (*(unsigned short *)rec.c) & 0xffff;
-			/* FIXME the return value isn't correct */
-			return snd_seq_oss_synth_load_patch(dp, rec.s.dev,
-							    fmt, buf, 0, count);
+			err = snd_seq_oss_synth_load_patch(dp, rec.s.dev,
+							   fmt, buf, 0, count);
+			return err < 0 ? err : count;
 		}
 		if (ev_is_long(&rec)) {
 			/* extended code */


