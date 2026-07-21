Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6280415F36;
	Tue, 21 Jul 2026 18:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658188; cv=none; b=LPFganUSIlawN6Z2r8aGrgpxXNQaSlKetAeIeHPsPrkLV5Iidu9av6hiWey3lq3u03XGhY3mNHLaw+hcf5T1e4WFPMRgOTyd6k0ZjCLtq8SHIjt5MRWZAfvehqweds7vkwKSOx6nNxd6PPOCQy2EcbQdaOGMEScj6qm61iqB/mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658188; c=relaxed/simple;
	bh=tTnozoX2L1tCUv8vq1XgE9y6hCDbQnkgXO1+fZUqhj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PVaxXAeuPn+29t62rCd7OfV63hUcX9uHQLhNTkSGm1EQ1jwEoXyBixGC63M9zJeMUrhcHpf+hfC2uwzH0yqT3b881RwDDEPCmkVtWfjCJvdrPHOKIojnpr9egKBb08CYd4kWfHP0P8wyGEX9M4J+UgD8UMHo+qvvlxD90ritH5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PyigVaya; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PyigVaya"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 394431F000E9;
	Tue, 21 Jul 2026 18:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658187;
	bh=O8wUy/JlSh0Ucm2w/0lIA7fNkhsnB3NWFuqZUVYcw4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PyigVaya5bNydHSvEkF4BS48fKqC6yUYe+mn8nFrCPOahV2G5+vypxdprKhHSL2YX
	 V3mbtiIuvZtMVpcrYgLu05aYfaZGHjDseQ5UL69LCpH0WzuWywWWoMt4FMwSDjPgDR
	 DokNCkBQYphrFmTYnkA6cVeWTVXnXkbPRSR/BUac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zongyao Bai <zongyao.bai@intel.com>,
	Shuicheng Lin <shuicheng.lin@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1022/1611] drm/xe/hw_engine: Fix double-free of managed BO in error path
Date: Tue, 21 Jul 2026 17:18:58 +0200
Message-ID: <20260721152538.379045518@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index d8f16e25b817db..d88770370eeb0f 100644
--- a/drivers/gpu/drm/xe/xe_hw_engine.c
+++ b/drivers/gpu/drm/xe/xe_hw_engine.c
@@ -619,7 +619,7 @@ static int hw_engine_init(struct xe_gt *gt, struct xe_hw_engine *hwe,
 		hwe->exl_port = xe_execlist_port_create(xe, hwe);
 		if (IS_ERR(hwe->exl_port)) {
 			err = PTR_ERR(hwe->exl_port);
-			goto err_hwsp;
+			goto err_name;
 		}
 	} else {
 		/* GSCCS has a special interrupt for reset */
@@ -639,8 +639,6 @@ static int hw_engine_init(struct xe_gt *gt, struct xe_hw_engine *hwe,
 
 	return devm_add_action_or_reset(xe->drm.dev, hw_engine_fini, hwe);
 
-err_hwsp:
-	xe_bo_unpin_map_no_vm(hwe->hwsp);
 err_name:
 	hwe->name = NULL;
 
-- 
2.53.0



