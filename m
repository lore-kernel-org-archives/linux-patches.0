Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FDBE474AE7;
	Tue, 21 Jul 2026 18:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656802; cv=none; b=pVqX1OmB2t3GsLEoxnsQfbV6xxzoaJzOrrCv9Ls25w6axvJSDCk5RyR86MXh5hfc526nk2FFlqR0EQGi9D5ksHIgzHXoxKubg35vJ7Koad88q20UMDwHuIBL+3ohM5F936YcJdlQhke7qVAcfKXizJQhL+k6szqqGb/o3NWClVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656802; c=relaxed/simple;
	bh=itrnkyH/MtEQ5HjRwVARwhM7PEIDt9F4zGNW7xsZ28M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RVKpBZ+JvT+ZQQP/IQR/ohQ3VQZhpAO/535q52IidNka0DA2sQc1lqKX12B8y/sE+snoOX8ywZjbZZMaypg99vLVTOfesH0wAP1BD0skqaEbsWueC8sU+iOC6hLtxqZ83aNCRmxsWoX6fkRQHacmQvXuPPbf1HUoUJbTRQXglmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZssNKbdw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZssNKbdw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E2EB1F000E9;
	Tue, 21 Jul 2026 17:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656801;
	bh=9RXbL0OUzRcGPYl43Co78M5/iFVG9f/38RRbfKifVmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZssNKbdw1qMJ/OPeOnbMJFtf/WkLIr97dzVsZNtrX2ZO2uvXe8bXwWpjl0kWYP+M6
	 cO+xqu452GLjjEeuMrPTXyhmDgqsMle0HqiPRD/BTSivdMSOK1RsNAYyDmf7WyzWu0
	 6bSD4DYOuzKREdUz3qbKiDBIBS6AbUTjh20/PuB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Grzegorz Nitka <grzegorz.nitka@intel.com>,
	Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0525/1611] dpll: balance create/delete notifications in __dpll_pin_(un)register
Date: Tue, 21 Jul 2026 17:10:41 +0200
Message-ID: <20260721152527.158485595@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Grzegorz Nitka <grzegorz.nitka@intel.com>

[ Upstream commit 1a2292101c0dc422466c673031de03d2e871adbe ]

__dpll_pin_register() emits dpll_pin_create_ntf() internally, but
__dpll_pin_unregister() left the matching delete to its callers. The
counts then diverge on dpll_pin_on_pin_register() rollback and on
dpll_pin_on_pin_unregister(), leaking stale notifications.

Emit dpll_pin_delete_ntf() inside __dpll_pin_unregister() and drop the
now-redundant call in dpll_pin_unregister().

Fixes: 9431063ad323 ("dpll: core: Add DPLL framework base functions")
Signed-off-by: Grzegorz Nitka <grzegorz.nitka@intel.com>
Reviewed-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Link: https://patch.msgid.link/20260607183045.1213735-8-grzegorz.nitka@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dpll/dpll_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dpll/dpll_core.c b/drivers/dpll/dpll_core.c
index c457c7b03fce4d..6fa6a0d8e430dc 100644
--- a/drivers/dpll/dpll_core.c
+++ b/drivers/dpll/dpll_core.c
@@ -856,6 +856,7 @@ __dpll_pin_unregister(struct dpll_device *dpll, struct dpll_pin *pin,
 		      const struct dpll_pin_ops *ops, void *priv, void *cookie)
 {
 	ASSERT_DPLL_PIN_REGISTERED(pin);
+	dpll_pin_delete_ntf(pin);
 	dpll_xa_ref_pin_del(&dpll->pin_refs, pin, ops, priv, cookie);
 	dpll_xa_ref_dpll_del(&pin->dpll_refs, dpll, ops, priv, cookie);
 	if (xa_empty(&pin->dpll_refs)) {
@@ -883,7 +884,6 @@ void dpll_pin_unregister(struct dpll_device *dpll, struct dpll_pin *pin,
 		return;
 
 	mutex_lock(&dpll_lock);
-	dpll_pin_delete_ntf(pin);
 	__dpll_pin_unregister(dpll, pin, ops, priv, NULL);
 	mutex_unlock(&dpll_lock);
 }
-- 
2.53.0



