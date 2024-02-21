Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A719469953;
	Wed, 21 Feb 2024 13:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522264; cv=none; b=JVbR2KtFu3jjlfgTZUSYmgaJFwN4EN6EAajMuFkFEXC1QOxydKFN23GoXcpw+4oVG3ymfcGe7HoGQX1sAlNzDupN4+MM9nHx4o7IQ0YCHnmJ5t66KbcdPKyErZEGKqzEvschWgnhK8qH5viUESTi4lRwkqVZxjKwcyqY9JrnsoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522264; c=relaxed/simple;
	bh=Zy8qwI/HfZ617pVfx53YnJHRNN8t/VXvTN6JM1NsC2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X04WKWyndwvkkbeiJTrUmFhEsR8vPusY3lW7XK1LQcA1GYmpEwCn+KKvhEq892Sswv/+aFTF90JM9lqOaHq58ALzhnyJ8Py0nRTE0lZqTmm/0tttXak5igL3Ge7tneEa6SwK9YjtH0wAKmH+j99OjR7QGgWdq7vjsUhpisP/528=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ytnue/Oz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ytnue/Oz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A77DC43390;
	Wed, 21 Feb 2024 13:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522264;
	bh=Zy8qwI/HfZ617pVfx53YnJHRNN8t/VXvTN6JM1NsC2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ytnue/OzTYzL1mJaO/TujwGnlqN6aMUwMp7gYEIwSJivwKkGDrSwv0qFnNV7qSmnx
	 fHNLXNSBHCAnkPD83jDRC4XdURZWd+Hc0dSOKrFNJoizStZbw3FEd6+x7BjqwSi/lZ
	 Cwbj9Mh9TLeWqnueL1Xhifru3XHv0DktcEVG/WQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Javier Martinez Canillas <javierm@redhat.com>
Subject: [PATCH 5.15 091/476] drm: Dont unref the same fb many times by mistake due to deadlock handling
Date: Wed, 21 Feb 2024 14:02:22 +0100
Message-ID: <20240221130011.352997368@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit cb4daf271302d71a6b9a7c01bd0b6d76febd8f0c upstream.

If we get a deadlock after the fb lookup in drm_mode_page_flip_ioctl()
we proceed to unref the fb and then retry the whole thing from the top.
But we forget to reset the fb pointer back to NULL, and so if we then
get another error during the retry, before the fb lookup, we proceed
the unref the same fb again without having gotten another reference.
The end result is that the fb will (eventually) end up being freed
while it's still in use.

Reset fb to NULL once we've unreffed it to avoid doing it again
until we've done another fb lookup.

This turned out to be pretty easy to hit on a DG2 when doing async
flips (and CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y). The first symptom I
saw that drm_closefb() simply got stuck in a busy loop while walking
the framebuffer list. Fortunately I was able to convince it to oops
instead, and from there it was easier to track down the culprit.

Cc: stable@vger.kernel.org
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20231211081625.25704-1-ville.syrjala@linux.intel.com
Acked-by: Javier Martinez Canillas <javierm@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_plane.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/drm_plane.c
+++ b/drivers/gpu/drm/drm_plane.c
@@ -1378,6 +1378,7 @@ retry:
 out:
 	if (fb)
 		drm_framebuffer_put(fb);
+	fb = NULL;
 	if (plane->old_fb)
 		drm_framebuffer_put(plane->old_fb);
 	plane->old_fb = NULL;


