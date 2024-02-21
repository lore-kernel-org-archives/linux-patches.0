Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FE017BB16;
	Wed, 21 Feb 2024 13:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523535; cv=none; b=JfVOhX3uEFZSf50ObWPPcD/RL3abYK5QB9Km6kXhDB6Pfi7sk9tooMSjCHxcgLDcmWUL2Tl7R7JIEOVpc4943ekx+rfa6+QuXgUCzTOnorxf0VD3jYRMFzCDp8MxgVzxft9G7JWp3FFaDdf9et0fdLjmrUVqZXEwEZ499h1E8N0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523535; c=relaxed/simple;
	bh=Wi6ETXRS2A6gG3lxBU67wTP2T0O+rWGlgiqJKWothCM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Csrh2p3u5g4v7jSbfSWrgPWp9D32caEuftNhoJrqbes2nHlJQNgNoApg6GCGNBJe4t/inA4rNkZ+fw7omBAw6+hfxq3wm2Xl8h6Jx/lt/JetmWTWFNCP7s/WkdzgXn0Se+9r7Fpj/fj9HSe25yLQP5xg/LbmgLRfXnY1YI5BCwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=glX0Gj5m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="glX0Gj5m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 650EFC433F1;
	Wed, 21 Feb 2024 13:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523534;
	bh=Wi6ETXRS2A6gG3lxBU67wTP2T0O+rWGlgiqJKWothCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=glX0Gj5m7Wc86OQ9UKrSl+92MxRMTcgMQSbCNBe8PqI5MYrOVCRNbFvkxnNVJ9D+J
	 zjIHAiLzqe/8TTtIzzkqGhWutF/lMUHTGsj7Fci9aSbj4+iUcGSm4xC5DlekHQHRzH
	 LUNB8KXV7bMwFxhQ2/LifEKV1Sboz3WrOI3fnjc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Douglas Anderson <dianders@chromium.org>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Amit Pundir <amit.pundir@linaro.org>
Subject: [PATCH 5.15 466/476] PM: runtime: Have devm_pm_runtime_enable() handle pm_runtime_dont_use_autosuspend()
Date: Wed, 21 Feb 2024 14:08:37 +0100
Message-ID: <20240221130025.255996024@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit b4060db9251f919506e4d672737c6b8ab9a84701 ]

The PM Runtime docs say:

  Drivers in ->remove() callback should undo the runtime PM changes done
  in ->probe(). Usually this means calling pm_runtime_disable(),
  pm_runtime_dont_use_autosuspend() etc.

>From grepping code, it's clear that many people aren't aware of the
need to call pm_runtime_dont_use_autosuspend().

When brainstorming solutions, one idea that came up was to leverage
the new-ish devm_pm_runtime_enable() function. The idea here is that:

 * When the devm action is called we know that the driver is being
   removed. It's the perfect time to undo the use_autosuspend.

 * The code of pm_runtime_dont_use_autosuspend() already handles the
   case of being called when autosuspend wasn't enabled.

Suggested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: 3d07a411b4fa ("drm/msm/dsi: Use pm_runtime_resume_and_get to prevent refcnt leaks")
Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/power/runtime.c |    5 +++++
 include/linux/pm_runtime.h   |    4 ++++
 2 files changed, 9 insertions(+)

--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -1479,11 +1479,16 @@ EXPORT_SYMBOL_GPL(pm_runtime_enable);
 
 static void pm_runtime_disable_action(void *data)
 {
+	pm_runtime_dont_use_autosuspend(data);
 	pm_runtime_disable(data);
 }
 
 /**
  * devm_pm_runtime_enable - devres-enabled version of pm_runtime_enable.
+ *
+ * NOTE: this will also handle calling pm_runtime_dont_use_autosuspend() for
+ * you at driver exit time if needed.
+ *
  * @dev: Device to handle.
  */
 int devm_pm_runtime_enable(struct device *dev)
--- a/include/linux/pm_runtime.h
+++ b/include/linux/pm_runtime.h
@@ -542,6 +542,10 @@ static inline void pm_runtime_disable(st
  * Allow the runtime PM autosuspend mechanism to be used for @dev whenever
  * requested (or "autosuspend" will be handled as direct runtime-suspend for
  * it).
+ *
+ * NOTE: It's important to undo this with pm_runtime_dont_use_autosuspend()
+ * at driver exit time unless your driver initially enabled pm_runtime
+ * with devm_pm_runtime_enable() (which handles it for you).
  */
 static inline void pm_runtime_use_autosuspend(struct device *dev)
 {


