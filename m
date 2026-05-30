Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCB33320CAD;
	Sat, 30 May 2026 17:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163606; cv=none; b=tFbJqxNWZg0esZcEDhvjLkHeTUiftAz9mVxNeDDqRMlCe5naMLUx6lR7KvfXnv4ZdEBSL5IMvs2wsStZ/b9lA//G8dgf6ebgzFJ68rAAp8GVyF0IqLebncAFswECBYbo0GY8rHMzFgf+QjbkeKiJmKWmgt9H9Ad22iO5bv71YqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163606; c=relaxed/simple;
	bh=LOB5TplWHFUBFzgcHx3yN8EBbQIJ8q45TVCAkWZIH6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CyojaK+TV5umhuphI9iKYcLp3POKtxvemXi9vj525u/MP5g2fi7Dnq2FiId4Q01YWv1+9oY0+1w5y8/uMZ8cgbQ3On8h/wmpdKeCILlcle+CxEutkFayrVKg7bUqdHTUIxx0pZcu2JfwANwGXMVhf0DGG3t7wx82CDRlxlCBM38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z+ItWhCO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z+ItWhCO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E8CE1F00893;
	Sat, 30 May 2026 17:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163605;
	bh=E98nFmX7fzG02Wn5PszC4mcBl/cBCbiCDwrLUPttlMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z+ItWhCOHQHuZN1DVQTtlS6QpzHgR8/venDVl4b5DE8x7mLdMzr1uHHJNp5oSSq3i
	 57XuaM4DMQnmgR2hE4jPvHNV7QuBWJC4X+Y7dXrGcibmQ9bgXl74w2wFF91TIqRENj
	 VEpupa1jIifhBk4r8XVPGGTPGqgq9xiMOd6+aFlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai Zen <kai.aizen.dev@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 309/776] net: rtnetlink: zero ifla_vf_broadcast to avoid stack infoleak in rtnl_fill_vfinfo
Date: Sat, 30 May 2026 18:00:23 +0200
Message-ID: <20260530160248.552465153@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kai Zen <kai.aizen.dev@gmail.com>

commit 4b9e327991815e128ad3af75c3a04630a63ce3e0 upstream.

rtnl_fill_vfinfo() declares struct ifla_vf_broadcast on the stack
without initialisation:

	struct ifla_vf_broadcast vf_broadcast;

The struct contains a single fixed 32-byte field:

	/* include/uapi/linux/if_link.h */
	struct ifla_vf_broadcast {
		__u8 broadcast[32];
	};

The function then copies dev->broadcast into it using dev->addr_len
as the length:

	memcpy(vf_broadcast.broadcast, dev->broadcast, dev->addr_len);

On Ethernet devices (the overwhelming majority of SR-IOV NICs)
dev->addr_len is 6, so only the first 6 bytes of broadcast[] are
written. The remaining 26 bytes retain whatever was previously on
the kernel stack. The full struct is then handed to userspace via:

	nla_put(skb, IFLA_VF_BROADCAST,
		sizeof(vf_broadcast), &vf_broadcast)

leaking up to 26 bytes of uninitialised kernel stack per VF per
RTM_GETLINK request, repeatable.

The other vf_* structs in the same function are explicitly zeroed
for exactly this reason - see the memset() calls for ivi,
vf_vlan_info, node_guid and port_guid a few lines above.
vf_broadcast was simply missed when it was added.

Reachability: any unprivileged local process can open AF_NETLINK /
NETLINK_ROUTE without capabilities and send RTM_GETLINK with an
IFLA_EXT_MASK attribute carrying RTEXT_FILTER_VF. The kernel walks
each VF and emits IFLA_VF_BROADCAST, leaking 26 bytes of stack per
VF per request. Stack residue at this call site can include return
addresses and transient sensitive data; KASAN with stack
instrumentation, or KMSAN, will flag the nla_put() when reproduced.

Zero the on-stack struct before the partial memcpy, matching the
existing pattern used for the other vf_* structs in the same
function.

Fixes: 75345f888f70 ("ipoib: show VF broadcast address")
Cc: stable@vger.kernel.org
Signed-off-by: Kai Zen <kai.aizen.dev@gmail.com>
Link: https://patch.msgid.link/3c506e8f936e52b57620269b55c348af05d413a2.1777557228.git.kai.aizen.dev@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/rtnetlink.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1309,6 +1309,7 @@ static noinline_for_stack int rtnl_fill_
 		port_guid.vf = ivi.vf;
 
 	memcpy(vf_mac.mac, ivi.mac, sizeof(ivi.mac));
+	memset(&vf_broadcast, 0, sizeof(vf_broadcast));
 	memcpy(vf_broadcast.broadcast, dev->broadcast, dev->addr_len);
 	vf_vlan.vlan = ivi.vlan;
 	vf_vlan.qos = ivi.qos;


