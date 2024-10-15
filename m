Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AA8F1AF0AC;
	Tue, 15 Oct 2024 13:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997596; cv=none; b=oUQptwGef2RgnkqmCyHgJvr5KL4pBvS5hJ5PBqOp5O74CkVkg0nany9yCKSjcJtZYEBspi5P384EF+aYC2RRomSprtLleK3RmKiVqlJomaC3z5RGYYjERHNtEmPTE6btmR/BL8bttd57yU3YEtE3VeogiAaGLR/O9cT18v7aozM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997596; c=relaxed/simple;
	bh=t6PWYvyoN4LEbp6W/ufQ5or0q96MkHL6Q/TR2PY5kso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XGoRC4Qf8L794jyTWeoavI8Xq+f5K0yBex3ZKUL6x8wNBbNasrpcJG8ZX03dtrlGyydfgHO/f4JyBmPF58NQ9pCD8w7jEuVpwe4fQYM6aTsjWCHXGkeCtIerT5pZu3lhvcWwOoaA7etS1Wu6jnb3jYEYMzusXLha9xO6d9f0l9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wqUgkltK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wqUgkltK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E814BC4CEC6;
	Tue, 15 Oct 2024 13:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997596;
	bh=t6PWYvyoN4LEbp6W/ufQ5or0q96MkHL6Q/TR2PY5kso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wqUgkltK2oPvLuXTbzXKzKSk1zM9YtVgKaEJ+aqpWInFRDjRsFL0IP+P9D1bq5KLc
	 S0UgBPf/h4uhpJlmoliziIMSqzfYyf6szbuswaRnGqv3SbpoyZnjf/f3HibuwexORP
	 LM5l0AkPGws4xa0m57Od7Qilccs5IgC2cCSiSIWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaixin Wang <kxwang23@m.fudan.edu.cn>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 202/518] net: seeq: Fix use after free vulnerability in ether3 Driver Due to Race Condition
Date: Tue, 15 Oct 2024 14:41:46 +0200
Message-ID: <20241015123924.781222433@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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
index 65c98837ec457..3d4a86bf8fd11 100644
--- a/drivers/net/ethernet/seeq/ether3.c
+++ b/drivers/net/ethernet/seeq/ether3.c
@@ -845,9 +845,11 @@ static void ether3_remove(struct expansion_card *ec)
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



