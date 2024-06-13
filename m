Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DE0A1E49B;
	Thu, 13 Jun 2024 12:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282862; cv=none; b=mCPtlesnJdxBXWiu6a4bWVcwRSVbLWdhDcBnNsXILXIGi8c+vnRvooM6/oL2fMfX1pRzfnwHSsxlG8ghgxAobjeVS6zhkWQMi+ofiEeSPBk2yR3YpMIjsOZUzn4yzZ3AT1cSfKo1g6MtWaCOGM7v3V8IGhQq+nwRiSMvMVhgQzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282862; c=relaxed/simple;
	bh=9uLpRcn94snOYOzVqGdbk8lGft9ucpdtRjFVHYC0vss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C+Df9nRty/Z0M6MO3g4/X2bUMfgQiueREDInxGtMTu2vIaqfaJLTHgwQdsJ8NZC7F7dLg+YdGDoWS8PbVXAXWM6aeeDFOHB+gWtnaV1pcpJ103mOijMtpI0mfgC4+gxBFVQbwDYHuBPrtX1G0dMpeubylMBeiQ2SNoBxs49nwWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qzkV/gJd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qzkV/gJd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E8DDC32786;
	Thu, 13 Jun 2024 12:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282860;
	bh=9uLpRcn94snOYOzVqGdbk8lGft9ucpdtRjFVHYC0vss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qzkV/gJdoeQTzOAlq1vOI8wbp4RxmNkxRNyLkzkhFIcNi4HpzCmWC+qUAjeJisJWy
	 A2bB5atotVpRbL7/YO4Y8D4yxiRX5UpBpPi5yjqZecLuDPW+ubxb/v7bc33vIN5Pj7
	 n0e7QEPutCrTUEZj6CbYm0Rvrx1W1F8JHKN//0Y0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <oliver.sang@intel.com>,
	Shradha Gupta <shradhagupta@linux.microsoft.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 6.1 02/85] drm: Check polling initialized before enabling in drm_helper_probe_single_connector_modes
Date: Thu, 13 Jun 2024 13:35:00 +0200
Message-ID: <20240613113214.232579459@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113214.134806994@linuxfoundation.org>
References: <20240613113214.134806994@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -574,7 +574,8 @@ retry:
 	}
 
 	/* Re-enable polling in case the global poll config changed. */
-	if (drm_kms_helper_poll != dev->mode_config.poll_running)
+	if (dev->mode_config.poll_enabled &&
+	    (drm_kms_helper_poll != dev->mode_config.poll_running))
 		drm_kms_helper_poll_enable(dev);
 
 	dev->mode_config.poll_running = drm_kms_helper_poll;


