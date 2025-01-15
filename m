Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3D021E7C02;
	Wed, 15 Jan 2025 10:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937996; cv=none; b=J6z6XDdyTjy/tL3B3Eb7XbOAmBNJz/TAxxDzrRDzlkhA8dUNkorY9FouNdkozEvcbtzYreghMgX86nLCUev0Rh+xZG8bzvv/UcgS8+TJXeYzsc+XN+OKxEu02ePq7maAJJQzvoCYotgQRsxs62Z2lKZYmnhS5z2bkQJ9GjuRo64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937996; c=relaxed/simple;
	bh=vzCrwcBS8LosoT/FndnhLqYLPnj4rRwBSqGKAIgeLTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O5GSGmb+d+5FMb/PB8DcN81tYQ2upLxSwWgPkzR2ZljPz2Co5Mg+fG8v0KhsUzBMZ4ybJ22YeRfFjho0uWhiLtCu1t3FnqDwX9mev8RF9VOZ4LdI2RxcJTWL+NNlal8QwxBeovbSkYLBFPenKXPxfDJVF0qAKZ0PvuO2ZQPZwjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vFDku59u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vFDku59u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B93DDC4CEDF;
	Wed, 15 Jan 2025 10:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937996;
	bh=vzCrwcBS8LosoT/FndnhLqYLPnj4rRwBSqGKAIgeLTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vFDku59uiG3yUf2ScG8+yB1ygz2H6TbzPF/fs5Q1+PbiDT3v+rqErvxJirUr5ysXi
	 i8aHomSLXHKXHErYByqi+3oVqcqs9kub2Qe+OeEWOC5xcJF8F3Ub7w3TpCJs+H6epo
	 yvibD6yJ0qwzfvsVqi6D7kMnArsKquCzw2uwTzlU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jie Wang <wangjie125@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 052/189] net: hns3: fix kernel crash when 1588 is sent on HIP08 devices
Date: Wed, 15 Jan 2025 11:35:48 +0100
Message-ID: <20250115103608.427091237@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jie Wang <wangjie125@huawei.com>

[ Upstream commit 9741e72b2286de8b38de9db685588ac421a95c87 ]

Currently, HIP08 devices does not register the ptp devices, so the
hdev->ptp is NULL. But the tx process would still try to set hardware time
stamp info with SKBTX_HW_TSTAMP flag and cause a kernel crash.

[  128.087798] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000018
...
[  128.280251] pc : hclge_ptp_set_tx_info+0x2c/0x140 [hclge]
[  128.286600] lr : hclge_ptp_set_tx_info+0x20/0x140 [hclge]
[  128.292938] sp : ffff800059b93140
[  128.297200] x29: ffff800059b93140 x28: 0000000000003280
[  128.303455] x27: ffff800020d48280 x26: ffff0cb9dc814080
[  128.309715] x25: ffff0cb9cde93fa0 x24: 0000000000000001
[  128.315969] x23: 0000000000000000 x22: 0000000000000194
[  128.322219] x21: ffff0cd94f986000 x20: 0000000000000000
[  128.328462] x19: ffff0cb9d2a166c0 x18: 0000000000000000
[  128.334698] x17: 0000000000000000 x16: ffffcf1fc523ed24
[  128.340934] x15: 0000ffffd530a518 x14: 0000000000000000
[  128.347162] x13: ffff0cd6bdb31310 x12: 0000000000000368
[  128.353388] x11: ffff0cb9cfbc7070 x10: ffff2cf55dd11e02
[  128.359606] x9 : ffffcf1f85a212b4 x8 : ffff0cd7cf27dab0
[  128.365831] x7 : 0000000000000a20 x6 : ffff0cd7cf27d000
[  128.372040] x5 : 0000000000000000 x4 : 000000000000ffff
[  128.378243] x3 : 0000000000000400 x2 : ffffcf1f85a21294
[  128.384437] x1 : ffff0cb9db520080 x0 : ffff0cb9db500080
[  128.390626] Call trace:
[  128.393964]  hclge_ptp_set_tx_info+0x2c/0x140 [hclge]
[  128.399893]  hns3_nic_net_xmit+0x39c/0x4c4 [hns3]
[  128.405468]  xmit_one.constprop.0+0xc4/0x200
[  128.410600]  dev_hard_start_xmit+0x54/0xf0
[  128.415556]  sch_direct_xmit+0xe8/0x634
[  128.420246]  __dev_queue_xmit+0x224/0xc70
[  128.425101]  dev_queue_xmit+0x1c/0x40
[  128.429608]  ovs_vport_send+0xac/0x1a0 [openvswitch]
[  128.435409]  do_output+0x60/0x17c [openvswitch]
[  128.440770]  do_execute_actions+0x898/0x8c4 [openvswitch]
[  128.446993]  ovs_execute_actions+0x64/0xf0 [openvswitch]
[  128.453129]  ovs_dp_process_packet+0xa0/0x224 [openvswitch]
[  128.459530]  ovs_vport_receive+0x7c/0xfc [openvswitch]
[  128.465497]  internal_dev_xmit+0x34/0xb0 [openvswitch]
[  128.471460]  xmit_one.constprop.0+0xc4/0x200
[  128.476561]  dev_hard_start_xmit+0x54/0xf0
[  128.481489]  __dev_queue_xmit+0x968/0xc70
[  128.486330]  dev_queue_xmit+0x1c/0x40
[  128.490856]  ip_finish_output2+0x250/0x570
[  128.495810]  __ip_finish_output+0x170/0x1e0
[  128.500832]  ip_finish_output+0x3c/0xf0
[  128.505504]  ip_output+0xbc/0x160
[  128.509654]  ip_send_skb+0x58/0xd4
[  128.513892]  udp_send_skb+0x12c/0x354
[  128.518387]  udp_sendmsg+0x7a8/0x9c0
[  128.522793]  inet_sendmsg+0x4c/0x8c
[  128.527116]  __sock_sendmsg+0x48/0x80
[  128.531609]  __sys_sendto+0x124/0x164
[  128.536099]  __arm64_sys_sendto+0x30/0x5c
[  128.540935]  invoke_syscall+0x50/0x130
[  128.545508]  el0_svc_common.constprop.0+0x10c/0x124
[  128.551205]  do_el0_svc+0x34/0xdc
[  128.555347]  el0_svc+0x20/0x30
[  128.559227]  el0_sync_handler+0xb8/0xc0
[  128.563883]  el0_sync+0x160/0x180

Fixes: 0bf5eb788512 ("net: hns3: add support for PTP")
Signed-off-by: Jie Wang <wangjie125@huawei.com>
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Link: https://patch.msgid.link/20250106143642.539698-8-shaojijie@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c
index 5505caea88e9..bab16c2191b2 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c
@@ -58,6 +58,9 @@ bool hclge_ptp_set_tx_info(struct hnae3_handle *handle, struct sk_buff *skb)
 	struct hclge_dev *hdev = vport->back;
 	struct hclge_ptp *ptp = hdev->ptp;
 
+	if (!ptp)
+		return false;
+
 	if (!test_bit(HCLGE_PTP_FLAG_TX_EN, &ptp->flags) ||
 	    test_and_set_bit(HCLGE_STATE_PTP_TX_HANDLING, &hdev->state)) {
 		ptp->tx_skipped++;
-- 
2.39.5



