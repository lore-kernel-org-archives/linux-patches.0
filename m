Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A3761EB5EE;
	Wed, 19 Mar 2025 14:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394952; cv=none; b=Lgzw1BvrhZvYFaI5su6VIjVH32LsRhOUF4MHyRtqg8wwXlGdba4NdqIGtIWxm0ymlGGg//93Jl4gkC0mWEmFyNzs9OhRsY2cGtr/ves9cTGHHFvD97bd0lCsYhCfQeRDaQSLUPNettKJ4OviOqS5cMxsZQiuS+hVNyLgahUglHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394952; c=relaxed/simple;
	bh=hLPfvmeKyvHUg++WofdjPKlWYUryUiPWks4n1Lf2ZTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L1tqktl5WggvB8jdrRRPd99MafgCO9ZbeavXRID3Ty1PP2wXJb0L7qgPwp5/DzRZ4RYKJebvw5EuZEPgiNUjooAC2fEplaf4S7Rpjs1ZIIexDZtIjZvlnSa1jDuWRf3u47kD2fd+kRij+gqWV4Fy1nSizA2T0B+KKDEdJYigw3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u4hlvUBu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u4hlvUBu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F0EDC4CEE4;
	Wed, 19 Mar 2025 14:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394952;
	bh=hLPfvmeKyvHUg++WofdjPKlWYUryUiPWks4n1Lf2ZTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u4hlvUBuFhu2m9avGwVyA2NZYl12IkYeSyGgfFH9niwP4K9/8GFotb5dbMa5Ww13W
	 QsYEkBmRJU8eGZNDN91DrChY9v1c2N93733k/txXE1yr1uPqnv+EvvJcnzpCz9Wfn1
	 s86e9KVtV2/KMzPEbKRtfrbmaH7Vs478gWMO8im8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simona Vetter <simona.vetter@ffwll.ch>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>
Subject: [PATCH 6.13 177/241] drm/atomic: Filter out redundant DPMS calls
Date: Wed, 19 Mar 2025 07:30:47 -0700
Message-ID: <20250319143032.112956135@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit de93ddf88088f7624b589d0ff3af9effb87e8f3b upstream.

Video players (eg. mpv) do periodic XResetScreenSaver() calls to
keep the screen on while the video playing. The modesetting ddx
plumbs these straight through into the kernel as DPMS setproperty
ioctls, without any filtering whatsoever. When implemented via
atomic these end up as empty commits on the crtc (which will
nonetheless take one full frame), which leads to a dropped
frame every time XResetScreenSaver() is called.

Let's just filter out redundant DPMS property changes in the
kernel to avoid this issue.

v2: Explain the resulting commits a bit better (Sima)
    Document the behaviour in uapi docs (Sima)

Cc: stable@vger.kernel.org
Testcase: igt/kms_flip/flip-vs-dpms-on-nop
Reviewed-by: Simona Vetter <simona.vetter@ffwll.ch>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250219160239.17502-1-ville.syrjala@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_atomic_uapi.c |    4 ++++
 drivers/gpu/drm/drm_connector.c   |    4 ++++
 2 files changed, 8 insertions(+)

--- a/drivers/gpu/drm/drm_atomic_uapi.c
+++ b/drivers/gpu/drm/drm_atomic_uapi.c
@@ -956,6 +956,10 @@ int drm_atomic_connector_commit_dpms(str
 
 	if (mode != DRM_MODE_DPMS_ON)
 		mode = DRM_MODE_DPMS_OFF;
+
+	if (connector->dpms == mode)
+		goto out;
+
 	connector->dpms = mode;
 
 	crtc = connector->state->crtc;
--- a/drivers/gpu/drm/drm_connector.c
+++ b/drivers/gpu/drm/drm_connector.c
@@ -1308,6 +1308,10 @@ EXPORT_SYMBOL(drm_hdmi_connector_get_out
  * 	callback. For atomic drivers the remapping to the "ACTIVE" property is
  * 	implemented in the DRM core.
  *
+ * 	On atomic drivers any DPMS setproperty ioctl where the value does not
+ * 	change is completely skipped, otherwise a full atomic commit will occur.
+ * 	On legacy drivers the exact behavior is driver specific.
+ *
  * 	Note that this property cannot be set through the MODE_ATOMIC ioctl,
  * 	userspace must use "ACTIVE" on the CRTC instead.
  *


