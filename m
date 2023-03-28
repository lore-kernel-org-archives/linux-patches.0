Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4F198BE0
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 14:49:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CD7AC433EF;
	Tue, 28 Mar 2023 14:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680014968;
	bh=UicRirrhPAs+MjJ7dnsxD0ucHQYvAHSdT+df5UameMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NBzbCQK+oFlwuKxpOWvpXZuRWROi83kBbwuEGwaH6BqykRSSO7sQv7MRNMQ7Gx0ad
	 gyWOYNbVhHA4GSTJeXvhDqZkqRCMdk5lwUYjlv198mRlOp638gj5MATdifKy5ov5Sy
	 z6XPdhxGBIQgreQH9AJ8cltbYiFWKsHhliAZWnvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.2 118/240] thunderbolt: Use scale field when allocating USB3 bandwidth
Date: Tue, 28 Mar 2023 16:41:21 +0200
Message-Id: <20230328142624.703667203@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mika Westerberg <mika.westerberg@linux.intel.com>

commit c82510b1d87bdebfe916048857d2ef46f1778aa5 upstream.

When tunneling aggregated USB3 (20 Gb/s) the bandwidth values that are
programmed to the ADP_USB3_CS_2 go higher than 4096 and that does not
fit anymore to the 12-bit field. Fix this by scaling the value using
the scale field accordingly.

Fixes: 3b1d8d577ca8 ("thunderbolt: Implement USB3 bandwidth negotiation routines")
Cc: stable@vger.kernel.org
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/usb4.c |   22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

--- a/drivers/thunderbolt/usb4.c
+++ b/drivers/thunderbolt/usb4.c
@@ -2067,18 +2067,30 @@ static int usb4_usb3_port_write_allocate
 						    int downstream_bw)
 {
 	u32 val, ubw, dbw, scale;
-	int ret;
+	int ret, max_bw;
 
-	/* Read the used scale, hardware default is 0 */
-	ret = tb_port_read(port, &scale, TB_CFG_PORT,
-			   port->cap_adap + ADP_USB3_CS_3, 1);
+	/* Figure out suitable scale */
+	scale = 0;
+	max_bw = max(upstream_bw, downstream_bw);
+	while (scale < 64) {
+		if (mbps_to_usb3_bw(max_bw, scale) < 4096)
+			break;
+		scale++;
+	}
+
+	if (WARN_ON(scale >= 64))
+		return -EINVAL;
+
+	ret = tb_port_write(port, &scale, TB_CFG_PORT,
+			    port->cap_adap + ADP_USB3_CS_3, 1);
 	if (ret)
 		return ret;
 
-	scale &= ADP_USB3_CS_3_SCALE_MASK;
 	ubw = mbps_to_usb3_bw(upstream_bw, scale);
 	dbw = mbps_to_usb3_bw(downstream_bw, scale);
 
+	tb_port_dbg(port, "scaled bandwidth %u/%u, scale %u\n", ubw, dbw, scale);
+
 	ret = tb_port_read(port, &val, TB_CFG_PORT,
 			   port->cap_adap + ADP_USB3_CS_2, 1);
 	if (ret)


