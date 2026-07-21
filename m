Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 075EC3E49CF;
	Tue, 21 Jul 2026 17:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653639; cv=none; b=a0cYhARLTUTY6htTm3N69o2gNdlUf/j0BIq4UA9VdzI4tOz2dFV2alGTk4aQuPkzADc8IbkPnri7Uh/z/vvxbgfhA7i4yvLXISFpmm4S8iGHCOMlK+ZTMux7RHnsYSgBQjuqYqKC/0OfAuKBMjFLXXgEGaBHyJFciY000glYXIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653639; c=relaxed/simple;
	bh=FFD8fi0CaPoBrcPzZFnpo6yzFLdYoZ5fDDj3CH5UMlg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e9LgZIh72eLgW7pAGVGwUxp+yPT1hCufSiLA1rC1Syju4JGFZYdWSHEOlIMSxt+1aQQW1yfFITu0ni8/ZaNyf9n7RDM1iv3E+iAh93S2Sz9A1JPYXV+EThv217WGfY+HDZMJJK1UiwEqLhKWo8v7Mzv2nRpgrpwjVgEVja/eLdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ni0wMB3A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ni0wMB3A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E0011F00A3A;
	Tue, 21 Jul 2026 17:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653636;
	bh=BsXQ++LJiOKR+1jQjBJsN+3OMqmrOXF2HUDBLrSfFg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ni0wMB3Avur4bMeB6lBrWKlatS7Jye28wQmc43mUYQV5v8gXNVJr97Qguv8oD0JvO
	 CY+g5G15J91ah9cF4ZxAjh+2hlSW+cVhAbbvObzlcB3tmAde1gmUEg4f9S1dDzqEI3
	 /y4GCNGeYpbAZzEiBF2iAYuOrGaws9UbuKYi5Z8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zongyao Bai <zongyao.bai@intel.com>,
	Shuicheng Lin <shuicheng.lin@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1402/2077] drm/xe/hw_engine: Fix double-free of managed BO in error path
Date: Tue, 21 Jul 2026 17:17:55 +0200
Message-ID: <20260721152625.877333428@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 6dd05fac659564..a7441a66e94c21 100644
--- a/drivers/gpu/drm/xe/xe_hw_engine.c
+++ b/drivers/gpu/drm/xe/xe_hw_engine.c
@@ -629,7 +629,7 @@ static int hw_engine_init(struct xe_gt *gt, struct xe_hw_engine *hwe,
 		hwe->exl_port = xe_execlist_port_create(xe, hwe);
 		if (IS_ERR(hwe->exl_port)) {
 			err = PTR_ERR(hwe->exl_port);
-			goto err_hwsp;
+			goto err_name;
 		}
 	} else {
 		/* GSCCS has a special interrupt for reset */
@@ -649,8 +649,6 @@ static int hw_engine_init(struct xe_gt *gt, struct xe_hw_engine *hwe,
 
 	return devm_add_action_or_reset(xe->drm.dev, hw_engine_fini, hwe);
 
-err_hwsp:
-	xe_bo_unpin_map_no_vm(hwe->hwsp);
 err_name:
 	hwe->name = NULL;
 
-- 
2.53.0



