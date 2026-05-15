Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D311B3FD96C;
	Fri, 15 May 2026 16:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861148; cv=none; b=slMcQCPSm3XDG3SmsYh+3XvdiAXet3H4bKFax/Ph0iMbs0GThA9c1g9LcJusGEw8qas31qC2WWWLF9fpBrba1iM7ZNkDXsnmNAX7CUlU7+3I+Rky273V1eYS1gN0MJv/8YSc+y6+/+VFFdz35cofgufb12kPFaD/jLk0FVUzz6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861148; c=relaxed/simple;
	bh=jQK5vDivhyohLTA4nbLSV5lMYjhN49DCh1PmjEqR8OY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=by18UOauLhjY7c3/rSBuvIdFQPpcKXcKiurrMW16pyZizNqQcRIuNwWwbj029NS+8JLRA65E8IvaELVYywBfdW6fiFPuNrsU78FyCEOzPN7pUW0TnuOLzYQxUa3C7y5okoGhg2ruYO5id//S8DRqmXQk9d9k2q6gYBljezy+CPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lB6hCPeP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lB6hCPeP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A18FC2BCC7;
	Fri, 15 May 2026 16:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861148;
	bh=jQK5vDivhyohLTA4nbLSV5lMYjhN49DCh1PmjEqR8OY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lB6hCPePLDKk2q/SXU6nKpwbu4T3OGDIcZjssXKKG0Alc4msVM7KA59vI63qOZgcQ
	 HIr8G5uhuvFQM4eXZYcroksbiuK7UEG021kVj2BogmRBn5zEBpPZaSASlw7peKjq19
	 mE6USw46urVGTb7teFxPp9npwgz3Ic3C877QxwM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai Zen <kai.aizen.dev@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 218/474] net: rtnetlink: zero ifla_vf_broadcast to avoid stack infoleak in rtnl_fill_vfinfo
Date: Fri, 15 May 2026 17:45:27 +0200
Message-ID: <20260515154719.726526009@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1362,6 +1362,7 @@ static noinline_for_stack int rtnl_fill_
 		port_guid.vf = ivi.vf;
 
 	memcpy(vf_mac.mac, ivi.mac, sizeof(ivi.mac));
+	memset(&vf_broadcast, 0, sizeof(vf_broadcast));
 	memcpy(vf_broadcast.broadcast, dev->broadcast, dev->addr_len);
 	vf_vlan.vlan = ivi.vlan;
 	vf_vlan.qos = ivi.qos;


