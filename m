Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9AE82F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:37:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AC7CC433D2;
	Wed, 12 Apr 2023 08:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681288621;
	bh=YWIk9rT/Gtmv4gf/oTVvDysdaVPmfHuPrk0fUPlqNAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lqq7XvXeeleU9sXkoFNaPvXTubBlcsW219o/zuOzN63HPcG1oan6Bk/5w1hhVpgpH
	 1rWVEjuECd0nWCvyh4C6Ju4Kihp7bdzg1mcZrNNRb+me/6gmwJgZSOcTPyv6HXNS3Q
	 ZOeiW9nM8jk4hZYMA96dCxIaClUZnxi1Ab9hptho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junfeng Guo <junfeng.guo@intel.com>,
	Lingyu Liu <lingyu.liu@intel.com>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 47/93] ice: Reset FDIR counter in FDIR init stage
Date: Wed, 12 Apr 2023 10:33:48 +0200
Message-Id: <20230412082825.130302728@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082823.045155996@linuxfoundation.org>
References: <20230412082823.045155996@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lingyu Liu <lingyu.liu@intel.com>

[ Upstream commit 83c911dc5e0e8e6eaa6431c06972a8f159bfe2fc ]

Reset the FDIR counters when FDIR inits. Without this patch,
when VF initializes or resets, all the FDIR counters are not
cleaned, which may cause unexpected behaviors for future FDIR
rule create (e.g., rule conflict).

Fixes: 1f7ea1cd6a37 ("ice: Enable FDIR Configure for AVF")
Signed-off-by: Junfeng Guo <junfeng.guo@intel.com>
Signed-off-by: Lingyu Liu <lingyu.liu@intel.com>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/intel/ice/ice_virtchnl_fdir.c   | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c
index 2254cae817c16..412deb36b645b 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c
@@ -731,6 +731,21 @@ static void ice_vc_fdir_rem_prof_all(struct ice_vf *vf)
 	}
 }
 
+/**
+ * ice_vc_fdir_reset_cnt_all - reset all FDIR counters for this VF FDIR
+ * @fdir: pointer to the VF FDIR structure
+ */
+static void ice_vc_fdir_reset_cnt_all(struct ice_vf_fdir *fdir)
+{
+	enum ice_fltr_ptype flow;
+
+	for (flow = ICE_FLTR_PTYPE_NONF_NONE;
+	     flow < ICE_FLTR_PTYPE_MAX; flow++) {
+		fdir->fdir_fltr_cnt[flow][0] = 0;
+		fdir->fdir_fltr_cnt[flow][1] = 0;
+	}
+}
+
 /**
  * ice_vc_fdir_has_prof_conflict
  * @vf: pointer to the VF structure
@@ -2263,6 +2278,7 @@ void ice_vf_fdir_init(struct ice_vf *vf)
 	spin_lock_init(&fdir->ctx_lock);
 	fdir->ctx_irq.flags = 0;
 	fdir->ctx_done.flags = 0;
+	ice_vc_fdir_reset_cnt_all(fdir);
 }
 
 /**
-- 
2.39.2



