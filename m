Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED0F7386571;
	Tue, 21 Jul 2026 18:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657038; cv=none; b=fKMqF4qbZTqAir7obgwShBK+lGRarWbIhsK0CYMlxMmLclIokRkfmFAniQN+EwwCAVK1U925D3k7tR6YGqXFySbnY1YjVXRKRwV4wFcR1L1SGB/9gTlV9dbouS6XqOA6MzSPp7HjS+xST9gDgO/opf6BCC2URcMtq4Ui+WDGgMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657038; c=relaxed/simple;
	bh=z710D3JGrgualJB/txNv3O5Bl2ty1RUnZ1egmjnhYyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VBfxxDT37X+g2UPvLkeeGc/xYP1eYhu1SzE5t3oxq4jFp+Ikb+v4b5H57TSLvIAt5eyPgkYWPthb1n6dv6rnHHo/PWhdoBPkonWNBhrFFp3OKeN1RkrKVRui0F4iBhjPPl+daWzI//964MUOoh2wdoF/NZHf7CyjOHbKij9BInA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YOIBS3Bi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YOIBS3Bi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FDB01F000E9;
	Tue, 21 Jul 2026 18:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657036;
	bh=DNItS4Sdd3/pBMwfqyh3hymSr4d+4hKIy36MK0UFxmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YOIBS3BiGOJnrQwGfVkETB2VKh9x0DnLI/Phlt54uaSY9iqjM9tsXc3f4B/kcTRS7
	 dmRURv/WHQj7T69gKwUicMjUcYSaY0rhesSJRcCGggYnCjkorCWODtJtac2Z0EmXIv
	 eDyi1zxPMEEjTPe7lJ5piUVzgV2a3UT8L3HNz0O8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruikai Peng <ruikai@pwno.io>,
	Adam Crosser <adam.crosser@praetorian.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0614/1611] gpib: fix double decrement of descriptor_busy in command_ioctl()
Date: Tue, 21 Jul 2026 17:12:10 +0200
Message-ID: <20260721152529.194873895@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adam Crosser <adam.crosser@praetorian.com>

[ Upstream commit c4faab452b3c1ada003d49c477609dd80523b9bf ]

commit d1857f8296dc ("gpib: fix use-after-free in IO ioctl handlers")
introduced a descriptor_busy reference counter to pin struct
gpib_descriptor across IO ioctl operations.  In command_ioctl(), the
error path inside the loop decrements descriptor_busy and breaks, but
execution then falls through to the unconditional decrement after the
loop, underflowing the counter to -1.

This re-enables the use-after-free that the original fix was meant to
prevent: a concurrent close_dev_ioctl() sees descriptor_busy == 0 on
an actively-used descriptor and frees it.

Remove the early decrement from the error path.  The post-loop
decrement already handles all exit paths, matching the correct pattern
used in read_ioctl() and write_ioctl().

Fixes: d1857f8296dc ("gpib: fix use-after-free in IO ioctl handlers")
Reported-by: Ruikai Peng <ruikai@pwno.io>
Signed-off-by: Adam Crosser <adam.crosser@praetorian.com>
Link: https://patch.msgid.link/20260424123750.855863-1-adam.r.crosser@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/gpib/common/gpib_os.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/gpib/common/gpib_os.c b/drivers/staging/gpib/common/gpib_os.c
index 6bae025434e5cf..a2bed6bd757a06 100644
--- a/drivers/staging/gpib/common/gpib_os.c
+++ b/drivers/staging/gpib/common/gpib_os.c
@@ -1017,7 +1017,6 @@ static int command_ioctl(struct gpib_file_private *file_priv,
 		userbuf += bytes_written;
 		if (retval < 0) {
 			atomic_set(&desc->io_in_progress, 0);
-			atomic_dec(&desc->descriptor_busy);
 
 			wake_up_interruptible(&board->wait);
 			break;
-- 
2.53.0



