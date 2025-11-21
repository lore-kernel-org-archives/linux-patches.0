Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AAA11F09B3;
	Fri, 21 Nov 2025 13:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731598; cv=none; b=PbbXpaTXLhreZN6aWdPvSnhO3Pobup0as4YPl/gHMItWVwIwnAaKIRIRcRpjgSfVHoIoprBL79qdAoYgfvW+X6ith/tvfjykHJblx918NZsOrI2YZtirKpxAVtYN8fDz2MG05ja27tkR3hmw9IozhZb+xxMhHj9hpwD9bIB9pwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731598; c=relaxed/simple;
	bh=SuaAFycqUEu3JxUoUxASGf/vgiXEiG0ooKUy4BCGCnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WNmN6BbtmATZ3pgyS5+AJTWarQDjpB5g73P16Q3qOmFDzFuLPmsZ9Aty+5gKNFnkl4CfwdYcK2xvI1UFHBR9AiwYiJmsdwYp9MH6fFqp/VR70KhfdCtxk3FpqF1N55gcMYJt7q5tLOPLulcfqAXPWoOhXQqF15VMrwwcwwGgblM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H8fwCbHH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H8fwCbHH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2258C4CEF1;
	Fri, 21 Nov 2025 13:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731598;
	bh=SuaAFycqUEu3JxUoUxASGf/vgiXEiG0ooKUy4BCGCnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H8fwCbHHan3izQT5BzEynKm7JH8xmQInWFdZ90QgfGBeHB6b11X3a/YGdK1T1J0SC
	 assaFdqlfjqamM1vJ2gSrUrwYL8p/ypL/qJVgVaM2zYy7W7sp9uNjXX+Sot6OS+qZ1
	 KnnCVJ3EhgTHegaoZ8Y7j6+vROGBGdo+4PEqld+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhanjun Dong <zhanjun.dong@intel.com>,
	Balasubramani Vivekanandan <balasubramani.vivekanandan@intel.com>,
	Stuart Summers <stuart.summers@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 007/185] drm/xe/guc: Synchronize Dead CT worker with unbind
Date: Fri, 21 Nov 2025 14:10:34 +0100
Message-ID: <20251121130144.133982141@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

From: Balasubramani Vivekanandan <balasubramani.vivekanandan@intel.com>

[ Upstream commit 95af8f4fdce8349a5fe75264007f1af2aa1082ea ]

Cancel and wait for any Dead CT worker to complete before continuing
with device unbinding. Else the worker will end up using resources freed
by the undind operation.

Cc: Zhanjun Dong <zhanjun.dong@intel.com>
Fixes: d2c5a5a926f4 ("drm/xe/guc: Dead CT helper")
Signed-off-by: Balasubramani Vivekanandan <balasubramani.vivekanandan@intel.com>
Reviewed-by: Stuart Summers <stuart.summers@intel.com>
Link: https://patch.msgid.link/20251103123144.3231829-6-balasubramani.vivekanandan@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
(cherry picked from commit 492671339114e376aaa38626d637a2751cdef263)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_guc_ct.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_guc_ct.c b/drivers/gpu/drm/xe/xe_guc_ct.c
index d692e279d9fbf..7619b48dbfe43 100644
--- a/drivers/gpu/drm/xe/xe_guc_ct.c
+++ b/drivers/gpu/drm/xe/xe_guc_ct.c
@@ -188,6 +188,9 @@ static void guc_ct_fini(struct drm_device *drm, void *arg)
 {
 	struct xe_guc_ct *ct = arg;
 
+#if IS_ENABLED(CONFIG_DRM_XE_DEBUG)
+	cancel_work_sync(&ct->dead.worker);
+#endif
 	ct_exit_safe_mode(ct);
 	destroy_workqueue(ct->g2h_wq);
 	xa_destroy(&ct->fence_lookup);
-- 
2.51.0



