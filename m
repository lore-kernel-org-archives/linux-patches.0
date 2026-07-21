Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C84046A61C;
	Tue, 21 Jul 2026 18:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657883; cv=none; b=LcaPpbjjy6WiCA24DT70ytI/bWjib8A3NOzKgj2zIgimGtdhr+lBnc7f0tobjk2V9PAqmu3WGCffLxBWZBD8o8kba0P+K+qSDfxoAxQcmJmXxMVPp2fTyg3T3u4RVnYnpczCuYpx/wXLTWa+T6LpRZAaT9v1F9Cjvu64Hcxw1K8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657883; c=relaxed/simple;
	bh=oM1f55cxdKMiXKcYzmXKXYEG0xyACFXN7we05K7/SAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gG74KB3JacP1zPcAcljcFA7HlLz7c/W6H0XijnIrZx3f6hWfUNQqycULmKioV7g37fxDFqvSXYrzX0tJTYzaCml2WkfFszle/FdAkA8eDxq8PwvHVslLO4+bHraFB/xZszGiXYH0qcfwQ+6RFv3q/xGcf4GAT6KwQpSPrt690II=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OJvTBwo1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OJvTBwo1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABD4B1F000E9;
	Tue, 21 Jul 2026 18:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657881;
	bh=e8QycP5+i/S91cBJLRtUw+qppkpDs/cjbIFjlYgpXO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OJvTBwo1QNZ6m8ieduj3whNCZaDNcCEYJptZsrP/Y+gyRePpg0pC/bgTnX/FGRixJ
	 L6uPgWvv2Xjo3zeKe5IjbEEi0zi47GOzSFVPcFh0rFVc6+yibYyWwweLQJOVsqaLOJ
	 lDSFZOoV86BtWxc5FbxgYss055jDNeAYxklciSBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ZhaoJinming <zhaojinming@uniontech.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 6.18 0889/1611] ice: dpll: set pointers to NULL after kfree in ice_dpll_deinit_info
Date: Tue, 21 Jul 2026 17:16:45 +0200
Message-ID: <20260721152535.386252796@linuxfoundation.org>
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
index 81267bae0e5cb5..f3a7129d91d3ea 100644
--- a/drivers/net/ethernet/intel/ice/ice_dpll.c
+++ b/drivers/net/ethernet/intel/ice/ice_dpll.c
@@ -3772,9 +3772,13 @@ ice_dpll_init_pins_info(struct ice_pf *pf, enum ice_dpll_pin_type pin_type)
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



