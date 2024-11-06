Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C8CD1D5AD7;
	Wed,  6 Nov 2024 12:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895086; cv=none; b=PWoy6Q+WAHSwDHVqNNHzDWZcoX00wbYEm9fTga700FWjAip9r9/eprHeqd3/XC/AMGOF7x0FNlAvnrJMIe9yH8Qs75ptKK6sCaEHh09YfB5VObIbp8lU15jGa3PyIExy/po8ndrUU+Oz7fsSwyjiEgl0sI59X8t/7gBO+NEuvSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895086; c=relaxed/simple;
	bh=qKs2ARXj3w8tviK1EOjnBTbZ1DGvIiAKDZpXCu4IOMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WdN01Sa5TUsvYybl+gYndAkvNQRAVoEVAKyY0iEm5kqXnfo09jLhivq61cmzVVi1NNmvUWM7A6YBk1WskYlnH0S/XHJTFwH2Ih9Ss+wJOOYBy80MQy9uPSMorvhpq7k867g+ocPiEfpM4h38kIIu8e64fOAidYmBDRHxfJHr+mU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DsoOQ38y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DsoOQ38y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D84D8C4CECD;
	Wed,  6 Nov 2024 12:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895086;
	bh=qKs2ARXj3w8tviK1EOjnBTbZ1DGvIiAKDZpXCu4IOMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DsoOQ38ynBMdw/OmnjhauPRFBjJFh4aJ9/xYY6VssOzpgByx0L22Z9AsFV7weyeZQ
	 T0LEmT2TbGJ9EDNanpjxBhMUP6SDQVo79H5LfKVfeBXk4f3/ESJfH7lE1zjNC/bHJV
	 EqIpAZlhx+QE6Wiuw2RHJPYn5xKaS5NVoeK6qxbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaixin Wang <kxwang23@m.fudan.edu.cn>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 101/350] net: seeq: Fix use after free vulnerability in ether3 Driver Due to Race Condition
Date: Wed,  6 Nov 2024 13:00:29 +0100
Message-ID: <20241106120323.397790288@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kaixin Wang <kxwang23@m.fudan.edu.cn>

[ Upstream commit b5109b60ee4fcb2f2bb24f589575e10cc5283ad4 ]

In the ether3_probe function, a timer is initialized with a callback
function ether3_ledoff, bound to &prev(dev)->timer. Once the timer is
started, there is a risk of a race condition if the module or device
is removed, triggering the ether3_remove function to perform cleanup.
The sequence of operations that may lead to a UAF bug is as follows:

CPU0                                    CPU1

                      |  ether3_ledoff
ether3_remove         |
  free_netdev(dev);   |
  put_devic           |
  kfree(dev);         |
 |  ether3_outw(priv(dev)->regs.config2 |= CFG2_CTRLO, REG_CONFIG2);
                      | // use dev

Fix it by ensuring that the timer is canceled before proceeding with
the cleanup in ether3_remove.

Fixes: 6fd9c53f7186 ("net: seeq: Convert timers to use timer_setup()")
Signed-off-by: Kaixin Wang <kxwang23@m.fudan.edu.cn>
Link: https://patch.msgid.link/20240915144045.451-1-kxwang23@m.fudan.edu.cn
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/seeq/ether3.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/seeq/ether3.c b/drivers/net/ethernet/seeq/ether3.c
index d1bb73bf99148..a612ca6418883 100644
--- a/drivers/net/ethernet/seeq/ether3.c
+++ b/drivers/net/ethernet/seeq/ether3.c
@@ -851,9 +851,11 @@ static void ether3_remove(struct expansion_card *ec)
 {
 	struct net_device *dev = ecard_get_drvdata(ec);
 
+	ether3_outw(priv(dev)->regs.config2 |= CFG2_CTRLO, REG_CONFIG2);
 	ecard_set_drvdata(ec, NULL);
 
 	unregister_netdev(dev);
+	del_timer_sync(&priv(dev)->timer);
 	free_netdev(dev);
 	ecard_release_resources(ec);
 }
-- 
2.43.0



