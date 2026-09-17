Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 899014C10D4;
	Thu, 17 Sep 2026 17:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666359; cv=none; b=rxgww7teJHDyxeN2OoSGwE5AU4IW6GnkEum/ljpEt8pXhOTVgBZwRyb2zAWgpE4r55nMfVclIH+Mt3zA1Vl7k9CE/4fFL0ODUXwG1SveCfnXGh6NJkyeLZwsjAtrHQaeyDdg570TH+ovNRA4mdFSiAIZyhiSkQIgkSGLb3dr5No=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666359; c=relaxed/simple;
	bh=swEVDNRwZ+KzIREQLog0EtsJzindt0wluhDMFKdGXlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FaUbZ53MKW4TQZvxSZxde8SG1Ge7G7SfGizPnKd+AOy8EidVi8VMPFoPxCWmjw5MjmT0Ii5yR31c362AVIxEXyg3m4wxDj9hUUsC4Ztm3uQKwrOujn+S9YNeWpCG2mDteP3sghnfkzvh+EGsoGO2Z8lJp8AHQhu5AQ/pQUprLGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pPzFjePx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pPzFjePx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 999071F000FF;
	Thu, 17 Sep 2026 17:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666357;
	bh=NZDrz+Q3H5R1Ub9Spi3E5evoF+4xxDPF5wjrjTEe/CM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pPzFjePx9BNeVq8u8daScH3yWuIoHIQtDT74IDJAlpbvKoUJJKaUwAKdD4+srquiU
	 D3+36o62l2p3dEjtHj1ls+xAXXh8+XReZOYaq1I4cRxxeOSlrPBYYnjFjl+rRmgeKf
	 rUkTKpis0nS92nqlPPvNNYPnOIIxDHqkp/lukejw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shixiong Ou <oushixiong@kylinos.cn>,
	Maxime Ripard <mripard@kernel.org>,
	Philipp Stanner <phasta@kernel.org>
Subject: [PATCH 6.18 1009/1250] drm/sched: Create a fake device for KUnit tests
Date: Thu, 17 Sep 2026 16:13:24 +0100
Message-ID: <20260917151619.395382416@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shixiong Ou <oushixiong@kylinos.cn>

commit 28cc4d5a75bb07d0eb2fa178db355b04483f5aca upstream.

The DRM scheduler KUnit tests pass NULL for the dev field in
drm_sched_init_args, which NULL-pointer dereferences in the drm_sched_job
trace event via dev_name() on sched->dev.

Give the mock scheduler a device with kunit_device_register(), which is
also cleaned up at test exit. A per-function counter keeps the device
names unique, since some tests create several mock schedulers.

Fixes: 5a99350794fe ("drm/sched: Add scheduler unit testing infrastructure and some basic tests")
Cc: stable@vger.kernel.org
Signed-off-by: Shixiong Ou <oushixiong@kylinos.cn>
Acked-by: Maxime Ripard <mripard@kernel.org>
[phasta: removed static variable init to 0 again]
Signed-off-by: Philipp Stanner <phasta@kernel.org>
Link: https://patch.msgid.link/20260908055941.351486-1-oushixiong1025@163.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/scheduler/tests/mock_scheduler.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/gpu/drm/scheduler/tests/mock_scheduler.c
+++ b/drivers/gpu/drm/scheduler/tests/mock_scheduler.c
@@ -1,6 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (c) 2025 Valve Corporation */
 
+#include <kunit/device.h>
+
 #include "sched_tests.h"
 
 /*
@@ -288,6 +290,7 @@ static const struct drm_sched_backend_op
  */
 struct drm_mock_scheduler *drm_mock_sched_new(struct kunit *test, long timeout)
 {
+	static unsigned int instance;
 	struct drm_sched_init_args args = {
 		.ops		= &drm_mock_scheduler_ops,
 		.num_rqs	= DRM_SCHED_PRIORITY_COUNT,
@@ -297,11 +300,19 @@ struct drm_mock_scheduler *drm_mock_sche
 		.name		= "drm-mock-scheduler",
 	};
 	struct drm_mock_scheduler *sched;
+	struct device *dev;
+	char name[64];
 	int ret;
 
 	sched = kunit_kzalloc(test, sizeof(*sched), GFP_KERNEL);
 	KUNIT_ASSERT_NOT_NULL(test, sched);
 
+	snprintf(name, sizeof(name), "%s-%u", args.name, instance++);
+	dev = kunit_device_register(test, name);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, dev);
+
+	args.dev = dev;
+
 	ret = drm_sched_init(&sched->base, &args);
 	KUNIT_ASSERT_EQ(test, ret, 0);
 


