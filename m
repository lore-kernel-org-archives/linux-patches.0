Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C09A46EF89;
	Wed, 30 Sep 2026 19:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790797099; cv=none; b=rZfhIysdh2VE+S87zFEaIDqa/RawfRKdFXNGZ9uTvf3HZQgHJhI2v/hgYO9YMDUg6XcOd0a/7PBZ57JM3+phVDtbI26e7GktapFXY3BW7gXQpGwhNXSMks6hfM7d/EaMe92lVMpo4fUaMKiYS5i6IT9D/5yg7L2XY8SMZ6rlnX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790797099; c=relaxed/simple;
	bh=cBiOXupOXbOfHvcSdGeB79waNZAx/3urCjex5fm8Wqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Syn1NTtE+Aa5B6nuke7HbUU7t6KFLQ5D57Z824njMDzBxwzvW4+QMS92D+90eAtwET2u5C1QwwuEC3PTWtnw66h1FqhoW1C+3La8kyqe3ORPMn+Hj+xXQMuw0KY9TD9E0N43S735RU91UBKAtLyXwN5Ox8aIJ98gCbBHAytsYUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MgiKG9N4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MgiKG9N4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B00D11F000FF;
	Wed, 30 Sep 2026 19:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790797097;
	bh=MFyUUp4WhaVEH7A6Byau1/AcmSMlBlahKbdctXolU7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MgiKG9N48npp0A8tY108MXMWvwrAbwBcScwVe7pWo4bc5Gy10WMOIum+zmgtpudJL
	 Q0Bjw0pJLU2yM/PCK5T9iQuRoPDfdiKA3+CvgEuxpg9xDJFcM+XlwXEnfqZ8idxiUw
	 0ZpBnDWkWRRMP7bcVuxZFrW4PPfBxv9FtpCrZTmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Maximets <i.maximets@ovn.org>,
	Eric Dumazet <edumazet@google.com>,
	Norbert Szetei <norbert@doyensec.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 1101/1193] ipv6: do not let ipv6_find_hdr() return an offset past the packet end
Date: Wed, 30 Sep 2026 17:29:45 +0200
Message-ID: <20260930152458.693652585@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Norbert Szetei <norbert@doyensec.com>

commit ee319bd3a0e976af5087cbe59ebc50a66f31d202 upstream.

ipv6_find_hdr() walks the extension header chain, skipping each header by
the length that header itself declares.  ipv6_optlen() returns up to 2048,
and the skip is never checked against skb->len, so the offset stored in
*offset can point past the end of the packet.

openvswitch installs that offset as the transport header, and
update_ipv6_checksum() then reads and writes the transport checksum field
out of bounds:

  BUG: KASAN: slab-use-after-free in inet_proto_csum_replace16+0x445/0x470
  Read of size 2 at addr ffff88810b754b06 by task ovs_ipv6_oob/629
  CPU: 4 UID: 1000 PID: 629 Comm: ovs_ipv6_oob Tainted: G N 7.3.0-rc3+ #348
  Call Trace:
   inet_proto_csum_replace16+0x445/0x470
   set_ipv6_addr+0x3dd/0x460
   do_execute_actions+0x6a3d/0x7c40
   ovs_execute_actions+0xfd/0x480
   ovs_packet_cmd_execute+0xc38/0xf20
   genl_rcv_msg+0x59e/0x870
   netlink_rcv_skb+0x18b/0x450
   genl_rcv+0x2d/0x40
   netlink_unicast+0x6bc/0xa20

  The buggy address belongs to the object at ffff88810b754980
   which belongs to the cache skbuff_small_head of size 704
  The buggy address is located 390 bytes inside of
   freed 704-byte region [ffff88810b754980, ffff88810b754c40)

Other callers use that offset too, so bound it here rather than in one
caller.

Reject a header whose declared length does not fit in the packet.
ipv6_find_hdr() already fails with -EBADMSG on a malformed chain, so this
adds no new failure mode.

Fixes: f8f626754ebe ("ipv6: Move ipv6_find_hdr() out of Netfilter code.")
Suggested-by: Ilya Maximets <i.maximets@ovn.org>
Suggested-by: Eric Dumazet <edumazet@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Norbert Szetei <norbert@doyensec.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Ilya Maximets <i.maximets@ovn.org>
Link: https://patch.msgid.link/8F80BA1A-DDFD-432D-9075-242A3435FEB5@doyensec.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/exthdrs_core.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/ipv6/exthdrs_core.c
+++ b/net/ipv6/exthdrs_core.c
@@ -271,6 +271,9 @@ int ipv6_find_hdr(const struct sk_buff *
 			hdrlen = ipv6_optlen(hp);
 
 		if (!found) {
+			if (skb->len - start < hdrlen)
+				return -EBADMSG;
+
 			nexthdr = hp->nexthdr;
 			start += hdrlen;
 		}


