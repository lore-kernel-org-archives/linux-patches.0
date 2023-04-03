Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F2015683
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:17:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ADEAC433A4;
	Mon,  3 Apr 2023 14:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680531478;
	bh=sSU9XvZ09P806JnsvzQ+NQuxr5xjRZAphV+fuvT+dDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I5NdAyjxZWocIoxnL7JMTwRem1JPDyAh/XpfBAG6BZjcnhyXKnOn2hhe49PJkDKAA
	 31oggEiY0iLiJmNLvhzpJd/pGWnds8VPp0986IltQCzNz4FTQJ7hUYcgeUcrLebhA1
	 1hSNMABCxNQAIEbCZ1QiO/hFHNXpdIRlA0kI1rAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Marussi <cristian.marussi@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>
Subject: [PATCH 4.19 79/84] firmware: arm_scmi: Fix device node validation for mailbox transport
Date: Mon,  3 Apr 2023 16:09:20 +0200
Message-Id: <20230403140356.135257966@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140353.406927418@linuxfoundation.org>
References: <20230403140353.406927418@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Cristian Marussi <cristian.marussi@arm.com>

commit 2ab4f4018cb6b8010ca5002c3bdc37783b5d28c2 upstream.

When mailboxes are used as a transport it is possible to setup the SCMI
transport layer, depending on the underlying channels configuration, to use
one or two mailboxes, associated, respectively, to one or two, distinct,
shared memory areas: any other combination should be treated as invalid.

Add more strict checking of SCMI mailbox transport device node descriptors.

Fixes: 5c8a47a5a91d ("firmware: arm_scmi: Make scmi core independent of the transport type")
Cc: <stable@vger.kernel.org> # 4.19
Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Link: https://lore.kernel.org/r/20230307162324.891866-1-cristian.marussi@arm.com
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
[Cristian: backported to v4.19]
Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/arm_scmi/driver.c |   37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -705,6 +705,39 @@ static int scmi_remove(struct platform_d
 	return ret;
 }
 
+static int scmi_mailbox_chan_validate(struct device *cdev)
+{
+	int num_mb, num_sh, ret = 0;
+	struct device_node *np = cdev->of_node;
+
+	num_mb = of_count_phandle_with_args(np, "mboxes", "#mbox-cells");
+	num_sh = of_count_phandle_with_args(np, "shmem", NULL);
+	/* Bail out if mboxes and shmem descriptors are inconsistent */
+	if (num_mb <= 0 || num_sh > 2 || num_mb != num_sh) {
+		dev_warn(cdev, "Invalid channel descriptor for '%s'\n",
+			 of_node_full_name(np));
+		return -EINVAL;
+	}
+
+	if (num_sh > 1) {
+		struct device_node *np_tx, *np_rx;
+
+		np_tx = of_parse_phandle(np, "shmem", 0);
+		np_rx = of_parse_phandle(np, "shmem", 1);
+		/* SCMI Tx and Rx shared mem areas have to be distinct */
+		if (!np_tx || !np_rx || np_tx == np_rx) {
+			dev_warn(cdev, "Invalid shmem descriptor for '%s'\n",
+				 of_node_full_name(np));
+			ret = -EINVAL;
+		}
+
+		of_node_put(np_tx);
+		of_node_put(np_rx);
+	}
+
+	return ret;
+}
+
 static inline int
 scmi_mbox_chan_setup(struct scmi_info *info, struct device *dev, int prot_id)
 {
@@ -720,6 +753,10 @@ scmi_mbox_chan_setup(struct scmi_info *i
 		goto idr_alloc;
 	}
 
+	ret = scmi_mailbox_chan_validate(dev);
+	if (ret)
+		return ret;
+
 	cinfo = devm_kzalloc(info->dev, sizeof(*cinfo), GFP_KERNEL);
 	if (!cinfo)
 		return -ENOMEM;


