Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9FD04322E5;
	Mon, 17 Aug 2026 14:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978747; cv=none; b=Dleegh6mrV+XQqyWT4LGiOS7zY7npR/YALCh9pNvdJySA4NTbo//QHmGwppoYwk4I3jWm0lG9OGE3QScgcJXKr1DGJpRhPgRJFFQpoMYGgvRMg0Jr7T0XDaYRhCTHXLf0on/hJBySzQKCnZGpChudVHQTwvO5TxHRHOSlTvIzLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978747; c=relaxed/simple;
	bh=HeTwlJiClFwCH268f+P5Lz6PNHCXaKZ0ElTP0WJNWXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jo12s7oIcJaCztCCjccZEs3Ufo040GQ3HPWpC4Vk+XvwEHpiCMamEhv9ope7dSBSGaPQr1Vlm4mJts11l2f2p2dUfM5txX0T0Czmb/rZTtnliBvyMldm/vEeCRjVl4dIBMW2ebzUceIp8uIrKXom4GW30O43nJbG5i2sLZW+fts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V43Tz9rB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V43Tz9rB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 508751F000E9;
	Mon, 17 Aug 2026 14:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978745;
	bh=NYmn3ygZoMO9BYQVytGphtapEAFCGOyOdzmu+6oyy0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V43Tz9rBG9vcQ75B60AP3WXmyDC7PzhX12cOlwERB4siZ5qcXMkfesGkBEX/p+M8G
	 0KHvAJ7psow/bYGKjRQiA05WCIY6UvK9lTrOJKCOn5S4HzR8SD0pacvpcCWSx+QFSf
	 h1AKyEZwuYFggc/1Ee5Q+WijJiN4GmHPOalSzlqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuejie Shi <syjcnss@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 143/156] ipv6: fix Route Information option length validation
Date: Mon, 17 Aug 2026 15:34:37 +0200
Message-ID: <20260817132540.316019173@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132534.666299318@linuxfoundation.org>
References: <20260817132534.666299318@linuxfoundation.org>
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
@@ -989,13 +989,13 @@ int rt6_route_rcv(struct net_device *dev
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


