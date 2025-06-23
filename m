Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61DDF24EA9D;
	Mon, 23 Jun 2025 13:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685270; cv=none; b=jWFvhm/lWbvKSX2RLX1kYummnwM4D82Ksb4DBAcdMNOVlsjZMJ7E/S6fYUPrw+EmDbIXrAVHpBqs9Z1wHxVOOPufzVV5KXBflnx063DYIM23Tybsf8R16g8CAVSzwBt5/ms51RapLBTAsugnBQMyoC8aGSB4gzGyFW0eF4KCb2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685270; c=relaxed/simple;
	bh=OFtFlDKkVKUho9ZH6Qr/0R+jIqI/QQSnhUhksqOm1qI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AHm5v+zq/itgmyVZX52UBhJmorRfl7Oq6oJiTEz5KbZHWMANuP1f7hr9SXFYmBz2l2dqI3GtbZPtQ0R5LUoPQot0jxmCNpph2ayBLjkC7g1oea84RO6Ccc9iH0J2UdetCtgMhOGBGfvhtI8UESSHXyrjLvv24FqlFL0qGu2awGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i4bR9w64; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i4bR9w64"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8777C4CEF0;
	Mon, 23 Jun 2025 13:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685270;
	bh=OFtFlDKkVKUho9ZH6Qr/0R+jIqI/QQSnhUhksqOm1qI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i4bR9w64oFtYPiHK+nvXlM8Nphh16zxapQF4dzFCYKyDkF+5o6DmtcvMvO7HOUT9V
	 nkbeIzYcwzNc0CNIIiGeHaQlTTLroXqKv4ecKRm2NszCHnzjJPBATdCS0pqgujHPEZ
	 B0fO73P8wDYmmxhDYqTs81wQPqdic0j7fbsstDbk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Malz <robert.malz@canonical.com>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 080/222] i40e: retry VFLR handling if there is ongoing VF reset
Date: Mon, 23 Jun 2025 15:06:55 +0200
Message-ID: <20250623130614.502740464@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 783581739417f..d8ba409122032 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -4125,7 +4125,10 @@ int i40e_vc_process_vflr_event(struct i40e_pf *pf)
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



