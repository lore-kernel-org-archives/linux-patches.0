Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1559223DF0;
	Mon, 23 Jun 2025 21:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715697; cv=none; b=Y39obb1U2K3xh7rrctWMSmUt43Q7VUetHMh6Nhc86amgp2NcEA2+SJ00QMTt3V7lorMGt0C1EdtZli3fr5h/P6wkiYJowx+Hqamrri85qIdBueEmMIqx43+sH9S1V2kKJmbiNBjakrS9urdt+7GO/gn/VlWIQh7BH7J8ObgqT5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715697; c=relaxed/simple;
	bh=qGMnS12Fr7/GH7B7cAmIgar/YhlGcwM13JgiSsfPIPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EOYZFAxQ169Kw4Cy1ZoatHeGV2isQVS4FrXxKFtZapqBfnKeRfM1kn3k7Sz5ZoUTEGz+PiM5y+9cFERY65imLKlh+pC1HWw3ET7xrwkbAMeXB3x7MlH4fsB9g4GLKrv9vHemVSWVlfEv6uW4YlNHgT8kRshpemOREiqRKxhhDd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Euf2wVUe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Euf2wVUe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B9DDC4CEF2;
	Mon, 23 Jun 2025 21:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715697;
	bh=qGMnS12Fr7/GH7B7cAmIgar/YhlGcwM13JgiSsfPIPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Euf2wVUeiBwJSQMRFwuvUoGlXRwucNLK1e3jjHOJhFMU4IrI8w6yFtLfRHFoCbQ/7
	 LaGsOmueMIfktMSilR/bBB+SSv7iHWO9uR+dQfSm/hW9riyMqBSs+BuKlXu48ODQe8
	 yxmADYsEs00uEK4VijoDaZroN4N38scj7edrendw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Malz <robert.malz@canonical.com>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 246/508] i40e: retry VFLR handling if there is ongoing VF reset
Date: Mon, 23 Jun 2025 15:04:51 +0200
Message-ID: <20250623130651.305136962@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robert Malz <robert.malz@canonical.com>

[ Upstream commit fb4e9239e029954a37a00818b21e837cebf2aa10 ]

When a VFLR interrupt is received during a VF reset initiated from a
different source, the VFLR may be not fully handled. This can
leave the VF in an undefined state.
To address this, set the I40E_VFLR_EVENT_PENDING bit again during VFLR
handling if the reset is not yet complete. This ensures the driver
will properly complete the VF reset in such scenarios.

Fixes: 52424f974bc5 ("i40e: Fix VF hang when reset is triggered on another VF")
Signed-off-by: Robert Malz <robert.malz@canonical.com>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index 87d74b54a3337..ff4f1c4f3829b 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -4267,7 +4267,10 @@ int i40e_vc_process_vflr_event(struct i40e_pf *pf)
 		reg = rd32(hw, I40E_GLGEN_VFLRSTAT(reg_idx));
 		if (reg & BIT(bit_idx))
 			/* i40e_reset_vf will clear the bit in GLGEN_VFLRSTAT */
-			i40e_reset_vf(vf, true);
+			if (!i40e_reset_vf(vf, true)) {
+				/* At least one VF did not finish resetting, retry next time */
+				set_bit(__I40E_VFLR_EVENT_PENDING, pf->state);
+			}
 	}
 
 	return 0;
-- 
2.39.5



