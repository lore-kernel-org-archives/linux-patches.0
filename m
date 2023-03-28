Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16B198BE0
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 15:07:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DF3FC433EF;
	Tue, 28 Mar 2023 15:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680016054;
	bh=jo9kQ5ygQfoK0N2d3Rz4/2jYseiKz7W+XG0vfg/2K6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wxx0DyRlaUHIAvcx/cluIEsymVgaMTFRLSE1Q50m0y5TlRXsDrtg+viQsc+EUntHz
	 ZiPpgNh0p7NgtKN+bYeGRHKxvTcDOc+keEnXMwJo1rqZW8wHlWC+rxPx5hTHpmjJ+l
	 nLrSPeC8nJqqE1Ta8PgM04y/7lIOKoPfwc2/Uxb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniil Tatianin <d-tatianin@yandex-team.ru>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 031/146] qed/qed_sriov: guard against NULL derefs from qed_iov_get_vf_info
Date: Tue, 28 Mar 2023 16:42:00 +0200
Message-Id: <20230328142604.011526807@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142602.660084725@linuxfoundation.org>
References: <20230328142602.660084725@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Daniil Tatianin <d-tatianin@yandex-team.ru>

[ Upstream commit 25143b6a01d0cc5319edd3de22ffa2578b045550 ]

We have to make sure that the info returned by the helper is valid
before using it.

Found by Linux Verification Center (linuxtesting.org) with the SVACE
static analysis tool.

Fixes: f990c82c385b ("qed*: Add support for ndo_set_vf_trust")
Fixes: 733def6a04bf ("qed*: IOV link control")
Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qed/qed_sriov.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_sriov.c b/drivers/net/ethernet/qlogic/qed/qed_sriov.c
index 3eb05376e7c3e..bf0ba3855da1d 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_sriov.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_sriov.c
@@ -4378,6 +4378,9 @@ qed_iov_configure_min_tx_rate(struct qed_dev *cdev, int vfid, u32 rate)
 	}
 
 	vf = qed_iov_get_vf_info(QED_LEADING_HWFN(cdev), (u16)vfid, true);
+	if (!vf)
+		return -EINVAL;
+
 	vport_id = vf->vport_id;
 
 	return qed_configure_vport_wfq(cdev, vport_id, rate);
@@ -5124,7 +5127,7 @@ static void qed_iov_handle_trust_change(struct qed_hwfn *hwfn)
 
 		/* Validate that the VF has a configured vport */
 		vf = qed_iov_get_vf_info(hwfn, i, true);
-		if (!vf->vport_instance)
+		if (!vf || !vf->vport_instance)
 			continue;
 
 		memset(&params, 0, sizeof(params));
-- 
2.39.2



