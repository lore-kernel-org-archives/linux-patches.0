Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC7762EF9BF;
	Thu,  3 Jul 2025 14:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554415; cv=none; b=u8DwoC+5LF3ol3A5TOfKORBU9G6yVqz7wsd0GwbpBOVNmo1bX9v9vibX6/FzyxFkgx/E1HshbG//rjV0zy6MgmoyH6StjOEm4VQUo6pouuhWxMzXHvmUGo/SCW2MdcsRkU4XCse+QTyVBLGKuF1jfL5Qwo+PtAR/g6+S7YY9VMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554415; c=relaxed/simple;
	bh=jKaZFqlooAiKlO9oK3Fd/D/x1ntfQvhGkybi8yeUtls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LLy9oI/dWjFB9qkqyhlNH1RYPs6DCF0XmGdtQsQarvFJ5xLejbIulMXn8QH05GTHApfgofuvh18NFcqjPQRYFsd7EY0GgxSyNv6f554uoDkkBAs3KUMfKcwZGGaNk54PQbxRJN3aE8w2F5a5ER78iEbh03f6ZIIbuH6oTrBmRiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SDeEhnYJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SDeEhnYJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42F6BC4CEE3;
	Thu,  3 Jul 2025 14:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554415;
	bh=jKaZFqlooAiKlO9oK3Fd/D/x1ntfQvhGkybi8yeUtls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SDeEhnYJiO8GWuRW9AUHIfzYvXJxbBrqowrgTSfYUQvxHfl3V7F0LxnQECVFYwLSw
	 YAT5cWwqUAAu7RVJ+NsMRF/pvUDS6Mo74Yd2R+cduJ5ppNH4gVy526lksCsEJcPRuO
	 Zzo6Ynw+zK1YicH72EECnLhS+eU5cWPLwuz1h4zw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Wenshan Lan <jetlan9@163.com>
Subject: [PATCH 6.12 180/218] net: libwx: fix Tx L4 checksum
Date: Thu,  3 Jul 2025 16:42:08 +0200
Message-ID: <20250703144003.371017154@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiawen Wu <jiawenwu@trustnetic.com>

commit c7d82913d5f9e97860772ee4051eaa66b56a6273 upstream.

The hardware only supports L4 checksum offload for TCP/UDP/SCTP protocol.
There was a bug to set Tx checksum flag for the other protocol that results
in Tx ring hang. Fix to compute software checksum for these packets.

Fixes: 3403960cdf86 ("net: wangxun: libwx add tx offload functions")
Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
Link: https://patch.msgid.link/20250324103235.823096-2-jiawenwu@trustnetic.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Wenshan Lan <jetlan9@163.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/wangxun/libwx/wx_lib.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/wangxun/libwx/wx_lib.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
@@ -1336,6 +1336,7 @@ static void wx_tx_csum(struct wx_ring *t
 	u8 tun_prot = 0;
 
 	if (skb->ip_summed != CHECKSUM_PARTIAL) {
+csum_failed:
 		if (!(first->tx_flags & WX_TX_FLAGS_HW_VLAN) &&
 		    !(first->tx_flags & WX_TX_FLAGS_CC))
 			return;
@@ -1429,7 +1430,8 @@ static void wx_tx_csum(struct wx_ring *t
 					WX_TXD_L4LEN_SHIFT;
 			break;
 		default:
-			break;
+			skb_checksum_help(skb);
+			goto csum_failed;
 		}
 
 		/* update TX checksum flag */


