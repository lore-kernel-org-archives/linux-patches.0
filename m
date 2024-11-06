Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C5411DFE06;
	Wed,  6 Nov 2024 13:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898130; cv=none; b=kRkL/b1Bvm7wITubvi5AoZn6lF0OzEs1sf5H4QpKQfxfZzzWnfS5M4aZ1t/r3s22VjT5I5R8qeIfM4ModyMbEH7tT5S6SwMhyvfELgq35/qbAHBJp5wofpVNcUy4Bqr8mADT6W18W8OOFeFfypRedY703ZxkN4cuEgEnAXmnz+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898130; c=relaxed/simple;
	bh=VLY0j4BmGStW08WvOB+IiXBAq95mpTDkIBb1HjWBVSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AzalaqbnMr7nmAHdzJC9+iVUgUkf4QQObgc+K/7O864F+M5mOUCTtkRGxbNsGS5Ru60CpIOW2CUz2t/tEqx/lLpQfEkveQnFIoevDOFO4Tz9oDAk2uKbWvHJP/RvLbvGsqOeaVBlk9VeYwIvofk+IUKFUfX2ilPoeTNQ0ZGhG3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XJgadkPM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XJgadkPM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15803C4CECD;
	Wed,  6 Nov 2024 13:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898130;
	bh=VLY0j4BmGStW08WvOB+IiXBAq95mpTDkIBb1HjWBVSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XJgadkPMKvXvT9ijtxBKu3MkhcuvtI0dvf4ssWGmjsIq95d8CwVE/fEPLI6AFl3Ua
	 l7DSo6brNmtN8ZQ0EmVweRRkRJgU+dGUjoKdWjPxypMplriWO5UeXmUDkw34ITbJLO
	 TqNP1TI5brD5Yh0vyg7LRuVp9LGYep1qkETSbCi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaixin Wang <kxwang23@m.fudan.edu.cn>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 134/462] net: seeq: Fix use after free vulnerability in ether3 Driver Due to Race Condition
Date: Wed,  6 Nov 2024 13:00:27 +0100
Message-ID: <20241106120334.816684891@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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
index 632a7c85964df..b057a38d3217a 100644
--- a/drivers/net/ethernet/seeq/ether3.c
+++ b/drivers/net/ethernet/seeq/ether3.c
@@ -848,9 +848,11 @@ static void ether3_remove(struct expansion_card *ec)
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



