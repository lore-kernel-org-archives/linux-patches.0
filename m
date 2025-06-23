Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7676038DE1;
	Mon, 23 Jun 2025 21:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713519; cv=none; b=QhBKGF5cazGklOCVeskFtgZ92BMnDqoXn92RWnoAVKnyhEkSEjb7+YViTiymzJTn0om7GJck4QUKXpUsP876khuAD22pcF5a3BXG3p38FWHOQyxpfdbVafL39cHGVd00vanpOCRXph5rcIqiil6Pd1TgWpmPS75+tKQh2Yq9nFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713519; c=relaxed/simple;
	bh=Qatf3W0nyq4c9bVLCdo7ZK7czbPE4XkebyY+1HLXitc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SoxHnrTn/OylHT3GwN3+zmDJox04W69Hd5PuT7ix+1xSk7dekElrBdW1caf66oNnlXysX1QIIldrF18MTRQKqw2EthfXmUCPqkMmfOOxGh5CW0ZT+MJxsjV5TuF1CJBf8MLayvbmFhujsh5H656ZX3DJCgdU8G0EDs89m/lO2Ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VeFtWY8r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VeFtWY8r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A473DC4CEEA;
	Mon, 23 Jun 2025 21:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713519;
	bh=Qatf3W0nyq4c9bVLCdo7ZK7czbPE4XkebyY+1HLXitc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VeFtWY8r6ROtoqgAW7pTtFkSpYMXzGnqNaOzv9BfvFVUDu/uyQwV8v3OK/V9huLxW
	 Oc4EO212whjhM3yuY65BS7IGRtZjP5HDti1uRbyahrNzKVlR0dGx2V99fSp9sSprh+
	 vNh79COyCX7TIyKy+FdhNx7DS8ByRk7iMB+OxIrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Malz <robert.malz@canonical.com>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 151/411] i40e: retry VFLR handling if there is ongoing VF reset
Date: Mon, 23 Jun 2025 15:04:55 +0200
Message-ID: <20250623130637.429832538@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a5265b1a7184a..d5b8462aa3eae 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -4212,7 +4212,10 @@ int i40e_vc_process_vflr_event(struct i40e_pf *pf)
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



