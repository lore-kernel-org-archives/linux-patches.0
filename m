Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB6E146C84B;
	Sat, 12 Sep 2026 10:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210162; cv=none; b=YUgzy0i9z4Xs1fWbEXvUDG+3hMFfXA7Kp/SoPn1/nx47mcdjx7P8epuHtCeZ0QRMbe4i8CN6T6xLuupFBbcj/f67dRKTiGgEM5+jpoYN7h1gvQ2Ub2JSYA3BKqAGHU2V9Eh12snvSMfNH/usD6QVZXrwOZ15Q/22IB0sdjDQX20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210162; c=relaxed/simple;
	bh=XFBp76GBPFJ2qUZzN9azIc/dzEVniVWxC1yczrARvqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QxKkUo5dBby8n9AHJXvrJKHUWRKbFL3Ch2e0coQYamExSFBduitToWZzv0YVpQ5XsddbEp1cv5bt1JZ8wXgarRqbnHdkb/jB1uxbviKHhkhl94pyXpxY/wT3DkH4WGnjRffxEBqwAx7fU79BXYeV3YLjd2gkxZrDcF9sl4jyF0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tVkpJAxp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tVkpJAxp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7DE41F00893;
	Sat, 12 Sep 2026 10:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210158;
	bh=uRJRpnhIjUTuE7bQE7lBpnav6X/6+vZK6vvXdyB2ueM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tVkpJAxp7OY1NjZsLWS/4Q7ogGnh6sfELTMTbVRD0Z/WzKsBtnQl1LiyJDGKeKBi4
	 4oHd2uIAAvD7NQFDpb2JWT6sNTTAXaXLAmQUyDBphkj9JelsDtAq+/bOd7ru8Ztffw
	 /LuVObZvrJIlBi8uKtGNs53XQp4xqpn5hzAQnAFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0926/1518] module: replace use of system_wq with system_dfl_wq
Date: Sat, 12 Sep 2026 08:51:35 +0200
Message-ID: <20260912065644.396499141@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Marco Crivellari <marco.crivellari@suse.com>

[ Upstream commit 581ac2d4a58b81669cc6abf645a558bce5cf14ab ]

Currently if a user enqueues a work item using schedule_delayed_work() the
used wq is "system_wq" (per-cpu wq) while queue_delayed_work() use
WORK_CPU_UNBOUND (used when a cpu is not specified). The same applies to
schedule_work() that is using system_wq and queue_work(), that makes use
again of WORK_CPU_UNBOUND.

This lack of consistency cannot be addressed without refactoring the API.

This continues the effort to refactor workqueue APIs, which began with
the introduction of new workqueues and a new alloc_workqueue flag in:

commit 128ea9f6ccfb ("workqueue: Add system_percpu_wq and system_dfl_wq")
commit 930c2ea566af ("workqueue: Add new WQ_PERCPU flag")

Switch to using system_dfl_wq, the new unbound workqueue, because the
users do not benefit from a per-cpu workqueue.

Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Marco Crivellari <marco.crivellari@suse.com>
Reviewed-by: Petr Pavlu <petr.pavlu@suse.com>
Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Stable-dep-of: 5eecb11b543f ("module/dups: Fix use-after-free in kmod_dup_req lifetime handling")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/module/dups.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/module/dups.c b/kernel/module/dups.c
index bd2149fbe1173..0b633f2edda6b 100644
--- a/kernel/module/dups.c
+++ b/kernel/module/dups.c
@@ -113,7 +113,7 @@ static void kmod_dup_request_complete(struct work_struct *work)
 	 * let this linger forever as this is just a boot optimization for
 	 * possible abuses of vmalloc() incurred by finit_module() thrashing.
 	 */
-	queue_delayed_work(system_wq, &kmod_req->delete_work, 60 * HZ);
+	queue_delayed_work(system_dfl_wq, &kmod_req->delete_work, 60 * HZ);
 }
 
 bool kmod_dup_request_exists_wait(char *module_name, bool wait, int *dup_ret)
@@ -240,7 +240,7 @@ void kmod_dup_request_announce(char *module_name, int ret)
 	 * There is no rush. But we also don't want to hold the
 	 * caller up forever or introduce any boot delays.
 	 */
-	queue_work(system_wq, &kmod_req->complete_work);
+	queue_work(system_dfl_wq, &kmod_req->complete_work);
 
 out:
 	mutex_unlock(&kmod_dup_mutex);
-- 
2.53.0



