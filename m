Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591017;
	b=esES+4QN+rsQpyV5w99qwGD2yew1nNgLX2LH4M5S9AYuLsQI4J/loaKIZF2auK4PZpeS
	 DvrS6xESCtbu3PZ7nP5jJ/kDEp61Mv2aKoYEoISkKSFBSiCFfoRkigg1s0QrVVebgRxTJ
	 gmY3caxJgC/2QgSGY02jeDkKjyyFP8M3Sfbttnx+U7Lj6c801qIXHWYg6M3dEGrOisb5I
	 xwP8Q7ZtQ7ou7E6udHS9BqZKnZQlX8mwfmmBLEfWeiitTZMHx9rSuqm311I+4QDr94ybE
	 6Hr8917vOkbhUTaSSJRsUFIy6Z15ZHAtKHy25aVQsE9HI9nAlHDh2rAvIZmVimS9YTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591017;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=X1FEbyJwtUsNw4NtHs6AD0dn5x/1qYR/NeNrjggJD4w=;
	b=PI6sa3TiDTY8VNgWf8QjZY+6n2YZUwzRpDoYc7E8C1Tf7J3HJOPYCmtitdYUYlbEjZCT
	 OK+KSXAObce+MooVgQYDcjOyYSr4OND997DrA/swY1ozYdTUb8QpLE2Gjj3VEm0pA3iJB
	 S+9e83sOBfMkr9NMpj6iwiW3H6BkWOWE5BMdD8dQuRXH887k//Rjlj1jjF11TfT+PTgt3
	 nSpEFGrmeOmbZ1ybnrWjqUfVIWke+yHTqA/aCOfurd3WPh8vfg5uimDMN5T9/5tFsybL5
	 wT2qA9jWca9k88GfNoLgnt7VZGz2v9YWSUO9nsmxuFgIQtbu/O5Q+c4EF3PXKA/dCAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fkJ3tuCl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F7EB6070F26;
	Fri, 13 Nov 2026 17:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fkJ3tuCl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24C7C1F000C4;
	Fri, 13 Nov 2026 17:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591017;
	bh=X1FEbyJwtUsNw4NtHs6AD0dn5x/1qYR/NeNrjggJD4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fkJ3tuClLKY95f/3WxIJQ+8I+t2TeXn73Ws5QmdOYLD9+mTbm5e2HJPqBPROlXbuo
	 6Fi4qwip3PXWlrkFb+zmCa7KkvjvqyyiBJIUXoRazLrcl7aQ+vCb0NyCNrGxz5TB1r
	 nV93tRcr8ExiYlYXAfEgqWhln2H3iXi7oW4RwFUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Jocelyn Falempe <jfalempe@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 184/670] drm/panic: Fix kmsg screen hang on a long log line
Date: Fri, 13 Nov 2026 10:45:48 -0500
Message-ID: <20261113153818.258241270@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 0aa87eafdacd5..06f0aa1cb4f74 100644
--- a/drivers/gpu/drm/drm_panic.c
+++ b/drivers/gpu/drm/drm_panic.c
@@ -395,7 +395,8 @@ static void draw_panic_static_kmsg(struct drm_scanout_buffer *sb)
 	const struct font_desc *font = get_default_font(sb->width, sb->height, NULL, NULL);
 	struct drm_rect r_screen = DRM_RECT_INIT(0, 0, sb->width, sb->height);
 	struct kmsg_dump_iter iter;
-	char kmsg_buf[512];
+	/* the size printk formats one record into, too big for the stack */
+	static char kmsg_buf[2048];
 	size_t kmsg_len;
 	struct drm_panic_line line;
 	int yoffset;
@@ -413,6 +414,10 @@ static void draw_panic_static_kmsg(struct drm_scanout_buffer *sb)
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



