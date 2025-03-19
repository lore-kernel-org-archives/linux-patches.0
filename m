Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19B7E1DE2B2;
	Wed, 19 Mar 2025 14:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395141; cv=none; b=fpfI9LWatohhSr2RI/x4XYhtoRiekVvrml34KLVcyzv8YYwxpeXC4cA6k4G8bJbOa4pglHZT4QvkiYaV1bNcZKo/DxTlGj4U/U8gTd59WMd+qqUYm8c7SPK2LzkI/QI3weBl9xtmYQ0CzFRawWwPBpFr4Jlo6pNdEtmnwCCPHRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395141; c=relaxed/simple;
	bh=YD1TmsQ8Hm9Uqa3Nfx6NfBFTFKj2xGwY7KyrtkFrMrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oc0sAAS4xGOLdtaQ949Zq0giSnQSTsNEosx5QPBEitYAnPwrnYhEpVaVpkY4gWLylk+Yc611tPLI/PjJGscKIMi77yL+DMdIBbOddBjmb7zLjcXKWXxvS3w4fXH7eo4tQXPK0Bk52WwqH/JHxWcjtDrI8jw0D5UTu9aFq/6hJGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0mLkweQb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0mLkweQb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83735C4CEE4;
	Wed, 19 Mar 2025 14:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395140;
	bh=YD1TmsQ8Hm9Uqa3Nfx6NfBFTFKj2xGwY7KyrtkFrMrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0mLkweQbJCFqeXduKjY1k4Zq5f/yIVYfV93fXzpqb4qmTxd9AWYLiRqVo3T1BjuoU
	 StziTL0esRCWZ51RyOYKgtokJup9jTZ9WS1XgZFB5aykB4pmd36P8oYoxcK8qYogtN
	 vZ9nIH6mrTwOvv3DlItIgcJyS+u/WXVlo9O9Cc7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simona Vetter <simona.vetter@ffwll.ch>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>
Subject: [PATCH 6.12 172/231] drm/atomic: Filter out redundant DPMS calls
Date: Wed, 19 Mar 2025 07:31:05 -0700
Message-ID: <20250319143031.093387558@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


