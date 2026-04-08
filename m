Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB8802857C1;
	Wed,  8 Apr 2026 19:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674887; cv=none; b=RC0qdIVSl8KKxFbdkdMWey51OfkCAlIOLvAKGEG4iitLLyfAv4lctsTICuXaAGGO/MwNpqjAhJvK7Qm4Of785he9jbcImcVg2f42HKkDnN8p3S+3MiF7xYUbi6fWHrl9dQdd2Rd030g78W0KM+EUGWt4mU9DW/Ts5nBO6OkvHRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674887; c=relaxed/simple;
	bh=Dz2Kv57vio9ncTMLmxWKU82/hN1DYnhi6HnIkRwZEj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q/meAXmujstcRI7dJzkIpHFVgDPuVxDqzf4kvZpBoSdXRRWZmV4l4XnBsNA4OcJ0AsBJg2pvtSA/yzDxY9sPD/0f4C2wWS/tfK0i1f1gHgiUxnYMb0KK4CkjGk1mvApDFFnbhcqsIGHD0HrOglFp9yw9rWJHaTnqs8Ni1Q+NfZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nm1fESDi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nm1fESDi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6139DC19425;
	Wed,  8 Apr 2026 19:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674886;
	bh=Dz2Kv57vio9ncTMLmxWKU82/hN1DYnhi6HnIkRwZEj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nm1fESDiTuC/NKDWy9R4jmQETSciwcxdW9sxkOrxsVhkfWKqZEArOWi6DNDk957SM
	 VB/RZB4JnyeCHPvMN3CvieC7XjUS9ylskjXVB+tsyZ46IunkE5CnoXbHiMPIZRuLW2
	 tGjL4s9NQNYY2Ed2HCW4B1JrinolaZ6gKWXCgmOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Nicolas Pitre <nico@fluxnic.net>
Subject: [PATCH 6.19 271/311] vt: resize saved unicode buffer on alt screen exit after resize
Date: Wed,  8 Apr 2026 20:04:31 +0200
Message-ID: <20260408175949.501294927@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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


