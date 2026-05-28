Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D282318EE1;
	Thu, 28 May 2026 19:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998025; cv=none; b=f0w6IAy1V3wVRhnBqzcGC4jyn65f8pwNLYbHk2ZNFyP0UrhhS4o+ks+jC6Jhb3pTJ+m78rizfDaHIS0QjvbuSspEMJ2m0puwHF7jiCZXmOosg7xrT6sMY01ZHgT5BtY1gDK/NRTnFc5ScM61ZrzbjN7n1dXwixjCzUiygIdCxfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998025; c=relaxed/simple;
	bh=ye68Bzx9oNEZlDHVQZWVHtdWJEhEa3eriAwVvsKIyGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K3O/MAqNfEtGY9Z1lu6/avLgU1yXN6F/xwFzYxwGZ5fBQNVBQmD7KQZRUEaHzEHevsE7mXL9s7TExznqpwLhLBPx0u3rDe+7lSTJba8oRApGmdShXxCFyBw7WTfwj5Va4nESw41nfgTX+sl3fj/YiDA8QTk/uPhMuCz7GqHAB70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zZmaMMSs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zZmaMMSs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 991BD1F000E9;
	Thu, 28 May 2026 19:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998024;
	bh=keDVBSovKGSMwAONpsNqe9GHmM1ZFh4it4qCUBtvoCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zZmaMMSsIwYK4CCIbqmwAKwEwTCGBD/3x21B07/5+H0qQncNmScDHC9pArE1MS5Fc
	 BrKIB8JpMwrpLhQsSFNoOX8MI2acMtWS3Ff+sv7VJtHh4eskaNnkOO9c/1xI3+OjtX
	 kGXsDdrfQk6P3rXQ9Vo+bqPozyy4P+Ih2lgTdzzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.0 026/461] ALSA: scarlett2: Allow flash writes ending at segment boundary
Date: Thu, 28 May 2026 21:42:35 +0200
Message-ID: <20260528194647.647043390@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cássio Gabriel <cassiogabrielcontato@gmail.com>

commit a69b677e47a80319ce148d61cc29a2b57006e78d upstream.

scarlett2_hwdep_write() rejects writes when offset + count is greater than
or equal to the selected flash segment size. That incorrectly treats a
write ending exactly at the end of the segment as out of space, although
the last byte written is still within the segment.

Split invalid argument checks from the segment-space check, keep
zero-length writes as no-ops, and compare count against the remaining
segment size. This permits exact-end writes and avoids relying on
offset + count before deciding whether the request is in bounds.

Fixes: 1abfbd3c9527 ("ALSA: scarlett2: Add support for uploading new firmware")
Cc: stable@vger.kernel.org
Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Link: https://patch.msgid.link/20260519-alsa-scarlett2-flash-write-boundary-v1-1-b550480e92da@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/mixer_scarlett2.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/sound/usb/mixer_scarlett2.c
+++ b/sound/usb/mixer_scarlett2.c
@@ -9185,12 +9185,15 @@ static long scarlett2_hwdep_write(struct
 	flash_size = private->flash_segment_blocks[segment_id] *
 		     SCARLETT2_FLASH_BLOCK_SIZE;
 
-	if (count < 0 || *offset < 0 || *offset + count >= flash_size)
-		return -ENOSPC;
+	if (count < 0 || *offset < 0)
+		return -EINVAL;
 
 	if (!count)
 		return 0;
 
+	if (*offset >= flash_size || count > flash_size - *offset)
+		return -ENOSPC;
+
 	/* Limit the *req size to SCARLETT2_FLASH_RW_MAX */
 	if (count > max_data_size)
 		count = max_data_size;


