Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EE8223F40D;
	Mon, 17 Aug 2026 13:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974645; cv=none; b=cSt2U+yPfzV1y/oVXahLxWWroZYGu0QGJit57hT13S3Q9uy8PrbVGLxfpmD8hJ2d1LvZ7TEKbSy+SyQXbkYoXEGNIGKsA/9xHAzsPXgrNDUjghPBdzabHDXHS7BYYaHhOt+CqOJC5KLFrokn/8QDB8HeqyIgO9ehCdHFYVU4rB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974645; c=relaxed/simple;
	bh=ni8a84DcC7S7z8wzVRnaQO2BMkgHoUcPRY3t7Fvedb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gyO5wyFrvuUP9t91Uvr1V/Aus+221OdQZJx9PYibEyZOLpT8ysKnRa3DKx0GVdG8jE1MABAn9HHYZ89AxQ4gfmtnCO1BZ5fNSnm4bZ76gqkr4tcrqoKRi0FrMskCP6VF6TIbpspj/g+61lkS8Q+PsUlsDMiQkauYeimTW+IfMwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OA44TU32; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OA44TU32"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA2971F00A3A;
	Mon, 17 Aug 2026 13:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974640;
	bh=7UTe2Smk84fywREzca9QycrcdL9VcbtfwFUFJoEbSDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OA44TU32t77iLc2WthzohNh8hz8bh85TSMSb7tHTr0MxcbgQ4yReuKvFw6m2DlEe7
	 iTsCuV6DdXXStawmyh7/XUM/2XE3obUPtlOEAtfjLxn842oo0IEZijSW2yLALYFZiV
	 rnVclVvGgeQwe1KEqPc31BbWzx+HodCXnvnwPnXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuejie Shi <syjcnss@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 254/271] ipv6: fix Route Information option length validation
Date: Mon, 17 Aug 2026 15:32:59 +0200
Message-ID: <20260817132547.201961041@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -987,13 +987,13 @@ int rt6_route_rcv(struct net_device *dev
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


