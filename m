Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C9EF2CA6;
	Thu, 13 Jun 2024 12:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282628; cv=none; b=vA0/zo3cfTSEwst75jiFvrih5kIVTbe2z+hs3vfgvhZ77NtbhRU7bhCUKcLJ2X53avHn2ifPEZWcanKcsHOfXKUEQo6Nzs/ExHrfvth/7K798S9jek4rFvRebLxCE5bX3nVQWABWpjAfnw1s7p9CpFZDryn9bkaPz32P+EdtA78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282628; c=relaxed/simple;
	bh=Lj6aXx1pGJufDYqfiqJoKGeOlgudeGjjQfFZjSxssw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VFzo0GdcCL9uQxkI8yAbHLqlqClX7lI4iM9XDzbF1a0Siy/TeSMFLdoPkQEeJUxIhtdAh13VSRP3IXZeKYNnUwgRi2Yt3/tHjwqenG3hk9u4002/By1f9olxAVq0ggGRU3e5ZSkRmynI17l66fZl5TrLw3bJ2rvBsplFlei713M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dUH/nyHK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dUH/nyHK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17F7BC4AF1C;
	Thu, 13 Jun 2024 12:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282628;
	bh=Lj6aXx1pGJufDYqfiqJoKGeOlgudeGjjQfFZjSxssw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dUH/nyHKQ6XILB3/Z3qD8CDCZzFoYzM2OVYfJPJRf41RlKVbnvy/BO7OxeV1M9tPm
	 mhi4GHtt08ZCySC3RR5yUu97q4xmjukx0TQ8EWGW3icBUtjoROX5Or1NcD3abpc0Pm
	 pwVKiEY+tHxjouWVuUlttA9yX5fo64okuPQRZb8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <oliver.sang@intel.com>,
	Shradha Gupta <shradhagupta@linux.microsoft.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 5.15 341/402] drm: Check polling initialized before enabling in drm_helper_probe_single_connector_modes
Date: Thu, 13 Jun 2024 13:34:58 +0200
Message-ID: <20240613113315.434170602@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shradha Gupta <shradhagupta@linux.microsoft.com>

commit 048a36d8a6085bbd8ab9e5794b713b92ac986450 upstream.

In function drm_helper_probe_single_connector_modes() when we enable
polling again, if it is already uninitialized, a warning is reported.
This patch fixes the warning message by checking if poll is initialized
before enabling it.

Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202401191128.db8423f1-oliver.sang@intel.com
Signed-off-by: Shradha Gupta <shradhagupta@linux.microsoft.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/1706856224-9725-1-git-send-email-shradhagupta@linux.microsoft.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_probe_helper.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/drm_probe_helper.c
+++ b/drivers/gpu/drm/drm_probe_helper.c
@@ -498,7 +498,8 @@ retry:
 	}
 
 	/* Re-enable polling in case the global poll config changed. */
-	if (drm_kms_helper_poll != dev->mode_config.poll_running)
+	if (dev->mode_config.poll_enabled &&
+	    (drm_kms_helper_poll != dev->mode_config.poll_running))
 		drm_kms_helper_poll_enable(dev);
 
 	dev->mode_config.poll_running = drm_kms_helper_poll;


