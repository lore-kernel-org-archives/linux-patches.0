Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B5821F76A1;
	Tue, 17 Dec 2024 17:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455894; cv=none; b=M4aBQH/bFtpOgpHGkzm3U6bJyo9gmtndLkAyzFwzmi4cHKjKee10Yd5kvxQfEGZGUnhq8XQI8+ll8wBQb1JMux/VYXaEM6lO/amjcRyTrCf2PC0Y06Vkhy/zUsi8rlpAQcxBHHBd/8qybtoB+zVRTdN5hajh911dX7kYJcbmJKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455894; c=relaxed/simple;
	bh=M01v46qBCIW2Bv+gvZMBXp4LuVMSl0UkSpHq5Ukm70g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qb1dTBJ4c0hYkKS7S+0Wru6rKM73UGIFnnkKf2im4kFViAi59om/o9Y+T40prtvdfjoAg2F+nK2mB1cpD5pl6bSf6z0AoaQ/YTkbH2ggJMaybj2nabNoHkAew0cSafUVhT4hIgve0N/X/mGk3INjMe0eXkPOnc7Dlq8lDwuxtp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=beE+A0mB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="beE+A0mB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B79B0C4CED3;
	Tue, 17 Dec 2024 17:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455894;
	bh=M01v46qBCIW2Bv+gvZMBXp4LuVMSl0UkSpHq5Ukm70g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=beE+A0mBNo12guneLvQETzT7PrmJ0At+KecTsD+/W3tkhaCgTqx1X4N4UkkjfHkGi
	 pbQgOlTyaA6cTBs3CT+DWA/Wg9f6Ch/s+/yKxvFNAV5dS95i69FVfj40TffvU+9g2E
	 HwzGHywcasSezxPRk1AtZzSpQEHxU5HYQRB92ZL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>,
	Juergen Gross <jgross@suse.com>
Subject: [PATCH 6.1 68/76] xen/netfront: fix crash when removing device
Date: Tue, 17 Dec 2024 18:07:48 +0100
Message-ID: <20241217170529.266783762@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170526.232803729@linuxfoundation.org>
References: <20241217170526.232803729@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Juergen Gross <jgross@suse.com>

commit f9244fb55f37356f75c739c57323d9422d7aa0f8 upstream.

When removing a netfront device directly after a suspend/resume cycle
it might happen that the queues have not been setup again, causing a
crash during the attempt to stop the queues another time.

Fix that by checking the queues are existing before trying to stop
them.

This is XSA-465 / CVE-2024-53240.

Reported-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Fixes: d50b7914fae0 ("xen-netfront: Fix NULL sring after live migration")
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/xen-netfront.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -867,7 +867,7 @@ static netdev_tx_t xennet_start_xmit(str
 static int xennet_close(struct net_device *dev)
 {
 	struct netfront_info *np = netdev_priv(dev);
-	unsigned int num_queues = dev->real_num_tx_queues;
+	unsigned int num_queues = np->queues ? dev->real_num_tx_queues : 0;
 	unsigned int i;
 	struct netfront_queue *queue;
 	netif_tx_stop_all_queues(np->netdev);
@@ -882,6 +882,9 @@ static void xennet_destroy_queues(struct
 {
 	unsigned int i;
 
+	if (!info->queues)
+		return;
+
 	for (i = 0; i < info->netdev->real_num_tx_queues; i++) {
 		struct netfront_queue *queue = &info->queues[i];
 


