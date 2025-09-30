Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B44A173;
	Tue, 30 Sep 2025 15:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245567; cv=none; b=VcQN5caG03PwQHuuuWXNNajW5/g9Ex/osE+iNFqsnsEIYYqW//gPqhkr1c6A2YQPW9ZB5sqxGYA0CY5Ej89lfgHdxja0hJNmkWG9mNDXOmxdGPk8nul7u7nCSRE6VBfF/5Egpx2Ks8m+ybFeCf+m/9ZPOYvhe79mLzsvthV4dts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245567; c=relaxed/simple;
	bh=eFIPeiFUiuVqpR82O+7D5Y1N1DVYXDn5v+Xx9sQpQ/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LEhqTiknZLKozwQ8LOnf38vYzqLg+XZCaBQS120lxGmkyvaMjFrSBVUqfr1MN5qYTpV83nea1s1KoPmqyTW7hMV9LGJfz/V/lO+ivLFGu3IyCwU5uXVdwhfk6BecK8oP3wDXF5jU9984O4VvRUOG6JpiYQVrZ/Fy1qUR2eFLD8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s/asW4K7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s/asW4K7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEAAAC4CEF0;
	Tue, 30 Sep 2025 15:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245567;
	bh=eFIPeiFUiuVqpR82O+7D5Y1N1DVYXDn5v+Xx9sQpQ/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s/asW4K7At/HVXPku2I1STP2phHjO97gvPliGazjrCRcQ+udvKRCbEtoQuv2PcECV
	 5XaL0TgwsrhSIpzyeLeudO1qrsByz/1YFz1HannZr9B/0Fgx8nlmVM1+4uEIhDoK6G
	 nmA8tslZ5wr46EFM7sua6vvoQJr5R8ixvBgd+uUM=
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
Subject: [PATCH 6.1 56/73] fbcon: Fix OOB access in font allocation
Date: Tue, 30 Sep 2025 16:48:00 +0200
Message-ID: <20250930143822.968849206@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143820.537407601@linuxfoundation.org>
References: <20250930143820.537407601@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2489,7 +2489,7 @@ static int fbcon_set_font(struct vc_data
 	unsigned charcount = font->charcount;
 	int w = font->width;
 	int h = font->height;
-	int size;
+	int size, alloc_size;
 	int i, csum;
 	u8 *new_data, *data = font->data;
 	int pitch = PITCH(font->width);
@@ -2522,10 +2522,10 @@ static int fbcon_set_font(struct vc_data
 		return -EINVAL;
 
 	/* Check for overflow in allocation size calculation */
-	if (check_add_overflow(FONT_EXTRA_WORDS * sizeof(int), size, &size))
+	if (check_add_overflow(FONT_EXTRA_WORDS * sizeof(int), size, &alloc_size))
 		return -EINVAL;
 
-	new_data = kmalloc(size, GFP_USER);
+	new_data = kmalloc(alloc_size, GFP_USER);
 
 	if (!new_data)
 		return -ENOMEM;


