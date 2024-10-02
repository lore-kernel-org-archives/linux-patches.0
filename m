Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A37A1D1F56;
	Wed,  2 Oct 2024 14:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880674; cv=none; b=f6ndX4UBaNb91gQevHvK6GLOj2Ah38fhM/5XfhpYg5NcKENVfgenoUQ4MOlY3ehCw4p6lyUXYmwxrraOJpZ4//qu55nsVtMZYttEoAnMy01QfBQg3tbGCCb4TOSPV99sdmSU/LPY1ZjD8sLPgdC8R7P+katgBjckkpmdq21HDY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880674; c=relaxed/simple;
	bh=nli6/Fk4GPjnVprbLc7V3mlCU5l7jTG/GBQwcCn6FBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NvpaH+ppDvJGcOD/we4Y9OxftYsyD737iz7or/tUy3Bu7P4i+kRZZJfg8RCuCoG3d6OSgjYss/eISArf/PHObs1F0RNFMl83aberXwRaeUFh4xPOkDXI/8ewx0XnERtaPb7ogIi7B/hbZbQh9zwaIBnnwxjF24WSYaWYYVZoWB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HCMD12vn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HCMD12vn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82B25C4CEC2;
	Wed,  2 Oct 2024 14:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880673;
	bh=nli6/Fk4GPjnVprbLc7V3mlCU5l7jTG/GBQwcCn6FBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HCMD12vnfDc63pLBynbypyw0dnJJSR3MNZVJm6i+9ALJ6bucuqsZfyOvNbFf0G0ni
	 GvqRZAc5h/Fh9ElUa9lZ293oge+Y4+dyNNLVa/C+HSY/mdXz93C5r2epzYVcBXDrJn
	 p9U64MologCfwfwzM5Hxpr7WzkorerLTsBM4vHPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gil Fine <gil.fine@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Qin Wan <qin.wan@hp.com>,
	Alexandru Gagniuc <alexandru.gagniuc@hp.com>
Subject: [PATCH 6.6 508/538] thunderbolt: Make is_gen4_link() available to the rest of the driver
Date: Wed,  2 Oct 2024 15:02:27 +0200
Message-ID: <20241002125812.494308139@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

From: Gil Fine <gil.fine@linux.intel.com>

[ Upstream commit aa673d606078da36ebc379f041c794228ac08cb5 ]

Rework the function to return the link generation, update the name to
tb_port_get_link_generation(), and make available to the rest of the
driver. This is needed in the subsequent patches.

Signed-off-by: Gil Fine <gil.fine@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Qin Wan <qin.wan@hp.com>
Signed-off-by: Alexandru Gagniuc <alexandru.gagniuc@hp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/switch.c |   36 +++++++++++++++++++++++++++++-------
 drivers/thunderbolt/tb.h     |    1 +
 2 files changed, 30 insertions(+), 7 deletions(-)

--- a/drivers/thunderbolt/switch.c
+++ b/drivers/thunderbolt/switch.c
@@ -922,6 +922,32 @@ int tb_port_get_link_speed(struct tb_por
 }
 
 /**
+ * tb_port_get_link_generation() - Returns link generation
+ * @port: Lane adapter
+ *
+ * Returns link generation as number or negative errno in case of
+ * failure. Does not distinguish between Thunderbolt 1 and Thunderbolt 2
+ * links so for those always returns 2.
+ */
+int tb_port_get_link_generation(struct tb_port *port)
+{
+	int ret;
+
+	ret = tb_port_get_link_speed(port);
+	if (ret < 0)
+		return ret;
+
+	switch (ret) {
+	case 40:
+		return 4;
+	case 20:
+		return 3;
+	default:
+		return 2;
+	}
+}
+
+/**
  * tb_port_get_link_width() - Get current link width
  * @port: Port to check (USB4 or CIO)
  *
@@ -966,11 +992,6 @@ static bool tb_port_is_width_supported(s
 	return widths & width_mask;
 }
 
-static bool is_gen4_link(struct tb_port *port)
-{
-	return tb_port_get_link_speed(port) > 20;
-}
-
 /**
  * tb_port_set_link_width() - Set target link width of the lane adapter
  * @port: Lane adapter
@@ -998,7 +1019,7 @@ int tb_port_set_link_width(struct tb_por
 	switch (width) {
 	case TB_LINK_WIDTH_SINGLE:
 		/* Gen 4 link cannot be single */
-		if (is_gen4_link(port))
+		if (tb_port_get_link_generation(port) >= 4)
 			return -EOPNOTSUPP;
 		val |= LANE_ADP_CS_1_TARGET_WIDTH_SINGLE <<
 			LANE_ADP_CS_1_TARGET_WIDTH_SHIFT;
@@ -1147,7 +1168,8 @@ int tb_port_wait_for_link_width(struct t
 	int ret;
 
 	/* Gen 4 link does not support single lane */
-	if ((width_mask & TB_LINK_WIDTH_SINGLE) && is_gen4_link(port))
+	if ((width_mask & TB_LINK_WIDTH_SINGLE) &&
+	    tb_port_get_link_generation(port) >= 4)
 		return -EOPNOTSUPP;
 
 	do {
--- a/drivers/thunderbolt/tb.h
+++ b/drivers/thunderbolt/tb.h
@@ -1062,6 +1062,7 @@ static inline bool tb_port_use_credit_al
 	     (p) = tb_next_port_on_path((src), (dst), (p)))
 
 int tb_port_get_link_speed(struct tb_port *port);
+int tb_port_get_link_generation(struct tb_port *port);
 int tb_port_get_link_width(struct tb_port *port);
 int tb_port_set_link_width(struct tb_port *port, enum tb_link_width width);
 int tb_port_lane_bonding_enable(struct tb_port *port);


