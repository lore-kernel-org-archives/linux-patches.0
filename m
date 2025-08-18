Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98B70335BC6;
	Mon, 18 Aug 2025 13:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524912; cv=none; b=LBajFs5gFTihij0waSWI40MjxvRI2VuZg1XiVVLAf7v/RBseXzAMVRyHXUNkWSQVZCCKGlp0egjCALikY/ejIHHRJnQl86/5V5vmt4mVTLrbrw92RiAhpv28PSEejQ9sQBk+ZsnWvw5HdmQrzCm2JLVB3u2DZmFdrzp6rcrEggU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524912; c=relaxed/simple;
	bh=3H3GCH+1jqvaBdqh5qKN+VuyE/uCX/I4uHPYbg5VQNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aaEeLm52S+LwieShwB8PsqkSq0D73Qg1hS/YT4nQ84m3fa82CzCKp7YJClNDHz+5oo9sWFHwpBTFHMi6w4RNKRby9dT08ngGg7e2TT17QunrNb5vHFhHYQaD5l8xgEUHrN5WQB34lyzyKFxgv/pVfJkVUKVx/FzuuMJsjVuJ6T8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ErV/2I4q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ErV/2I4q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A39AC4CEEB;
	Mon, 18 Aug 2025 13:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524912;
	bh=3H3GCH+1jqvaBdqh5qKN+VuyE/uCX/I4uHPYbg5VQNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ErV/2I4qFEFQJwCIfzQXszGeHnwNbF4M15KmlzcYk42FNTM3lXAW9Ur+fGJAct6II
	 ew2F5Alfy2+jhel9fHeq1XvfVTfPqDErTj8ksoq/qOFubR9BGa7WQ+LFhdN7+wW3sa
	 caUrazv4D5IZ7+IJP/Y9PRdmuHkG0A77i7VsTQOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jijie Shao <shaojijie@huawei.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 069/570] net: hibmcge: fix the np_link_fail error reporting issue
Date: Mon, 18 Aug 2025 14:40:56 +0200
Message-ID: <20250818124508.470019552@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jijie Shao <shaojijie@huawei.com>

[ Upstream commit 62c50180ffda01468e640ac14925503796f255e2 ]

Currently, after modifying device port mode, the np_link_ok state
is immediately checked. At this point, the device may not yet ready,
leading to the querying of an intermediate state.

This patch will poll to check if np_link is ok after
modifying device port mode, and only report np_link_fail upon timeout.

Fixes: e0306637e85d ("net: hibmcge: Add support for mac link exception handling feature")
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hibmcge/hbg_hw.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hibmcge/hbg_hw.c b/drivers/net/ethernet/hisilicon/hibmcge/hbg_hw.c
index 9b65eef62b3f..2844124f306d 100644
--- a/drivers/net/ethernet/hisilicon/hibmcge/hbg_hw.c
+++ b/drivers/net/ethernet/hisilicon/hibmcge/hbg_hw.c
@@ -12,6 +12,8 @@
 
 #define HBG_HW_EVENT_WAIT_TIMEOUT_US	(2 * 1000 * 1000)
 #define HBG_HW_EVENT_WAIT_INTERVAL_US	(10 * 1000)
+#define HBG_MAC_LINK_WAIT_TIMEOUT_US	(500 * 1000)
+#define HBG_MAC_LINK_WAIT_INTERVAL_US	(5 * 1000)
 /* little endian or big endian.
  * ctrl means packet description, data means skb packet data
  */
@@ -213,6 +215,9 @@ void hbg_hw_fill_buffer(struct hbg_priv *priv, u32 buffer_dma_addr)
 
 void hbg_hw_adjust_link(struct hbg_priv *priv, u32 speed, u32 duplex)
 {
+	u32 link_status;
+	int ret;
+
 	hbg_hw_mac_enable(priv, HBG_STATUS_DISABLE);
 
 	hbg_reg_write_field(priv, HBG_REG_PORT_MODE_ADDR,
@@ -224,8 +229,14 @@ void hbg_hw_adjust_link(struct hbg_priv *priv, u32 speed, u32 duplex)
 
 	hbg_hw_mac_enable(priv, HBG_STATUS_ENABLE);
 
-	if (!hbg_reg_read_field(priv, HBG_REG_AN_NEG_STATE_ADDR,
-				HBG_REG_AN_NEG_STATE_NP_LINK_OK_B))
+	/* wait MAC link up */
+	ret = readl_poll_timeout(priv->io_base + HBG_REG_AN_NEG_STATE_ADDR,
+				 link_status,
+				 FIELD_GET(HBG_REG_AN_NEG_STATE_NP_LINK_OK_B,
+					   link_status),
+				 HBG_MAC_LINK_WAIT_INTERVAL_US,
+				 HBG_MAC_LINK_WAIT_TIMEOUT_US);
+	if (ret)
 		hbg_np_link_fail_task_schedule(priv);
 }
 
-- 
2.50.1



