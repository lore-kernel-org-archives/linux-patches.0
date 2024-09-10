Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5170246444;
	Tue, 10 Sep 2024 09:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962020; cv=none; b=Vw5uFg9cAvhGXCKMPYNQdq55Gy3pcQwkPl+ADBaj3LwU0DeEEHEtg8jeAsspUTnZVy2rKAEka62DdKNTmNdO5j3buZU9piLzj9TXbg58Bi0VJLkUAw8Vtrh/UhQvBmHFGjgbDp8YP4FC/mS1PmWiDGKtZjbkwAj/xYrsm/98HGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962020; c=relaxed/simple;
	bh=v0JLhdjb4/rRy6h4gM8F78AN7k6VWqNAAnY7TFHbBx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VOalnyTg5ziqnEjrx4aPRStQpVhcX81PUPcHRfk3A3suFKTA5nvMcM52GgIRVMCDhDgKVq8qFcUjaLI38JenDhAFm3CUQkpi4JM90anHJLoe9a8hsgl20l769pMznYtFfmqd9TqdU5uTtWnMBUC6ncNVzw20ew+43MV402ksyR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lZm4545c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lZm4545c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82E71C4CEC3;
	Tue, 10 Sep 2024 09:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962019;
	bh=v0JLhdjb4/rRy6h4gM8F78AN7k6VWqNAAnY7TFHbBx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lZm4545c4TQ/Y5bg5GbrJA6wJCDBZlabFaqLkreSygXJ2Kg+qC0DE+4xJjQTjN1uL
	 wAw9IbNYiPPNa0bH6WisUpzMMd9MMPG6NgqvkYq0p8uIZ8jBMFt00E63DjLtJhbcT0
	 DBIqBiAuTsQrDn7ojGPcrSaBJbPkodc7md9KI34U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	Foster Snowhill <forst@pen.gy>,
	Georgi Valkov <gvalkov@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 268/375] usbnet: ipheth: race between ipheth_close and error handling
Date: Tue, 10 Sep 2024 11:31:05 +0200
Message-ID: <20240910092631.558608549@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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
index 687d70cfc556..6eeef10edada 100644
--- a/drivers/net/usb/ipheth.c
+++ b/drivers/net/usb/ipheth.c
@@ -475,8 +475,8 @@ static int ipheth_close(struct net_device *net)
 {
 	struct ipheth_device *dev = netdev_priv(net);
 
-	cancel_delayed_work_sync(&dev->carrier_work);
 	netif_stop_queue(net);
+	cancel_delayed_work_sync(&dev->carrier_work);
 	return 0;
 }
 
-- 
2.43.0



