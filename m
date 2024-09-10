Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71F195381A;
	Tue, 10 Sep 2024 10:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963758; cv=none; b=vCY1xbTk8bVCDan/6yypKUqAWUziW1AVV8nHlmv4wO2i4n7HV0FmoIe544mIaSnelwAft12fNoLbI1RYT0Xo3jhd7KOv0Df8OjNCwh3l5ZIw+Uk1lAOloCObhwXC0KiDHo2Iv8shmpoYlPlJHpTeeVKqGl7Azb4YAPrVythxyns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963758; c=relaxed/simple;
	bh=Uvifjr8J8fh/ZayAKxsO8a8AK0YKIRrluEboTa3r/rA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NcPunTKIb/QPhMpBfCLyjEzLwpjEsV9SCcz3qH1ztnXXzB3p/Y3ePiX0YXT1SKhwhofuVnX3m2ITrB9fauIyVv9xuoj78rMWjsJ4VkRif9iNNNvOLrS4FEVaeB2/xyk5BPnV4l0i0tSOOHqoYPQ3jO7coyv7zUz2+XPMIzqI3yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xsBXNf5S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xsBXNf5S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF87CC4CEC3;
	Tue, 10 Sep 2024 10:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963758;
	bh=Uvifjr8J8fh/ZayAKxsO8a8AK0YKIRrluEboTa3r/rA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xsBXNf5SYwEZCA+TJLgHmmxzxmm440R/XDVCbNKQ4YYb/y934mtx5HByypqmb6bZz
	 zrjVAE467kqi4eRipJ6wUgr25NE04kSckQhD75vDl+OmNudXHK0LDvtsnhi9ufEX9J
	 3SQaMIa8bDfZXwfRfNIu7cX8u3NxlO4hAZ9wZAwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	Foster Snowhill <forst@pen.gy>,
	Georgi Valkov <gvalkov@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 166/214] usbnet: ipheth: race between ipheth_close and error handling
Date: Tue, 10 Sep 2024 11:33:08 +0200
Message-ID: <20240910092605.473724642@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



