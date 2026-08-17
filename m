Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B0AC3D5C07;
	Mon, 17 Aug 2026 15:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980508; cv=none; b=bvY1MNfIhZV9ndnVfBPp2Yasl7wQIY9YNfnC3sephOK7YIGvrqvQwPaZmqOI9LuhI5XMGWXLGBGjMxpbFuVOeBsAx1IGtqrsuQaScOM/W49YTJMoG7mvDUmDNZhdTA5KWHQEOU/NkSSZ4JvwRphfAVNFNfaZYg1gvGOK+13js0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980508; c=relaxed/simple;
	bh=mrfTLBWa+xnIYCIo8e6RCTZBqD1zw73beBHURgseqzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nomfDH2TNP9x8LEhr74nv2Ez3p55QjRHQAcTqwz1zYI+bXZwu+lWfZvKkdzUCivKb84fKNpTHjlqxMJ8PzvYqWquIF9ErcyeFjArhmJ2CTIGwN+NZBZH5DegfVE19uQZB7P5s9Y1wkjZjzbYuwkL4NJQJQU4hs2GRztWZq3LN7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0GZIOzQD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0GZIOzQD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEFF11F000E9;
	Mon, 17 Aug 2026 15:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980507;
	bh=tJOneoLjNcc8QI9+jII9bI1oVCCAInRgd0jYdGx3X0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0GZIOzQDclv6QB9LQy09DJ4Kf5GJjshIXLsOt3y8qezbyntJ3t9QRxyFGPxjZbtkf
	 +HgDDjDrEz3ggEpdRdTz19lwIYox25JMgXnMud8eyu9hCPaubEFs/bxnDZ+oUZ1TCl
	 1AALNOVXdpLgagLkYVANF5xMEERbEZkFB1pr+MOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuejie Shi <syjcnss@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 597/609] ipv6: fix Route Information option length validation
Date: Mon, 17 Aug 2026 15:34:53 +0200
Message-ID: <20260817132603.620367250@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuejie Shi <syjcnss@gmail.com>

commit d1ad8fb2ac6a1afb71dc22d9ae8efb4dda96c824 upstream.

rt6_route_rcv() validates the Route Information option (RFC 4191) length
against the prefix length, but both checks are off by one.

rinfo->length is the ND option length in units of 8 octets and it
*includes* the 8-byte option header, so an option carrying N bytes of
prefix has length == 1 + N/8.  RFC 4191 section 2.3 requires length 3
when Prefix Length is greater than 64, and 2 or 3 when it is greater
than 0.  The code accepts length >= 2 and length >= 1 respectively.

ipv6_addr_prefix() then copies prefix_len/8 bytes out of rinfo->prefix,
so a Router Advertisement with (prefix_len=128, length=2) or
(prefix_len=64, length=1) makes the kernel read up to 8 bytes past the
end of the option.  Those bytes end up in the prefix of the route that
gets installed, so they are visible to userspace:

  # RA with a Route Information option (prefix_len=128, length=2)
  # followed by a source link-layer address option, 01 01 de ad be ef ca fe
  $ ip -6 route show
  2001:db8:dead:beef:101:dead:beef:cafe via fe80::1234 dev veth0 proto ra
                     ^^^^^^^^^^^^^^^^^^ the next option, read out of bounds

When the Route Information option is the last one in the packet, those
eight bytes come from the skb tail room instead.

Reject the option lengths RFC 4191 does not allow.

Fixes: 70ceb4f53929 ("[IPV6]: ROUTE: Add experimental support for Route Information Option in RA (RFC4191).")
Cc: stable@vger.kernel.org
Signed-off-by: Yuejie Shi <syjcnss@gmail.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260730035310.74584-1-syjcnss@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/route.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -990,13 +990,13 @@ int rt6_route_rcv(struct net_device *dev
 	} else if (rinfo->prefix_len > 128) {
 		return -EINVAL;
 	} else if (rinfo->prefix_len > 64) {
-		if (rinfo->length < 2) {
+		/* RFC 4191: Length MUST be 3 when Prefix Length > 64 */
+		if (rinfo->length < 3)
 			return -EINVAL;
-		}
 	} else if (rinfo->prefix_len > 0) {
-		if (rinfo->length < 1) {
+		/* RFC 4191: Length MUST be 2 or 3 when Prefix Length > 0 */
+		if (rinfo->length < 2)
 			return -EINVAL;
-		}
 	}
 
 	pref = rinfo->route_pref;


