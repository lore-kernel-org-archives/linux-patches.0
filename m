Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1170B1F4738;
	Mon, 21 Oct 2024 10:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507364; cv=none; b=NTpTC8m2nZWLAMePkHmSYg5BHljE0f3R0fCWzAeC8h1bYA0A/U0sy0p9pBlJN3y6BDUIKKdN77hv62e0pBNKf4lhjNDu0VYnhxPI7809y9l4vLWv+jzfFrwdhlg19uP9UVYVVIYsFjTfRbGx14a6bLZTh7lnPljuNA0kqyvbruo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507364; c=relaxed/simple;
	bh=yYnA+WxlFloSw268iNjOYYl2s+GBYeMyv1qMg07hD58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BziIooGN+9vBI0zXlLkSUzAv+HLCgd3zWT1wMCQFjjahAwXFF+7/rI0qd0pBHu3yjVnMk4hQGyHQE5wkRbudLS+0+HODGA1fmh43JBz0arFGHMMvoKKbCVVtpCtTPwQ7mvR2+kgnNBMPW+sj2qroFWOx2d4a4iUjgX0UGWMGX0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GPYk39T3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GPYk39T3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78721C4CEC3;
	Mon, 21 Oct 2024 10:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507363;
	bh=yYnA+WxlFloSw268iNjOYYl2s+GBYeMyv1qMg07hD58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GPYk39T3AwHtUoVj/CYJHKL2OeOsSajeqTG5zOvXpa3YRWpoNAAOSkkUCigNKga4E
	 DouZtTpUdhTpEgXBn5vDDUvYLhUYW9KBrcj4WrwqQhK0NglzRggrI7LIfKC0JR/dq8
	 aKMJggap/MaShAgMYqveqfpxciP7k+SJ99WKIquQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	amd-gfx@lists.freedesktop.org,
	Erhard Furtner <erhard_f@mailbox.org>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>
Subject: [PATCH 6.1 51/91] drm/radeon: Fix encoder->possible_clones
Date: Mon, 21 Oct 2024 12:25:05 +0200
Message-ID: <20241021102251.811649488@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102249.791942892@linuxfoundation.org>
References: <20241021102249.791942892@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit 28127dba64d8ae1a0b737b973d6d029908599611 upstream.

Include the encoder itself in its possible_clones bitmask.
In the past nothing validated that drivers were populating
possible_clones correctly, but that changed in commit
74d2aacbe840 ("drm: Validate encoder->possible_clones").
Looks like radeon never got the memo and is still not
following the rules 100% correctly.

This results in some warnings during driver initialization:
Bogus possible_clones: [ENCODER:46:TV-46] possible_clones=0x4 (full encoder mask=0x7)
WARNING: CPU: 0 PID: 170 at drivers/gpu/drm/drm_mode_config.c:615 drm_mode_config_validate+0x113/0x39c
...

Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: amd-gfx@lists.freedesktop.org
Fixes: 74d2aacbe840 ("drm: Validate encoder->possible_clones")
Reported-by: Erhard Furtner <erhard_f@mailbox.org>
Closes: https://lore.kernel.org/dri-devel/20241009000321.418e4294@yea/
Tested-by: Erhard Furtner <erhard_f@mailbox.org>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 3b6e7d40649c0d75572039aff9d0911864c689db)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/radeon/radeon_encoders.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/radeon_encoders.c
+++ b/drivers/gpu/drm/radeon/radeon_encoders.c
@@ -43,7 +43,7 @@ static uint32_t radeon_encoder_clones(st
 	struct radeon_device *rdev = dev->dev_private;
 	struct radeon_encoder *radeon_encoder = to_radeon_encoder(encoder);
 	struct drm_encoder *clone_encoder;
-	uint32_t index_mask = 0;
+	uint32_t index_mask = drm_encoder_mask(encoder);
 	int count;
 
 	/* DIG routing gets problematic */


