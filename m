Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590186;
	b=lZADRt0aQ+TBk2JiCzmao+on+qF/nHfDolqvvuCOypozLgI2A24kURJOVm5t4Bb0YA6K
	 3FEgboWAX94zbnQ07eDpnKBWKG2hnRzLSd1RKYdgj6chuVq9+GlCZeKgPnGVkwCz8syW/
	 gkDwkuqgVUXiCbletHKwIemFkZdSAIPvCbqAZh7ags8/q3K3hygOexebHIBKHXVgapwz9
	 xFI+nFzomwFqKIE8JB+mIyyUOkI5AAv8HTiq2PAqRZcP5ZGR6olAYKHfKKLrkltdzbLio
	 UKPQVxHAWPoDcDiDGoEPxOpnorZDIUtGtexGPWNTzfjGAXuq/BmVvK1q2itUR4URC0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590186;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=g3umUmpQ3kk6pLVMAXhppbodP5hcrCWAV6OQczEHp98=;
	b=Bu+aGItql5riPb9RpTE7ISxAs5FCzWZRSnqRkJY9vFy1cQ/g8jdvzZ2Oz4htJ1MYuIHb
	 n9fKZS0RgpT4Nn9U18ZqZvuXn5AQN3FIdP4sFIG4LY5kVy4cIpuTo6abDEtUiyUBVq1Gt
	 GBxpL7/fJ/SlKeiQT1aVknaupt8HK61u7rY8e/VpkE9sSS+oMW26dvQN1UkFpCt1abWTX
	 XnfKDW3ruPpp3CLsi7vafnspHWQSCOG4oHOE0EdPtjMf6wqigEcCXgPyc7swKJRWcqy6x
	 7N1h1/mnMBBjrYzr/y3D/b+Fg7BTWJRFX07vr6+LiJdSQrnrtdbwnuWsOF5bl+Cevrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HP+ClUN3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CCD2606B83F;
	Fri, 13 Nov 2026 17:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HP+ClUN3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD4811F000D0;
	Fri, 13 Nov 2026 17:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590185;
	bh=g3umUmpQ3kk6pLVMAXhppbodP5hcrCWAV6OQczEHp98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HP+ClUN3pb0tMEz8O42sh1DwoZLTg2TN8o8FYpL9Db+czZtL7rRUPZAGZdrZ7AI6E
	 HAy8g7lhB+aih9vGg67PaR6m+2GevESZSzMYr8j/PWEY1p+9G/fRASh6SDItcQlUz6
	 4m8MXzY7peT5bQJMF7ktRqQHcbb2CNkHWBsbUSdY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Jocelyn Falempe <jfalempe@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 195/686] drm/panic: Fix kmsg screen hang on a long log line
Date: Fri, 13 Nov 2026 10:45:28 -0500
Message-ID: <20261113153827.646505811@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Devin Wittmayer <lucid_duck@justthetip.ca>

[ Upstream commit 1ba6405638439a4214783965538b0196c8de8a5b ]

The kmsg panic screen reads the log back one chunk at a time. A record
that does not fit in a chunk comes back empty without moving on, so the
screen asks for it again forever and the panic never finishes. Every
oops logs the list of loaded modules, and on my machine that list does
not fit.

Read into a buffer the size printk formats one record into, and stop if
a read still comes back empty.

Fixes: 54034bebb22f ("drm/panic: Add a kmsg panic screen")
Cc: stable@vger.kernel.org
Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
Reviewed-by: Jocelyn Falempe <jfalempe@redhat.com>
Link: https://patch.msgid.link/20261016052722.60051-1-lucid_duck@justthetip.ca
Signed-off-by: Jocelyn Falempe <jfalempe@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_panic.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_panic.c b/drivers/gpu/drm/drm_panic.c
index 9c4ac2febc931..17b795a18d2cd 100644
--- a/drivers/gpu/drm/drm_panic.c
+++ b/drivers/gpu/drm/drm_panic.c
@@ -562,7 +562,8 @@ static void draw_panic_static_kmsg(struct drm_scanout_buffer *sb)
 	const struct font_desc *font = get_default_font(sb->width, sb->height, NULL, NULL);
 	struct drm_rect r_screen = DRM_RECT_INIT(0, 0, sb->width, sb->height);
 	struct kmsg_dump_iter iter;
-	char kmsg_buf[512];
+	/* the size printk formats one record into, too big for the stack */
+	static char kmsg_buf[2048];
 	size_t kmsg_len;
 	struct drm_panic_line line;
 	int yoffset;
@@ -580,6 +581,10 @@ static void draw_panic_static_kmsg(struct drm_scanout_buffer *sb)
 		char *start;
 		char *end;
 
+		/* a record that does not fit comes back empty, every time */
+		if (!kmsg_len)
+			break;
+
 		/* ignore terminating NUL and newline */
 		start = kmsg_buf + kmsg_len - 2;
 		end = kmsg_buf + kmsg_len - 1;
-- 
2.53.0



