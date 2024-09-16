Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71FC61514C6;
	Mon, 16 Sep 2024 12:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488259; cv=none; b=LdYlFlshYKyVKzFChgOiX40Ewo7I4Zh+gIW54ODNnu+4WXH05sQd3LmTTuvxaaVUa+PrzfgzEaD8JTxnhUIqiLe4BoPo+GcPs+L0zZJXQpBOvQ7nOwHZ4e0p5mrZePu6aKmXtAVPY9efzqKwZ1/dlp9DuJxS9IEujyqKqA22TjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488259; c=relaxed/simple;
	bh=ByDeBhQ7aCPI48Y6kQlnZbAK9LGiz0TdoNRNOziwyh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RvwfvkSMO4OiQ3hu9554O2X6ndXncVrc75PjSGhY5KydNLbBp1WuzyVWx4bULwGdJ00/iuKaiz449H/LpoAfaJNUznZbaZ6OYqJFi9hxJyFOJz2xFFcoeLL+jG4cn96YW2h4iN2tCtQkjgnCDcmZa6mDI+R6t2dX/i13hE0b+gM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MQ54uKfP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MQ54uKfP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA561C4CEC4;
	Mon, 16 Sep 2024 12:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488259;
	bh=ByDeBhQ7aCPI48Y6kQlnZbAK9LGiz0TdoNRNOziwyh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MQ54uKfPC24HauD49b5TGoG/lT47T8ZfHuxQ0EeXDfHO5i4BxN6TQCSVmVrhEnP/j
	 bcEnQzGzJTc9W+NajulFiG0QqNzKWXxeBkB/wYJACMR1qoELgWSQrEFt9ymC/tXC9F
	 yEJL91GH7CtfRvkN0b6COUjQIiQN3j9GcyCAhP74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.10 051/121] net: libwx: fix number of Rx and Tx descriptors
Date: Mon, 16 Sep 2024 13:43:45 +0200
Message-ID: <20240916114230.822023135@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiawen Wu <jiawenwu@trustnetic.com>

commit 077ee7e6b13a2b6668196ed01a22023549e19381 upstream.

The number of transmit and receive descriptors must be a multiple of 128
due to the hardware limitation. If it is set to a multiple of 8 instead of
a multiple 128, the queues will easily be hung.

Cc: stable@vger.kernel.org
Fixes: 883b5984a5d2 ("net: wangxun: add ethtool_ops for ring parameters")
Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20240910095629.570674-1-jiawenwu@trustnetic.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/wangxun/libwx/wx_type.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/wangxun/libwx/wx_type.h
+++ b/drivers/net/ethernet/wangxun/libwx/wx_type.h
@@ -424,9 +424,9 @@ enum WX_MSCA_CMD_value {
 #define WX_MIN_RXD                   128
 #define WX_MIN_TXD                   128
 
-/* Number of Transmit and Receive Descriptors must be a multiple of 8 */
-#define WX_REQ_RX_DESCRIPTOR_MULTIPLE   8
-#define WX_REQ_TX_DESCRIPTOR_MULTIPLE   8
+/* Number of Transmit and Receive Descriptors must be a multiple of 128 */
+#define WX_REQ_RX_DESCRIPTOR_MULTIPLE   128
+#define WX_REQ_TX_DESCRIPTOR_MULTIPLE   128
 
 #define WX_MAX_JUMBO_FRAME_SIZE      9432 /* max payload 9414 */
 #define VMDQ_P(p)                    p


