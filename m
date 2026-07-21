Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8694379C3C;
	Tue, 21 Jul 2026 15:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648406; cv=none; b=auMV4lTXrzrbdUodMRkZdqoEKCXjCL/pL6BZPPaoSFDbyJtiDM9YLxHl6SiDZt3AAQ+pd47i/d4EAeGNlbjZVh+vVTOFlGD7wDY++zOukl0xgxXWmEl15610W3DzvW3K6DejPkWaQzZ27zUyJY2iQUz3g0XkWwcjLcHiTn0mxX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648406; c=relaxed/simple;
	bh=8ZHvekLqoabBSI0ziSQvxeO1Q9zA0/reV8hz44Dg66g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WfhYovD69Yhjw/cdUuI0yFIFbvWDAmnhP+mNnf9m4DAEXvIoqrK6gOdLFotXGlpNoAU8F5jOGXvulO9PK8OcbidliQJmY8KhVEsC/6ky1u544BEEalk/KrZjpUHRsz/ONtEu6NPz0XYDq2ilSn/+EXzJUHu8lgd9bD6vWP0FBZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ByD/Hlvs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ByD/Hlvs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A3FD1F000E9;
	Tue, 21 Jul 2026 15:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648404;
	bh=npBwWZ362/NZl2iV47iUC7DEDRJqgyRuAYHAYNMeSQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ByD/HlvslscF//IssNGu/x7eghg67fWGcHXeGwQ/t8GRxY1Kw1zRN/O1aNQCh7hXV
	 12LqP/T3sUGEz/ImmrruYLtvdHDWSWKq5+SZaoTSGGkGnqZk2FXrFFBsR8pgcqO4p/
	 RF7L/+XWAAfF4ab9Opu5tyZzm47wRpIKV22O+u7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0188/2077] workqueue: forbid TEST_WORKQUEUE from being built-in
Date: Tue, 21 Jul 2026 16:57:41 +0200
Message-ID: <20260721152557.119014624@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 1503043fd75e29ad49c7d506232e272f6951d07d ]

The benchmark drives the workqueue's affinity_scope through sysfs by
filp_open()'ing /sys/bus/workqueue/devices/bench_wq/affinity_scope. When
CONFIG_TEST_WORKQUEUE=y, the module_init runs during kernel init before
userspace has mounted sysfs, so every open returns -ENOENT and the
benchmark loop spins emitting:

  test_workqueue: open /sys/bus/workqueue/devices/bench_wq/affinity_scope failed: -2

Mirror the TEST_BPF pattern and add "depends on m" so Kconfig will not
let this be built into the kernel image, and document the reason in the
help text.

Fixes: 24b2e73f9700 ("workqueue: add test_workqueue benchmark module")
Signed-off-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/Kconfig.debug | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 8ff5adcfe1e0a2..040f4e077435b5 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -2649,12 +2649,17 @@ config TEST_VMALLOC
 
 config TEST_WORKQUEUE
 	tristate "Test module for stress/performance analysis of workqueue"
+	depends on m
 	default n
 	help
 	  This builds the "test_workqueue" module for benchmarking
 	  workqueue throughput under contention. Useful for evaluating
 	  affinity scope changes (e.g., cache_shard vs cache).
 
+	  The test drives sysfs to switch affinity scopes, so it must be
+	  loaded after userspace has mounted sysfs; building it in (=y)
+	  would run module_init before /sys is available.
+
 	  If unsure, say N.
 
 config TEST_BPF
-- 
2.53.0



