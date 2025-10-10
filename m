Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E8C82F39C1;
	Fri, 10 Oct 2025 13:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102550; cv=none; b=q23E8pa+yeVvhZ3VNxH2N0GDW0CUA2qWLjEbUhwuNGcd46pqxQPdF7bxJs4nlx0FeEfhoo+2rMX9h6yh5WbcTNOJg3Z4gmnQwRREdvzEufADFeODyfvShPAaB6becChA6dSYzRWfnL8XCgOPDVWMsEfPFVG2MsFdRODyaleTp3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102550; c=relaxed/simple;
	bh=7Of+xAoMGLGcpy2ssrdH7hbjZAZ+jItajeiQxbDca2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DUtQb/gk3asyJlxs0vl1njZkwoiAU56OoodLqI9sCe52enRARSU/FK0ClfHNV3LeY42tHPOsZ8YPvFYWQLeFuL0xz40zl7SlbPDrcPxTsFH+Jowa/nykP3Semlir0F8AYCFzyy2HrcN/51aE2AI1OtsS1tWi8I1K8OX+vwL/BIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EKwZ44cx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EKwZ44cx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBD34C4CEF1;
	Fri, 10 Oct 2025 13:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102550;
	bh=7Of+xAoMGLGcpy2ssrdH7hbjZAZ+jItajeiQxbDca2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EKwZ44cxZE/yjNJBty7kbpdnAeb+OxIMIMVzasghIprs8Ishio+NhjQj2CXcDxAhR
	 Pm5u4WxMII12n4I6ndW39H1Y29VwAjbPPxg+Ae91bLRbeNCBtx5GJ+/13uSD7NahZO
	 hB/tSD9TUSCM8Augig5zu0o292LwDT+7Ve4OTpf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+52c1a7d3e5b361ccd346@syzkaller.appspotmail.com,
	Arnaud Lecomte <contact@arnaud-lcm.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Romain Sioen <romain.sioen@microchip.com>
Subject: [PATCH 6.6 18/28] hid: fix I2C read buffer overflow in raw_event() for mcp2221
Date: Fri, 10 Oct 2025 15:16:36 +0200
Message-ID: <20251010131331.027492181@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251010131330.355311487@linuxfoundation.org>
References: <20251010131330.355311487@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaud Lecomte <contact@arnaud-lcm.com>

commit b56cc41a3ae7323aa3c6165f93c32e020538b6d2 upstream.

As reported by syzbot, mcp2221_raw_event lacked
validation of incoming I2C read data sizes, risking buffer
overflows in mcp->rxbuf during multi-part transfers.
As highlighted in the DS20005565B spec, p44, we have:
"The number of read-back data bytes to follow in this packet:
from 0 to a maximum of 60 bytes of read-back bytes."
This patch enforces we don't exceed this limit.

Reported-by: syzbot+52c1a7d3e5b361ccd346@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=52c1a7d3e5b361ccd346
Tested-by: syzbot+52c1a7d3e5b361ccd346@syzkaller.appspotmail.com
Signed-off-by: Arnaud Lecomte <contact@arnaud-lcm.com>
Link: https://patch.msgid.link/20250726220931.7126-1-contact@arnaud-lcm.com
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Romain Sioen <romain.sioen@microchip.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-mcp2221.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/hid/hid-mcp2221.c
+++ b/drivers/hid/hid-mcp2221.c
@@ -814,6 +814,10 @@ static int mcp2221_raw_event(struct hid_
 			}
 			if (data[2] == MCP2221_I2C_READ_COMPL ||
 			    data[2] == MCP2221_I2C_READ_PARTIAL) {
+				if (!mcp->rxbuf || mcp->rxbuf_idx < 0 || data[3] > 60) {
+					mcp->status = -EINVAL;
+					break;
+				}
 				buf = mcp->rxbuf;
 				memcpy(&buf[mcp->rxbuf_idx], &data[4], data[3]);
 				mcp->rxbuf_idx = mcp->rxbuf_idx + data[3];


