Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CC168F7D;
	Tue, 30 Sep 2025 14:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759243974; cv=none; b=tV6qXvNKzx1h45rtokOjPk7e+2LbvCg89OPOkhpykhgL6UE+XyPfNBqKupOXC4oDqPo3CandilA7hcUU3jcZrKYEk8KhS4ZL2y8LmkooslAjO+aVRpfbHzdv1gH7jvD2lW0rWRGZcB52DpJ0Ez2HJzfpw/4ijMBa9nMEJ2F6E+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759243974; c=relaxed/simple;
	bh=54qlCFXQ+6ihPuFlpAGhkFi5nSfgjArMCPvY+j43RVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CbT+SHGSHLibgDf2lHbY1VZtP55+EXyAgYaKeU61M8o8Y+69xk1VjQNApvRdAzSJKkuFV4yOXKBd7con43StzR3I38nJeoK6n411IzoxZLHJwDD9cE3O4/xPkNJRdEU1sKyCkEqpkRRsA2qF+zFVFa2JK1JnNtYcbwckas647MA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sflZlo80; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sflZlo80"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D39BDC4CEF0;
	Tue, 30 Sep 2025 14:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759243974;
	bh=54qlCFXQ+6ihPuFlpAGhkFi5nSfgjArMCPvY+j43RVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sflZlo80HoIc6GgEhdwGF7AXO/Frh9XpS4IiqJH+UyFEi1HImlLwuVrxveT8q4RxS
	 Vfxt5KR7Ocnm2Eb0aR9xqeV9JgFYKaSkKPIlezl3WYb2O9XNj8tqnz++I0bTaWVEdF
	 84KUj/ZlPHb0jPrk64M/SRRyOb8fR/poUkjv4+gY=
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
Subject: [PATCH 5.4 73/81] fbcon: fix integer overflow in fbcon_do_set_font
Date: Tue, 30 Sep 2025 16:47:15 +0200
Message-ID: <20250930143822.759716444@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143819.654157320@linuxfoundation.org>
References: <20250930143819.654157320@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2509,9 +2509,16 @@ static int fbcon_set_font(struct vc_data
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


