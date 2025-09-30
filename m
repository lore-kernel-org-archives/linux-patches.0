Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F0C716A956;
	Tue, 30 Sep 2025 15:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245853; cv=none; b=OOwsGN/NbnBljGMMfFy2a0dcURHgOuDtxoOUfNk5k95LCDS+PeC/mD9mNeBc/g2YnsyhH5n1OFc1lvNWLYq0T9GtqNuEmZxPmthBJ/i6KMYcUD1ZnCMjRNJDN0uA9ltkI77qSwhV/K470OxLbUoIWIXarmFPkKdCtOW+fGnqhR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245853; c=relaxed/simple;
	bh=fzF81w2NBWRKQfaro8xtwpdLF6fmhXtNrWoC/bfSBTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XDKDWELVCKOuP5YyktxxLU2+mbZKV0lJhPJO2SLy2fuYwzY+plL75c2ikSmmrwtGL7+8TWy8bD/mJRu2Zw9Zl/l82fK3PQXr4vRAq1LHHz2VHq67BlBEdYXsU9SeeMTh6x6rtMBIwdwHDeFD8sNjD4HATP0Ur5RhvpHqM+72TZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jstqFTUd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jstqFTUd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FDC1C4CEF0;
	Tue, 30 Sep 2025 15:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245849;
	bh=fzF81w2NBWRKQfaro8xtwpdLF6fmhXtNrWoC/bfSBTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jstqFTUdGb3zDY3HMRMvKIknr5xJLIuEAmCFMMbs03iv6e/NBl0BgPMTu0xw2clIz
	 D7G1fyI5fwSvKjlR7aJW36s3sn6SpAVYLKGWIZ+pCRTMRF/TzGKkDBxdh33SpaxeqO
	 gtFO+9GezNKGIdOGZOCZ5X9eFcdxlZYqPxNIdefg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samasth Norway Ananda <samasth.norway.ananda@oracle.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	George Kennedy <george.kennedy@oracle.com>,
	syzbot+38a3699c7eaf165b97a6@syzkaller.appspotmail.com,
	Simona Vetter <simona@ffwll.ch>,
	Helge Deller <deller@gmx.de>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Sam Ravnborg <sam@ravnborg.org>,
	Qianqiang Liu <qianqiang.liu@163.com>,
	Shixiong Ou <oushixiong@kylinos.cn>,
	Kees Cook <kees@kernel.org>
Subject: [PATCH 6.6 69/91] fbcon: fix integer overflow in fbcon_do_set_font
Date: Tue, 30 Sep 2025 16:48:08 +0200
Message-ID: <20250930143824.050293077@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.118938523@linuxfoundation.org>
References: <20250930143821.118938523@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samasth Norway Ananda <samasth.norway.ananda@oracle.com>

commit 1a194e6c8e1ee745e914b0b7f50fa86c89ed13fe upstream.

Fix integer overflow vulnerabilities in fbcon_do_set_font() where font
size calculations could overflow when handling user-controlled font
parameters.

The vulnerabilities occur when:
1. CALC_FONTSZ(h, pitch, charcount) performs h * pith * charcount
   multiplication with user-controlled values that can overflow.
2. FONT_EXTRA_WORDS * sizeof(int) + size addition can also overflow
3. This results in smaller allocations than expected, leading to buffer
   overflows during font data copying.

Add explicit overflow checking using check_mul_overflow() and
check_add_overflow() kernel helpers to safety validate all size
calculations before allocation.

Signed-off-by: Samasth Norway Ananda <samasth.norway.ananda@oracle.com>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Fixes: 39b3cffb8cf3 ("fbcon: prevent user font height or width change from causing potential out-of-bounds access")
Cc: George Kennedy <george.kennedy@oracle.com>
Cc: stable <stable@vger.kernel.org>
Cc: syzbot+38a3699c7eaf165b97a6@syzkaller.appspotmail.com
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Helge Deller <deller@gmx.de>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: "Ville Syrjälä" <ville.syrjala@linux.intel.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Qianqiang Liu <qianqiang.liu@163.com>
Cc: Shixiong Ou <oushixiong@kylinos.cn>
Cc: Kees Cook <kees@kernel.org>
Cc: <stable@vger.kernel.org> # v5.9+
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://lore.kernel.org/r/20250912170023.3931881-1-samasth.norway.ananda@oracle.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/core/fbcon.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -2510,9 +2510,16 @@ static int fbcon_set_font(struct vc_data
 	if (fbcon_invalid_charcount(info, charcount))
 		return -EINVAL;
 
-	size = CALC_FONTSZ(h, pitch, charcount);
+	/* Check for integer overflow in font size calculation */
+	if (check_mul_overflow(h, pitch, &size) ||
+	    check_mul_overflow(size, charcount, &size))
+		return -EINVAL;
+
+	/* Check for overflow in allocation size calculation */
+	if (check_add_overflow(FONT_EXTRA_WORDS * sizeof(int), size, &size))
+		return -EINVAL;
 
-	new_data = kmalloc(FONT_EXTRA_WORDS * sizeof(int) + size, GFP_USER);
+	new_data = kmalloc(size, GFP_USER);
 
 	if (!new_data)
 		return -ENOMEM;


