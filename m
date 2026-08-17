Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 089CF4266AA;
	Mon, 17 Aug 2026 13:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974590; cv=none; b=jWmDNICPuNzlTH8InywvoTdFmtBQ+pDDYibeJLJfe7rZaqOyYYJxVE3dO7g9oTbPZxws1seeTXD0/mv5l3SHHdvPt7dmzKIXNSXagol63fgUPe4aS5L93Dq145XhQh75B57V83707Z5cISft/6hFWioD7gwzLyOuYt0i08gZ3TA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974590; c=relaxed/simple;
	bh=cHwkDHnJ9QfQy57rYAp23diQ7SyiegcTL3YrV+0DSNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KVaMvyqxeXd6RSuxVwyQVM65jaWeE12fU68/gtzJbGMN9ASoXKJthGNwu6mXSDqMxWVjlxvVpJzzgk4Bc1ndPuV07cfseIbRBHXYjMq8WabTGznmt/mM2Qn6kc5QaiCRBkBO/16RxYkcdUGVuyszoRrNLQZL1atzpNNqc0taa/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SOpdjTlQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SOpdjTlQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5716B1F000E9;
	Mon, 17 Aug 2026 13:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974582;
	bh=Bt1M9VMOcErR0T1M5kGCdPBgOJH6ZkVtfWrWKCaykHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SOpdjTlQrmgeY41Z6ZHrT5PNkiBEfnan3kVKMGJ4ZyqfMET8E0XDeEe4vBCvkFxWb
	 xofV/WwoyDc0ka6ma6SkZOQ7INgMdIOXMYax3h0bWBeBucTXz72mBgzJQvoe1nIaGy
	 /82ashW1HjiKQyUO0zCY9dNU+Nxlw6iETIiM0m7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+61b1db46218109869c14@syzkaller.appspotmail.com,
	Rik van Riel <riel@surriel.com>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 7.1 206/271] fbdev: bitblit: bound-check glyph index in bit_cursor()
Date: Mon, 17 Aug 2026 15:32:11 +0200
Message-ID: <20260817132545.289897030@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rik van Riel <riel@surriel.com>

commit e033cbf3975a8465f879ebd5989dc35b04423a4d upstream.

bit_cursor() fetches the glyph under the cursor with

	c = scr_readw(vc_pos);
	src = vc_font.data + ((c & charmask) * w * height);

where charmask is 0x1ff when vc_hi_font_mask is set. The screen buffer
value comes directly from scr_readw() and may be larger than the current
font's glyph count.

Syzkaller triggers this via vcs_write(). The Call Trace shows
vcs_write() in vc_screen.c writing an arbitrary 16-bit value with
writev() to /dev/vcsa, which vcs_write_buf() in vc_screen.c stores via
vcs_scr_writew() without checking charcount. The stored value is later
read in bit_cursor() in bitblit.c.

When the font is changed from a font with 512 glyphs to a font with
256 glyphs, the screen buffer can retain characters with the high
bit set from the previous mode, which could also produce the same
out-of-bounds access.

  BUG: KASAN: global-out-of-bounds in soft_cursor+0x378/0x6bc drivers/video/fbdev/core/softcursor.c:70
  Read of size 16 at addr ffff800086c57970

  Call Trace:
   soft_cursor+0x378/0x6bc drivers/video/fbdev/core/softcursor.c:70
   bit_cursor+0xa90/0x1108 drivers/video/fbdev/core/bitblit.c:365
   fbcon_cursor+0x344/0x498 drivers/video/fbdev/core/fbcon.c:1427
   hide_cursor+0xdc/0x2d0 drivers/tty/vt/vt.c:883
   update_region+0x100/0x18c drivers/tty/vt/vt.c:669
   vcs_write+0x8ec/0xaf0 drivers/tty/vt/vc_screen.c:685

bit_putcs_aligned() and bit_putcs_unaligned() already clamp the glyph
index to vc_font.charcount. Apply the same clamp in bit_cursor() after
extracting the attribute and masking, before indexing fontdata.

The fix completes the bounds checking started in commit 18c4ef4e765a
("fbdev: bitblit: bound-check glyph index in bit_putcs*"), which missed
the cursor path.

This change should be safe because the clamp reuses the existing
contract from fbcon: charcount is maintained under console_lock in
con_font_set() and fbcon_font_set(), and hi_font_mask is cleared when
switching from 512 to 256 glyphs. When stale screen data with high bits
remains after a font switch, or when vcs_write() stores an arbitrary
value, clamping the index to 0 prevents the out-of-bounds read without
changing cursor semantics — the same fallback bit_putcs uses.

Reported-by: syzbot+61b1db46218109869c14@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=61b1db46218109869c14
Link: https://lore.kernel.org/all/6a75205c.01d0871a.3a0d52.0032.GAE@google.com/
Fixes: 18c4ef4e765a ("fbdev: bitblit: bound-check glyph index in bit_putcs*")
Cc: stable@vger.kernel.org
Assisted-by: Hermes:muse-spark-1.2 syzkaller
Signed-off-by: Rik van Riel <riel@surriel.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/core/bitblit.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/video/fbdev/core/bitblit.c
+++ b/drivers/video/fbdev/core/bitblit.c
@@ -273,9 +273,14 @@ static void bit_cursor(struct vc_data *v
 	if (!vc->vc_font.data)
 		return;
 
- 	c = scr_readw((u16 *) vc->vc_pos);
+	c = scr_readw((u16 *) vc->vc_pos);
 	attribute = get_attribute(info, c);
-	src = vc->vc_font.data + ((c & charmask) * (w * vc->vc_font.height));
+	c &= charmask;
+
+	/* Clamp to font size, same as bit_putcs_aligned() */
+	if (c >= vc->vc_font.charcount)
+		c = 0;
+	src = vc->vc_font.data + (c * (w * vc->vc_font.height));
 
 	if (par->cursor_state.image.data != (const char *)src ||
 	    par->cursor_reset) {


