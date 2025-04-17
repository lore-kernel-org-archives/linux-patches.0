Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 423CD25C6EA;
	Thu, 17 Apr 2025 17:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912546; cv=none; b=tucncpWHbrY3xaCsTJKq2AFVVkQ1PgOV2oQFytXr6v7IT72Y6iGYnRA304ZLi7TowT9YH45vXHygoOh/bIyb/lh5pedqdJfX4iGdS88a7mg6aNLA7v+H5UtYkxyX7AVewZ9NN7EZn08VzxK/tQllcXNlvUQRLPCnGfif8vCFVow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912546; c=relaxed/simple;
	bh=e8+sc4e0Sc+Gdalsa0ZKz5AUD1z57nOdXeiMr0oCVPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nuWyQmu4bY+PjKI/vcfi7kxZM13PXR8T5an29tU2aJ/OF9Tiw6T3cyEp5LkTqDoU4v1OwA4pjAESLEqlZdK6mX7tKEEpbEH/yxxXh1NrGdDFF3Kobq2VzOCkmhGL3r6iCGVML7s32PRCXaTxBVE3CNI+ceiK3gXpe8GXEqlhbzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2YjILgGT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2YjILgGT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3502DC4CEE4;
	Thu, 17 Apr 2025 17:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912545;
	bh=e8+sc4e0Sc+Gdalsa0ZKz5AUD1z57nOdXeiMr0oCVPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2YjILgGThVjXKVcLQab5vJD8MTPVGZm0VHgL7dfvQ+sTqIg41zwobmw1UcbJWIyDh
	 LfixwjtVvyydvlBcYfNNMRqP0yf7jN236XAZLB8pWcUNjl4gYpJ4eqViwolMQhD2Pu
	 0DlsQs6L13z5F/FeJHRfuUaAFhqWF0viqZz5mp0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Michal Kubiak <michal.kubiak@intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 046/449] net: libwx: Fix the wrong Rx descriptor field
Date: Thu, 17 Apr 2025 19:45:34 +0200
Message-ID: <20250417175119.844019289@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

[ Upstream commit 13e7d7240a43d8ea528c12ae5a912be1ff7fa29b ]

WX_RXD_IPV6EX was incorrectly defined in Rx ring descriptor. In fact, this
field stores the 802.1ad ID from which the packet was received. The wrong
definition caused the statistics rx_csum_offload_errors to fail to grow
when receiving the 802.1ad packet with incorrect checksum.

Fixes: ef4f3c19f912 ("net: wangxun: libwx add rx offload functions")
Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>
Link: https://patch.msgid.link/20250407103322.273241-1-jiawenwu@trustnetic.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/wangxun/libwx/wx_lib.c  | 3 ++-
 drivers/net/ethernet/wangxun/libwx/wx_type.h | 3 +--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/wangxun/libwx/wx_lib.c b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
index 43b89509d0fe5..5b113fd71fe2e 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_lib.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
@@ -546,7 +546,8 @@ static void wx_rx_checksum(struct wx_ring *ring,
 		return;
 
 	/* Hardware can't guarantee csum if IPv6 Dest Header found */
-	if (dptype.prot != WX_DEC_PTYPE_PROT_SCTP && WX_RXD_IPV6EX(rx_desc))
+	if (dptype.prot != WX_DEC_PTYPE_PROT_SCTP &&
+	    wx_test_staterr(rx_desc, WX_RXD_STAT_IPV6EX))
 		return;
 
 	/* if L4 checksum error */
diff --git a/drivers/net/ethernet/wangxun/libwx/wx_type.h b/drivers/net/ethernet/wangxun/libwx/wx_type.h
index b54bffda027b4..1d9ed1cffd67c 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_type.h
+++ b/drivers/net/ethernet/wangxun/libwx/wx_type.h
@@ -460,6 +460,7 @@ enum WX_MSCA_CMD_value {
 #define WX_RXD_STAT_L4CS             BIT(7) /* L4 xsum calculated */
 #define WX_RXD_STAT_IPCS             BIT(8) /* IP xsum calculated */
 #define WX_RXD_STAT_OUTERIPCS        BIT(10) /* Cloud IP xsum calculated*/
+#define WX_RXD_STAT_IPV6EX           BIT(12) /* IPv6 Dest Header */
 
 #define WX_RXD_ERR_OUTERIPER         BIT(26) /* CRC IP Header error */
 #define WX_RXD_ERR_RXE               BIT(29) /* Any MAC Error */
@@ -535,8 +536,6 @@ enum wx_l2_ptypes {
 
 #define WX_RXD_PKTTYPE(_rxd) \
 	((le32_to_cpu((_rxd)->wb.lower.lo_dword.data) >> 9) & 0xFF)
-#define WX_RXD_IPV6EX(_rxd) \
-	((le32_to_cpu((_rxd)->wb.lower.lo_dword.data) >> 6) & 0x1)
 /*********************** Transmit Descriptor Config Masks ****************/
 #define WX_TXD_STAT_DD               BIT(0)  /* Descriptor Done */
 #define WX_TXD_DTYP_DATA             0       /* Adv Data Descriptor */
-- 
2.39.5



