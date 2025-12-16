Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 030CF33A036;
	Tue, 16 Dec 2025 12:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887119; cv=none; b=TFnqmywkcSTcIiu9piaj1sjxaHmf5N4C/pPzIBsAXpspUzRJDJNPD/+xoDdLlewWEYdXWYNhZzxFAFg4uZLL1/lAa55LIHVAzfMjwr0aDcxNQAW3WQIkCEwEXjHHzajZqFC9mZebI+NPbf6Jf9VICWUOH8BkAR5b6GQUn5xRCeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887119; c=relaxed/simple;
	bh=eoGDjfCjFtP+KGE34vq2h12rkedTspdLcsLIjnuWXtw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CLBT+W4tcNXQUxHTZaSITJhuLc6bQYTBKykoIPKvPQ0zn+cr1YZF/Y9ETVmtHJM80OHq5QnVbnUCBYHhKrJkHPZ82T0+dny6f8vPHowJ9qU+8X78+Tpj7vQSZmuTAclHd0w7MCW4KdqRBkCkVIVbWoX9kKTE+xv3Gyd60bjU5S0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bp/m5pa9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bp/m5pa9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 653D6C4CEF1;
	Tue, 16 Dec 2025 12:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887118;
	bh=eoGDjfCjFtP+KGE34vq2h12rkedTspdLcsLIjnuWXtw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bp/m5pa9NqUOmFxVuCf8XvGwoGWcQ5X+JrS9yAUn2v9v3yq/vAno/KwIprcKe6l51
	 29AjUBmBjo2dWqY/ChsxvF9W7tY5x2llhahHxTlhxu4u1zCvX4EjTcCf0XoIgCuBXh
	 o5R9wXSieifJ0cuDh/wkqAFP5PSlOcubS67/gNyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 6.18 099/614] ice: move ice_init_interrupt_scheme() prior ice_init_pf()
Date: Tue, 16 Dec 2025 12:07:46 +0100
Message-ID: <20251216111404.908220361@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Przemek Kitszel <przemyslaw.kitszel@intel.com>

[ Upstream commit 2fe18288fce6b421f1dc585bcb9dd3afa32d3ad9 ]

Move ice_init_interrupt_scheme() prior ice_init_pf().
To enable the move ice_set_pf_caps() was moved out from ice_init_pf()
to the caller (ice_init_dev()), and placed prior to the irq scheme init.

The move makes deinit order of ice_deinit_dev() and failure-path of
ice_init_pf() match (at least in terms of not calling
ice_clear_interrupt_scheme() and ice_deinit_pf() in opposite ways).

The new order aligns with findings made by Jakub Buchocki in
the commit 24b454bc354a ("ice: Fix ice module unload").

Signed-off-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Rinitha S <sx.rinitha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Stable-dep-of: 1390b8b3d2be ("ice: remove duplicate call to ice_deinit_hw() on error paths")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 25 ++++++++++-------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 41c2f0d52ce0d..13db83fb383e6 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -4043,8 +4043,6 @@ void ice_start_service_task(struct ice_pf *pf)
  */
 static int ice_init_pf(struct ice_pf *pf)
 {
-	ice_set_pf_caps(pf);
-
 	mutex_init(&pf->sw_mutex);
 	mutex_init(&pf->tc_mutex);
 	mutex_init(&pf->adev_mutex);
@@ -4746,11 +4744,18 @@ int ice_init_dev(struct ice_pf *pf)
 		ice_set_safe_mode_caps(hw);
 	}
 
+	ice_set_pf_caps(pf);
+	err = ice_init_interrupt_scheme(pf);
+	if (err) {
+		dev_err(dev, "ice_init_interrupt_scheme failed: %d\n", err);
+		return -EIO;
+	}
+
 	ice_start_service_task(pf);
 	err = ice_init_pf(pf);
 	if (err) {
 		dev_err(dev, "ice_init_pf failed: %d\n", err);
-		return err;
+		goto unroll_irq_scheme_init;
 	}
 
 	pf->hw.udp_tunnel_nic.set_port = ice_udp_tunnel_set_port;
@@ -4768,14 +4773,6 @@ int ice_init_dev(struct ice_pf *pf)
 		pf->hw.udp_tunnel_nic.tables[1].tunnel_types =
 			UDP_TUNNEL_TYPE_GENEVE;
 	}
-
-	err = ice_init_interrupt_scheme(pf);
-	if (err) {
-		dev_err(dev, "ice_init_interrupt_scheme failed: %d\n", err);
-		err = -EIO;
-		goto unroll_pf_init;
-	}
-
 	/* In case of MSIX we are going to setup the misc vector right here
 	 * to handle admin queue events etc. In case of legacy and MSI
 	 * the misc functionality and queue processing is combined in
@@ -4784,16 +4781,16 @@ int ice_init_dev(struct ice_pf *pf)
 	err = ice_req_irq_msix_misc(pf);
 	if (err) {
 		dev_err(dev, "setup of misc vector failed: %d\n", err);
-		goto unroll_irq_scheme_init;
+		goto unroll_pf_init;
 	}
 
 	return 0;
 
-unroll_irq_scheme_init:
-	ice_clear_interrupt_scheme(pf);
 unroll_pf_init:
 	ice_deinit_pf(pf);
+unroll_irq_scheme_init:
 	ice_service_task_stop(pf);
+	ice_clear_interrupt_scheme(pf);
 	return err;
 }
 
-- 
2.51.0



