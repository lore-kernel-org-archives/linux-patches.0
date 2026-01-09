Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF719336EDA;
	Fri,  9 Jan 2026 12:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962174; cv=none; b=Eu8vLBCDGNbaD7iDoWzeV8TMmIyZAXRyTrv6ZcNjLSzNufWWmDcN29FxVG4gNB98IX7U8yQlJdrGRrLtGCTyspn3DWwj5IoAEhUctd4jLKAHv+oLOB0UZ7Qxuyr0Uig28MGNy5oj+JU+8EJmzj/vD8WPBeIPCSlj1s9m5EdvtQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962174; c=relaxed/simple;
	bh=hE599tQlvlRIuLRoCPXgqOagVAmVs+c3F24GHv9QkBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VXAVbECFv5fStkMfSp52PB9pjs8dtOJeGhCGi/bhdfsidUMJYAi6ZrChT/F387aonTYO5bMRyrvu7UA1y4nh710LRb1uP4dyfOu5uWyC8qs0Oadfy1Awkq90P0E9KVi69JTUumou0e9IcRAOdkwCiUnzNuC8asf+B88XTzhAGcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n4YAU+55; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n4YAU+55"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D267C4CEF1;
	Fri,  9 Jan 2026 12:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962174;
	bh=hE599tQlvlRIuLRoCPXgqOagVAmVs+c3F24GHv9QkBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n4YAU+554MwlBY+Z97Wna4WiBI1nNvss8dUNiyzBDEN3JyCbPgsTct+ZE/yMSM9Ts
	 OP896YgkUiLME1B94pygThRR+rZEKWM8yupcVSYF0HNkMuOiJywFWyOSZEmeAQX/1E
	 3qA7J1sjM+eiIXNULRtmqtatECBYuNY3nPZrLquU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian Shen <shenjian15@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 271/634] net: hns3: add VLAN id validation before using
Date: Fri,  9 Jan 2026 12:39:09 +0100
Message-ID: <20260109112127.732773829@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jian Shen <shenjian15@huawei.com>

[ Upstream commit 6ef935e65902bfed53980ad2754b06a284ea8ac1 ]

Currently, the VLAN id may be used without validation when
receive a VLAN configuration mailbox from VF. The length of
vlan_del_fail_bmap is BITS_TO_LONGS(VLAN_N_VID). It may cause
out-of-bounds memory access once the VLAN id is bigger than
or equal to VLAN_N_VID.

Therefore, VLAN id needs to be checked to ensure it is within
the range of VLAN_N_VID.

Fixes: fe4144d47eef ("net: hns3: sync VLAN filter entries when kill VLAN ID failed")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20251211023737.2327018-4-shaojijie@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index c45340f26ee49..a92f056b25613 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -10585,6 +10585,9 @@ int hclge_set_vlan_filter(struct hnae3_handle *handle, __be16 proto,
 	bool writen_to_tbl = false;
 	int ret = 0;
 
+	if (vlan_id >= VLAN_N_VID)
+		return -EINVAL;
+
 	/* When device is resetting or reset failed, firmware is unable to
 	 * handle mailbox. Just record the vlan id, and remove it after
 	 * reset finished.
-- 
2.51.0



