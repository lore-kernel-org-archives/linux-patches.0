Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82A5D14D431;
	Tue, 10 Sep 2024 10:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962654; cv=none; b=bxTRcd2MnEZKBKT9hDo3UTeUGtlovTJrGPf2+DXDdAEpo5nGQakwdm5nI5FmhaY3aQPPd0gM5jSvGAY65pUeMVwUIn/h499BviuECHu1LwFHhuzQ8j4xr8cSfqN6FpnZzeeVvk5CP3zdrMzEmYDXfYrimKVVgSlaXUxHUteTGOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962654; c=relaxed/simple;
	bh=PIpqTZ+0z/P7K38JGRkj8fQ+7Yxx9K718+MYgm2sgpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SN3CUjr6d0/UMSPm1LPn24Ph4j4NypHqyo8zRsZLt2MvcP0BZ51N/t1rVaKtrO8FedtGBDHGetvXuI179Bc9mApVP3swBrY7jFqpiz2RLEy3hv0pOZE/3z4a5swsWx50RA0wXp4WA+hOyhWtwxmuxadPNHtMju7BnRozKSabirI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WyM8yqa0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WyM8yqa0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05AFCC4CEC3;
	Tue, 10 Sep 2024 10:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962654;
	bh=PIpqTZ+0z/P7K38JGRkj8fQ+7Yxx9K718+MYgm2sgpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WyM8yqa05YghP8q9Q8tAiP9OJFehs8CgGSfnE9qdCUqVdDBfXI9CYINV4i2ndNsy5
	 5IdWjBoHsDc/ke9Gu0jx8yyPPN09B6NHBxyXWBb5fSNi6D32iD0OSV6l/Ai/6rMgWH
	 CvOZ6AoAQebpqkLM6hgJtdhgrDwFyZV5HbEk7hkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	Foster Snowhill <forst@pen.gy>,
	Georgi Valkov <gvalkov@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 089/121] usbnet: ipheth: race between ipheth_close and error handling
Date: Tue, 10 Sep 2024 11:32:44 +0200
Message-ID: <20240910092550.096747448@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092545.737864202@linuxfoundation.org>
References: <20240910092545.737864202@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.com>

[ Upstream commit e5876b088ba03a62124266fa20d00e65533c7269 ]

ipheth_sndbulk_callback() can submit carrier_work
as a part of its error handling. That means that
the driver must make sure that the work is cancelled
after it has made sure that no more URB can terminate
with an error condition.

Hence the order of actions in ipheth_close() needs
to be inverted.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Signed-off-by: Foster Snowhill <forst@pen.gy>
Tested-by: Georgi Valkov <gvalkov@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/ipheth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/ipheth.c b/drivers/net/usb/ipheth.c
index 9887eb282beb..05576f66f73d 100644
--- a/drivers/net/usb/ipheth.c
+++ b/drivers/net/usb/ipheth.c
@@ -353,8 +353,8 @@ static int ipheth_close(struct net_device *net)
 {
 	struct ipheth_device *dev = netdev_priv(net);
 
-	cancel_delayed_work_sync(&dev->carrier_work);
 	netif_stop_queue(net);
+	cancel_delayed_work_sync(&dev->carrier_work);
 	return 0;
 }
 
-- 
2.43.0



