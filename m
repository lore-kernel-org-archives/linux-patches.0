Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F3B323A995;
	Tue, 30 Sep 2025 15:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245853; cv=none; b=tARMDiDPCMqQX1fpEVL0u2tHWABHzfA0BGtj+snJ7C10gmnYn1IW4w57ieHN9o408kz+G/M9nnvftdP41BTduCDmbU8keSRL6rxtFiAs/5UYiM4IjCZ9+6n6/WT2qcXI8bbc33OJ9O+6Yi36390jMRmoP9vzKD9L2AWWROSvlhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245853; c=relaxed/simple;
	bh=pLx0jorEQnAfS8dwoW3HtcJxm/HnLBd8jT0nBluVP8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ABBj0VyUWJL4bMfPa3z3u6Kg9qW3eOZz92DBQonjcmmFCcpy4pbwMvu+Vtchb3D9anq7Sg6xOSLZfqY6+4PEBCVtBiRGAQP0voaebTSs39gCuv7ZX6OvFz9eGFI3Y9+C7x4qNjAsLrIz62oq8b2E1DyBvlrxd8mXRb7HkjsjZ4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nvoHm4QQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nvoHm4QQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92617C113D0;
	Tue, 30 Sep 2025 15:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245853;
	bh=pLx0jorEQnAfS8dwoW3HtcJxm/HnLBd8jT0nBluVP8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nvoHm4QQveEtAacltg6Uk1VkZ15odt/+bcKbhZw5elrAboBj5kDL5FEVJ6Q9y/oGP
	 X78Au+kHpbtEbxT4FptQt9fTItB18bkESOzXkyTSI9wLCrlLOkdHaXv8ctXAGbF2iD
	 FZuBX6CAW99l7Isshwyd91WQEMYq5IJarwDTLgdE=
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
Subject: [PATCH 6.6 70/91] fbcon: Fix OOB access in font allocation
Date: Tue, 30 Sep 2025 16:48:09 +0200
Message-ID: <20250930143824.092961622@linuxfoundation.org>
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
@@ -2483,7 +2483,7 @@ static int fbcon_set_font(struct vc_data
 	unsigned charcount = font->charcount;
 	int w = font->width;
 	int h = font->height;
-	int size;
+	int size, alloc_size;
 	int i, csum;
 	u8 *new_data, *data = font->data;
 	int pitch = PITCH(font->width);
@@ -2516,10 +2516,10 @@ static int fbcon_set_font(struct vc_data
 		return -EINVAL;
 
 	/* Check for overflow in allocation size calculation */
-	if (check_add_overflow(FONT_EXTRA_WORDS * sizeof(int), size, &size))
+	if (check_add_overflow(FONT_EXTRA_WORDS * sizeof(int), size, &alloc_size))
 		return -EINVAL;
 
-	new_data = kmalloc(size, GFP_USER);
+	new_data = kmalloc(alloc_size, GFP_USER);
 
 	if (!new_data)
 		return -ENOMEM;


