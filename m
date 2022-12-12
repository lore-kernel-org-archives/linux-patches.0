Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5E5D28ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:18:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E317BC433D2;
	Mon, 12 Dec 2022 13:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670851105;
	bh=4yWfRhNy53E6Q33BNnxnukJlUirlBhwKmHPUvHZ1csU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BWcWDHbJg/s07n9ACfLUVxjSmxpRNnYJaHCDxGcjQyCQ8kSjpVm2q9SKCBf9HctlV
	 yjtOZax00+ukTyoZ2jRi5fnMWsXkhXWdv+yNOd6oRInyl8Xh2CtExN3q9br/3RZTTk
	 EMw2SJQMNj+rVEJuI1FmrmOZbyJBsnMKpJm++zM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>,
	Jan Sokolowski <jan.sokolowski@intel.com>,
	Konrad Jankowski <konrad0.jankowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 086/106] i40e: Fix for VF MAC address 0
Date: Mon, 12 Dec 2022 14:10:29 +0100
Message-Id: <20221212130928.625918080@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130924.863767275@linuxfoundation.org>
References: <20221212130924.863767275@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>

[ Upstream commit 08501970472077ed5de346ad89943a37d1692e9b ]

After spawning max VFs on a PF, some VFs were not getting resources and
their MAC addresses were 0. This was caused by PF sleeping before flushing
HW registers which caused VIRTCHNL_VFR_VFACTIVE to not be set in time for
VF.

Fix by adding a sleep after hw flush.

Fixes: e4b433f4a741 ("i40e: reset all VFs in parallel when rebuilding PF")
Signed-off-by: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
Signed-off-by: Jan Sokolowski <jan.sokolowski@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index 381b28a08746..bb2a79b70c3a 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -1525,6 +1525,7 @@ bool i40e_reset_vf(struct i40e_vf *vf, bool flr)
 	i40e_cleanup_reset_vf(vf);
 
 	i40e_flush(hw);
+	usleep_range(20000, 40000);
 	clear_bit(I40E_VF_STATE_RESETTING, &vf->vf_states);
 
 	return true;
@@ -1648,6 +1649,7 @@ bool i40e_reset_all_vfs(struct i40e_pf *pf, bool flr)
 	}
 
 	i40e_flush(hw);
+	usleep_range(20000, 40000);
 	clear_bit(__I40E_VF_DISABLE, pf->state);
 
 	return true;
-- 
2.35.1



