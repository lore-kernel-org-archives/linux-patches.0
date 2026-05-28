Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1B551DE4E0;
	Thu, 28 May 2026 20:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000982; cv=none; b=JIzrf3eo5XAm+ydNid/PX0A405GbKmtbe2CVZZhNkN7VQxlFkIuR3Hj0sH9vPVwKJS5AT4qMcJNfjiHbhn9LzdodFtihzqp6LJ3VWGeHa4ynp0VjbdNUsdSkoF8bl315JWrkapmlx/h0V38TGg+aJFVwgncMjCwNTPTz+FlAtnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000982; c=relaxed/simple;
	bh=6ROdIiU8peJVpg/L6V85dhK2sAx0q/lKq1PAR842S0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mbgOxH6OyT6PU1mgtLaSWGv26gEG9DeAmBmm3+ICYvr8+rdozx7um2Ssz7ChV1aV249VlNhGG93+4C60+Ri6dz8Fer+M5VyUYsIjRY2N7ReeSo2LYxgyyhOFGCUfY9XoXUczUl5NezRRn4bOREtvByKLjgJ5B2dtwAKYvpxu/0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OwOYQ30l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OwOYQ30l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B64A1F000E9;
	Thu, 28 May 2026 20:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000981;
	bh=IAWzvrkGZKUabMl0ShZt+KIJ2MzjtA1DG/YkVHlrl6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OwOYQ30lX/DsIlyQUBv+0LIomkxmyS9HamJQIEufe/aA9fgDHacCsrQ0K+Bl0JhFA
	 rZhZaN53e/6D5SVntXcnG2dA1blaKbNlHEyi5PhPbbuFP/2JwGgxTsMA9YZoUXRR4b
	 oHWxKKyaoWs7bBZXV7hrHaMig0SlJo+baGwNuO3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
	Shuicheng Lin <shuicheng.lin@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 237/272] drm/xe/gsc: Fix double-free of managed BO in error path
Date: Thu, 28 May 2026 21:50:11 +0200
Message-ID: <20260528194635.793906193@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuicheng Lin <shuicheng.lin@intel.com>

[ Upstream commit d3ded53fab90996e7d94a39049e11962dd066725 ]

The error path in xe_gsc_init_post_hwconfig() explicitly frees a BO
allocated with xe_managed_bo_create_pin_map() via
xe_bo_unpin_map_no_vm(). Since the managed BO already has a devm
cleanup action registered, this causes a double-free when devm
unwinds during probe failure.

Remove the explicit free and let devm handle it, consistent with
all other xe_managed_bo_create_pin_map() callers.

Fixes: 2e5d47fe7839 ("drm/xe/uc: Use managed bo for HuC and GSC objects")
Reviewed-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Assisted-by: Claude:claude-opus-4.6
Link: https://patch.msgid.link/20260511154134.223696-1-shuicheng.lin@intel.com
Signed-off-by: Shuicheng Lin <shuicheng.lin@intel.com>
(cherry picked from commit 71d61e3e299a17139e47f980a4d6f425b2c59bf7)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_gsc.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_gsc.c b/drivers/gpu/drm/xe/xe_gsc.c
index efc480d34c9dd..6786773f4560b 100644
--- a/drivers/gpu/drm/xe/xe_gsc.c
+++ b/drivers/gpu/drm/xe/xe_gsc.c
@@ -485,8 +485,7 @@ int xe_gsc_init_post_hwconfig(struct xe_gsc *gsc)
 				 EXEC_QUEUE_FLAG_PERMANENT, 0);
 	if (IS_ERR(q)) {
 		xe_gt_err(gt, "Failed to create queue for GSC submission\n");
-		err = PTR_ERR(q);
-		goto out_bo;
+		return PTR_ERR(q);
 	}
 
 	wq = alloc_ordered_workqueue("gsc-ordered-wq", 0);
@@ -509,8 +508,6 @@ int xe_gsc_init_post_hwconfig(struct xe_gsc *gsc)
 
 out_q:
 	xe_exec_queue_put(q);
-out_bo:
-	xe_bo_unpin_map_no_vm(bo);
 	return err;
 }
 
-- 
2.53.0



