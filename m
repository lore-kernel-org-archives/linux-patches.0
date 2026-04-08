Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A53E83D4134;
	Wed,  8 Apr 2026 18:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673423; cv=none; b=dNT45nTc01dac0GBhKmX02gwyi9BM1fTESe9YG9XG+wvPMW9XDmHRQ4MOXLB1EXO789RoK/bXmcj37ShFezdZl25+sekmRLLXfVaMyaSe4WJWHhIInD0rIIF4SGa3icrLm7T9yCmkcolHO/6XfbMb/tMVhsEKqsL65sHfWpXnRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673423; c=relaxed/simple;
	bh=XbEUwuCHYOsg9Tdt/Pf78YLv1XuRptVWe+T1mIdiB50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hpDSNg3ZLB0DLoH/yV6n77Q4fzJ4riBwUQNIHYlwmC1n10QYVp8NkPJrD90Bz38Z/uE8s1WG0waKY6GVbe9e6PnBRBrYt0r19XTqjMxGAoPEwkW6qSQ+C29mUqpPs/mHLitKzSvCzs0L5H5GELx3ySz3et+Gq1aXwZ2N971tLnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sWgEGQWn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sWgEGQWn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CF8BC19421;
	Wed,  8 Apr 2026 18:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673423;
	bh=XbEUwuCHYOsg9Tdt/Pf78YLv1XuRptVWe+T1mIdiB50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sWgEGQWnw+7Qv5VlvKjFvRTN5J0jG0l+S9ZOF8L4syX5aKPQtWbjaovT2nMM+KKND
	 swAE/GE43VhpWAVEZwG3rGCjxTZx7HVKkZLQL12i9qOcur6pAUgUVTqg1cupNJH+Je
	 i6Chmzi05sNrdsCUDZx3uHavgYr0U9qszuWx8oxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Liav Mordouch <liavmordouch@gmail.com>,
	Nicolas Pitre <nico@fluxnic.net>
Subject: [PATCH 6.18 227/277] vt: discard stale unicode buffer on alt screen exit after resize
Date: Wed,  8 Apr 2026 20:03:32 +0200
Message-ID: <20260408175942.331816257@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

From: Liav Mordouch <liavmordouch@gmail.com>

commit 40014493cece72a0be5672cd86763e53fb3ec613 upstream.

When enter_alt_screen() saves vc_uni_lines into vc_saved_uni_lines and
sets vc_uni_lines to NULL, a subsequent console resize via vc_do_resize()
skips reallocating the unicode buffer because vc_uni_lines is NULL.
However, vc_saved_uni_lines still points to the old buffer allocated for
the original dimensions.

When leave_alt_screen() later restores vc_saved_uni_lines, the buffer
dimensions no longer match vc_rows/vc_cols. Any operation that iterates
over the unicode buffer using the current dimensions (e.g. csi_J clearing
the screen) will access memory out of bounds, causing a kernel oops:

  BUG: unable to handle page fault for address: 0x0000002000000020
  RIP: 0010:csi_J+0x133/0x2d0

The faulting address 0x0000002000000020 is two adjacent u32 space
characters (0x20) interpreted as a pointer, read from the row data area
past the end of the 25-entry pointer array in a buffer allocated for
80x25 but accessed with 240x67 dimensions.

Fix this by checking whether the console dimensions changed while in the
alternate screen. If they did, free the stale saved buffer instead of
restoring it. The unicode screen will be lazily rebuilt via
vc_uniscr_check() when next needed.

Fixes: 5eb608319bb5 ("vt: save/restore unicode screen buffer for alternate screen")
Cc: stable <stable@kernel.org>
Tested-by: Liav Mordouch <liavmordouch@gmail.com>
Signed-off-by: Liav Mordouch <liavmordouch@gmail.com>
Reviewed-by: Nicolas Pitre <nico@fluxnic.net>
Link: https://patch.msgid.link/20260327170204.29706-1-liavmordouch@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/vt/vt.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -1907,6 +1907,7 @@ static void leave_alt_screen(struct vc_d
 	unsigned int rows = min(vc->vc_saved_rows, vc->vc_rows);
 	unsigned int cols = min(vc->vc_saved_cols, vc->vc_cols);
 	u16 *src, *dest;
+	bool uni_lines_stale;
 
 	if (vc->vc_saved_screen == NULL)
 		return; /* Not inside an alt-screen */
@@ -1915,7 +1916,18 @@ static void leave_alt_screen(struct vc_d
 		dest = ((u16 *)vc->vc_origin) + r * vc->vc_cols;
 		memcpy(dest, src, 2 * cols);
 	}
-	vc_uniscr_set(vc, vc->vc_saved_uni_lines);
+	/*
+	 * If the console was resized while in the alternate screen,
+	 * vc_saved_uni_lines was allocated for the old dimensions.
+	 * Restoring it would cause out-of-bounds accesses. Discard it
+	 * and let the unicode screen be lazily rebuilt.
+	 */
+	uni_lines_stale = vc->vc_saved_rows != vc->vc_rows ||
+			  vc->vc_saved_cols != vc->vc_cols;
+	if (uni_lines_stale)
+		vc_uniscr_free(vc->vc_saved_uni_lines);
+	else
+		vc_uniscr_set(vc, vc->vc_saved_uni_lines);
 	vc->vc_saved_uni_lines = NULL;
 	restore_cur(vc);
 	/* Update the entire screen */


