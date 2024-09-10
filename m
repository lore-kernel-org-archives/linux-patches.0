Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5DA518F2FF;
	Tue, 10 Sep 2024 10:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964449; cv=none; b=W4K/040WFpG6nV65PJyUwK2e4pycGDkrT3ZoPn15Mjzb5gudNOD98rm5Z8YZx7G4ANmtSuQbkASteTOqMcs89cE+CDeZQrBd9MjT+I+bJr+NZpTCh4nQYfrI6y2ztf4ww9e1N0YpBzZUpcwRZ2iCN58WNXWqIK4R77gzZ0AGaHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964449; c=relaxed/simple;
	bh=ITUlwza0TxABM3W/SRGM4R7a/lNN9SM98aQBYhuTgew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WPZRo6WEfKzrS35Q/ChdmmxcAtNySp/ntZ8ujsq4noLJt89+cLU5nOjNFoKO2Sd3LcZl0Ihni+aYMGb9h8SqJvRdDUjm+UA4CPuYh2ZbhpzILjjQUVSQ0h1oKYjslGRHQW38+/3/rz1ffUr/EH9dK9jNka+0I1To0PG6digTl/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iY3I4rZS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iY3I4rZS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E07D7C4CEC3;
	Tue, 10 Sep 2024 10:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964449;
	bh=ITUlwza0TxABM3W/SRGM4R7a/lNN9SM98aQBYhuTgew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iY3I4rZSUGhs/ILkIT96U2Ioib5F/6MlJKEnB9Ulj6t5Mev658Ra6SCupgCNd35Se
	 4DagYIBeWAp0jyCPHMN/qqYc7vAoi8THbrzpaahMfrIQfbineXlHa6qL/1qn+/nK7r
	 9UCag7JBCmuaOVu/ufPH2nyC8TdmpGUTR1L3qlUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	Foster Snowhill <forst@pen.gy>,
	Georgi Valkov <gvalkov@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 187/269] usbnet: ipheth: race between ipheth_close and error handling
Date: Tue, 10 Sep 2024 11:32:54 +0200
Message-ID: <20240910092614.791099819@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



