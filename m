Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B904A2D12ED;
	Fri,  7 Aug 2026 15:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116549; cv=none; b=N/LAFeds8bOzpc5UBlwo8SYSkTS9g3hlnklbjnVsz6o0gNYawpiD/tbaISzMctlSHtjE+8yZSBpesJLkIf90PglEQEbzdIc+IP4cgErsw41mFnhFf8Tqv/baeb51cJqZJSYIkLDmtCLwXly5ByI+ytB0aN6SKPvR73uBKbglnYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116549; c=relaxed/simple;
	bh=B4b5UMEcXoOuugIkaUuE9sYqlHT9Qbpb5qgvDmqCgPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gq+xeCS6Br5AJKe/e9IsAcTj1BKpoGbrrdyAzeAEfXCEZfSJFMv3vkV/GO7kyH2wTlHC0gcHqh0J4W73ydaOFrNd3HXIPS0SMMCq1/MAHlWvSedg6VxFbqhRsE+7h0fyKBhszfSvkWbFinxd4TRsn5H8ZG8dR79bDpd10zuVBqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aVktnck+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aVktnck+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C573C1F000E9;
	Fri,  7 Aug 2026 15:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116548;
	bh=x7ZcHelBg64/qrM5hSP8XLy0nRFVLfaPkxwF04ixmDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aVktnck+Acpuim64+z3vkJHVtOeQoAZqxCI0SJEhrMH0H9rV4Kno0elBBnJly8T74
	 xAslqNSzWoaG8C2Q2OJDBTrDOB35PVT4j7oSCLlTmWEwUV3/vGsdbBG45U174HCkNr
	 pEofdvWSzU3du/kw82y9Pk2/LqLD7XsLz9rCcjhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gustavo Sousa <gustavo.sousa@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 255/261] drm/i915/hdcp: migrate away from kdev_to_i915() in bind/unbind
Date: Fri,  7 Aug 2026 16:40:12 +0200
Message-ID: <20260807143420.918766804@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

[ Upstream commit 3eac4684ecb5ea696bd283bd7f35e4829973f4f8 ]

Use to_intel_display() instead of kdev_to_i915() in the HDCP component
API hooks. Avoid further drive-by changes at this point, and just
convert the display pointer to i915, and leave the struct intel_display
conversion for later.

Reviewed-by: Gustavo Sousa <gustavo.sousa@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/0beedaa438e912828b48d9980f017807e079d7ab.1724942754.git.jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Stable-dep-of: db9e64c983dc ("drm/i915/hdcp: require monotonically increasing seq_num_v")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_hdcp.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_hdcp.c
+++ b/drivers/gpu/drm/i915/display/intel_hdcp.c
@@ -2108,10 +2108,11 @@ static void intel_hdcp_check_work(struct
 				   DRM_HDCP_CHECK_PERIOD_MS);
 }
 
-static int i915_hdcp_component_bind(struct device *i915_kdev,
+static int i915_hdcp_component_bind(struct device *drv_kdev,
 				    struct device *mei_kdev, void *data)
 {
-	struct drm_i915_private *i915 = kdev_to_i915(i915_kdev);
+	struct intel_display *display = to_intel_display(drv_kdev);
+	struct drm_i915_private *i915 = to_i915(display->drm);
 
 	drm_dbg(&i915->drm, "I915 HDCP comp bind\n");
 	mutex_lock(&i915->display.hdcp.hdcp_mutex);
@@ -2122,10 +2123,11 @@ static int i915_hdcp_component_bind(stru
 	return 0;
 }
 
-static void i915_hdcp_component_unbind(struct device *i915_kdev,
+static void i915_hdcp_component_unbind(struct device *drv_kdev,
 				       struct device *mei_kdev, void *data)
 {
-	struct drm_i915_private *i915 = kdev_to_i915(i915_kdev);
+	struct intel_display *display = to_intel_display(drv_kdev);
+	struct drm_i915_private *i915 = to_i915(display->drm);
 
 	drm_dbg(&i915->drm, "I915 HDCP comp unbind\n");
 	mutex_lock(&i915->display.hdcp.hdcp_mutex);


