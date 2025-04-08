Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFB6B374C4;
	Tue,  8 Apr 2025 11:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110976; cv=none; b=fO0Qw1EG4WEIfbwdfIRWS0c/sZKLhvmkjQ2MJszVPktBYRYXh+rr5GyAWFox1G3F15ZRx4MX1nA3R9yaNbSBhg0J9sV0MKRK8qoDisMXlgrD/B4gXFxFldEiNjB/w6/EsnUuT1y2c2LaHflgJ8ktGNeEoTL/hhJGR5OrQdJvjwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110976; c=relaxed/simple;
	bh=AStSGNN9jF1cWhMb3ic0W1gkw6bp9xA1+ZYn0reIjms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mgfr8BmrQoE0wlbTFui0Ne7v0hwnsQ9tKKdnOFk5ZbZu9ws3g5QT5adN9X+6AKK31VZaEbYr10dtEuVvA39aEGjd7hrgj6vG+qbLLanU7kAsYGJ/zF9BYOrXeDeR5klW1UAVeC9i8y4rmwG1zfh7GrP5kvuwru5W7+QshGIAlFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XBMYnZ2f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XBMYnZ2f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7FBEC4CEE5;
	Tue,  8 Apr 2025 11:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110975;
	bh=AStSGNN9jF1cWhMb3ic0W1gkw6bp9xA1+ZYn0reIjms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XBMYnZ2f63cadiyd7z7lwKT1tjmWaMdqwuP3QlI33T5p0pPcIPR+mrmGbm5+mb/VJ
	 SQygZNDoFU7bvikAsMHdFxq2qHbWT4Wxb8dzFVRFPaHqN+BebWdBf28G7iwRTqUYJ8
	 eVHZ0+oHU40dAamtknNY8QshE7e6x3sTV8R7zSOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 264/731] net: libwx: fix Tx L4 checksum
Date: Tue,  8 Apr 2025 12:42:41 +0200
Message-ID: <20250408104920.422603659@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiawen Wu <jiawenwu@trustnetic.com>

[ Upstream commit c7d82913d5f9e97860772ee4051eaa66b56a6273 ]

The hardware only supports L4 checksum offload for TCP/UDP/SCTP protocol.
There was a bug to set Tx checksum flag for the other protocol that results
in Tx ring hang. Fix to compute software checksum for these packets.

Fixes: 3403960cdf86 ("net: wangxun: libwx add tx offload functions")
Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
Link: https://patch.msgid.link/20250324103235.823096-2-jiawenwu@trustnetic.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/wangxun/libwx/wx_lib.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/wangxun/libwx/wx_lib.c b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
index 9294a9d8c5541..497abf2723a5e 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_lib.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
@@ -1337,6 +1337,7 @@ static void wx_tx_csum(struct wx_ring *tx_ring, struct wx_tx_buffer *first,
 	u8 tun_prot = 0;
 
 	if (skb->ip_summed != CHECKSUM_PARTIAL) {
+csum_failed:
 		if (!(first->tx_flags & WX_TX_FLAGS_HW_VLAN) &&
 		    !(first->tx_flags & WX_TX_FLAGS_CC))
 			return;
@@ -1441,7 +1442,8 @@ static void wx_tx_csum(struct wx_ring *tx_ring, struct wx_tx_buffer *first,
 					WX_TXD_L4LEN_SHIFT;
 			break;
 		default:
-			break;
+			skb_checksum_help(skb);
+			goto csum_failed;
 		}
 
 		/* update TX checksum flag */
-- 
2.39.5



