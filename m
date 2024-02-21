Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 226C41E4B2;
	Wed, 21 Feb 2024 13:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522864; cv=none; b=eejIQrOi8128d8G0zNs3VsH+w6b2kIwL8/QDTwgwygl3SPVM9akDPOQvHSeCieRhjEMcdT4IBcDMvqgg3QNREtaegAyR5av/f4YBDeSyat6tzEAccsVOhVcitQeFPX+2mqT40hKiXfltlYoJuiN2ts0IsAb0UfiqKPA78kpkmYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522864; c=relaxed/simple;
	bh=i/n3TqOfdefGud3vfuXOQr168LA9WFECJFonPuCLPSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s3GETA5v/Wq/Lcy2gxvTQEfPMr1mj99YyQc663HLKSvD0dOqN7luOHZdptiIUHG5Xj82cKI3yXDHB6lV3BOTaHNaCh0Uy2uG1Q0r1JMYkkVU04xHdsff9jimLZNGJRvNj8kRBmKZpHvHTLLbrRytgWsS1PCMKAeQlyvpGVca1U0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ST2idm6i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ST2idm6i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EB25C43399;
	Wed, 21 Feb 2024 13:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522864;
	bh=i/n3TqOfdefGud3vfuXOQr168LA9WFECJFonPuCLPSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ST2idm6iaENk7GVzqGTvzGwr/ZUcsqH37rPnx84RjDUp7bHfoOEhP+rhRWd6Gl7pg
	 sqTtFsSYt08Ur4SF4NHPTPRpibaRd9xyiTdnHEATnnvJ9K7efEsphX/Rgt4bwYSl5i
	 U8V3SxSKn3ph7xNN055ch7dCI6VWlXT/3u0q/o8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Simon Horman <horms@kernel.org>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH 5.15 279/476] ixgbe: Fix an error handling path in ixgbe_read_iosf_sb_reg_x550()
Date: Wed, 21 Feb 2024 14:05:30 +0100
Message-ID: <20240221130018.288919825@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit bbc404d20d1b46d89b461918bc44587620eda200 ]

All error handling paths, except this one, go to 'out' where
release_swfw_sync() is called.
This call balances the acquire_swfw_sync() call done at the beginning of
the function.

Branch to the error handling path in order to correctly release some
resources in case of error.

Fixes: ae14a1d8e104 ("ixgbe: Fix IOSF SB access issues")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c
index f97d87698f23..1d3f99e664dc 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c
@@ -717,7 +717,8 @@ static s32 ixgbe_read_iosf_sb_reg_x550(struct ixgbe_hw *hw, u32 reg_addr,
 		error = (command & IXGBE_SB_IOSF_CTRL_CMPL_ERR_MASK) >>
 			 IXGBE_SB_IOSF_CTRL_CMPL_ERR_SHIFT;
 		hw_dbg(hw, "Failed to read, error %x\n", error);
-		return -EIO;
+		ret = -EIO;
+		goto out;
 	}
 
 	if (!ret)
-- 
2.43.0



