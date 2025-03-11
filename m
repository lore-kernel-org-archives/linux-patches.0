Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DEDE1CAA8F;
	Tue, 11 Mar 2025 15:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707248; cv=none; b=YFvYIed4JzT3d+DrS6pjjl/l3mjtNHJChRSRQgyyYUTWZK2tdS90cX05wV+A0dU6/8K3sPXIt2SysMZRgEQGjxOYzdho5+F+hkE+dp3jC/0U2tQk7odxie3TLGbzA5/qwLlc15v/F19/tfse1r2XqMJA4I4GRAj+H65BTDuZTZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707248; c=relaxed/simple;
	bh=oo8ovOnCNqg+/HJRr7OX0xSP9AislwR1r4U9Q6wT+9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rlI243JY9jQSn2cwUSGz02te5MCwkQaAyAdkoOKtD6kl6pA+RL7877YdHrWouoWnEdtuuRb0elIWM9cVG5/18+s+7TO+oeCZZvcsCHtDg8LGXGCEpHhtIoRmMpTeOOOJi8ID8kX/0xxIoLhWq1rVg05zKEfs2YLBBMru3ZagoHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aUZtUOsZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aUZtUOsZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 147D0C4CEE9;
	Tue, 11 Mar 2025 15:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707248;
	bh=oo8ovOnCNqg+/HJRr7OX0xSP9AislwR1r4U9Q6wT+9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aUZtUOsZJz2LRLp50/XHWELDCdSo9F3gO7VzuLqJU7+m4e64yNQStowJ64hIRf+3y
	 tSVbztS99khzR9VT9LhxwsbaiuXkHE1clwb4OfoglHPLSihu5DSBZXkPJaXlSox43E
	 qw/WbQuo4b0x+PiHrZwFtI8zP/DHPb+7YYvTv2u8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>,
	Simon Wunderlich <sw@simonwunderlich.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 325/462] batman-adv: Drop initialization of flexible ethtool_link_ksettings
Date: Tue, 11 Mar 2025 15:59:51 +0100
Message-ID: <20250311145811.203584942@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

[ Upstream commit 813e62a6fe7539fdf0d8e018d4f157b57bdaeedd ]

The commit 94dfc73e7cf4 ("treewide: uapi: Replace zero-length arrays with
flexible-array members") changed various structures from using 0-length
arrays to flexible arrays

  net/batman-adv/bat_v_elp.c: note: in included file:
  ./include/linux/ethtool.h:148:38: warning: nested flexible array
  net/batman-adv/bat_v_elp.c:128:9: warning: using sizeof on a flexible structure

In theory, this could be worked around by using {} as initializer for the
variable on the stack. But this variable doesn't has to be initialized at
all by the caller of __ethtool_get_link_ksettings - everything will be
initialized by the callee when no error occurs.

Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Stable-dep-of: 8c8ecc98f5c6 ("batman-adv: Drop unmanaged ELP metric worker")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/bat_v_elp.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/batman-adv/bat_v_elp.c b/net/batman-adv/bat_v_elp.c
index fb76b8861f098..81b9dfec7151a 100644
--- a/net/batman-adv/bat_v_elp.c
+++ b/net/batman-adv/bat_v_elp.c
@@ -141,7 +141,6 @@ static bool batadv_v_elp_get_throughput(struct batadv_hardif_neigh_node *neigh,
 	/* if not a wifi interface, check if this device provides data via
 	 * ethtool (e.g. an Ethernet adapter)
 	 */
-	memset(&link_settings, 0, sizeof(link_settings));
 	rtnl_lock();
 	ret = __ethtool_get_link_ksettings(hard_iface->net_dev, &link_settings);
 	rtnl_unlock();
-- 
2.39.5



