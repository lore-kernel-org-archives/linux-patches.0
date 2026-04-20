Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 798462E093A;
	Mon, 20 Apr 2026 15:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700777; cv=none; b=Rs4pHHvMTawA2oQD9nJgn9nWkSVxiXwPf+q6X64cu+R65xRBVh8le/ZHchG5vPK3xBAFCKDQMQaiqtAu3z453TThQtnNhUp9WLokn1lsP9MV/6MrejlnkNXsAzqk7INF/1CNSTOHGtBicbjPr7MLNUCAVpRdopXXKSfP98S8YWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700777; c=relaxed/simple;
	bh=gQLPDidOiBzysNMmN8zsLxKUThfta+6xcf2H3LsCg/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uvIYeFFFCBiajQqbzAy5Yvh9V7Tv1/HPiTARZnFPGReSNtkAc4GFH1Eq/qGEcHck5B01Xn7VDiKLE/+NpYq6b4P5WKZdlb0rlToZTABNnNxkkpkowpt8GSWTfyIFDtd8OvRdj3pg9IjCXFYrbqIr4UI1xE5B9z8A6FdLuZ1Ecn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SRR57Qdj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SRR57Qdj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F8E4C19425;
	Mon, 20 Apr 2026 15:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700777;
	bh=gQLPDidOiBzysNMmN8zsLxKUThfta+6xcf2H3LsCg/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SRR57QdjcIZ1X1tk8MViWvFhXMrRpWNHPTK07fdPmQOPn7UQiLMaeyF1+1nMxHh/x
	 SyldTJ+lS4B9jXEtxoKm/9+COJJwYYEUaooUFSuPcnA6qUTQ+rz9KcHeBcWN+hiEAm
	 /zF5XWyXgA8aKvwuBuQEH6Bgh/yrYeLQwBewmZqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kohei Enju <kohei@enjuk.jp>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 084/198] ice: ptp: dont WARN when controlling PF is unavailable
Date: Mon, 20 Apr 2026 17:41:03 +0200
Message-ID: <20260420153938.632058786@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153935.605963767@linuxfoundation.org>
References: <20260420153935.605963767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

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



