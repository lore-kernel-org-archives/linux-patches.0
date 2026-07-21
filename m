Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66B98417D67;
	Tue, 21 Jul 2026 19:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661048; cv=none; b=XrDs8+WvRU1Yo9+SSP8ixFyUMDaHpZBHqmgjxOSnvLBvaf0wITwPU+JuJCIv+nVItDiCgZyNwtjStSytKvmQG4jhdNi3el1nON6tF1543rGZewsyoBx/k2anD/fmuDGUPDekwAv4ZcP7rbEEzmPwCOKnwFowytP+kFzPzcSmWH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661048; c=relaxed/simple;
	bh=u9MuZa6LvW55vkdkfqKaLRy5aObPXg31e2EqmxJ+Ljg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i1mMIOijv5eVTDIK3B/YXWy9weko7EY44r1Qofk9MbD0M8o2oIDK1At/6lrv01P9G4nirxW0Xxw47dJ1SjRSMKJwZMdyUPZctzU4IbrpkcHmFqzeqOeukQyRh1BqRg6Zvt+tPs41+oizJ4/Nc5zlr59edo4DwQZV5WAZuNgwfaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1FkLu9EC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1FkLu9EC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC68A1F000E9;
	Tue, 21 Jul 2026 19:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661047;
	bh=GhP/FXzbMnknEdQPw1dabVxFhBYil19+5b0uQQTPWtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1FkLu9ECL4qtUx1V4Zgf2U3cLPrN3NCxeu3nxIQisTTtrlvc+EnH04nU4xCWv9dJj
	 hXDlMiIztcqaHJhXxOONYdNwy5ev8UvMwKa8XTfe9BWqMupWEeyMuqpsdJPsyNctbS
	 RRaaLtxS4hNJcaA7vp6r+aqSt5xpVQD0bz+1sPqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ZhaoJinming <zhaojinming@uniontech.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 7.1 1212/2077] ice: dpll: set pointers to NULL after kfree in ice_dpll_deinit_info
Date: Tue, 21 Jul 2026 17:14:45 +0200
Message-ID: <20260721152621.402825480@linuxfoundation.org>
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

From: ZhaoJinming <zhaojinming@uniontech.com>

[ Upstream commit a903afff66d7379c6ece42bd18b2a17f4c79d1a9 ]

ice_dpll_deinit_info() calls kfree() on several pf->dplls fields
(inputs, outputs, eec.input_prio, pps.input_prio) but does not set
the pointers to NULL afterward. This leaves dangling pointers in the
pf->dplls structure.

While not currently exploitable through existing code paths, this is
unsafe because:

1. If ice_dpll_init_info() is called again after a deinit (e.g. during
   driver recovery), and a subsequent allocation within init fails, the
   error path will jump to deinit_info and call ice_dpll_deinit_info()
   again. Since some pointers still hold the old freed addresses, this
   would result in a double-free.

2. Any future code that checks these pointers before use or after free
   would be unprotected against use-after-free.

Follow the common kernel convention of setting pointers to NULL after
kfree() so that:
- kfree(NULL) is a safe no-op, preventing double-free
- NULL checks on these pointers become meaningful

This is a preparatory fix for a subsequent patch that routes additional
error paths in ice_dpll_init_info() to the deinit_info label.

Fixes: d7999f5ea64b ("ice: implement dpll interface to control cgu")
Signed-off-by: ZhaoJinming <zhaojinming@uniontech.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Rinitha S <sx.rinitha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_dpll.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_dpll.c b/drivers/net/ethernet/intel/ice/ice_dpll.c
index 0704e92ab04305..ff5053abb854b6 100644
--- a/drivers/net/ethernet/intel/ice/ice_dpll.c
+++ b/drivers/net/ethernet/intel/ice/ice_dpll.c
@@ -4249,9 +4249,13 @@ ice_dpll_init_pins_info(struct ice_pf *pf, enum ice_dpll_pin_type pin_type)
 static void ice_dpll_deinit_info(struct ice_pf *pf)
 {
 	kfree(pf->dplls.inputs);
+	pf->dplls.inputs = NULL;
 	kfree(pf->dplls.outputs);
+	pf->dplls.outputs = NULL;
 	kfree(pf->dplls.eec.input_prio);
+	pf->dplls.eec.input_prio = NULL;
 	kfree(pf->dplls.pps.input_prio);
+	pf->dplls.pps.input_prio = NULL;
 }
 
 /**
-- 
2.53.0



