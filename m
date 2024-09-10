Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2BA118C32E;
	Tue, 10 Sep 2024 10:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725965193; cv=none; b=uCqOCQaEjbWCxVVzAYFAB+SMf28ATT1er0mDExN0bL9zYfWflwDX9Y3RTznjBfytHMMEPOQ9DnV8duhms0YoHK+kK0h6HvgGv58rtXk6jVfrNny6toiUo/XyJHmrQ5C23enB8d+22z5d9U08ut0zIeZG1Qp/WQtljARtB+2X/xU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725965193; c=relaxed/simple;
	bh=mlJIBL7NROT8ca3PkWyivHuGo0yxHncUnabgCR4EIYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FcyIh7fl0OeHQ277PupHO/7ycLYgCyzoAaQbCKaahrXWRmitjKeFpM1xucWP2/AQHXaUErM22bQNXKFln3K2/E5Fxg8ylPpWFBu+1AQwv7+P8VuK+XvnGCLuJm5fG15kBOKzQvyqzQxosit1zpV7Sx23rko50HKawpkukyB1/Qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iKBALHCV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iKBALHCV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20823C4CEC3;
	Tue, 10 Sep 2024 10:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725965193;
	bh=mlJIBL7NROT8ca3PkWyivHuGo0yxHncUnabgCR4EIYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iKBALHCVoBQcFUT5rOGdsBqpocNrkzCp6L+N47AYcjdN3bGe0g34HhmWPA8uXaV16
	 YM2Gg4us55BamqJkob1R1dJzRZJf+p2E9lGqAlwd4aLLDrP51bE7MoyMV7qv+7kjHQ
	 Dw+kSNsdBfaqpFRHv44ZiK+eBQQod61A0Id/2PDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	Foster Snowhill <forst@pen.gy>,
	Georgi Valkov <gvalkov@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 151/186] usbnet: ipheth: race between ipheth_close and error handling
Date: Tue, 10 Sep 2024 11:34:06 +0200
Message-ID: <20240910092600.803188054@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index d56e276e4d80..4485388dcff2 100644
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



