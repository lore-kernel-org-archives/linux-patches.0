Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44EE763B8
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:49:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B8F9C4339C;
	Mon, 20 Feb 2023 13:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676900949;
	bh=EI7HBo5dBwWLO7niIYKiq7q8NIRfjbdy1C1p5xSNPa0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZGV+ZB50p7DSX6nbiru1rBbzi/1juzWwcVguB1TCYbYu1T3KIHx5GxVJfp5YUXv/6
	 fu9ToC4R1FIx1dhBRzluzBEXlqZevZHpqKDK9qUHbEkp+g6MieVXjDwmU++8mrBD8I
	 h03S+1Pp0dUSSXPuU3xWf3qvM9sSc9649y6sqHnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Shaoying Xu <shaoyi@amazon.com>
Subject: [PATCH 5.4 128/156] ipv4: Fix incorrect route flushing when source address is deleted
Date: Mon, 20 Feb 2023 14:36:12 +0100
Message-Id: <20230220133607.935453541@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133602.515342638@linuxfoundation.org>
References: <20230220133602.515342638@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit f96a3d74554df537b6db5c99c27c80e7afadc8d1 ]

Cited commit added the table ID to the FIB info structure, but did not
prevent structures with different table IDs from being consolidated.
This can lead to routes being flushed from a VRF when an address is
deleted from a different VRF.

Fix by taking the table ID into account when looking for a matching FIB
info. This is already done for FIB info structures backed by a nexthop
object in fib_find_info_nh().

Add test cases that fail before the fix:

 # ./fib_tests.sh -t ipv4_del_addr

 IPv4 delete address route tests
     Regular FIB info
     TEST: Route removed from VRF when source address deleted            [ OK ]
     TEST: Route in default VRF not removed                              [ OK ]
     TEST: Route removed in default VRF when source address deleted      [ OK ]
     TEST: Route in VRF is not removed by address delete                 [ OK ]
     Identical FIB info with different table ID
     TEST: Route removed from VRF when source address deleted            [FAIL]
     TEST: Route in default VRF not removed                              [ OK ]
 RTNETLINK answers: File exists
     TEST: Route removed in default VRF when source address deleted      [ OK ]
     TEST: Route in VRF is not removed by address delete                 [FAIL]

 Tests passed:   6
 Tests failed:   2

And pass after:

 # ./fib_tests.sh -t ipv4_del_addr

 IPv4 delete address route tests
     Regular FIB info
     TEST: Route removed from VRF when source address deleted            [ OK ]
     TEST: Route in default VRF not removed                              [ OK ]
     TEST: Route removed in default VRF when source address deleted      [ OK ]
     TEST: Route in VRF is not removed by address delete                 [ OK ]
     Identical FIB info with different table ID
     TEST: Route removed from VRF when source address deleted            [ OK ]
     TEST: Route in default VRF not removed                              [ OK ]
     TEST: Route removed in default VRF when source address deleted      [ OK ]
     TEST: Route in VRF is not removed by address delete                 [ OK ]

 Tests passed:   8
 Tests failed:   0

Fixes: 5a56a0b3a45d ("net: Don't delete routes in different VRFs")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Shaoying Xu <shaoyi@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/fib_semantics.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -421,6 +421,7 @@ static struct fib_info *fib_find_info(st
 		    nfi->fib_prefsrc == fi->fib_prefsrc &&
 		    nfi->fib_priority == fi->fib_priority &&
 		    nfi->fib_type == fi->fib_type &&
+		    nfi->fib_tb_id == fi->fib_tb_id &&
 		    memcmp(nfi->fib_metrics, fi->fib_metrics,
 			   sizeof(u32) * RTAX_MAX) == 0 &&
 		    !((nfi->fib_flags ^ fi->fib_flags) & ~RTNH_COMPARE_MASK) &&


