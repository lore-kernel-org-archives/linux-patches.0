Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 921A426738C;
	Sat, 30 May 2026 18:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165967; cv=none; b=ZOhyj5lXlL7S4a3sqBzc3QuZU0YLUSRhFBOoVPzNCJLkB1gLbuAECB+oQ376zjWFI28zGIxzXG1HzH7bjcqsg02gjWjT4iN6j6vOnbLI7txIh14fO+RGO0Q7tVseUBo8mGVhoTJXlq2I2nLTJBUj672tj/XkAJ438FNDfp7N3fI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165967; c=relaxed/simple;
	bh=qD3mcvwjiifxyC4aI068AsYijkfCkVp4NmqU7j3GXwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eHsZ1dsFmWu4BNaGOnDBt7nNxTCAP1miOnKVNsHKkEva9/Po3DHTYFngtJRUs1R9fMx13bmunVE3eOX5GY0VKRuOa3zsUTDVBu4WHGUlXDub9VVY0B+uXWTv915VzWuiiEqM4Yy7AkMBhcUDHs5fDlrLdDC0Snu0eQigWIrdo7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zh4SjfZZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zh4SjfZZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A80361F00893;
	Sat, 30 May 2026 18:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165966;
	bh=Oq/Zyzu7XDAnlNsjuHbfxTIMAMIFJ3mSVhKgBoi0WpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zh4SjfZZcK9wO3VrFPQ819ua6H86et8CgdMDejduSxTnCwknaS0Dp40RATwFi3xdC
	 fKoPuQOoHfidMC5zWyrEs9rSHRBzlxVdmZ/HGWP+AK/ohIBex4qhS6H3auoYWzs+dL
	 5PAt1yiWFJq1C0orF0DddJM0JXXlcTyxSQHy4ujc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai Zen <kai.aizen.dev@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 234/589] net: rtnetlink: zero ifla_vf_broadcast to avoid stack infoleak in rtnl_fill_vfinfo
Date: Sat, 30 May 2026 18:01:55 +0200
Message-ID: <20260530160231.137820840@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1287,6 +1287,7 @@ static noinline_for_stack int rtnl_fill_
 		port_guid.vf = ivi.vf;
 
 	memcpy(vf_mac.mac, ivi.mac, sizeof(ivi.mac));
+	memset(&vf_broadcast, 0, sizeof(vf_broadcast));
 	memcpy(vf_broadcast.broadcast, dev->broadcast, dev->addr_len);
 	vf_vlan.vlan = ivi.vlan;
 	vf_vlan.qos = ivi.qos;


