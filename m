Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C336A2F60A7;
	Tue, 17 Mar 2026 17:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767304; cv=none; b=nJaQ6rkCQ7fN3UgLGY5jwTvkT/XHlA3gAzniORUwgNsbqB6bpIg484KQIgarPRIsMEay/HZ0RdLQmOx9En1OaQrWioa2fpspGc7JV0ycIDgN160N3B8jXrmTXaAwIjcrv5hfBvxFjXV6698kywtqOsF/PKoRAEHEHMiIfOSkVLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767304; c=relaxed/simple;
	bh=GdDdqyakRiCmHHa4mPmjW/sWIYtlt4Tk8+UGoujpfVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CcahMzO6BtHgoYLDNEXol/UozW4vtl4bHTxWVsZILeMsZhnQTWVBboLBfQVMkFUq5Uh/CchtSkgIVd3r5gNBuTpHWu23tuMoSxjg2M+CH5c8dYq6imJF8T5PIcHYJE9eUi3RdUolqNJ0HDru6dXMnH8JwhPAPxA6oKwdsxW7xzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TpuQ7W2K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TpuQ7W2K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF778C4CEF7;
	Tue, 17 Mar 2026 17:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767304;
	bh=GdDdqyakRiCmHHa4mPmjW/sWIYtlt4Tk8+UGoujpfVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TpuQ7W2KqhsTXg104UDPPPm7/n2NuSpPUnXq+JdIb1YroFVc1BX4defjNBo44yFtv
	 s+0Xr6njwRXuiCxOSDmv+TVug3aIFszS9G878Ter0IcfggtS7TYYEgDPgxIPlLnMTU
	 KzfJkhdqXiRU7AENR0NeeUY/DDYhzOdQhnsrOd5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haiyue Wang <haiyuewa@163.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 058/333] mctp: i2c: fix skb memory leak in receive path
Date: Tue, 17 Mar 2026 17:31:27 +0100
Message-ID: <20260317163001.521705126@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haiyue Wang <haiyuewa@163.com>

[ Upstream commit e3f5e0f22cfc2371e7471c9fd5b4da78f9df7c69 ]

When 'midev->allow_rx' is false, the newly allocated skb isn't consumed
by netif_rx(), it needs to free the skb directly.

Fixes: f5b8abf9fc3d ("mctp i2c: MCTP I2C binding driver")
Signed-off-by: Haiyue Wang <haiyuewa@163.com>
Link: https://patch.msgid.link/20260305143240.97592-1-haiyuewa@163.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/mctp/mctp-i2c.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/mctp/mctp-i2c.c b/drivers/net/mctp/mctp-i2c.c
index 8043b57bdf250..f138b0251313e 100644
--- a/drivers/net/mctp/mctp-i2c.c
+++ b/drivers/net/mctp/mctp-i2c.c
@@ -343,6 +343,7 @@ static int mctp_i2c_recv(struct mctp_i2c_dev *midev)
 	} else {
 		status = NET_RX_DROP;
 		spin_unlock_irqrestore(&midev->lock, flags);
+		kfree_skb(skb);
 	}
 
 	if (status == NET_RX_SUCCESS) {
-- 
2.51.0



