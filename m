Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1296B474AE7;
	Tue, 21 Jul 2026 17:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656799; cv=none; b=VaNT5vvdWhBImYgtK7iRi0lcPLSdiSuHk0JilSkj12/4x2WkFqkOckVd+bJNzenT9euM+UcGOG2bq+FS75XqrpORZjpYOjyEaSaqwfJq4cZDMnbHM01gcdMuBdIVEiJ0eat0j+Nh9cPBLNp0tQTHTt2qTZ7bFWdvskpc6+9UP0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656799; c=relaxed/simple;
	bh=yR48MgmR05nyTliSZf25ewQGkkvgqTD9UGQ8xP2rS9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ggm5uNP3I9ODtp3c3fF5SQRw6ToUAT+3r4uvwyL3J/AryJfCiBdoaRkF8cUtqPCI9P7t3V8YgOrXmFefXIz/XHS3A72KE5BSMW+gLI7JJfys0HnlbELsKJ+IabX2jzyx47OBsaeHBv2H77JZKzU5AdQLawtzCw2ds1OmNrYPdkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IzhHfUA7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IzhHfUA7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 794C31F000E9;
	Tue, 21 Jul 2026 17:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656798;
	bh=QrPdzi+yqgC+u+NqL54mlIr8wNHDkm17DsD/PBC/w0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IzhHfUA7PocVPvmJKj+Q3t2tOCCkB5OKr1iOcl1slSRsz6kKpP2XzDrVOrNbP235U
	 dyiZVxkRFwi6peWnC5DlZBBZx7R7fu4IL6sVg9pRvbk2A8fehx3K9/aoHHeLjPnDbJ
	 U8KIfye963lStifMLbfsCjIoqN1rPjdAidptl/NQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Grzegorz Nitka <grzegorz.nitka@intel.com>,
	Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0524/1611] dpll: guard sync-pair removal on full pin unregister
Date: Tue, 21 Jul 2026 17:10:40 +0200
Message-ID: <20260721152527.136014879@linuxfoundation.org>
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

[ Upstream commit 0a5c720a7d57d2287d5566c4ad93ee26b7c06845 ]

__dpll_pin_unregister() wiped the global sync-pair state on every
(dpll, ops, priv, cookie) tuple removed from a pin. When a pin is
registered multiple times and only one registration is being torn
down, this dropped sync-pair pairings still in use by the surviving
registrations.

Move dpll_pin_ref_sync_pair_del() inside the xa_empty(&pin->dpll_refs)
branch so it only runs when the last registration is gone, alongside
clearing the DPLL_REGISTERED mark.

Fixes: 58256a26bfb3 ("dpll: add reference sync get/set")
Signed-off-by: Grzegorz Nitka <grzegorz.nitka@intel.com>
Reviewed-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Link: https://patch.msgid.link/20260607183045.1213735-7-grzegorz.nitka@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dpll/dpll_core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/dpll/dpll_core.c b/drivers/dpll/dpll_core.c
index 08b5055ee09cf5..c457c7b03fce4d 100644
--- a/drivers/dpll/dpll_core.c
+++ b/drivers/dpll/dpll_core.c
@@ -856,11 +856,12 @@ __dpll_pin_unregister(struct dpll_device *dpll, struct dpll_pin *pin,
 		      const struct dpll_pin_ops *ops, void *priv, void *cookie)
 {
 	ASSERT_DPLL_PIN_REGISTERED(pin);
-	dpll_pin_ref_sync_pair_del(pin->id);
 	dpll_xa_ref_pin_del(&dpll->pin_refs, pin, ops, priv, cookie);
 	dpll_xa_ref_dpll_del(&pin->dpll_refs, dpll, ops, priv, cookie);
-	if (xa_empty(&pin->dpll_refs))
+	if (xa_empty(&pin->dpll_refs)) {
+		dpll_pin_ref_sync_pair_del(pin->id);
 		xa_clear_mark(&dpll_pin_xa, pin->id, DPLL_REGISTERED);
+	}
 }
 
 /**
-- 
2.53.0



