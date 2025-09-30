Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 454562FD1DD;
	Tue, 30 Sep 2025 15:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244859; cv=none; b=IEUtJs5KWI2GIHdLzL/89q2gb/ggOpLJAre32NaAiR+W97qQQu1IHmlCy5Fp2oaQN7P7yW3FfRq++/c2HAB3Qa0VaBHjkZh2g0fWOVMdA7CX5aiz23Nfv0R2cGkQWfpZYwcV3YZm2tNyTT3PHfD//jgSIhUbnDdwc/70Ou/8pis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244859; c=relaxed/simple;
	bh=8rNlWu6EdwbLqiCpOCndoh87oqkX6PoPtdmxWm7sDNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Fdhh/1e7JaukChtWKOzeRSVSucr5B8JqeARDq931GVpVHA2NcI/QwVRviYIh7+9oru5DWrITL7d6uBSf4Z3ERRD+aQSeFQmqNUK6umQzm2EmDdSZTgbhrrlr+m73dErX/9AepmGL7OY2AaI0tEVqCuvMrtsxgkkKVOQBT1kChGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PmV+IQ3l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PmV+IQ3l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77FFEC4CEF0;
	Tue, 30 Sep 2025 15:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244859;
	bh=8rNlWu6EdwbLqiCpOCndoh87oqkX6PoPtdmxWm7sDNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PmV+IQ3lKfCIKNFXuV83JWHf/KVmf4AAeQ85k9NO+cBKOIDNnnAHwmvdWIgVSDeIh
	 9+5tIbqtpEZcLZ1bJHMUr+ksvZcYHFi2cNo0XL/HgMnedI5JHnBnVpDfAxkGlJO/f1
	 Irgp1qKqaK2cb0vze83/qQwXj1zJuDVcpjFd5RWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Samasth Norway Ananda <samasth.norway.ananda@oracle.com>,
	George Kennedy <george.kennedy@oracle.com>,
	Simona Vetter <simona@ffwll.ch>,
	Helge Deller <deller@gmx.de>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Sam Ravnborg <sam@ravnborg.org>,
	Qianqiang Liu <qianqiang.liu@163.com>,
	Shixiong Ou <oushixiong@kylinos.cn>,
	Kees Cook <kees@kernel.org>,
	Zsolt Kajtar <soci@c64.rulez.org>,
	Lucas De Marchi <lucas.demarchi@intel.com>
Subject: [PATCH 6.16 136/143] fbcon: Fix OOB access in font allocation
Date: Tue, 30 Sep 2025 16:47:40 +0200
Message-ID: <20250930143836.654193853@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

commit 9b2f5ef00e852f8e8902a4d4f73aeedc60220c12 upstream.

Commit 1a194e6c8e1e ("fbcon: fix integer overflow in fbcon_do_set_font")
introduced an out-of-bounds access by storing data and allocation sizes
in the same variable. Restore the old size calculation and use the new
variable 'alloc_size' for the allocation.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Fixes: 1a194e6c8e1e ("fbcon: fix integer overflow in fbcon_do_set_font")
Reported-by: Jani Nikula <jani.nikula@linux.intel.com>
Closes: https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/15020
Closes: https://gitlab.freedesktop.org/drm/xe/kernel/-/issues/6201
Cc: Samasth Norway Ananda <samasth.norway.ananda@oracle.com>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: George Kennedy <george.kennedy@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Helge Deller <deller@gmx.de>
Cc: "Ville Syrjälä" <ville.syrjala@linux.intel.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Qianqiang Liu <qianqiang.liu@163.com>
Cc: Shixiong Ou <oushixiong@kylinos.cn>
Cc: Kees Cook <kees@kernel.org>
Cc: <stable@vger.kernel.org> # v5.9+
Cc: Zsolt Kajtar <soci@c64.rulez.org>
Reviewed-by: Lucas De Marchi <lucas.demarchi@intel.com>
Reviewed-by: Qianqiang Liu <qianqiang.liu@163.com>
Link: https://lore.kernel.org/r/20250922134619.257684-1-tzimmermann@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/core/fbcon.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -2491,7 +2491,7 @@ static int fbcon_set_font(struct vc_data
 	unsigned charcount = font->charcount;
 	int w = font->width;
 	int h = font->height;
-	int size;
+	int size, alloc_size;
 	int i, csum;
 	u8 *new_data, *data = font->data;
 	int pitch = PITCH(font->width);
@@ -2524,10 +2524,10 @@ static int fbcon_set_font(struct vc_data
 		return -EINVAL;
 
 	/* Check for overflow in allocation size calculation */
-	if (check_add_overflow(FONT_EXTRA_WORDS * sizeof(int), size, &size))
+	if (check_add_overflow(FONT_EXTRA_WORDS * sizeof(int), size, &alloc_size))
 		return -EINVAL;
 
-	new_data = kmalloc(size, GFP_USER);
+	new_data = kmalloc(alloc_size, GFP_USER);
 
 	if (!new_data)
 		return -ENOMEM;


