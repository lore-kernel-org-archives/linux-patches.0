Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57CCB19E98B;
	Mon, 23 Dec 2024 16:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970402; cv=none; b=PHMGahUnIpz6mI0AuTqMfmHg/IwDKR6wJk+a68FkHPVOEEa7VFJcAPGFTbHjYKmjb6cEHgmuYsc5PfWxNlxA6mU+4mUWKWNaVqD9NIgTGKZ7mrKDSzd5fWa0gRKsacMfGsk2aP85A4ii6MBefNmJKxsqbjfg7Xq1EvlA64ztvZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970402; c=relaxed/simple;
	bh=0/3/DoYOsdoDUtbPUXYVigoKSE0LZmq0uJK4EPRbaJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TNMmQ4T1NIPkqXFUQHbt1mydoUJzwDQT5uQsIMh9EzBPbedn9kPkqLceZqotChq4pDB7Bp5FymD0L91MjdjraN28jVlojLs4m7vYPVTtCVR9PGcq8ASpv1BGZNA6NDWy5EdasvIuBk0ax1IqMWiIC5G1VcC/U/hJ/XuRuKpkyoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cXJcGQfo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cXJcGQfo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87D8EC4CED3;
	Mon, 23 Dec 2024 16:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970402;
	bh=0/3/DoYOsdoDUtbPUXYVigoKSE0LZmq0uJK4EPRbaJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cXJcGQfooQOsEt7tjwWsgzb0d7R3niZi278vtG/TN3a2TPORcyPqBi5ILm6fnVDKX
	 LYZM2lju884T4kaeT9dgR41ueqCMNO+YiA+40zur3XmG4QJc9Dn7w6pYPxjwK9e2qN
	 neu8qXLxYTnTOk3uA2LvJ3rTJjlxm/PKnZF9E0OU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+622bba18029bcde672e1@syzkaller.appspotmail.com,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 6.6 073/116] drm/modes: Avoid divide by zero harder in drm_mode_vrefresh()
Date: Mon, 23 Dec 2024 16:59:03 +0100
Message-ID: <20241223155402.402267487@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155359.534468176@linuxfoundation.org>
References: <20241223155359.534468176@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit 9398332f23fab10c5ec57c168b44e72997d6318e upstream.

drm_mode_vrefresh() is trying to avoid divide by zero
by checking whether htotal or vtotal are zero. But we may
still end up with a div-by-zero of vtotal*htotal*...

Cc: stable@vger.kernel.org
Reported-by: syzbot+622bba18029bcde672e1@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=622bba18029bcde672e1
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241129042629.18280-2-ville.syrjala@linux.intel.com
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_modes.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/drm_modes.c
+++ b/drivers/gpu/drm/drm_modes.c
@@ -1285,14 +1285,11 @@ EXPORT_SYMBOL(drm_mode_set_name);
  */
 int drm_mode_vrefresh(const struct drm_display_mode *mode)
 {
-	unsigned int num, den;
+	unsigned int num = 1, den = 1;
 
 	if (mode->htotal == 0 || mode->vtotal == 0)
 		return 0;
 
-	num = mode->clock;
-	den = mode->htotal * mode->vtotal;
-
 	if (mode->flags & DRM_MODE_FLAG_INTERLACE)
 		num *= 2;
 	if (mode->flags & DRM_MODE_FLAG_DBLSCAN)
@@ -1300,6 +1297,12 @@ int drm_mode_vrefresh(const struct drm_d
 	if (mode->vscan > 1)
 		den *= mode->vscan;
 
+	if (check_mul_overflow(mode->clock, num, &num))
+		return 0;
+
+	if (check_mul_overflow(mode->htotal * mode->vtotal, den, &den))
+		return 0;
+
 	return DIV_ROUND_CLOSEST_ULL(mul_u32_u32(num, 1000), den);
 }
 EXPORT_SYMBOL(drm_mode_vrefresh);


