Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 961853A8FE7;
	Mon, 20 Apr 2026 13:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776690976; cv=none; b=FYhrzl5r9eXSU6hp3AR9Gzqhq+gvVQmk95oonCXw8TL1LAEWT0H1BtmN5mW9wjPBIYw+MX41wJTo3HazELSbF65ReNR7//wp0XMNvawcZ6xSsvFhXBWIrKpsgClQhjE2iheJE32hqCWhGn+CmOG9JAUunPjElE2UvtMe3bOZ9ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776690976; c=relaxed/simple;
	bh=3gnS4H5dN42k38IxAUh5e5CfDoKP9ZQMGb82ft8Sop0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xqn2odyQcKb+uOG2wE+2PlbbNT1EOTKEEchMDBESgs7OqF1H7bNnkJ9kB7GL0yEdpbCiSXlcwGqLhaqqzut0vws7g5+4ig4yqcn4/j/kefsI8oZGhtyVxbVM2x2O95HqDQgbOkqFBGIJ2KB4MyL1ImAAOw6/zTQuNaSfEu5qP9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R8Z7jEi4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R8Z7jEi4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E15A4C2BCC9;
	Mon, 20 Apr 2026 13:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776690975;
	bh=3gnS4H5dN42k38IxAUh5e5CfDoKP9ZQMGb82ft8Sop0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R8Z7jEi4Oq87usBdbuxfM8PhvjI1jIp/duOSrVCYZdkqKHsTcwl6er8tjNZYyaCEh
	 fMc7qG0NoiTr32m7JmOZngV60NdG/BnEhUxSQhmwBrtbG2NDEyv/91QS442jdkertZ
	 yzcj67jwuTAuR7Re6wFcHSl82KzcH8VHU835Um7VzI4GoCk3+609vVslFlOqH6Pnn6
	 3qNxe5DO8L4uPLFpx01AFgz8sn2tPg0Kh3VyiAeZLpwqIwa3yrYv5FVWMOB6pp3+H1
	 FwD0v4CekRi8iPpbdYzDApSOCt98pKvEc+FBnctbKpcSIDZUtmCYJJ8HtMzI8O9id2
	 xkjWUhwjIOK9w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Kohei Enju <kohei@enjuk.jp>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	jesse.brandeburg@intel.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	przemyslaw.kitszel@intel.com,
	sergey.temerkhanov@intel.com,
	intel-wired-lan@lists.osuosl.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] ice: ptp: don't WARN when controlling PF is unavailable
Date: Mon, 20 Apr 2026 09:08:07 -0400
Message-ID: <20260420131539.986432-21-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420131539.986432-1-sashal@kernel.org>
References: <20260420131539.986432-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.23
Content-Transfer-Encoding: 8bit

From: Kohei Enju <kohei@enjuk.jp>

[ Upstream commit bb3f21edc7056cdf44a7f7bd7ba65af40741838c ]

In VFIO passthrough setups, it is possible to pass through only a PF
which doesn't own the source timer. In that case the PTP controlling PF
(adapter->ctrl_pf) is never initialized in the VM, so ice_get_ctrl_ptp()
returns NULL and triggers WARN_ON() in ice_ptp_setup_pf().

Since this is an expected behavior in that configuration, replace
WARN_ON() with an informational message and return -EOPNOTSUPP.

Fixes: e800654e85b5 ("ice: Use ice_adapter for PTP shared data instead of auxdev")
Signed-off-by: Kohei Enju <kohei@enjuk.jp>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

 drivers/net/ethernet/intel/ice/ice_ptp.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index df38345b12d72..02517772fb5f4 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -3041,7 +3041,13 @@ static int ice_ptp_setup_pf(struct ice_pf *pf)
 	struct ice_ptp *ctrl_ptp = ice_get_ctrl_ptp(pf);
 	struct ice_ptp *ptp = &pf->ptp;
 
-	if (WARN_ON(!ctrl_ptp) || pf->hw.mac_type == ICE_MAC_UNKNOWN)
+	if (!ctrl_ptp) {
+		dev_info(ice_pf_to_dev(pf),
+			 "PTP unavailable: no controlling PF\n");
+		return -EOPNOTSUPP;
+	}
+
+	if (pf->hw.mac_type == ICE_MAC_UNKNOWN)
 		return -ENODEV;
 
 	INIT_LIST_HEAD(&ptp->port.list_node);
-- 
2.53.0

