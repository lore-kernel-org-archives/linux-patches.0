Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 671D84C6A
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 13:02:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0529C43470;
	Mon, 14 Nov 2022 13:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1668430957;
	bh=2cVBtfCfD96RA3g+oq+0HS9yZ2X6WhHc8nepJziZPt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uPwvS28wrBqwlgERi/UKomCZixQbzzRKU+udqNt2YVZozz+ryz2rCxpP5TxKBago9
	 FF4Y2K5BeWbcsMYpQwy8mlVf4VuUDnTLsG6agfQ79pdKNquvaWLotxvobGW5T8L8QJ
	 CYOPZRzWwkwe3brzmXG/j7OHEPIgS8U/dx/Nygts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 048/190] net: lapbether: fix issue of dev reference count leakage in lapbeth_device_event()
Date: Mon, 14 Nov 2022 13:44:32 +0100
Message-Id: <20221114124500.909153217@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhengchao Shao <shaozhengchao@huawei.com>

[ Upstream commit 531705a765493655472c993627106e19f7e5a6d2 ]

When following tests are performed, it will cause dev reference counting
leakage.
a)ip link add bond2 type bond mode balance-rr
b)ip link set bond2 up
c)ifenslave -f bond2 rose1
d)ip link del bond2

When new bond device is created, the default type of the bond device is
ether. And the bond device is up, lapbeth_device_event() receives the
message and creates a new lapbeth device. In this case, the reference
count value of dev is hold once. But after "ifenslave -f bond2 rose1"
command is executed, the type of the bond device is changed to rose. When
the bond device is unregistered, lapbeth_device_event() will not put the
dev reference count.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wan/lapbether.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wan/lapbether.c b/drivers/net/wan/lapbether.c
index 960f1393595c..cb360dca3250 100644
--- a/drivers/net/wan/lapbether.c
+++ b/drivers/net/wan/lapbether.c
@@ -446,7 +446,7 @@ static int lapbeth_device_event(struct notifier_block *this,
 	if (dev_net(dev) != &init_net)
 		return NOTIFY_DONE;
 
-	if (!dev_is_ethdev(dev))
+	if (!dev_is_ethdev(dev) && !lapbeth_get_x25_dev(dev))
 		return NOTIFY_DONE;
 
 	switch (event) {
-- 
2.35.1



