Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BB173839B2;
	Thu, 30 Jul 2026 15:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426290; cv=none; b=KmJ6jRMO/kY8Pw0KrLx3OFClOuuCqfQw2S+NL7Rl+EguBV7gdzGaMYE2V+Km4Vp2zjKvV6cfsmlAxO29oiyzr3jhEJJld8u4GesMZjqxMHWw95UzUPxL6UyLD4y7Ja72ALcR+L7Vgw5+tvZAD5Lwf0DgCthrrlFR4aDdbMZ55vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426290; c=relaxed/simple;
	bh=f692GFl1xdUDZsiAhbSFtdVjkG5l/PYGB42WlxdcJcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aolqY+Ai1k10nGyHKATUPgXIr/vyXtRnQfhnQkzufVSOaZ+mW+RYx9e7LzP+kR/HeGZkIFv8xUGZ0gJwmpmUrv7+bqPDkvNJ/0CuO1Y4YVkwDKZKoFyrYSfbEGb3h4BFTy9DPW86+MU3yfvW4Fv5AFUw9daRWShki5N5PW2DU9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O/Cpml+x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O/Cpml+x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E73F81F000E9;
	Thu, 30 Jul 2026 15:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426289;
	bh=R6P3+5i5blFlpbdoIi8gm2AUls1IhxHsAS9syNN4ViY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O/Cpml+xIzpBbB5ZWiSDx8fbgW+ZCNAOpQAJiptjMNih9bnvI7uLz6ey6EYIMFEeo
	 vnjfcwXVnAUxp7YzmbirZioG3/Iz7+9vm8swgGxijBb6rdLbeI+m0IOP4xkBKOtDuu
	 2gYlGx0Yui9B4/j8vLYiUwg1h8VRrKtIvG1KZBzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	Phillip Potter <phil@philpotter.co.uk>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 365/602] cdrom: fix stack out-of-bounds read in CDROMVOLCTRL
Date: Thu, 30 Jul 2026 16:12:37 +0200
Message-ID: <20260730141443.629382880@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

From: Xu Rao <raoxu@uniontech.com>

commit b27e195d4db8dea263050bdbeb11881b2999c9c6 upstream.

mmc_ioctl_cdrom_volume() first reads the audio control mode page into a
32-byte stack buffer with cgc->buflen set to 24.  If the device reports a
block descriptor, the function increases cgc->buflen to include that
descriptor and reads the page again.

For CDROMVOLCTRL, the function then builds a MODE SELECT parameter list
by moving cgc->buffer forward by offset - 8 bytes.  This drops the block
descriptor from the outgoing payload and leaves a new 8-byte mode
parameter header in front of the audio control page.  However, cgc->buflen
is left unchanged.

With a standard 8-byte block descriptor, cgc->buffer points at buffer + 8
but cgc->buflen remains 32.  cdrom_mode_select() therefore asks the low
level packet path to write 32 bytes from that adjusted pointer, reading 8
bytes past the end of the 32-byte stack buffer.

This is not hit by CDROMVOLREAD, and CDROMVOLCTRL only triggers it on
drives that return a non-zero block descriptor length, which helps explain
why it has gone unnoticed.  The overread is also sent to the device as
extra MODE SELECT payload, so it may not produce an obvious local failure.

Reduce cgc->buflen by the same amount as the buffer pointer adjustment so
the MODE SELECT transfer covers only the intended parameter list.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Xu Rao <raoxu@uniontech.com>
Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
Link: https://patch.msgid.link/20260720194421.1497-2-phil@philpotter.co.uk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cdrom/cdrom.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -3191,6 +3191,7 @@ static noinline int mmc_ioctl_cdrom_volu
 
 	/* set volume */
 	cgc->buffer = buffer + offset - 8;
+	cgc->buflen -= offset - 8;
 	memset(cgc->buffer, 0, 8);
 	return cdrom_mode_select(cdi, cgc);
 }


