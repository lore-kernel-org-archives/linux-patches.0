Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35C4726AF2;
	Mon, 27 May 2024 19:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836926; cv=none; b=ug0zTj3DeDqOBjrl+/EFVxZIy0EizbUNRZyoLbpjmsCO75cHVzAGm1HrtkVHX0MudURo5qhksj9iNhjDPNL4zArMFdWTDK7um59K0qxtFnwPpvgqWvkz/zfwH6mXjmb8LduJVp00GeIegs/OVSZRuDThSao3IPYX05YF6rshyKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836926; c=relaxed/simple;
	bh=2GG6jCS1q5MAI/roPd0MaKkY20DYKGy1bve7VGWLr0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BWhd6BXlIqw2UMIMBN5MuV2Cd8rSjfCFRs4PhL6lNCVKFD3YajZZOMjL2bWLz5x0mh78f+czfA6okMVeTYVIGn1V3ZUDAsK+0VAh3pwdkBRpi6uasUKe7qAnJvmZswLwkSeSnLLZ3ZEiRUUCx6oUoRg/mlQ6dCvskeREhDy70no=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q2dRhAa8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q2dRhAa8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD536C2BBFC;
	Mon, 27 May 2024 19:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836926;
	bh=2GG6jCS1q5MAI/roPd0MaKkY20DYKGy1bve7VGWLr0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q2dRhAa8Nb6SPkFszo+6eHxnuZYdtoWrwpKtsZFUxuVJNqYp2S90mqTeGLW7R8G+a
	 vBkg+FbHzOuXKJXa0LO5N4+/vtTmi+Xniwfor1buUhu4UrgIGUa2+dR65qVt02+WfV
	 YCSLZs4rBprJYDbuW3D0NWSDXNrgAdVi6u+kV5r8=
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
Subject: [PATCH 6.9 243/427] ice: Fix package download algorithm
Date: Mon, 27 May 2024 20:54:50 +0200
Message-ID: <20240527185625.262583602@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index fc91c4d411863..4df561d64bc38 100644
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



