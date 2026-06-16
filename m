Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18C783C276B;
	Tue, 16 Jun 2026 17:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632451; cv=none; b=E6gcyzCiWsIH9Dg/ftxD+H8ZAyhhjEnWju8Ri7DvcxKQQz0TWiNjXBAmxofWFHJ1oP0/54BYuPmuB6tSP7ohNRTSVxvmfv7CvPaxedHQOEuTQ/EhAAzaZ/WYnSRVcjHyePFTqK3Cdxsr1rvfwZfNFzHkS2am7yARrafh95Jw5bI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632451; c=relaxed/simple;
	bh=C5/jKjHwJLO8/qloBZ6SGuv7uWrM/cOVNcFFZZKstjc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ozuMGex/6ooLts9nfo7JXQHQuw67I7s1DYfWSYrjn8h0PvFU+d8wM5x8WlzLdDr7QExwdFsuIEw+wxJjUwXnLatMTAC/v4iUXn2MJ64gXF7jJpiq8EBB35joxFnwT7uBzMUcV1fpNzvjpDobJ1u+XkeAPfGA/TPsnX+AmwlHjEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aFCNUdkm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aFCNUdkm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7F2D1F000E9;
	Tue, 16 Jun 2026 17:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781632450;
	bh=F/xn5xfHK+yPF/h8VWEelRk6GXD0tFCwgXhEsza7BCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aFCNUdkmkGurDzilhezGoc5+o9mXpBT3ryjyNHC/GvlELsiAJlJsxbdk6JdRWSRjM
	 MLYkgVXOYzFNll0OZe8SYD1l71JtjA5utdpiUg5bI5MSfCTNqQvsP8tMe2WXywkKST
	 DeVPpcpdrJ//xgzkS+EA9/Qog5I75yXDwWVUefCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavitra Jha <jhapavitra98@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 406/522] net: wwan: t7xx: validate port_count against message length in t7xx_port_enum_msg_handler
Date: Tue, 16 Jun 2026 20:29:13 +0530
Message-ID: <20260616145145.058362428@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

From: Pavitra Jha <jhapavitra98@gmail.com>

[ Upstream commit 0e7c074cfcd9bd93765505f9eb8b42f03ed2a744 ]

t7xx_port_enum_msg_handler() uses the modem-supplied port_count field as
a loop bound over port_msg->data[] without checking that the message buffer
contains sufficient data. A modem sending port_count=65535 in a 12-byte
buffer triggers a slab-out-of-bounds read of up to 262140 bytes.

Add a sizeof(*port_msg) check before accessing the port message header
fields to guard against undersized messages.

Add a struct_size() check after extracting port_count and before the loop.

In t7xx_parse_host_rt_data(), guard the rt_feature header read with a
remaining-buffer check before accessing data_len, validate feat_data_len
against the actual remaining buffer to prevent OOB reads and signed
integer overflow on offset.

Pass msg_len from both call sites: skb->len at the DPMAIF path after
skb_pull(), and the validated feat_data_len at the handshake path.

Fixes: da45d2566a1d ("net: wwan: t7xx: Add control port")
Cc: stable@vger.kernel.org
Signed-off-by: Pavitra Jha <jhapavitra98@gmail.com>
Link: https://patch.msgid.link/20260501110713.145563-1-jhapavitra98@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wwan/t7xx/t7xx_modem_ops.c     |   17 +++++++++++++++--
 drivers/net/wwan/t7xx/t7xx_port_ctrl_msg.c |   18 ++++++++++++++++--
 drivers/net/wwan/t7xx/t7xx_port_proxy.h    |    2 +-
 3 files changed, 32 insertions(+), 5 deletions(-)

--- a/drivers/net/wwan/t7xx/t7xx_modem_ops.c
+++ b/drivers/net/wwan/t7xx/t7xx_modem_ops.c
@@ -415,8 +415,20 @@ static int t7xx_parse_host_rt_data(struc
 
 	offset = sizeof(struct feature_query);
 	for (i = 0; i < FEATURE_COUNT && offset < data_length; i++) {
+		size_t remaining = data_length - offset;
+		size_t feat_data_len, feat_total;
+
+		if (remaining < sizeof(*rt_feature))
+			break;
+
 		rt_feature = data + offset;
-		offset += sizeof(*rt_feature) + le32_to_cpu(rt_feature->data_len);
+		feat_data_len = le32_to_cpu(rt_feature->data_len);
+
+		if (feat_data_len > remaining - sizeof(*rt_feature))
+			break;
+
+		feat_total = sizeof(*rt_feature) + feat_data_len;
+		offset += feat_total;
 
 		ft_spt_cfg = FIELD_GET(FEATURE_MSK, core->feature_set[i]);
 		if (ft_spt_cfg != MTK_FEATURE_MUST_BE_SUPPORTED)
@@ -427,7 +439,8 @@ static int t7xx_parse_host_rt_data(struc
 			return -EINVAL;
 
 		if (i == RT_ID_MD_PORT_ENUM)
-			t7xx_port_enum_msg_handler(ctl->md, rt_feature->data);
+			t7xx_port_enum_msg_handler(ctl->md, rt_feature->data,
+						   feat_data_len);
 	}
 
 	return 0;
--- a/drivers/net/wwan/t7xx/t7xx_port_ctrl_msg.c
+++ b/drivers/net/wwan/t7xx/t7xx_port_ctrl_msg.c
@@ -117,6 +117,7 @@ static int fsm_ee_message_handler(struct
  * t7xx_port_enum_msg_handler() - Parse the port enumeration message to create/remove nodes.
  * @md: Modem context.
  * @msg: Message.
+ * @msg_len:	Length of @msg in bytes.
  *
  * Used to control create/remove device node.
  *
@@ -124,12 +125,18 @@ static int fsm_ee_message_handler(struct
  * * 0		- Success.
  * * -EFAULT	- Message check failure.
  */
-int t7xx_port_enum_msg_handler(struct t7xx_modem *md, void *msg)
+int t7xx_port_enum_msg_handler(struct t7xx_modem *md, void *msg, size_t msg_len)
 {
 	struct device *dev = &md->t7xx_dev->pdev->dev;
 	unsigned int version, port_count, i;
 	struct port_msg *port_msg = msg;
 
+	if (msg_len < sizeof(*port_msg)) {
+		dev_err(dev, "Port enum msg too short for header: need %zu, have %zu\n",
+			sizeof(*port_msg), msg_len);
+		return -EINVAL;
+	}
+
 	version = FIELD_GET(PORT_MSG_VERSION, le32_to_cpu(port_msg->info));
 	if (version != PORT_ENUM_VER ||
 	    le32_to_cpu(port_msg->head_pattern) != PORT_ENUM_HEAD_PATTERN ||
@@ -141,6 +148,13 @@ int t7xx_port_enum_msg_handler(struct t7
 	}
 
 	port_count = FIELD_GET(PORT_MSG_PRT_CNT, le32_to_cpu(port_msg->info));
+
+	if (msg_len < struct_size(port_msg, data, port_count)) {
+		dev_err(dev, "Port enum msg too short: need %zu, have %zu\n",
+			struct_size(port_msg, data, port_count), msg_len);
+		return -EINVAL;
+	}
+
 	for (i = 0; i < port_count; i++) {
 		u32 port_info = le32_to_cpu(port_msg->data[i]);
 		unsigned int ch_id;
@@ -187,7 +201,7 @@ static int control_msg_handler(struct t7
 
 	case CTL_ID_PORT_ENUM:
 		skb_pull(skb, sizeof(*ctrl_msg_h));
-		ret = t7xx_port_enum_msg_handler(ctl->md, (struct port_msg *)skb->data);
+		ret = t7xx_port_enum_msg_handler(ctl->md, (struct port_msg *)skb->data, skb->len);
 		if (!ret)
 			ret = port_ctl_send_msg_to_md(port, CTL_ID_PORT_ENUM, 0);
 		else
--- a/drivers/net/wwan/t7xx/t7xx_port_proxy.h
+++ b/drivers/net/wwan/t7xx/t7xx_port_proxy.h
@@ -91,7 +91,7 @@ void t7xx_port_proxy_reset(struct port_p
 void t7xx_port_proxy_uninit(struct port_proxy *port_prox);
 int t7xx_port_proxy_init(struct t7xx_modem *md);
 void t7xx_port_proxy_md_status_notify(struct port_proxy *port_prox, unsigned int state);
-int t7xx_port_enum_msg_handler(struct t7xx_modem *md, void *msg);
+int t7xx_port_enum_msg_handler(struct t7xx_modem *md, void *msg, size_t msg_len);
 int t7xx_port_proxy_chl_enable_disable(struct port_proxy *port_prox, unsigned int ch_id,
 				       bool en_flag);
 


