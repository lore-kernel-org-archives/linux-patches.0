Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 385C44ABBBA;
	Thu, 17 Sep 2026 15:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660272; cv=none; b=NwwI7N8TSvcUCEllwes1GokE+Drjtv9YiNYEILyFtMjA39EkttCXzJcih4S7jkOl4KH5sFRtVflbTeNEKytepFSWlpg0cPUgcI8ikAExBrYejUDMwbuepKXdDo4chBIMwS1ga6mGWb1seaJn8RdAlREUXrDeHNInh9lLqVFlLVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660272; c=relaxed/simple;
	bh=iP5m6V/wq85RFHglJpKdbgVvWA+p6ixYmLcK7AOKONI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gRMDiv64+b4kBTax5qhMUg56yQWmhgFktaITQOMDb8+4BkDLouEUySuVU+r6Z5sY2Pk2PdqGgDpWg2hb1Bd0Az5FrMIpkq9AX0tGSRCTs0hx0oB8oohD+WcjM5D+8/bTPrGkf/DVNI4qLZkBByyxA5MUGe+WGQOM0NYA/briXxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LakYrgKv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LakYrgKv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEC031F00893;
	Thu, 17 Sep 2026 15:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660268;
	bh=6/e3zMRJk5p+uMGYBAP/Iv50tjaijEYbOHOIFbGcjU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LakYrgKvz+1p4BzQV8SrwIA4+IeQ/JPUhCj7bA7Keu5kKrJwW5P9wyV3CIbM/6wDC
	 Oum9ehlPKssLkbU+xF7e0MubDTwWZ6G6YH4dcuRFFK/5eb6m5aQv1iiTL5/VMaKnVk
	 qx2Ohj+/HWO9KdQ9Zfs7d9L5f0/qE8nw0aIJDRak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shixiong Ou <oushixiong@kylinos.cn>,
	Maxime Ripard <mripard@kernel.org>,
	Philipp Stanner <phasta@kernel.org>
Subject: [PATCH 7.2 533/733] drm/sched: Create a fake device for KUnit tests
Date: Thu, 17 Sep 2026 16:14:01 +0100
Message-ID: <20260917151405.482898391@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
 


