Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4264830F52D;
	Mon, 13 Oct 2025 14:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760366946; cv=none; b=GgnG14pGBxq8L8esMSp7wE+2Ovc7s/MPWE7urHNMfth+Dz1BLAsS/DdpVPwD/dSQZxjY2ke2b8VHS6fRtR4m8eTdtaD3kaVj6IpBdM5eVdSsFVnLjL6UBRPS8JIN7UAzvg4prayC80ehPGP9GGibj3n5H/qAxq7R0RChan/BuKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760366946; c=relaxed/simple;
	bh=zM22GH8U7MSWnzq1SCVQxW9B0nAeBbIV1lwMVb9t3I4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BE7lUWNbqhISaoDje7claCv9vvPrPPlr1ECkWhAQ/Pn/SwJAoSRLIHoctFePKxDagT3EYmo8gLzZl7beRdhkbCBo2aghn7S4JFBLXjlUW1zbBFcwwLh2CGNj/cp9Kpp+WfW/xkNjKpgmzss6UuHeOI1XXOAqA35QVmv1J9r9Qjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KUYB9lBe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KUYB9lBe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8D42C4CEE7;
	Mon, 13 Oct 2025 14:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760366946;
	bh=zM22GH8U7MSWnzq1SCVQxW9B0nAeBbIV1lwMVb9t3I4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KUYB9lBevMc+RXg7YLo9+W3kcbACVYRAFAGCwj9s5d7hrjo5ZuGzAhwhR4aee5sr/
	 g8+R9nZZxRmZMo+BM0jSgV4A/MD5wjZZ6NgmF2tz3P4RujDSXDfbEc4MDp5cl4dFAs
	 5bHhbciPrWqgnqOiskDESjmHCe8Q2/PHTNXrQOTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+52c1a7d3e5b361ccd346@syzkaller.appspotmail.com,
	Arnaud Lecomte <contact@arnaud-lcm.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Romain Sioen <romain.sioen@microchip.com>
Subject: [PATCH 6.1 038/196] hid: fix I2C read buffer overflow in raw_event() for mcp2221
Date: Mon, 13 Oct 2025 16:43:31 +0200
Message-ID: <20251013144315.965421740@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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
@@ -791,6 +791,10 @@ static int mcp2221_raw_event(struct hid_
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


