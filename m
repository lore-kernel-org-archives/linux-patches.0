Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78D4C2FA623;
	Tue, 17 Jun 2025 16:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179361; cv=none; b=hnuXASiyaTG2RBjetBLPT6xmBJtmIA72RGyFqfyZ9jlnxE/P338imjIo7HAT7XhzjPQQoYQUepJ5GSzzkz30gsTvsPkJwe+OwOcASxpGHgU//r+gI7sVRip0gtjLFSXG19WgnpQhhZ3LxDIIYAG+r2/PC8IgMv5esZ4EJ+qHWSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179361; c=relaxed/simple;
	bh=iyoqkCi+6D1AvfPa5b4jsXkwg0vSsrlNvhVBr8hj+9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FLX8swPy5Y5EzTm3GfE2kHWg3E5IF/ia+3ftwM2MskUJflo2BmOsB8zF9vEcjLFHp5DZ9YoQJFWv9Mfp3LsXZd80fbGQz5TAoO/Ac4pI6T4gVnC2Rd+I61Tg+GqdQRxI3cYNhikZcmAS01w1l1h84IPdZN/V+l4B/MEDJgrNP44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IcXGIVjI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IcXGIVjI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC7BDC4CEE3;
	Tue, 17 Jun 2025 16:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179361;
	bh=iyoqkCi+6D1AvfPa5b4jsXkwg0vSsrlNvhVBr8hj+9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IcXGIVjI61YXpXW7sG3w1EZEnIsWFeUzU5MZ/DtPh2KdGkXrUxkzsTIjNLttUZ4rP
	 68ZEkanR7CTVHwyJdoJP+iFraDUsqT3BGHPZKXUXeQuUpKgyQqLvUG8ZB6GAXEIzXn
	 FsEEsd5Kav+V8qOhHuHUBE8g9xBXdlAFjK4Ludc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tariq Toukan <tariqt@nvidia.com>,
	Nimrod Oren <noren@nvidia.com>,
	Gal Pressman <gal@nvidia.com>,
	Joe Damato <jdamato@fastly.com>,
	Edward Cree <ecree.xilinx@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 722/780] net: ethtool: Dont check if RSS context exists in case of context 0
Date: Tue, 17 Jun 2025 17:27:10 +0200
Message-ID: <20250617152520.894614154@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gal Pressman <gal@nvidia.com>

[ Upstream commit d78ebc772c7ceccf6e655ddb93099f49a1268af4 ]

Context 0 (default context) always exists, there is no need to check
whether it exists or not when adding a flow steering rule.

The existing check fails when creating a flow steering rule for context
0 as it is not stored in the rss_ctx xarray.

For example:
$ ethtool --config-ntuple eth2 flow-type tcp4 dst-ip 194.237.147.23 dst-port 19983 context 0 loc 618
rmgr: Cannot insert RX class rule: Invalid argument
Cannot insert classification rule

An example usecase for this could be:
- A high-priority rule (loc 0) directing specific port traffic to
  context 0.
- A low-priority rule (loc 1) directing all other TCP traffic to context
  1.

This is a user-visible regression that was caught in our testing
environment, it was not reported by a user yet.

Fixes: de7f7582dff2 ("net: ethtool: prevent flow steering to RSS contexts which don't exist")
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Nimrod Oren <noren@nvidia.com>
Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Joe Damato <jdamato@fastly.com>
Reviewed-by: Edward Cree <ecree.xilinx@gmail.com>
Link: https://patch.msgid.link/20250612071958.1696361-2-gal@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethtool/ioctl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 8262cc10f98db..4b1badeebc741 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -1001,7 +1001,8 @@ static noinline_for_stack int ethtool_set_rxnfc(struct net_device *dev,
 		    ethtool_get_flow_spec_ring(info.fs.ring_cookie))
 			return -EINVAL;
 
-		if (!xa_load(&dev->ethtool->rss_ctx, info.rss_context))
+		if (info.rss_context &&
+		    !xa_load(&dev->ethtool->rss_ctx, info.rss_context))
 			return -EINVAL;
 	}
 
-- 
2.39.5



