Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF3A61E9B3D;
	Thu,  3 Jul 2025 15:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555198; cv=none; b=NZAsWn2g7fBsaLNEKFlgcHYpGNP3Ai7gEWZGyvGuF1XnbS+0VzryPK2fl/8E1YpwCP6JIGg1Iy8402jUhzT+G8iZkHTdiIUOK6BP79XDQjsDEnu/6XyDr8YgqdPTmc00IxIVruxqijBnnLQx6TDYszoqRa5ThY2QmFm4xhmEfQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555198; c=relaxed/simple;
	bh=MEGYntyt9hyAqWBGcSdXDZ5MvMa/5h2EbgN/wG+3k2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KFU2iGY6wzrhzvO4O8p97CPecydKj5RlFYb1bHMuIMrAb+JbhJEUUswgG3JSplQRAn/YVmpfD+PrVPpWwv8xotNyjfU2QpqRgoIfaT5d7YJM0wHJ1BDjYoQLayYFMsuMjBwpz12z35YXTJm8rTgUkdbqd4wXFHr0qufQTHkyWYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j9NuIS1S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j9NuIS1S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B1DFC4CEE3;
	Thu,  3 Jul 2025 15:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555197;
	bh=MEGYntyt9hyAqWBGcSdXDZ5MvMa/5h2EbgN/wG+3k2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j9NuIS1SiR6Phgt9T1IcK2QlT0RR9TuLxo10pUKvtYHxjJPGYqmWkPaSIs2xRUY/M
	 9R0apNWkhahf/5XMdepx4hWN7uPK4dNFKkjw5JEhNQApwpduiaWi9SZahls/CW/XaE
	 pQjr6iGWrW2Q5k0tYxCGcpTRlBQ4FcSxKENMc+K8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Jocelyn Falempe <jfalempe@redhat.com>
Subject: [PATCH 6.15 206/263] drm/simpledrm: Do not upcast in release helpers
Date: Thu,  3 Jul 2025 16:42:06 +0200
Message-ID: <20250703144012.629268777@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

commit d231cde7c84359fb18fb268cf6cff03b5bce48ff upstream.

The res pointer passed to simpledrm_device_release_clocks() and
simpledrm_device_release_regulators() points to an instance of
struct simpledrm_device. No need to upcast from struct drm_device.
The upcast is harmless, as DRM device is the first field in struct
simpledrm_device.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Fixes: 11e8f5fd223b ("drm: Add simpledrm driver")
Cc: <stable@vger.kernel.org> # v5.14+
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Reviewed-by: Jocelyn Falempe <jfalempe@redhat.com>
Link: https://lore.kernel.org/r/20250407134753.985925-2-tzimmermann@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/tiny/simpledrm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/tiny/simpledrm.c
+++ b/drivers/gpu/drm/tiny/simpledrm.c
@@ -284,7 +284,7 @@ static struct simpledrm_device *simpledr
 
 static void simpledrm_device_release_clocks(void *res)
 {
-	struct simpledrm_device *sdev = simpledrm_device_of_dev(res);
+	struct simpledrm_device *sdev = res;
 	unsigned int i;
 
 	for (i = 0; i < sdev->clk_count; ++i) {
@@ -382,7 +382,7 @@ static int simpledrm_device_init_clocks(
 
 static void simpledrm_device_release_regulators(void *res)
 {
-	struct simpledrm_device *sdev = simpledrm_device_of_dev(res);
+	struct simpledrm_device *sdev = res;
 	unsigned int i;
 
 	for (i = 0; i < sdev->regulator_count; ++i) {


