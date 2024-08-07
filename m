Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3AA2374CC;
	Wed,  7 Aug 2024 15:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043032; cv=none; b=oxUknQd9jBKrnehFL+bonQ2KcgeDDRMNaV/lcUneCebm8xIskSAuxRftauGeO66lxgWDSahNpY3g18f+dJvgbP8ctSXtI9lcqTJO0NhGsKPwbVnOuUr0DX3YQdb0M9BjZeA9Iwt+WICLRI0t9vJgiRsJMH0ip5eA+XqKHhIdWTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043032; c=relaxed/simple;
	bh=+pg1wMAWhiVDhbc5IehSKfKwrpbWtezqqGCYGc/N8Oc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z97rxbtOkOltn7dpjLwn5TiD9584Nyv8Ra5epDv3zhU3W2oTF7hf5Yo1G4G8e35VXXw8NTdAywCinIX52kNBg/2fgXPM61tksPwNwe9+eEAMN2F10934S8mF7slZwYrmgy3mQDg5K2yQgMl+i1251ZW8e7V5Ej1p4QaB3tmE64I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GgqSqHMZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GgqSqHMZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47A1CC32781;
	Wed,  7 Aug 2024 15:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043032;
	bh=+pg1wMAWhiVDhbc5IehSKfKwrpbWtezqqGCYGc/N8Oc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GgqSqHMZTS1OT4abc7xgLeWhG0ft3nYixveZ65D75hxEdch/gfhQA3aQFvuZY4Jd3
	 kN51YVw2M3NfxN8WvbV0LxdlpGRXD7SzDFjRF09eIg5S0qhXwD3z7EVxTM618qmERi
	 GJqk+HqQ5wuHBzg/6ujowaMO1CqaqysApxrohyts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 036/123] ethtool: fix setting key and resetting indir at once
Date: Wed,  7 Aug 2024 16:59:15 +0200
Message-ID: <20240807150021.998214044@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
References: <20240807150020.790615758@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 7195f0ef7f5b8c678cf28de7c9b619cb908b482c ]

The indirection table and the key follow struct ethtool_rxfh
in user memory.

To reset the indirection table user space calls SET_RXFH with
table of size 0 (OTOH to say "no change" it should use -1 / ~0).
The logic for calculating the offset where they key sits is
incorrect in this case, as kernel would still offset by the full
table length, while for the reset there is no indir table and
key is immediately after the struct.

  $ ethtool -X eth0 default hkey 01:02:03...
  $ ethtool -x eth0
  [...]
  RSS hash key:
00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00
  [...]

Fixes: 3de0b592394d ("ethtool: Support for configurable RSS hash key")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethtool/ioctl.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 223dcd25d88a2..fcc3dbef8b503 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -1277,11 +1277,11 @@ static noinline_for_stack int ethtool_set_rxfh(struct net_device *dev,
 	u32 rss_cfg_offset = offsetof(struct ethtool_rxfh, rss_config[0]);
 	const struct ethtool_ops *ops = dev->ethtool_ops;
 	u32 dev_indir_size = 0, dev_key_size = 0, i;
+	u32 user_indir_len = 0, indir_bytes = 0;
 	struct ethtool_rxfh_param rxfh_dev = {};
 	struct netlink_ext_ack *extack = NULL;
 	struct ethtool_rxnfc rx_rings;
 	struct ethtool_rxfh rxfh;
-	u32 indir_bytes = 0;
 	u8 *rss_config;
 	int ret;
 
@@ -1342,6 +1342,7 @@ static noinline_for_stack int ethtool_set_rxfh(struct net_device *dev,
 	 */
 	if (rxfh.indir_size &&
 	    rxfh.indir_size != ETH_RXFH_INDIR_NO_CHANGE) {
+		user_indir_len = indir_bytes;
 		rxfh_dev.indir = (u32 *)rss_config;
 		rxfh_dev.indir_size = dev_indir_size;
 		ret = ethtool_copy_validate_indir(rxfh_dev.indir,
@@ -1368,7 +1369,7 @@ static noinline_for_stack int ethtool_set_rxfh(struct net_device *dev,
 		rxfh_dev.key_size = dev_key_size;
 		rxfh_dev.key = rss_config + indir_bytes;
 		if (copy_from_user(rxfh_dev.key,
-				   useraddr + rss_cfg_offset + indir_bytes,
+				   useraddr + rss_cfg_offset + user_indir_len,
 				   rxfh.key_size)) {
 			ret = -EFAULT;
 			goto out;
-- 
2.43.0



