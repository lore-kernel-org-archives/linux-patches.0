Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 718EA7E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 03:15:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76002C433C1;
	Wed,  2 Nov 2022 03:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667358934;
	bh=4zCCEprtMmqynw5l30ROvAT4mXd1UaHS/SC7WUkiGwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sqBCjO0k98sn2Z41WdBSoA0JkwsV525AVwaFluy8eZftW94I2EzrzACaEuYG1Qt3Q
	 XvicZDLva4sP53AqLJYrxBjlzUwI2Rym94OM3tWTTfYUSW5OKurnUNkdLOvOKnlX5z
	 vec+Vmiv9kFuFSD/UR5EyfRxTEaBY+q8Q/efoxM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 49/91] net: hinic: fix the issue of double release MBOX callback of VF
Date: Wed,  2 Nov 2022 03:33:32 +0100
Message-Id: <20221102022056.416823495@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022055.039689234@linuxfoundation.org>
References: <20221102022055.039689234@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhengchao Shao <shaozhengchao@huawei.com>

[ Upstream commit 8ec2f4c6b2e11a4249bba77460f0cfe6d95a82f8 ]

In hinic_vf_func_init(), if VF fails to register information with PF
through the MBOX, the MBOX callback function of VF is released once. But
it is released again in hinic_init_hwdev(). Remove one.

Fixes: 7dd29ee12865 ("hinic: add sriov feature support")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/huawei/hinic/hinic_sriov.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_sriov.c b/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
index f8a26459ff65..4d82ebfe27f9 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
@@ -1178,7 +1178,6 @@ int hinic_vf_func_init(struct hinic_hwdev *hwdev)
 			dev_err(&hwdev->hwif->pdev->dev,
 				"Failed to register VF, err: %d, status: 0x%x, out size: 0x%x\n",
 				err, register_info.status, out_size);
-			hinic_unregister_vf_mbox_cb(hwdev, HINIC_MOD_L2NIC);
 			return -EIO;
 		}
 	} else {
-- 
2.35.1



