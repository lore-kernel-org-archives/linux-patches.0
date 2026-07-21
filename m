Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FDA14343F1;
	Tue, 21 Jul 2026 19:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663235; cv=none; b=UPOrJ66kqMAZxhY0tkU+KacyhG0/aOvbKpGTdJRAQvmAoqcGTy3EDYFSLwlT1p3IiPqSm7YOxJ27UZ3EUekHO0NjGNNmkKkiX0ffqjEmGi65QC9cJZW5rXMaILxsXGWpPgtkIyAz2GJiBweNFv2xVZHiBDvVj5WqH7lVCAlpYa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663235; c=relaxed/simple;
	bh=7b49TVeJAymAEKd5A3qvVCuIpymrDDi6/aBsb6H5h5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SUynBNcXkVq671Qz5FzmU+Fw49R2HRD1jakW9XJp5kuRQwYklhPUcmXLlH7NGg+oE3CGwJUTJEs1JTE99eS4mvXG3JhNuvu9oAXR32ZtexhNWkdC1H5FsADVZad1Rk3Bgk2lVXQ6JMvPNP1dnaU/iUy9K5KW7XDPhji8+7GOE6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wU/dm0nR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wU/dm0nR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E08381F000E9;
	Tue, 21 Jul 2026 19:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663234;
	bh=L7PC5fJZ+exaE8AgfmJ1qNErf2t9NUS9UT0ZOXPHnu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wU/dm0nRNo4TxlH0AYdWmjNfgH2pJ/oyw9nbjY1/MfXj/0HuTZLiMWFnYgkcFrZli
	 /67PLxIRPZc7VciQOwzXASVoba9HfeNS8noknHkzHGxiJqnskIA3oMsqh2pmc8XsD1
	 XgtXRVzOzLGOwOXOqiZLx4Z135tTWEHGRnTApSjg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zongyao Bai <zongyao.bai@intel.com>,
	Shuicheng Lin <shuicheng.lin@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0747/1276] drm/xe/hw_engine: Fix double-free of managed BO in error path
Date: Tue, 21 Jul 2026 17:19:50 +0200
Message-ID: <20260721152502.797276683@linuxfoundation.org>
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

From: Shuicheng Lin <shuicheng.lin@intel.com>

[ Upstream commit 7ac3cae7a251d28e9079de07a991bd4eb2bb7fd8 ]

The error path in hw_engine_init() explicitly frees a BO allocated
with xe_managed_bo_create_pin_map() via xe_bo_unpin_map_no_vm().
Since the managed BO already has a devm cleanup action registered,
this causes a double-free when devm unwinds during probe failure.

Remove the explicit free and let devm handle it, consistent with
all other xe_managed_bo_create_pin_map() callers.

Fixes: 0e1a47fcabc8 ("drm/xe: Add a helper for DRM device-lifetime BO create")
Assisted-by: Claude:claude-opus-4.6
Reviewed-by: Zongyao Bai <zongyao.bai@intel.com>
Link: https://patch.msgid.link/20260626210631.3887291-1-shuicheng.lin@intel.com
Signed-off-by: Shuicheng Lin <shuicheng.lin@intel.com>
(cherry picked from commit e459a3bdeb117be496d7f229e2ea1f6c9fe4080b)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_hw_engine.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_hw_engine.c b/drivers/gpu/drm/xe/xe_hw_engine.c
index 0248597c6269a3..45d0ae074e6522 100644
--- a/drivers/gpu/drm/xe/xe_hw_engine.c
+++ b/drivers/gpu/drm/xe/xe_hw_engine.c
@@ -561,7 +561,7 @@ static int hw_engine_init(struct xe_gt *gt, struct xe_hw_engine *hwe,
 		hwe->exl_port = xe_execlist_port_create(xe, hwe);
 		if (IS_ERR(hwe->exl_port)) {
 			err = PTR_ERR(hwe->exl_port);
-			goto err_hwsp;
+			goto err_name;
 		}
 	} else {
 		/* GSCCS has a special interrupt for reset */
@@ -578,8 +578,6 @@ static int hw_engine_init(struct xe_gt *gt, struct xe_hw_engine *hwe,
 
 	return devm_add_action_or_reset(xe->drm.dev, hw_engine_fini, hwe);
 
-err_hwsp:
-	xe_bo_unpin_map_no_vm(hwe->hwsp);
 err_name:
 	hwe->name = NULL;
 
-- 
2.53.0



