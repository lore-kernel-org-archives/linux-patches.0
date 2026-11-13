Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585387;
	b=TaiKd3VLatOXNjimEmSL4BBFzPx+nsDE0Pg4VvpQ9kdwky4R3IaV86qRbSaP5Jr+iO9t
	 TbluzMqJfZns2JcfGvOlnE3q89MCT252qx8ZwflOUshyBKlUoEpuJ9M8RcYVzeG2qK9vY
	 SrkL0+DAolyLCHDaTdeNoa+M0t+yhVCZemhigP8V0adAs8JEAZd4oA0EwEAJcCrphmgC1
	 hJVhE6YKz1cS1zHQt2bp3ABOgV7f7Yho9aKSfoxu3r6bfFBeEoicrR4J0gKAsLShU9jkD
	 MYuUz3kzZ70Wr7o7f6GPDHgptjOGC7LU5eqd9IUR1hekkS2CsTeDJ/eYaeiVHbU3dxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585387;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7P70gaZXJmqFznrLJM14hO57AZKHDfvI0s6KJWXO05A=;
	b=UCFd8+BvfTOgrFZZYQf8QnytLeMJLlZAeP4hdIXf2gvBZcZLFJ6/nKDmh1aokNdoW1ty
	 R/4a/t13nT0su32Hzazv747Y3jfHCjO4V5P3tQ4iNPqQk5ki+fWMdvE0VWJ0F1WSnBDKJ
	 JYlg7F8Y8QbfUhR3cQM2qAteY8dpYS4MQfekkfkn3wE4JKxNd+8DBjP9ksSE15Vidjd1F
	 5Pqp8Wh7/4VGnxFh6pUle4pP8yIkqGcqsLAdbwuvDtkY7sLdw/1HQvgnqFcuTrZ5CJiX2
	 hQHVYJxBH+oZglQ607oFf1cH3ENZ+NphcT0nV9GOoSYZRUTVI0vvSFiXQHBppXxlM7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PqLVnjMv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E8D4607023A;
	Fri, 13 Nov 2026 15:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PqLVnjMv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CE911F000CB;
	Fri, 13 Nov 2026 15:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585387;
	bh=7P70gaZXJmqFznrLJM14hO57AZKHDfvI0s6KJWXO05A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PqLVnjMv1gnOfS7dfy2owGrn76Ziv1dLGbB6ll2u1EMEKz6eVAbPDcX/KVBUISCXl
	 zs3uXa0BL4mWy9mRhPJUSY+pQF0RXaxLdLqcNGQTtT/J2q6tM1zy770bVmpbGtHymy
	 QrnLJonkGmpHqo/B5R0EBBJVwnLxZTnyzMxLGs5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Jocelyn Falempe <jfalempe@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 060/507] drm/panic: Fix kmsg screen hang on a long log line
Date: Fri, 13 Nov 2026 10:46:04 -0500
Message-ID: <20261113153755.592361194@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index d28ce8878e055..fef47625c5268 100644
--- a/drivers/gpu/drm/drm_panic.c
+++ b/drivers/gpu/drm/drm_panic.c
@@ -558,7 +558,8 @@ static void draw_panic_screen_kmsg(struct drm_scanout_buffer *sb)
 	const struct font_desc *font = get_default_font(sb->width, sb->height, NULL, NULL);
 	struct drm_rect r_screen = DRM_RECT_INIT(0, 0, sb->width, sb->height);
 	struct kmsg_dump_iter iter;
-	char kmsg_buf[512];
+	/* the size printk formats one record into, too big for the stack */
+	static char kmsg_buf[2048];
 	size_t kmsg_len;
 	struct drm_panic_line line;
 	int yoffset;
@@ -576,6 +577,10 @@ static void draw_panic_screen_kmsg(struct drm_scanout_buffer *sb)
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



