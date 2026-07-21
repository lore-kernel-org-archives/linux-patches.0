Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 372AF46EC7D;
	Tue, 21 Jul 2026 18:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659858; cv=none; b=kFHnQfRaHz9fz7YbfTPUOSLdE9WL7mGvDturRZqYOseh47BxEGy/x4hVFGRkIOVYX6xyOsAuzaU2fdZJ4N7f7BDd5qUVh2SwLlq8K+lN5bDR+xeJ2NSVmoNejpD180+M+B2tCPFBQ24cYP+6+Kgsas6FB+BpeK9O7QkJDELStNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659858; c=relaxed/simple;
	bh=VSZXHc6yHRj9iO7C7D39OgYiI5aS8B9P6ye2AIVmx9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kmZX6at/MvOmAgpfSpEVaRNFuRbJ5OO9Zv22BZhzfaDWw272iHUVd7sMElbVFbJuaLv/zMkpzmn5+My4HuqUN1LpcEZM9QkVLaUnwXbrHCjZnOk8cQja7uPD1HstXe8iJCuU+bYbgProdvsi2yyDzl7zpts6pH3ArV2g3o1mwsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XtFad578; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XtFad578"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CA051F000E9;
	Tue, 21 Jul 2026 18:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659855;
	bh=jhtBfriY/gttdryYLg2+MRjUQluZ94TOl52rpvQ2QME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XtFad578goQOzAWMD1dIws8Xq1hGu8o9otmGqO16Wm3LXui0TzWHa3qr9enxPR4hi
	 GgklARoYn17sudUEiJnv4aldT/1hJZjBalcPTy8f8/lmvcEShSMx34qPDbWK3WldyF
	 r+pq1Z/y6yrp5dp2ZdUkqdCB6OEeBXrJhsLgDvDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Grzegorz Nitka <grzegorz.nitka@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0759/2077] dpll: fix stale iteration in dpll_pin_on_pin_unregister()
Date: Tue, 21 Jul 2026 17:07:12 +0200
Message-ID: <20260721152610.695309650@linuxfoundation.org>
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

From: Grzegorz Nitka <grzegorz.nitka@intel.com>

[ Upstream commit 32239d600236a986c8e6d16aa814d3d91066b244 ]

Neither parent->dpll_refs nor pin->dpll_refs on its own is a correct
iteration target at unregister time:

  - pin->dpll_refs includes DPLLs the child was registered against
    via a different parent or directly; blind unregister WARNs on
    the cookie miss in dpll_xa_ref_pin_del().
  - parent->dpll_refs reflects the parent's current attachments, not
    those at child-register time. Another driver may have (un)reg'd
    the parent against additional DPLLs in the meantime, so we miss
    registrations that exist and visit DPLLs that have none.

Walk pin->dpll_refs and use dpll_pin_registration_find() to filter
to entries whose cookie is this parent. Symmetric with
dpll_pin_on_pin_register(), correct under any subsequent change to
parent->dpll_refs.

Fixes: 9431063ad323 ("dpll: core: Add DPLL framework base functions")
Signed-off-by: Grzegorz Nitka <grzegorz.nitka@intel.com>
Link: https://patch.msgid.link/20260607183045.1213735-4-grzegorz.nitka@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dpll/dpll_core.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/dpll/dpll_core.c b/drivers/dpll/dpll_core.c
index cbb635db43210f..1f1b9a6696231a 100644
--- a/drivers/dpll/dpll_core.c
+++ b/drivers/dpll/dpll_core.c
@@ -1018,14 +1018,19 @@ EXPORT_SYMBOL_GPL(dpll_pin_on_pin_register);
 void dpll_pin_on_pin_unregister(struct dpll_pin *parent, struct dpll_pin *pin,
 				const struct dpll_pin_ops *ops, void *priv)
 {
+	struct dpll_pin_registration *reg;
 	struct dpll_pin_ref *ref;
 	unsigned long i;
 
 	mutex_lock(&dpll_lock);
 	dpll_pin_delete_ntf(pin);
 	dpll_xa_ref_pin_del(&pin->parent_refs, parent, ops, priv, pin);
-	xa_for_each(&pin->dpll_refs, i, ref)
+	xa_for_each(&pin->dpll_refs, i, ref) {
+		reg = dpll_pin_registration_find(ref, ops, priv, parent);
+		if (!reg)
+			continue;
 		__dpll_pin_unregister(ref->dpll, pin, ops, priv, parent);
+	}
 	mutex_unlock(&dpll_lock);
 }
 EXPORT_SYMBOL_GPL(dpll_pin_on_pin_unregister);
-- 
2.53.0



