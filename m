Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 210A62EBB84;
	Tue, 12 May 2026 17:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778607952; cv=none; b=EJXXXPdVa69x9cKaEeSxrj0HfEettVb8RbUtl5xXtxkLWSIkEfRrTqkANXOlD0kNJLP2GM4OGH8vLr0LFJH43QSx6spW0Al8348GIZr2aUs9Q8TzIocG/fpMd+QfC1CPLOW8HjBROH9Kd6iLR/j++ZpFLKVI/aqwOxVKNWwQD2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778607952; c=relaxed/simple;
	bh=E6rn2Bm7Wq00vfEEmvRcph0cgl77Gtufa3WpuaItghg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jd6WFcQF58lUaPIcdah6tajUhTkv8v/Tb6nRsNbaA559u1a3uLd66mBq+rCtmXLTFXIGYm8WKIuRhek3zrhasTcuZO/I63+M+SFMUQLJi7iwB8yFSTxwBAg40koYINy2MBN/fFp6nMXwsX6S/fG9DoDoFRweiAlMaP6R42Mfh2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sN2G4AUZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sN2G4AUZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC127C2BCB0;
	Tue, 12 May 2026 17:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778607952;
	bh=E6rn2Bm7Wq00vfEEmvRcph0cgl77Gtufa3WpuaItghg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sN2G4AUZ17lmaru1h/F9Uk4wsE59xHAndy5dixYAL41XcM3FKFiIs9Xf33V3+lGG9
	 OuWBYS8LWMabFOpG+6VuZWp1CctPLF1AvRFPv04HoM594AbD5zwBYSgssYxJmtWcjj
	 Vc4scNaKd3gbaHHmGT7Xcd0Bj4r1BOJ316/804IY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 097/206] ice: fix double free in ice_sf_eth_activate() error path
Date: Tue, 12 May 2026 19:39:09 +0200
Message-ID: <20260512173934.911766101@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

commit 9aab1c3d7299285e2569cbc0ed5892d631a241b2 upstream.

When auxiliary_device_add() fails, ice_sf_eth_activate() jumps to
aux_dev_uninit and calls auxiliary_device_uninit(&sf_dev->adev).

The device release callback ice_sf_dev_release() frees sf_dev, but
the current error path falls through to sf_dev_free and calls
kfree(sf_dev) again, causing a double free.

Keep kfree(sf_dev) for the auxiliary_device_init() failure path, but
avoid falling through to sf_dev_free after auxiliary_device_uninit().

Fixes: 13acc5c4cdbe ("ice: subfunction activation and base devlink ops")
Cc: stable@vger.kernel.org
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20260416-iwl-net-submission-2026-04-14-v2-3-686c33c9828d@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ice/ice_sf_eth.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_sf_eth.c b/drivers/net/ethernet/intel/ice/ice_sf_eth.c
index 2cf04bc6edce..a730aa368c92 100644
--- a/drivers/net/ethernet/intel/ice/ice_sf_eth.c
+++ b/drivers/net/ethernet/intel/ice/ice_sf_eth.c
@@ -305,6 +305,8 @@ ice_sf_eth_activate(struct ice_dynamic_port *dyn_port,
 
 aux_dev_uninit:
 	auxiliary_device_uninit(&sf_dev->adev);
+	return err;
+
 sf_dev_free:
 	kfree(sf_dev);
 xa_erase:
-- 
2.54.0



