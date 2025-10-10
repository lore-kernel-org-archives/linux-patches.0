Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D95122F0C63;
	Fri, 10 Oct 2025 13:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102504; cv=none; b=e5sUH8cbw+Yw6L0DbatqZWI/aRHMibKlPdXJ4UoZLajKXahpiqcKTLdYT31biGBEjvgoCEtxWK7MVQ5a0zDCpmXR1g/4khzG4bX5/0VcOZMP9ml/nnj3TUbvIxoEDCjKbBXSnhaPRz38H9lx0sMfYNjyKUX6lMaltvAaUdi/mx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102504; c=relaxed/simple;
	bh=ePnu6SdZbeIDFlOUfTPOZR1BzDnyuWBZWTNIBH1ejeg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oM++otvreJwzslVeDQPWm9Wiz3V8e4hdDpa0wLHxKT9tkKSiJXebCZCiCfzjmQzntGbajPUwa37oohZuRXX/0TbWbsQYTtuQza3SWnspOhxFjinXGOIHA3ROwAkuqOViA7hbXLEpgpcI6kUjNPgh0mVpACnsk9VyfZI76eS+9SM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uN+CB1Iw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uN+CB1Iw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60180C4CEF1;
	Fri, 10 Oct 2025 13:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102504;
	bh=ePnu6SdZbeIDFlOUfTPOZR1BzDnyuWBZWTNIBH1ejeg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uN+CB1Iwg7s6xUW3H60WdMtmizlX9xY8rkN6SpRybQP6kqz9GGJhCszQVW7ERwiFh
	 ACjVH8/w01ojl9l9FuWgrnPNKJ6Vc/j9JfRsHYqAS6OvYOPJvp0VXhEz0N3DaxtzRq
	 SJca8I3cfP+v73QQeC2DvYK27WdNCKhOIh/waI2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+52c1a7d3e5b361ccd346@syzkaller.appspotmail.com,
	Arnaud Lecomte <contact@arnaud-lcm.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Romain Sioen <romain.sioen@microchip.com>
Subject: [PATCH 6.12 25/35] hid: fix I2C read buffer overflow in raw_event() for mcp2221
Date: Fri, 10 Oct 2025 15:16:27 +0200
Message-ID: <20251010131332.701110291@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251010131331.785281312@linuxfoundation.org>
References: <20251010131331.785281312@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


