Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36D0717727;
	Mon, 27 May 2024 19:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838229; cv=none; b=Ze7IFWuuqsUKbpcPige7Z0PfLTapQ4oNQxcG5Fiv5HPfbV9d3f6+BSO3ne5lbbyJx/6BHSRSmMJtXUTKsnrFYU+Hi4PkJnVY6llrPMOVx5OhYXTrzMSbVMzslmBX5cCxAj3iO0CLMgnVSVtbjwMBHzOKVo6YMlabxZXPbyg4tow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838229; c=relaxed/simple;
	bh=LYb24pcTBRvf7+eeNVPlwDOkAsum3E+37QUf1xAUhrs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bg3Arks2jDdUVIlRC6q1EKyZm7FIJThN4Gz73kpxpHFTLc1FbDflv/18QG1ORgLG2b8pb0q5kYmmK36TqoxITtjTERR25EZ25QjI+sdaJezAbbR/5CZJM1agWC+a+PVBdeO9xGPGo6SWnEDCi5r80xmdrc0txrCaftUnXBVJo14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xXPwoJyO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xXPwoJyO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDFC1C2BBFC;
	Mon, 27 May 2024 19:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838229;
	bh=LYb24pcTBRvf7+eeNVPlwDOkAsum3E+37QUf1xAUhrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xXPwoJyOrHFD8TZKbJVYq4/7hG7yTXZXhaa5WjeGlVpKaSaK46dskzxiW4vN4dOyh
	 QUrJp7zJLOYcAn6dSPp05zgzb0gCAV2tSP2ySx5gmPaWA1WLsyOU9qpQwK6EyUul/J
	 rujIIHm83MsKLib0GbYtXRDsEY+p4NmRbCHUXBZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Dan Nowlin <dan.nowlin@intel.com>,
	Paul Greenwalt <paul.greenwalt@intel.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH 6.8 307/493] ice: Fix package download algorithm
Date: Mon, 27 May 2024 20:55:09 +0200
Message-ID: <20240527185640.341796943@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Nowlin <dan.nowlin@intel.com>

[ Upstream commit 6d51d44ecddb5c2962688ef06e55e4fbc949f04a ]

Previously, the driver assumed that all signature segments would contain
one or more buffers to download. In the future, there will be signature
segments that will contain no buffers to download.

Correct download flow to allow for signature segments that have zero
download buffers and skip the download in this case.

Fixes: 3cbdb0343022 ("ice: Add support for E830 DDP package segment")
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Signed-off-by: Dan Nowlin <dan.nowlin@intel.com>
Signed-off-by: Paul Greenwalt <paul.greenwalt@intel.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Link: https://lore.kernel.org/r/20240508171908.2760776-1-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_ddp.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ddp.c b/drivers/net/ethernet/intel/ice/ice_ddp.c
index 8b7504a9df316..90b9e28ddba91 100644
--- a/drivers/net/ethernet/intel/ice/ice_ddp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ddp.c
@@ -1424,14 +1424,14 @@ ice_dwnld_sign_and_cfg_segs(struct ice_hw *hw, struct ice_pkg_hdr *pkg_hdr,
 		goto exit;
 	}
 
-	conf_idx = le32_to_cpu(seg->signed_seg_idx);
-	start = le32_to_cpu(seg->signed_buf_start);
 	count = le32_to_cpu(seg->signed_buf_count);
-
 	state = ice_download_pkg_sig_seg(hw, seg);
-	if (state)
+	if (state || !count)
 		goto exit;
 
+	conf_idx = le32_to_cpu(seg->signed_seg_idx);
+	start = le32_to_cpu(seg->signed_buf_start);
+
 	state = ice_download_pkg_config_seg(hw, pkg_hdr, conf_idx, start,
 					    count);
 
-- 
2.43.0



