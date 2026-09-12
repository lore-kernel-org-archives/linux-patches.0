Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FE622D23A6;
	Sat, 12 Sep 2026 14:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222427; cv=none; b=HMYvqnuOLLJh2jsd1jmAenci6SkXlrECJQBJInXQprq3u+uyhMWx0OeYyc72XY4lHNGYSysmUKV9NsAzGCMr4WFiQzkr3foeAZx9QYD2OX3QQWj6uZzW0liXzLQnyxarQOxfSB0s223KL3nWTUlkQpfzk+uGsTk1iDx5vWLfJg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222427; c=relaxed/simple;
	bh=/DB5xRXbuV514P9U0qgMrnmmUw18oUCPI7gFCyJfMTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vm023EraITXW4RfsepucBb7osHcR5SgnA2mRghPAm6qDNz+xa9YEl+rLS1YvY8jxEX4SZ0NnyZY8JxGg+XBTG3twKGCyXjg6KGoqxPuxRQFIaMI3WfCkE8LfXxI+TfEY32ZVzZ5BY+XS26CW6uTh6jeLJgi51mR2+z2ulK+lgG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gEmsbumR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gEmsbumR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94BDB1F000FF;
	Sat, 12 Sep 2026 14:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222426;
	bh=DXC0LVmp2tncj7YtKdyyWUZCtmWbcLBhN8PWsOJUBkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gEmsbumRWzcpBCt/acIGVPPIN+n66HH9BZjaB7Vb3faX+RlSSxauOOnfxz0dp6yxG
	 lcO4eoiJetxZfL5wJ5Lb1Y+GBddz8/o/3hN5A7yaabFV9L9aU0GdVn+TLrkp6xRou6
	 OmzTxtA08XGTuNya+s7iDpUM3mT192IiX8yHHQYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0542/1424] net: libwx: fix Tx L4 checksum
Date: Sat, 12 Sep 2026 08:49:34 +0200
Message-ID: <20260912065619.439537047@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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
index 23dbe4e4b36c0..c27e68e320e62 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_lib.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
@@ -1327,6 +1327,7 @@ static void wx_tx_csum(struct wx_ring *tx_ring, struct wx_tx_buffer *first,
 	u8 tun_prot = 0;
 
 	if (skb->ip_summed != CHECKSUM_PARTIAL) {
+csum_failed:
 		if (!(first->tx_flags & WX_TX_FLAGS_HW_VLAN) &&
 		    !(first->tx_flags & WX_TX_FLAGS_CC))
 			return;
@@ -1420,7 +1421,8 @@ static void wx_tx_csum(struct wx_ring *tx_ring, struct wx_tx_buffer *first,
 					WX_TXD_L4LEN_SHIFT;
 			break;
 		default:
-			break;
+			skb_checksum_help(skb);
+			goto csum_failed;
 		}
 
 		/* update TX checksum flag */
-- 
2.53.0



