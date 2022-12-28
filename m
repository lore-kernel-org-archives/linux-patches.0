Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FFDC1C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:43:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99DBBC433EF;
	Wed, 28 Dec 2022 16:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672245825;
	bh=yOqexlF7Pg6JfdPBE3az4NjdJGwGGeRXN3SazuVHnZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d78CjChgTJg1As0SvRbpXhT352VHVf/yxxz6mtm64V6gA0P2zK5/Y1njvJpbA2MSq
	 RI7WvDCXDzjVinSo6VzeHmfBtYBuIs/OvrTadbrlAM5jhb3V2lCCWXeH8dIUtL2oJT
	 z+ACYOZWhY7OZfh+IghVLXwG1SO0Mk7tlOM67L2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harsh Tyagi <harshtya@google.com>,
	Jeremy Kerr <jk@codeconstruct.com.au>,
	Alexander Duyck <alexanderduyck@fb.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0931/1146] mctp: serial: Fix starting value for frame check sequence
Date: Wed, 28 Dec 2022 15:41:10 +0100
Message-Id: <20221228144355.574667028@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jeremy Kerr <jk@codeconstruct.com.au>

[ Upstream commit 2856a62762c8409e360d4fd452194c8e57ba1058 ]

RFC1662 defines the start state for the crc16 FCS to be 0xffff, but
we're currently starting at zero.

This change uses the correct start state. We're only early in the
adoption for the serial binding, so there aren't yet any other users to
interface to.

Fixes: a0c2ccd9b5ad ("mctp: Add MCTP-over-serial transport binding")
Reported-by: Harsh Tyagi <harshtya@google.com>
Tested-by: Harsh Tyagi <harshtya@google.com>
Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/mctp/mctp-serial.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/mctp/mctp-serial.c b/drivers/net/mctp/mctp-serial.c
index 7cd103fd34ef..9f9eaf896047 100644
--- a/drivers/net/mctp/mctp-serial.c
+++ b/drivers/net/mctp/mctp-serial.c
@@ -35,6 +35,8 @@
 #define BYTE_FRAME		0x7e
 #define BYTE_ESC		0x7d
 
+#define FCS_INIT		0xffff
+
 static DEFINE_IDA(mctp_serial_ida);
 
 enum mctp_serial_state {
@@ -123,7 +125,7 @@ static void mctp_serial_tx_work(struct work_struct *work)
 		buf[2] = dev->txlen;
 
 		if (!dev->txpos)
-			dev->txfcs = crc_ccitt(0, buf + 1, 2);
+			dev->txfcs = crc_ccitt(FCS_INIT, buf + 1, 2);
 
 		txlen = write_chunk(dev, buf + dev->txpos, 3 - dev->txpos);
 		if (txlen <= 0) {
@@ -303,7 +305,7 @@ static void mctp_serial_push_header(struct mctp_serial *dev, unsigned char c)
 	case 1:
 		if (c == MCTP_SERIAL_VERSION) {
 			dev->rxpos++;
-			dev->rxfcs = crc_ccitt_byte(0, c);
+			dev->rxfcs = crc_ccitt_byte(FCS_INIT, c);
 		} else {
 			dev->rxstate = STATE_ERR;
 		}
-- 
2.35.1



