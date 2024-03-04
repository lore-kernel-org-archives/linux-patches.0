Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B60B27994A;
	Mon,  4 Mar 2024 21:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587591; cv=none; b=fEZBfYZNPbC3v5dYqi0/mirIRaP0yk7O+Mor5y//0zCBcvUhVoDx+zd9agrQqEw1R5fEBzR3W4MtdfIkt6Cm6nzoaJckuW8MMNJuxOx4hQ1f2yVHOdehGFHi9IlbxI1BQOrDDhgmv05Vc43JSL0DUUEWFWMxco+6hufcWKtnGG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587591; c=relaxed/simple;
	bh=Yy4ksJBnad2P4DFIerOIZXziqoSSBaZGg/HStVAm4ew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eBSDg50sRsdHKWk68OofnxoGFlZ2C4NA36EiqAlVS3eSpZml+soLzp0VNfWtaCN50/FYLbd3VLHs5mtSxvFUkm8+VwqRwByaKQZpd3R/H+zOJW/6i4PKYncWo2h4SQtCth6MmHJMtmWrQQdVmo+a72G7lUfXDFZBYau/Bju1nig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aXHBxQqp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aXHBxQqp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 401B5C43390;
	Mon,  4 Mar 2024 21:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587591;
	bh=Yy4ksJBnad2P4DFIerOIZXziqoSSBaZGg/HStVAm4ew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aXHBxQqp4o47Z/a1Vh/G1FOnAZ0hfu3uMnOhUvaaGfDPt1ulEzlTcj/pNk+7kTgFP
	 1VdDKoFyyA2W1LX7Z5fm8RRGWPX7xDRKrwUWLGRP7bSQqa17Mm6r+gDyaJJ80TH/cg
	 XwYBTU70wDry6aPMVD4i4hCeWnPsUTnFIK81jgRg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Bagnucki <igor.bagnucki@intel.com>,
	Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH 6.7 007/162] ice: fix pin phase adjust updates on PF reset
Date: Mon,  4 Mar 2024 21:21:12 +0000
Message-ID: <20240304211552.070585503@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>

[ Upstream commit ee89921da471edcb4b1e67f5bbfedddf39749782 ]

Do not allow to set phase adjust value for a pin if PF reset is in
progress, this would cause confusing netlink extack errors as the firmware
cannot process the request properly during the reset time.

Return (-EBUSY) and report extack error for the user who tries configure
pin phase adjust during the reset time.

Test by looping execution of below steps until netlink error appears:
- perform PF reset
$ echo 1 > /sys/class/net/<ice PF>/device/reset
- change pin phase adjust value:
$ ./tools/net/ynl/cli.py --spec Documentation/netlink/specs/dpll.yaml \
	--do pin-set --json '{"id":0, "phase-adjust":1000}'

Fixes: 90e1c90750d7 ("ice: dpll: implement phase related callbacks")
Reviewed-by: Igor Bagnucki <igor.bagnucki@intel.com>
Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_dpll.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_dpll.c b/drivers/net/ethernet/intel/ice/ice_dpll.c
index bcb9b9c13aabc..2b657d43c769d 100644
--- a/drivers/net/ethernet/intel/ice/ice_dpll.c
+++ b/drivers/net/ethernet/intel/ice/ice_dpll.c
@@ -988,6 +988,9 @@ ice_dpll_pin_phase_adjust_set(const struct dpll_pin *pin, void *pin_priv,
 	u8 flag, flags_en = 0;
 	int ret;
 
+	if (ice_dpll_is_reset(pf, extack))
+		return -EBUSY;
+
 	mutex_lock(&pf->dplls.lock);
 	switch (type) {
 	case ICE_DPLL_PIN_TYPE_INPUT:
-- 
2.43.0



