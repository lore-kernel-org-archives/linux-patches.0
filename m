Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10179302158;
	Mon, 27 Oct 2025 19:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592978; cv=none; b=oKgCd+D+RfoSt5vKfROhR9DhuCaUbzNV0oowYEEAGNIkw3g3BcYFRjQGhHkol9YvUOkjH0pLeN4NW2N1Cok3+xeBp62fYyZHTdbkITOhU6k6gBQo95zIDFZn3LHrnlmc0vyJfKImJKSTqiI2B1jvwiZRPlpnzJieRS4PRtdNn6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592978; c=relaxed/simple;
	bh=KdFX6NIIbNrEjnFf+NrvYRYuKfK8kKidJ/L7rmaLw0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EmaqerlDv4ReqlbZOzCSNdEcGTJ992+vr1kHpHsFdz2S4NI+qabM7faRLRTjqBcM/It3PZjIDSJliy4ymPmmeF+rTK2IZu41hK1knrdbyzasCsgYrsy1xUbh7jmrSm0XQOnYerM8XBtyOWZzBdHMyWozlasgT59ae4vP1pikhso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QRhvKB7m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QRhvKB7m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27B98C4CEF1;
	Mon, 27 Oct 2025 19:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592977;
	bh=KdFX6NIIbNrEjnFf+NrvYRYuKfK8kKidJ/L7rmaLw0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QRhvKB7mhopiyZZcvP1RZw0sRRmcgltkBMPBALwEgw5X9+wcpiU3xOLMOWhwnGWdw
	 Z3kA7vomG8SshXFr/se2hspYCJFmuKt4WnZKsDQXBKONbI8iToSyVIRaf7jnfGSYOG
	 +gGnIxHvDI90+F90zd6B4AM9Cyn/PVX7uI6hiDms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Martinez Canillas <javierm@redhat.com>,
	Jocelyn Falempe <jfalempe@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 085/117] drm/panic: Fix drawing the logo on a small narrow screen
Date: Mon, 27 Oct 2025 19:36:51 +0100
Message-ID: <20251027183456.325931181@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183453.919157109@linuxfoundation.org>
References: <20251027183453.919157109@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jocelyn Falempe <jfalempe@redhat.com>

[ Upstream commit 179753aa5b7890b311968c033d08f558f0a7be21 ]

If the logo width is bigger than the framebuffer width, and the
height is big enough to hold the logo and the message, it will draw
at x coordinate that are higher than the width, and ends up in a
corrupted image.

Fixes: 4b570ac2eb54 ("drm/rect: Add drm_rect_overlap()")
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://lore.kernel.org/r/20251009122955.562888-2-jfalempe@redhat.com
Signed-off-by: Jocelyn Falempe <jfalempe@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_panic.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/drm_panic.c b/drivers/gpu/drm/drm_panic.c
index f128d345b16df..932a54b674794 100644
--- a/drivers/gpu/drm/drm_panic.c
+++ b/drivers/gpu/drm/drm_panic.c
@@ -306,6 +306,9 @@ static void drm_panic_logo_rect(struct drm_rect *rect, const struct font_desc *f
 static void drm_panic_logo_draw(struct drm_scanout_buffer *sb, struct drm_rect *rect,
 				const struct font_desc *font, u32 fg_color)
 {
+	if (rect->x2 > sb->width || rect->y2 > sb->height)
+		return;
+
 	if (logo_mono)
 		drm_panic_blit(sb, rect, logo_mono->data,
 			       DIV_ROUND_UP(drm_rect_width(rect), 8), 1, fg_color);
-- 
2.51.0



