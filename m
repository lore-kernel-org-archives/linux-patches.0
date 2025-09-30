Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57E8D7640E;
	Tue, 30 Sep 2025 15:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245354; cv=none; b=ZjZEY8HwPr0XhKUaUR2Zvik/pRseNZKAIQ9PSqRwxIrbxOdDLa7t4otPlLIzEBoBgjvZ86/GZH4lVG8RHKQOwwC5ZJQINv/IzgASeydiDSDUhTWbIDzUya5l1aa2JpW7RXZewA8Xs0clzeM764iZ+KscEh8dXBOJ+3GNQFg8CoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245354; c=relaxed/simple;
	bh=emfzQ80FIE9hImDHjrEYjf3mgHY0kH0xFTXX3VM+Bhs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GmzN7DinHTRs2lXJRs1Ofkh62qUv1LD0QsQXzdmKZTojYOIf5AbRY2WApV2QLeC1BMV4eB8P7D3tJ/Nb3WwEkUb5hGfhgMEPydGmt5oy+Y2sZlJa5cQdYqhj1TZNPgiN17ZjB1/RId6B07+Ry1cqSqMp7yA9CM+u3tPpm2Y0Wcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ymVWj5hY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ymVWj5hY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A81E2C4CEF0;
	Tue, 30 Sep 2025 15:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245354;
	bh=emfzQ80FIE9hImDHjrEYjf3mgHY0kH0xFTXX3VM+Bhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ymVWj5hYKAdBCD6Y/DBviDLcubuI95hEzMmBICl1HFF+u+IW7AA16Xj2rGReaGbRc
	 HZ3Vd+arKSvpp1bi8KKo0Y6o1oeOvyZZ8kQYP7M5avzQGpvy/bApCW7+OvdmfNnnDy
	 Xy8BuwXm82g7rcwNFb36YtEtrvF5YGSezcZ4BRdw=
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
Subject: [PATCH 5.15 143/151] fbcon: fix integer overflow in fbcon_do_set_font
Date: Tue, 30 Sep 2025 16:47:53 +0200
Message-ID: <20250930143833.288271075@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
References: <20250930143827.587035735@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2506,9 +2506,16 @@ static int fbcon_set_font(struct vc_data
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


