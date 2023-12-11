Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F7E95101A;
	Mon, 11 Dec 2023 18:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RttlIwJo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9539EC433C7;
	Mon, 11 Dec 2023 18:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319301;
	bh=L2wFki585LnZmSMlvLaVnsZeeGuIO1uaSiaBnxaT/2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RttlIwJowH/bSIFgnKBgbiSaqV5b2rl+qaNcZe8p/xlay5E9qpeboh7rRXlKpd1hU
	 aQo2SBBEqVQNhGmE13jsQft8eNEFtrl7ZipuytTG4ZK5UnQC6Y+GiEFtlCbWMqliQf
	 tTRtmYM3LHeXOQTYmth7lw8/7qxglc+AqvWGqZsk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yonglong Liu <liuyonglong@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Wojciech Drewek <wojciech.drewek@intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 055/244] net: hns: fix fake link up on xge port
Date: Mon, 11 Dec 2023 19:19:08 +0100
Message-ID: <20231211182048.283660658@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yonglong Liu <liuyonglong@huawei.com>

[ Upstream commit f708aba40f9c1eeb9c7e93ed4863b5f85b09b288 ]

If a xge port just connect with an optical module and no fiber,
it may have a fake link up because there may be interference on
the hardware. This patch adds an anti-shake to avoid the problem.
And the time of anti-shake is base on tests.

Fixes: b917078c1c10 ("net: hns: Add ACPI support to check SFP present")
Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Reviewed-by: Wojciech Drewek <wojciech.drewek@intel.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/hisilicon/hns/hns_dsaf_mac.c | 29 +++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c
index 928d934cb21a5..f75668c479351 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c
@@ -66,6 +66,27 @@ static enum mac_mode hns_get_enet_interface(const struct hns_mac_cb *mac_cb)
 	}
 }
 
+static u32 hns_mac_link_anti_shake(struct mac_driver *mac_ctrl_drv)
+{
+#define HNS_MAC_LINK_WAIT_TIME 5
+#define HNS_MAC_LINK_WAIT_CNT 40
+
+	u32 link_status = 0;
+	int i;
+
+	if (!mac_ctrl_drv->get_link_status)
+		return link_status;
+
+	for (i = 0; i < HNS_MAC_LINK_WAIT_CNT; i++) {
+		msleep(HNS_MAC_LINK_WAIT_TIME);
+		mac_ctrl_drv->get_link_status(mac_ctrl_drv, &link_status);
+		if (!link_status)
+			break;
+	}
+
+	return link_status;
+}
+
 void hns_mac_get_link_status(struct hns_mac_cb *mac_cb, u32 *link_status)
 {
 	struct mac_driver *mac_ctrl_drv;
@@ -83,6 +104,14 @@ void hns_mac_get_link_status(struct hns_mac_cb *mac_cb, u32 *link_status)
 							       &sfp_prsnt);
 		if (!ret)
 			*link_status = *link_status && sfp_prsnt;
+
+		/* for FIBER port, it may have a fake link up.
+		 * when the link status changes from down to up, we need to do
+		 * anti-shake. the anti-shake time is base on tests.
+		 * only FIBER port need to do this.
+		 */
+		if (*link_status && !mac_cb->link)
+			*link_status = hns_mac_link_anti_shake(mac_ctrl_drv);
 	}
 
 	mac_cb->link = *link_status;
-- 
2.42.0



