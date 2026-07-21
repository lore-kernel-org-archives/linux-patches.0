Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1501942DA53;
	Tue, 21 Jul 2026 19:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662712; cv=none; b=Julj7+UcOqLZY9EpBmYz5NdXWEbjrJ5HUQx8lfM7pIPPE1AKOQ/z3GmfUTuj2KXOTsKjFyHrbGlQiL81KNXHiTNJh72tAHOeuhZQI3JDUIFx7/IHalATI2dqW0CiINhdWw+3a6j7Y6onx+wtOD/ik9BQVEOM1LB78IV1IdRnXn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662712; c=relaxed/simple;
	bh=mmLQ2M+oeM92CzGWoNOkkKQkY5DSseG2Hge0MzLVhoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G2HKeDOYyVwHfM3TfmFqkPrUdMq1wS1aJL5xV1jGz4O01cydKbhgok6dne5uGe+/xg3C851jBG2V32KyE/Tr6ZnQJj5NmFOh9WCq1LxBSqLZ1J7t58alMushOl2mCmAoBgUKESs3gTymmGB/ew4UX9J3PZgWrScNNjI0EFrxEgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F8qVHclM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F8qVHclM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79D531F000E9;
	Tue, 21 Jul 2026 19:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662711;
	bh=eSWc+UhiUMpwEpi9sDRUBA0ggiUlYZZrHPlUnlgb2BE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F8qVHclM7hto8tNA7FK67Ls1mQm95kHt9qVSooiAv/osjPPpjTRmM4t7NNvvSpnCy
	 DSCw/Ftk5l4Mh2h0vIac3WbM0u49zpiPVkipMw1sKTM3wa+US4VgARgw9JDqwc4LI+
	 Sju5dQt94c+6egB6pbZ1FT1gCyyXR9lRCsaqSrdE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0546/1276] i3c: master: add WQ_PERCPU to alloc_workqueue users
Date: Tue, 21 Jul 2026 17:16:29 +0200
Message-ID: <20260721152458.339654654@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Marco Crivellari <marco.crivellari@suse.com>

[ Upstream commit de53ad6ca49e5d73bba72d24b49ec5d40f33ee01 ]

Currently if a user enqueues a work item using schedule_delayed_work() the
used wq is "system_wq" (per-cpu wq) while queue_delayed_work() use
WORK_CPU_UNBOUND (used when a cpu is not specified). The same applies to
schedule_work() that is using system_wq and queue_work(), that makes use
again of WORK_CPU_UNBOUND.
This lack of consistency cannot be addressed without refactoring the API.

alloc_workqueue() treats all queues as per-CPU by default, while unbound
workqueues must opt-in via WQ_UNBOUND.

This default is suboptimal: most workloads benefit from unbound queues,
allowing the scheduler to place worker threads where they’re needed and
reducing noise when CPUs are isolated.

This continues the effort to refactor workqueue APIs, which began with
the introduction of new workqueues and a new alloc_workqueue flag in:

commit 128ea9f6ccfb ("workqueue: Add system_percpu_wq and system_dfl_wq")
commit 930c2ea566af ("workqueue: Add new WQ_PERCPU flag")

This change adds a new WQ_PERCPU flag to explicitly request
alloc_workqueue() to be per-cpu when WQ_UNBOUND has not been specified.

With the introduction of the WQ_PERCPU flag (equivalent to !WQ_UNBOUND),
any alloc_workqueue() caller that doesn’t explicitly specify WQ_UNBOUND
must now use WQ_PERCPU.

Once migration is complete, WQ_UNBOUND can be removed and unbound will
become the implicit default.

Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Marco Crivellari <marco.crivellari@suse.com>
Link: https://patch.msgid.link/20251107132949.184944-1-marco.crivellari@suse.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Stable-dep-of: 527756cb9ebb ("i3c: master: Make hot-join workqueue freezable to block hot-join during suspend")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i3c/master.c b/drivers/i3c/master.c
index fe6f956cc31113..cde9b53a7fc4a6 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -2853,7 +2853,7 @@ int i3c_master_register(struct i3c_master_controller *master,
 	if (ret)
 		goto err_put_dev;
 
-	master->wq = alloc_workqueue("%s", 0, 0, dev_name(parent));
+	master->wq = alloc_workqueue("%s", WQ_PERCPU, 0, dev_name(parent));
 	if (!master->wq) {
 		ret = -ENOMEM;
 		goto err_put_dev;
-- 
2.53.0



