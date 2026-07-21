Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CBDE47143E;
	Tue, 21 Jul 2026 19:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662929; cv=none; b=CJEbox6/xBlXoKE9B50vf+zQPEUKYCa5oOrmlTPhtQgbX6gSxaP5ObySiyyKlPiLm1dEyTLNVN6ajYeRd+HkwZymY1S1kv1G8gMBZft9J8iXH6Ep9qB6aX/hawTj0Q50WamD5DVAk65MzS0wnIMbhDvVcskvfbXehpQZxc6uKoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662929; c=relaxed/simple;
	bh=wpBPoWScRRpu0w9v5DOmBDV9iQWLBsWj9kEXtCJRzmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CKBXfZDPogfUm/mRoN0oiYVJGgVQHO1On6dqEsHZzK84xahx+4Fvd52CaZBcWvbZyquUL+yV7Hef7aqtayHPYeq7ru7BICniitISYKep2ijhI2+6w/9KwEoDsJzg/tKDRTCFQt2qmDLKaYy731t32osath7vZeNJDGOsWSd9V7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eTymBYyx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eTymBYyx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7156D1F000E9;
	Tue, 21 Jul 2026 19:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662927;
	bh=5rUfiSGG0YwykDVQjtCd9DRS4jKHy3IVl5OdDWJnSRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eTymBYyx788H8/05qsJGmGRCBG4VV4r8uZMJGKyFUKJjgcm+DLcLJ5VWLAe5XZydv
	 tZeynyNLzTg3SeMngFFdpSAxC62gm5RF1Vn2rZqsDGDJEN8XfKmIA9eOZNUjsEXzYC
	 jCKkk8AbKIy9rXDWN5pGh3+VG4CFm89YIL1I8tik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ZhaoJinming <zhaojinming@uniontech.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 6.12 0629/1276] ice: dpll: set pointers to NULL after kfree in ice_dpll_deinit_info
Date: Tue, 21 Jul 2026 17:17:52 +0200
Message-ID: <20260721152500.184897321@linuxfoundation.org>
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
index 38e151c7ea2362..7864f29c30eaed 100644
--- a/drivers/net/ethernet/intel/ice/ice_dpll.c
+++ b/drivers/net/ethernet/intel/ice/ice_dpll.c
@@ -2279,9 +2279,13 @@ ice_dpll_init_pins_info(struct ice_pf *pf, enum ice_dpll_pin_type pin_type)
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



