Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64BFE8634A;
	Mon,  6 Jan 2025 15:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178735; cv=none; b=Y6bM12axVawbSegdSeIXqEZfDJ5jrQW5IlcC+tXT3GuR0tQBFrgOoHuffaarjVIv0h8rRThYzm39YVUWgBh/7SdkWdfsVmq/HledQ+wu0Ml7nsI4Bs3LEMj2OvXLP4fxdwGOx3WtjY1FSL99Uikys1RGckOJ9Ue2Ld3oRZWXtj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178735; c=relaxed/simple;
	bh=OqSnRGruXUP7EKdk3Cm+ph9A9nBt0YWW2O41CCogQPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XTzSyLmk/RfgBI4VF+3UV8dtOdYfdZs+FMxUbKRW97gLEvUBEV/cb0UsXm+nrqd/B5ei8qeqJHQsp5JBO+HkZ8RmRPDSsv6q38jc4pK92a35juq/I19euBskXs83mCtAlmyFfvIdW+Ef+7n33UtR50RCBUs5sJ1QqbVvvdPeZ1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bYRG8ekl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bYRG8ekl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D130C4CED2;
	Mon,  6 Jan 2025 15:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178734;
	bh=OqSnRGruXUP7EKdk3Cm+ph9A9nBt0YWW2O41CCogQPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bYRG8eklJOI4dZmatAUlLjGT3Pm0aWvXhKSHslmgYn8T5B+DCdLoJEjscuo9HXhrM
	 eiXzloU+Vjw+hlJZX5RNj1xPMCFR4MK6mjlMvqSQ+CbroLeQleEKThgvGtuniQ0+MI
	 ecu5JW3tK7t+acDiCGEXvYLDyeHa8WK9/DQgtzts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+622bba18029bcde672e1@syzkaller.appspotmail.com,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.15 033/168] drm/modes: Avoid divide by zero harder in drm_mode_vrefresh()
Date: Mon,  6 Jan 2025 16:15:41 +0100
Message-ID: <20250106151139.714179001@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
User-Agent: quilt/0.68
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
@@ -757,14 +757,11 @@ EXPORT_SYMBOL(drm_mode_set_name);
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
@@ -772,6 +769,12 @@ int drm_mode_vrefresh(const struct drm_d
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


