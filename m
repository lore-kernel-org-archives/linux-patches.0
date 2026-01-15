Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2B2C3C008D;
	Thu, 15 Jan 2026 17:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498001; cv=none; b=We7TajhHK+7iLt/U8kX7QKSTLjxu8QqmusTUzHB9ogeF89hcwM27TJv/0K/M1RO0GY+s2H3K8PXg4ZaQsullKf37czT+mxUxvmTjG8mgiYT3lOuADpNHrQBcfoIulfa4WDqOMoMi2ACRI6Ec+7DK6ov0l9uoDs5UF15+Xf0FtmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498001; c=relaxed/simple;
	bh=zvjiXceDCIltFsEssRh2iwEbNhJnFzzqcK0W4H92J2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RhNS9C16791PxgJBo7MZaJwnIWF6xvt6PAYxEzgB4Pm494gG+0etfbis2P8/3/UEiRUno2dTzBUedCSG/AiPqI76pXpLOsufEr8wx5N4nzGRn+kbQfb1q7LNRnaIlai5BwUjcwMTJpjqNQPZaYeh1MO/PAkJdpwYqgBS5kbL8cY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2rCT7lIw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2rCT7lIw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1631BC116D0;
	Thu, 15 Jan 2026 17:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498001;
	bh=zvjiXceDCIltFsEssRh2iwEbNhJnFzzqcK0W4H92J2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2rCT7lIwts2ztvijkRigLfd5Xqy/WiE62yB1/sGEeLP5HI9tvJYwYAHy5XCAF9E1Y
	 PONmDDc66daA+cTUxDg5mvhdsDJvcwzbW3gwnv63RI2ttpfLTtlT1wG9rmPiUjKT8n
	 89k3BuoZgeT3iJyIIOsW7j/wEDoyIKIOX99psWoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian Shen <shenjian15@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 245/554] net: hns3: add VLAN id validation before using
Date: Thu, 15 Jan 2026 17:45:11 +0100
Message-ID: <20260115164255.110159313@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 1dffd1532bd76..dd9d5df31905a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -10682,6 +10682,9 @@ int hclge_set_vlan_filter(struct hnae3_handle *handle, __be16 proto,
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



