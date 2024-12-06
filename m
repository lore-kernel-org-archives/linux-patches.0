Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAB9D45BE3;
	Fri,  6 Dec 2024 14:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496354; cv=none; b=PXzgK0E8tZg8rEuN74+GZ9A4ggqV1henYEKfMPws6iD+EsEFN0pqy6HqQQag0HDsz3BOr+2xX3Xsu/41pj7YuZ9rY3t1+XTeC92cCblVHTnwTkOHanNLCwpqCEHczElM17gyRnGakJw7gAe/ng/8tUrmr7FhPCryj9GVnF/tSpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496354; c=relaxed/simple;
	bh=/+naIIvXfQjx02DJPbHxyoLuXwTVn8EY0wV1mkJo4g8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FTa5gJNIvoclZxQ8Fq098OAeSlZuxFi9HO2H5ZUrdVU+9y2+BEx68X820PjQWa67g5hcq4BMQo1eaIcV17RSL6w3ZtwU+JwP+egb5iZjBw927d8OUJfIX0JRw4WcjqImlPrRNXbduyty+oELq1LF0/Va1aWu2OllE59crjzWS+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ysGwjb0v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ysGwjb0v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A368C4CED1;
	Fri,  6 Dec 2024 14:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496353;
	bh=/+naIIvXfQjx02DJPbHxyoLuXwTVn8EY0wV1mkJo4g8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ysGwjb0vBDjbs+/xuDumqMBLOqcaM9iikx5KfQs7hQw5mOLGhvCtYh03cpLdcCmpV
	 v0yQhUzlSkrAvvk861RMIZq0NU7TcoYJw1jfDXoORWCOenCHV9xyoNjnghvwIzR+BL
	 Bo4dEWwZT/zGTDsELHQ16aoX7YA+mVdd5Qifr1wY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steffen Dirkwinkel <s.dirkwinkel@beckhoff.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Subject: [PATCH 6.12 128/146] drm: xlnx: zynqmp_dpsub: fix hotplug detection
Date: Fri,  6 Dec 2024 15:37:39 +0100
Message-ID: <20241206143532.579971977@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steffen Dirkwinkel <s.dirkwinkel@beckhoff.com>

commit 71ba1c9b1c717831920c3d432404ee5a707e04b4 upstream.

drm_kms_helper_poll_init needs to be called after zynqmp_dpsub_kms_init.
zynqmp_dpsub_kms_init creates the connector and without it we don't
enable hotplug detection.

Fixes: eb2d64bfcc17 ("drm: xlnx: zynqmp_dpsub: Report HPD through the bridge")
Cc: stable@vger.kernel.org
Signed-off-by: Steffen Dirkwinkel <s.dirkwinkel@beckhoff.com>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241028134218.54727-1-lists@steffen.cc
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xlnx/zynqmp_kms.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/xlnx/zynqmp_kms.c
+++ b/drivers/gpu/drm/xlnx/zynqmp_kms.c
@@ -509,12 +509,12 @@ int zynqmp_dpsub_drm_init(struct zynqmp_
 	if (ret)
 		return ret;
 
-	drm_kms_helper_poll_init(drm);
-
 	ret = zynqmp_dpsub_kms_init(dpsub);
 	if (ret < 0)
 		goto err_poll_fini;
 
+	drm_kms_helper_poll_init(drm);
+
 	/* Reset all components and register the DRM device. */
 	drm_mode_config_reset(drm);
 


