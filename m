Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2746A3CDBC3;
	Mon, 17 Aug 2026 14:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977783; cv=none; b=eqIuLaGxFhPfcJvdgVDdp8p14azbUgZRGsUwJufm+vg2wtrvdZFhqAyc/v11yOef+ydTUZpbRIwHC3aTu9+yrFIJEh7ZM0JkHflAjv8Kr9u9etpNLUSn9+6ZxF3yL+fP7egmLC9dzIR8nilaUOb2DkLPr19ScKOQoDQLYXqbxQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977783; c=relaxed/simple;
	bh=r0mCPUHNx6bNkhABgWceF2R21ALF98D+kt9XxlAX8K0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d7yCLE5tgxXsitfpudjuGxfiwDeHCaHZCKz0sCoqS2HRhzG/h8YKO3H0dLMpYz9XFVv1333+jfSMypxwNX+Yc97W/b/bWLy6NMTgqyA+cnRFoeoDZJ6QeJdvZfiZlNVAoDWhtkpV/6ux3FYjrWEdc++mlLx/4V0k521rn4NtDqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mm9RzaDO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mm9RzaDO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A0F51F000E9;
	Mon, 17 Aug 2026 14:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977782;
	bh=h1LqZHVWScMrf4gpG9DnCu47VZ2CiH1Dgo+mYhm0CtQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mm9RzaDO67uDtmvIfP/tzNgsIa8Pl/oxCOe652znD7LHewKFq/FiL1f2vadfDbvUe
	 5dceo10+ZscvkZJV1H7MaNVaZV+2Y4mZ5oJXi4JLMTS0MWw3TZmhzT2ZEQIp4NkfL0
	 oerf0e1vPHpYzFKRbATj3UJ83XDKYZq0G4bFDoyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuejie Shi <syjcnss@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 449/456] ipv6: fix Route Information option length validation
Date: Mon, 17 Aug 2026 15:33:59 +0200
Message-ID: <20260817132556.607319341@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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
@@ -947,13 +947,13 @@ int rt6_route_rcv(struct net_device *dev
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


