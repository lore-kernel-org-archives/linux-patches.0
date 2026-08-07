Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC6C938E8AD;
	Fri,  7 Aug 2026 15:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115774; cv=none; b=C8jjgvxb7mlBRW1CJPqM3WgjyIzAaIp/VEIz97sFQL0413p1bjZkPblkJCkbatxJAxV5i5ptRfpIenqHFlDWMgS/M7/qWNvVs8wgVuOeQRKXvcYaI4yf6f9bek1pgxjFrERFvER1IHccbnpuKCvc4Yo9eVE+hEvScGcYIpatzZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115774; c=relaxed/simple;
	bh=/g5WgO1PoYrHdTJ+jHMUIaKvtCM8BcNEkKFceoupsxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HW3wS2EnVsH+zSJ3IVmnDAngmCA5xq8x0drOIByVzFzmHbY7x8izK6N7WHznu9S7QeIqLVCfl2X0wVHBkY2CMATLxWRgJbfHdp+QioSOFLcV5ZgUhw2bctJA54jKsVFI7i/Rxk/2b4I5/rOE27Xa4zdCQvFedtRA6HB78gu7qxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XzVH6wKa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XzVH6wKa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 213621F000E9;
	Fri,  7 Aug 2026 15:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115772;
	bh=mOANX36/uWAbXsp8FCjh1aGIfRK6Q3iujFwgjqsmyC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XzVH6wKamUfn8GmGHbZuq8kFTZpRuwYE9X5Gwz7eXNxpUEoyvGP5atwpNkokEEdHU
	 toTY1TjlsBaoYJ3LUGrm87f0J2usijltd1UOEnb7c0yfcooSQupWyJf3quwlph17Fb
	 HpJIb9bTAD5JsXfAXheno+nONk3ITq02TgISDKrc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Bart Van Assche <bvanassche@acm.org>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Subject: [PATCH 6.18 395/396] drm/fb-helper: Fix a locking bug in an error path
Date: Fri,  7 Aug 2026 16:39:15 +0200
Message-ID: <20260807143432.794301963@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

commit bd64240dc88caaf7b96dd869f36f165f51b52039 upstream.

The name of the function __drm_fb_helper_initial_config_and_unlock() and
also the comment above that function make it clear that all code paths
in this function should unlock fb_helper->lock before returning. Add a
mutex_unlock() call in the only code path where it is missing. This has
been detected by the Clang thread-safety analyzer.

Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Christian König <christian.koenig@amd.com> # radeon
Cc: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com> # msm
Cc: Javier Martinez Canillas <javierm@redhat.com>
Fixes: 63c971af4036 ("drm/fb-helper: Allocate and release fb_info in single place")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patch.msgid.link/20260403205355.1181984-1-bvanassche@acm.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_fb_helper.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -1792,8 +1792,10 @@ __drm_fb_helper_initial_config_and_unloc
 	drm_client_modeset_probe(&fb_helper->client, width, height);
 
 	info = drm_fb_helper_alloc_info(fb_helper);
-	if (IS_ERR(info))
+	if (IS_ERR(info)) {
+		mutex_unlock(&fb_helper->lock);
 		return PTR_ERR(info);
+	}
 
 	ret = drm_fb_helper_single_fb_probe(fb_helper);
 	if (ret < 0) {


