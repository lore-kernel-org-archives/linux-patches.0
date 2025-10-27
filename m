Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 763F432D7D8;
	Mon, 27 Oct 2025 18:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590954; cv=none; b=gsz/ZLbIUe+MTMrzmXJ3YZaQ+WFMmlQfkCYFkZU/LDLdunFvfnjFfW94Cwi+svMFnAiYAFprUX8d8xUWm8HmZkAM2hPovbxDGdW5E0dKUArIeEvF3jVZlczpoDyd1/21Xuo11NMU+ClkwDaLJWbHReXgMCxfzCSWuJUQlYJKBHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590954; c=relaxed/simple;
	bh=42oaWvoaPn/NensWh47seybcqct+RjHOEQzOecgdvNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aVQgqYic2PY9RC4q8suSaBiaLM4/ZIO47IKEkyMgh0C8d1XjOFgYVPSwMnLzyqguwa6/QhEGxOfw2tV/qefMVzjSp7clsAW5ZQfJWIZMiT2wbYe+/5cqTrA4FdMDaVxJTDOC67oDlqhhATKLHlAoUlHDIsNDkPmaQSG6DfZQyAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bGyOqPUn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bGyOqPUn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98402C4CEF1;
	Mon, 27 Oct 2025 18:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590953;
	bh=42oaWvoaPn/NensWh47seybcqct+RjHOEQzOecgdvNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bGyOqPUnjdKjlRs6HsVQMJetLujZOFc4OlkSa2dz6UfcYPXwbmgD4iBqqrpBJ+Gg8
	 gBiMnkmJ3YTUUkunIsDIxgPjcc6vlFJKs+bqUAnsUjIO697MtaWx9AaXx8keHmrRn5
	 J35XeFY3rBFUIDrEcTpFo4bVGU7kk3vwcGeYOV90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+52c1a7d3e5b361ccd346@syzkaller.appspotmail.com,
	Arnaud Lecomte <contact@arnaud-lcm.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Romain Sioen <romain.sioen@microchip.com>
Subject: [PATCH 5.10 012/332] hid: fix I2C read buffer overflow in raw_event() for mcp2221
Date: Mon, 27 Oct 2025 19:31:05 +0100
Message-ID: <20251027183524.945957812@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


