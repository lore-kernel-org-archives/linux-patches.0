Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7B651ABED9;
	Mon, 14 Oct 2024 14:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917228; cv=none; b=FR7fctmX2ImzDiCr8nooUIDkMYv/izMRfZyZI76EyBFozIwZ0TH+4aNUQ4Lp9iGijZWYxVZkdV9tE/0rl+mQDfIM8PMyP9zbFY8Mu1eXitmN6+nj3RUS5Hh1kYqpDh9pen+m19wO3rDgpRZhIWuLOG8juqqIgeQzSv1Hkhj8IqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917228; c=relaxed/simple;
	bh=duqr0+8/kqKvG8zdqDzspq2mEzdYvcy6T0fMh8tq1rU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uFD+GgD//+rowI0+0Xegc5mwKLXex/61gEeB7qRC+rMPyK0sec/sE4nEWcxNIulcrF0C/BpzDUi7f9UtNTa0gBtqBQWsvXoevYBCfSVOLUJv3uSlhlRp6qxhV2bvorGDLNrtKrcywcjZLJJHr5gKHkj6E+6U8dIIZvW13lE17lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UoK2xep9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UoK2xep9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0806BC4CEC7;
	Mon, 14 Oct 2024 14:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917228;
	bh=duqr0+8/kqKvG8zdqDzspq2mEzdYvcy6T0fMh8tq1rU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UoK2xep9zc8J8Z3FrzhTssZZfEEtYZgVXIGNOUUPKYuiJF1V6NBnN/4QaS2RLDwsL
	 E8jOehfayzGvWHpnYtmz8lqQdoN/Wl+pAeMdUG/4dvOzH9JMWlZvvmGwRzM5OwBTSh
	 nxgyiQpCPneZDGzGdSvIt4Wk2oXbdVq8PKQpgAn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Paul <seanpaul@chromium.org>,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Subject: [PATCH 6.6 190/213] drm/i915/hdcp: fix connector refcounting
Date: Mon, 14 Oct 2024 16:21:36 +0200
Message-ID: <20241014141050.377626450@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

commit 4cc2718f621a6a57a02581125bb6d914ce74d23b upstream.

We acquire a connector reference before scheduling an HDCP prop work,
and expect the work function to release the reference.

However, if the work was already queued, it won't be queued multiple
times, and the reference is not dropped.

Release the reference immediately if the work was already queued.

Fixes: a6597faa2d59 ("drm/i915: Protect workers against disappearing connectors")
Cc: Sean Paul <seanpaul@chromium.org>
Cc: Suraj Kandpal <suraj.kandpal@intel.com>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: stable@vger.kernel.org # v5.10+
Reviewed-by: Suraj Kandpal <suraj.kandpal@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240924153022.2255299-1-jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit abc0742c79bdb3b164eacab24aea0916d2ec1cb5)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_hdcp.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_hdcp.c
+++ b/drivers/gpu/drm/i915/display/intel_hdcp.c
@@ -1005,7 +1005,8 @@ static void intel_hdcp_update_value(stru
 	hdcp->value = value;
 	if (update_property) {
 		drm_connector_get(&connector->base);
-		queue_work(i915->unordered_wq, &hdcp->prop_work);
+		if (!queue_work(i915->unordered_wq, &hdcp->prop_work))
+			drm_connector_put(&connector->base);
 	}
 }
 
@@ -2480,7 +2481,8 @@ void intel_hdcp_update_pipe(struct intel
 		mutex_lock(&hdcp->mutex);
 		hdcp->value = DRM_MODE_CONTENT_PROTECTION_DESIRED;
 		drm_connector_get(&connector->base);
-		queue_work(i915->unordered_wq, &hdcp->prop_work);
+		if (!queue_work(i915->unordered_wq, &hdcp->prop_work))
+			drm_connector_put(&connector->base);
 		mutex_unlock(&hdcp->mutex);
 	}
 
@@ -2497,7 +2499,9 @@ void intel_hdcp_update_pipe(struct intel
 		 */
 		if (!desired_and_not_enabled && !content_protection_type_changed) {
 			drm_connector_get(&connector->base);
-			queue_work(i915->unordered_wq, &hdcp->prop_work);
+			if (!queue_work(i915->unordered_wq, &hdcp->prop_work))
+				drm_connector_put(&connector->base);
+
 		}
 	}
 


