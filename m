Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 803A9305968;
	Tue, 30 Sep 2025 14:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244399; cv=none; b=RIL/PS0mRB92mld07jCiZzf48jREQ/aC7zGoCbO8W7uaXTYoDSd6jiksCrVS9mmejxHEQq8c4UKZMuPJMdfcz+jbVkOTS7FEbAL0gptwe7IUZ3I7BDRqjZfw3zIGSpcMGuIivkrkNoul4KvsN0b60P6H874v2QqoWdStpRKr8eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244399; c=relaxed/simple;
	bh=qHESSQwh6iUf5uQw/Hq88BNhGYYj4BvnVSK+gXQpau0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O5q0cXXxaICRLAUBLrLPZdE5/CIWf/vTxQbl2foHgcgAHvGTTfd5tC2SkCJd4w02oLxk1kKoyqsXRrrgfjk63yaHDF05eQ/G6SnHrhmvcJKaPbSy5fBDQeGo1w84NH0KmHa6+S+wElqg3iOeUga6W2FXMn5283wFW35vkCMHaVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h3zTW5gs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h3zTW5gs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5E5FC113D0;
	Tue, 30 Sep 2025 14:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244399;
	bh=qHESSQwh6iUf5uQw/Hq88BNhGYYj4BvnVSK+gXQpau0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h3zTW5gsjJU/zjm6ioursH/kpoh3ff1ASg+ACby3DuUsVNsX++hTUY/gGw0IXW/Ze
	 wCgMTPw5WHO0r6mXhU4gPveH0bMWcIDYWcdhnZYiKGUkm9CSq8qCPimhUaV/AwvEDo
	 ZRSS+H8jzqXKcZ5YPz8Uy/QRkKFz2obYncQGwykI=
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
Subject: [PATCH 5.10 116/122] fbcon: Fix OOB access in font allocation
Date: Tue, 30 Sep 2025 16:47:27 +0200
Message-ID: <20250930143827.711648453@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143822.939301999@linuxfoundation.org>
References: <20250930143822.939301999@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2500,7 +2500,7 @@ static int fbcon_set_font(struct vc_data
 	unsigned charcount = font->charcount;
 	int w = font->width;
 	int h = font->height;
-	int size;
+	int size, alloc_size;
 	int i, csum;
 	u8 *new_data, *data = font->data;
 	int pitch = PITCH(font->width);
@@ -2533,10 +2533,10 @@ static int fbcon_set_font(struct vc_data
 		return -EINVAL;
 
 	/* Check for overflow in allocation size calculation */
-	if (check_add_overflow(FONT_EXTRA_WORDS * sizeof(int), size, &size))
+	if (check_add_overflow(FONT_EXTRA_WORDS * sizeof(int), size, &alloc_size))
 		return -EINVAL;
 
-	new_data = kmalloc(size, GFP_USER);
+	new_data = kmalloc(alloc_size, GFP_USER);
 
 	if (!new_data)
 		return -ENOMEM;


