Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E7173DEAFA;
	Mon,  4 May 2026 14:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904481; cv=none; b=LUqkeEvekPTel86do6ZlHBIEQCjFNkCJbzPHgeLeDvTGSEblEbTjtaxSf6Rlf3IO4AT9k93cvEI6GwepVRRRcTcmkNIAf/mJ14HY3lwM9HhomaM5uwWoIObLOURQ94Wh6ZW94jnGWzRRyhrIsGRpL5z66rKLp/wZ9iK1B1XN7gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904481; c=relaxed/simple;
	bh=we/1RXS2bfmAnNPQIRPywIbh/RcRCKgkarJgtI8Fvkg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O8hjnoJ9lqAa5u7ihWDrS3MUyrEbzwatlGwHdNAFA+nYerzlaVvml4+mloYM8HVl12M5tPbsySIhMA6GX+TGVRIbPljX8rVxIpf3koCYeBLxqZ+4Fm2mG8XcscG4Im3vHiremUV9hoI8un+YvOsEKmUuO+2/uuqkF/fPTvfM078=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ypKHS/Pd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ypKHS/Pd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C951FC2BCF6;
	Mon,  4 May 2026 14:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904481;
	bh=we/1RXS2bfmAnNPQIRPywIbh/RcRCKgkarJgtI8Fvkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ypKHS/PdXVZ741e2TIL/WRDKRIJGzBSDLo8feULpDVwkQ/wMlZpzP2AJMYF6EmbxW
	 pUOClcueJ9PsOBc0t8Bx7IPV1OeywUuCbV5ilGVw1nVTDME5xj+rjjObY+/kF7aaXG
	 4OmcSuz/Q98pQoqVwaASoaRCQInPrIti0l9iyzZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 055/215] ALSA: seq_oss: return full count for successful SEQ_FULLSIZE writes
Date: Mon,  4 May 2026 15:51:14 +0200
Message-ID: <20260504135132.186334263@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


