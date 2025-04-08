Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93B872676C9;
	Tue,  8 Apr 2025 12:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113847; cv=none; b=dLBDWHzHLBK3LpApx8mRrslrRwbC99cUARQ67+KhGi91qfRzSlgnr9oMI4tYXse4doNaqqnPwc0hp5DjDzcHKvftcSgHvbciZHlTiyz2KMEHzRfX5gId/ZHjF1Rl3HhGtIsrdi7qGXfJgxuzeCHKMza65rbDWkrzGJ+Xa9GwBIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113847; c=relaxed/simple;
	bh=DZaayEnv2WORFHFYmcSScR7HcmJaZxJFierseHOZ0oE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Djtgc+SP3FnklqSvdVHWxX99p/1Y+8oye+wTAnOuBeSKMpVL7zaEXiIx0pt4rsxTlkmfbuanY6irBTiyYId2KoJ2GtrQa3kHiZTvIKiG588jgb/Odc9UrZpnT+0JGbNqfmwTZemO2wXycg3vSWWT65KGJfXvlxBfk3g+gVeQtwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dlYKhsT/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dlYKhsT/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23923C4CEE5;
	Tue,  8 Apr 2025 12:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113847;
	bh=DZaayEnv2WORFHFYmcSScR7HcmJaZxJFierseHOZ0oE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dlYKhsT/BidkvFdZ8dv9JT7Y1Qz3YzhI2h3KYxL/xGaUvsohhvrfdBcX4w/DRfOf5
	 oVQvkVgBod7bs/22Fj2VM/Uz1jEjlx1U7gjj5Q1LNJR0iK8kUmrpFUDk7Uy4PNfYNu
	 qNkwt+oOXeegrYH7jkU7reT20ZSwAJo77h3jPHh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simona Vetter <simona.vetter@ffwll.ch>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>
Subject: [PATCH 5.4 043/154] drm/atomic: Filter out redundant DPMS calls
Date: Tue,  8 Apr 2025 12:49:44 +0200
Message-ID: <20250408104816.650270375@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104815.295196624@linuxfoundation.org>
References: <20250408104815.295196624@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -929,6 +929,10 @@ int drm_atomic_connector_commit_dpms(str
 
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
@@ -912,6 +912,10 @@ static const struct drm_prop_enum_list h
  * 	implemented in the DRM core.  This is the only standard connector
  * 	property that userspace can change.
  *
+ * 	On atomic drivers any DPMS setproperty ioctl where the value does not
+ * 	change is completely skipped, otherwise a full atomic commit will occur.
+ * 	On legacy drivers the exact behavior is driver specific.
+ *
  * 	Note that this property cannot be set through the MODE_ATOMIC ioctl,
  * 	userspace must use "ACTIVE" on the CRTC instead.
  *


