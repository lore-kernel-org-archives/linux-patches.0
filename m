Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CD1636166F;
	Wed,  8 Apr 2026 18:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673426; cv=none; b=uaZzIzZ76c8IURhlNOHBoGP6HZdWkmHJ6hIN9vEQYXGU5eomEWWTKXRi/jipFZU7u2BhY3NnZ4xfDrfjxPS/jxEDoHsaipFhuX7bT5XWASDEd63n90/FNkafmy6JXb1jfytAtGgDwNlHN4Zy51zmgPj5J+GtqxiL++QYVW5Bx2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673426; c=relaxed/simple;
	bh=hz3gd9/g2E6oCRvZiCLMzBrNbYzevVRssLVwrK9QOTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pe/2xMz9AwLYI9aCJF12zq7cmfRSz/s64c601mExJBEPw2RqJn5hL2OeiqoYc5pdV0oBlgbzrw0/28ffpoSjUxLFvFUYR7B7vGDYDbl2juZTWWfsVUL5DpKlG4ooehFYs1UqjcOoV5+HZH/z3NbzPqjDPDmSr99kOi6CNB/g3rQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FQtJCM6p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FQtJCM6p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEBFCC19421;
	Wed,  8 Apr 2026 18:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673426;
	bh=hz3gd9/g2E6oCRvZiCLMzBrNbYzevVRssLVwrK9QOTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FQtJCM6po8Mwx6oezpNcPcNvjSYNX3CC8e4a/ydaNMkDX46btbw8ESNg+g/4+YCIs
	 P+fWV5p1nV5xAFsm1gKLfhPb/UGEH/ZHASCo+R1Tjl/HTxPg4JwaRfSOFuGB9p596r
	 Tfi6mS/ZEwzJuOPa9b8D+/rADh20mtnVv++cnQwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Nicolas Pitre <nico@fluxnic.net>
Subject: [PATCH 6.18 228/277] vt: resize saved unicode buffer on alt screen exit after resize
Date: Wed,  8 Apr 2026 20:03:33 +0200
Message-ID: <20260408175942.373064733@linuxfoundation.org>
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

From: Nicolas Pitre <nico@fluxnic.net>

commit 3ddbea7542ae529c1a88ef9a8b1ce169126211f6 upstream.

Instead of discarding the saved unicode buffer when the console was
resized while in the alternate screen, resize it to the current
dimensions using vc_uniscr_copy_area() to preserve its content. This
properly restores the unicode screen on alt screen exit rather than
lazily rebuilding it from a lossy reverse glyph translation.

On allocation failure the stale buffer is freed and vc_uni_lines is
set to NULL so it gets lazily rebuilt via vc_uniscr_check() when next
needed.

Fixes: 40014493cece ("vt: discard stale unicode buffer on alt screen exit after resize")
Cc: stable <stable@kernel.org>
Signed-off-by: Nicolas Pitre <nico@fluxnic.net>
Link: https://patch.msgid.link/3nsr334n-079q-125n-7807-n4nq818758ns@syhkavp.arg
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/vt/vt.c |   24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -1907,7 +1907,6 @@ static void leave_alt_screen(struct vc_d
 	unsigned int rows = min(vc->vc_saved_rows, vc->vc_rows);
 	unsigned int cols = min(vc->vc_saved_cols, vc->vc_cols);
 	u16 *src, *dest;
-	bool uni_lines_stale;
 
 	if (vc->vc_saved_screen == NULL)
 		return; /* Not inside an alt-screen */
@@ -1918,16 +1917,23 @@ static void leave_alt_screen(struct vc_d
 	}
 	/*
 	 * If the console was resized while in the alternate screen,
-	 * vc_saved_uni_lines was allocated for the old dimensions.
-	 * Restoring it would cause out-of-bounds accesses. Discard it
-	 * and let the unicode screen be lazily rebuilt.
+	 * resize the saved unicode buffer to the current dimensions.
+	 * On allocation failure new_uniscr is NULL, causing the old
+	 * buffer to be freed and vc_uni_lines to be lazily rebuilt
+	 * via vc_uniscr_check() when next needed.
 	 */
-	uni_lines_stale = vc->vc_saved_rows != vc->vc_rows ||
-			  vc->vc_saved_cols != vc->vc_cols;
-	if (uni_lines_stale)
+	if (vc->vc_saved_uni_lines &&
+	    (vc->vc_saved_rows != vc->vc_rows ||
+	     vc->vc_saved_cols != vc->vc_cols)) {
+		u32 **new_uniscr = vc_uniscr_alloc(vc->vc_cols, vc->vc_rows);
+
+		if (new_uniscr)
+			vc_uniscr_copy_area(new_uniscr, vc->vc_cols, vc->vc_rows,
+					    vc->vc_saved_uni_lines, cols, 0, rows);
 		vc_uniscr_free(vc->vc_saved_uni_lines);
-	else
-		vc_uniscr_set(vc, vc->vc_saved_uni_lines);
+		vc->vc_saved_uni_lines = new_uniscr;
+	}
+	vc_uniscr_set(vc, vc->vc_saved_uni_lines);
 	vc->vc_saved_uni_lines = NULL;
 	restore_cur(vc);
 	/* Update the entire screen */


