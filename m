Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBC282571B2;
	Thu, 17 Apr 2025 17:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912441; cv=none; b=Ljp3Q1v31Y2Qcq+nLutaRG1Vl7u6UUVAw6EkevWLDInCNT1CkFdYATUiKZ91V9/WUIrH19H7B9duzjTZcGcAgHlfQ0NUDs63U2pcEZkP9a4uGdsrtxUeqLZvKSJkrZX9BZXXDNz/unHhPcfWnjLQuWq3++EB/yvTA38xNV5Yi+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912441; c=relaxed/simple;
	bh=5qaFXxA5hPXhINfLjGdvS7G+eEorKeaaigOxcSqF/xw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n1Zwym5FHhckFP/8GmlSCMD/wv706H8g972jj9zQlHcZihiA5qpkdd+IRd4s2Jeunsr3FcRWyOB/J+cdmGdslOrcbvooPlQ666Ihdrmgt7x+I8M0XaSPRSQy4C6wKnvJJ3KQYypy/BaJ0DguiHaQKB9nSw1OXHTOo25y1NcT+nE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W5N54Skg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W5N54Skg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6C2EC4CEE7;
	Thu, 17 Apr 2025 17:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912440;
	bh=5qaFXxA5hPXhINfLjGdvS7G+eEorKeaaigOxcSqF/xw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W5N54SkgdKgBA2b68TuYn6Lbzxhh3h6QpycYu+su5mzQ792UMABZ2CK81MBlP6Jvu
	 mg2l7aAvb2QlOQHFM+C+VvWilEUPCtyuNc/pyEbLZW1t/n3gkv3SdOZUaNrw1LF6SF
	 ZWXZ3S9sPeh/ii5rjnpm3kNpN1B5JuVB0dDSiyJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taehee Yoo <ap420073@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 012/449] net: ethtool: fix ethtool_ringparam_get_cfg() returns a hds_thresh value always as 0.
Date: Thu, 17 Apr 2025 19:45:00 +0200
Message-ID: <20250417175118.484693093@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit 216a61d33c0728a8cf1650aaed2c523c6ce16354 ]

When hds-thresh is configured, ethnl_set_rings() is called, and it calls
ethtool_ringparam_get_cfg() to get ringparameters from .get_ringparam()
callback and dev->cfg.
Both hds_config and hds_thresh values should be set from dev->cfg, not
from .get_ringparam().
But ethtool_ringparam_get_cfg() sets only hds_config from dev->cfg.
So, ethtool_ringparam_get_cfg() returns always a hds_thresh as 0.

If an input value of hds-thresh is 0, a hds_thresh value from
ethtool_ringparam_get_cfg() are same. So ethnl_set_rings() does
nothing and returns immediately.
It causes a bug that setting a hds-thresh value to 0 is not working.

Reproducer:
    modprobe netdevsim
    echo 1 > /sys/bus/netdevsim/new_device
    ethtool -G eth0 hds-thresh 100
    ethtool -G eth0 hds-thresh 0
    ethtool -g eth0
    #hds-thresh value should be 0, but it shows 100.

The tools/testing/selftests/drivers/net/hds.py can test it too with
applying a following patch for hds.py.

Fixes: 928459bbda19 ("net: ethtool: populate the default HDS params in the core")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Link: https://patch.msgid.link/20250404122126.1555648-2-ap420073@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethtool/common.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index b97374b508f67..e2f8a41cc1084 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -785,6 +785,7 @@ void ethtool_ringparam_get_cfg(struct net_device *dev,
 
 	/* Driver gives us current state, we want to return current config */
 	kparam->tcp_data_split = dev->cfg->hds_config;
+	kparam->hds_thresh = dev->cfg->hds_thresh;
 }
 
 static void ethtool_init_tsinfo(struct kernel_ethtool_ts_info *info)
-- 
2.39.5



