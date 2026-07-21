Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B45293644B3;
	Tue, 21 Jul 2026 19:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662363; cv=none; b=c+xx4Pc4y5h/W6NpziT25lV1HgWRq1At23/jsaeDtl7J7fDOpDTwAAHhqAXgTtQ6Oyt/+lZ63wUVkCegW3yBOexth9r9EdLR9TtOyyfhKZOv+4sujhwSzhwNqZ3scNzbJBNctZnTlGWDZBwOCrkeZG6eanlP4+tPSJA8Zr2WnIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662363; c=relaxed/simple;
	bh=rW3WV6K/8K/gFaf3C2cDf/enFLmOpafBV3trQt6hqVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UdHf04HIC2LDIlhzSiiOAavoIP4sjfn4/iAaVwH6d9SrCJqp3WzcRl4Vc9enopgjiFkv2g462wy4yKeuzcsRFpY73Sa9o/zewBnwlyeHqLxZzpkj58vEqFRnMsGWb6Dcijjr/N0LHqtMe9ZDaF71mxGG6cfBAilDAa/13Pb/wao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dShS4NAX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dShS4NAX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20B4F1F000E9;
	Tue, 21 Jul 2026 19:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662362;
	bh=vbgkurmRJw0g+U9eaqxNS1Lr4WMvHo7jafwHkMOC5CE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dShS4NAXDf+fRxJwe6vfYW8M+CHHmkfiSr/ik1nDsrGD6kYGSvXnbyiZwpxfXbHpv
	 AEooDNPs5KSP6FqIvVspp2Tt2TSuvE893GNlczBzU4FWO+NkUpvxb0GW7NmLF02QE1
	 SzpR1oafkiE1YnoUJ43cfAf1rK+r5+ue+XscElIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Grzegorz Nitka <grzegorz.nitka@intel.com>,
	Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0372/1276] dpll: balance create/delete notifications in __dpll_pin_(un)register
Date: Tue, 21 Jul 2026 17:13:35 +0200
Message-ID: <20260721152454.431019811@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

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



