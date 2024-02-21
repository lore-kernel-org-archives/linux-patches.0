Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0FB91BC44;
	Wed, 21 Feb 2024 14:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525807; cv=none; b=QULlgff4kyfUBVY/uhZqCTV5BdF8LlKnTkqGfQPCN4ffvzzosVPlpsMEQY6z0nU2bmCSYG+mSG+bxy3OiSjErG4qE/R/Dk/e36QJzfnIJl1QC/wPqo9PRcSmOpdhMTTNPnNOBoKG2utna4cQbsdLCtT/YAl5rHZJ5tqlM/B6Lro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525807; c=relaxed/simple;
	bh=5iNFt82dwChTCojJqLCBWWUVvFOw3oky19PmPZQmfjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uWOVzABZ3vRnGgdy2NBowSsTR7XXeueTLSjhuG9hxtBeMlhYm06luHBBIyZ6jBAZGdLVjcwySH8mTMt9+1q6wVTya8R6iyp+YZndW+Uq5K8vJ/ERjLhZ54+rXyPxRwPxSpkDBEyTM0BDuzvyQdVG+153EMpQ6nTB/Gg6gxD2RLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UnxLi489; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UnxLi489"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA9D1C433F1;
	Wed, 21 Feb 2024 14:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525807;
	bh=5iNFt82dwChTCojJqLCBWWUVvFOw3oky19PmPZQmfjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UnxLi4897xhpa/wUvYmNIG2UOV8Tzu7g6WrGNKpCLmQeKrdHEWhwh8GXlHhEOlfdW
	 8BEZoSBcMNQds9ADtdhZiDKCZcsNiaJhbYyg4PsQOla8jI1v6W+JrFj1vDhM5KMhuW
	 TiIjIYa5LKIKMHDjFr7ot+EE9fkP7gmwk7LI1auY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Douglas Anderson <dianders@chromium.org>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Amit Pundir <amit.pundir@linaro.org>
Subject: [PATCH 5.4 260/267] PM: runtime: Have devm_pm_runtime_enable() handle pm_runtime_dont_use_autosuspend()
Date: Wed, 21 Feb 2024 14:10:01 +0100
Message-ID: <20240221125948.408519163@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
 include/linux/pm_runtime.h   |    5 +++++
 2 files changed, 10 insertions(+)

--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -1463,11 +1463,16 @@ EXPORT_SYMBOL_GPL(pm_runtime_enable);
 
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
@@ -300,6 +300,11 @@ static inline void pm_runtime_disable(st
 	__pm_runtime_disable(dev, true);
 }
 
+/**
+ * NOTE: It's important to undo this with pm_runtime_dont_use_autosuspend()
+ * at driver exit time unless your driver initially enabled pm_runtime
+ * with devm_pm_runtime_enable() (which handles it for you).
+ */
 static inline void pm_runtime_use_autosuspend(struct device *dev)
 {
 	__pm_runtime_use_autosuspend(dev, true);


