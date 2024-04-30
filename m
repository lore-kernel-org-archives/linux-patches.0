Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F95012C48F;
	Tue, 30 Apr 2024 10:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474069; cv=none; b=PlD18KApL8S9LkGnoGOGgmCRZK7PPy3+Y0iGEOS6xC0MVDfb25YVhJpr+D0ycwiOoGJcgW64G2WSWH8vgJmjWzMUDy6lBkqYOmBAV768PLcuKjLGNTHaX48Giw/67rAL8qaLm7gf768z9p/FVwVGc6bZRuMWQj/mcRqDu6rCG34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474069; c=relaxed/simple;
	bh=tnQMgKns3N4CUpWOOvOnbj373vsoAk6ymvBUp3t41wU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rUNPDy8E0J3eXKwg8G8MuMWmL+BBrjlgeFS9mUZKoBhkfc0ebXJSBh95DyD5kApdsBkH53KpqNhWoujBGJlqnwh7IGOOQj6+SJHRPLKMTK/3pa0PSDfiFsAcyrLFRQWwRdllwOOEyy5lu4p1qalN0rf+wNXbLlVAP+1R0oiAK04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eu5U9bpl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eu5U9bpl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E65DBC4AF14;
	Tue, 30 Apr 2024 10:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474069;
	bh=tnQMgKns3N4CUpWOOvOnbj373vsoAk6ymvBUp3t41wU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eu5U9bplolxMgDvpbt+ryUeXQGZM7vG0Bql82++QrmTfebp4JjM07U2omRl1+EVON
	 huor0HdZuCrwX4sFV3nQIy5YtO166CXMBJNOIQAnQqlSkosQwHGUXIF1eiz3ddFC5u
	 TkWVdlVhg0vlNE5Roi0KYnvajfFFlUb706zyOrzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	David Bauer <mail@david-bauer.net>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 049/228] vxlan: drop packets from invalid src-address
Date: Tue, 30 Apr 2024 12:37:07 +0200
Message-ID: <20240430103105.227871842@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Bauer <mail@david-bauer.net>

[ Upstream commit f58f45c1e5b92975e91754f5407250085a6ae7cf ]

The VXLAN driver currently does not check if the inner layer2
source-address is valid.

In case source-address snooping/learning is enabled, a entry in the FDB
for the invalid address is created with the layer3 address of the tunnel
endpoint.

If the frame happens to have a non-unicast address set, all this
non-unicast traffic is subsequently not flooded to the tunnel network
but sent to the learnt host in the FDB. To make matters worse, this FDB
entry does not expire.

Apply the same filtering for packets as it is done for bridges. This not
only drops these invalid packets but avoids them from being learnt into
the FDB.

Fixes: d342894c5d2f ("vxlan: virtual extensible lan")
Suggested-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: David Bauer <mail@david-bauer.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vxlan/vxlan_core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index 0bedb804824ba..9ec46048d361d 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -1615,6 +1615,10 @@ static bool vxlan_set_mac(struct vxlan_dev *vxlan,
 	if (ether_addr_equal(eth_hdr(skb)->h_source, vxlan->dev->dev_addr))
 		return false;
 
+	/* Ignore packets from invalid src-address */
+	if (!is_valid_ether_addr(eth_hdr(skb)->h_source))
+		return false;
+
 	/* Get address from the outer IP header */
 	if (vxlan_get_sk_family(vs) == AF_INET) {
 		saddr.sin.sin_addr.s_addr = ip_hdr(skb)->saddr;
-- 
2.43.0



