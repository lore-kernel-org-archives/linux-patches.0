Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 793842E5B11;
	Tue,  8 Jul 2025 16:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992650; cv=none; b=Pio3HEtvAdJ9Vui4xNs42BgvwsRKK/aziMJMoTJa123ssnUwg5d/9A0B4O3VB5NfhNgzqBssEePZIp381W/NPAUxmJT+y3Y5AZjRsCdmpdSbxGtLu2ce7kngIcruoKM9/m1oNCcs8ZlvVmiA/1mrVYR0uSGt6WprWk2eFXkVHAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992650; c=relaxed/simple;
	bh=E1rNWJQwUI3RG7+rtfZJQl2tg63Bco4O1UMfWsFpx7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eaV5VrWKHBOeIQ0ef30yNvYDFOl7FxZFgkDUocgCI6fjAPCkCiYfOP6MCP0JgXrajeMKZ4TwBVc+Llq2eQ242pfnSVNlwsxl3Sgzz+Jc5ZvNRwF0vH4+2hQI9blnrqe+0Op1G/9ZLcLEfRc0IUJykob6fvasuVaHa7WO7p4yJNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HPbLBM+n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HPbLBM+n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB6A1C4CEF6;
	Tue,  8 Jul 2025 16:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992650;
	bh=E1rNWJQwUI3RG7+rtfZJQl2tg63Bco4O1UMfWsFpx7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HPbLBM+njuZv72FWbiOr3qHtJYTY/1/ybzY/LtPrDJ/yZyuwO1PzjKbb1XzqcO9DB
	 pBcDnr+6WS9znbUKKmmkTGLw1Wjb4aDajN+TxdhQW/SRC6+OGSwSXciAcFvkLON6go
	 iS/2BznJXsaYmNcjd7bCLETYjhyVLktxirilOjVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 010/232] net: libwx: fix the incorrect display of the queue number
Date: Tue,  8 Jul 2025 18:20:06 +0200
Message-ID: <20250708162241.703513585@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

commit 5186ff7e1d0e26aaef998ba18b31c79c28d1441f upstream.

When setting "ethtool -L eth0 combined 1", the number of RX/TX queue is
changed to be 1. RSS is disabled at this moment, and the indices of FDIR
have not be changed in wx_set_rss_queues(). So the combined count still
shows the previous value. This issue was introduced when supporting
FDIR. Fix it for those devices that support FDIR.

Fixes: 34744a7749b3 ("net: txgbe: add FDIR info to ethtool ops")
Cc: stable@vger.kernel.org
Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/A5C8FE56D6C04608+20250701070625.73680-1-jiawenwu@trustnetic.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/wangxun/libwx/wx_lib.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/wangxun/libwx/wx_lib.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
@@ -1585,6 +1585,7 @@ static void wx_set_rss_queues(struct wx
 
 	clear_bit(WX_FLAG_FDIR_HASH, wx->flags);
 
+	wx->ring_feature[RING_F_FDIR].indices = 1;
 	/* Use Flow Director in addition to RSS to ensure the best
 	 * distribution of flows across cores, even when an FDIR flow
 	 * isn't matched.


