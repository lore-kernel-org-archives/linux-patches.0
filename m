Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB3A36ABD
	for <patches@lists.linux.dev>; Fri, 17 Feb 2023 14:25:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38801C433D2;
	Fri, 17 Feb 2023 14:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676643907;
	bh=qLOJNEeIv+d0UYCKuZi5cZMHL9DagN8/xOVg0jn7zyk=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=a1d2R6dub6LctI13yYmAabyuLvOpZoQ5+l5Z2hWonz8vKYVIvt1LRyVwUMN6TGROD
	 7+XZNMYTC+6Wt0MrpORk7MnsuvfOvPNB0vZRkrnyGZANlGnqr3FuRhj3ZVaZOmdOnu
	 LTiexvf0t/0tMelfxss/08fRpZuMJPaVgMzkvT0M=
Subject: Patch "ipv4: Fix incorrect route flushing when source address is deleted" has been added to the 5.4-stable tree
To: dsahern@kernel.org,gregkh@linuxfoundation.org,idosch@nvidia.com,kuba@kernel.org,patches@lists.linux.dev,sashal@kernel.org,shaoyi@amazon.com
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Fri, 17 Feb 2023 15:25:05 +0100
In-Reply-To: <20230207182820.4959-2-shaoyi@amazon.com>
Message-ID: <167664390513351@kroah.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 


This is a note to let you know that I've just added the patch titled

    ipv4: Fix incorrect route flushing when source address is deleted

to the 5.4-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     ipv4-fix-incorrect-route-flushing-when-source-address-is-deleted.patch
and it can be found in the queue-5.4 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From shaoyi@amazon.com  Fri Feb 17 15:23:36 2023
From: Shaoying Xu <shaoyi@amazon.com>
Date: Tue, 7 Feb 2023 18:28:20 +0000
Subject: ipv4: Fix incorrect route flushing when source address is deleted
To: <gregkh@linuxfoundation.org>
Cc: <dsahern@kernel.org>, <idosch@nvidia.com>, <kuba@kernel.org>, <patches@lists.linux.dev>, <sashal@kernel.org>, <shaoyi@amazon.com>, <stable@vger.kernel.org>
Message-ID: <20230207182820.4959-2-shaoyi@amazon.com>

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


Patches currently in stable-queue which might be from shaoyi@amazon.com are

queue-5.4/ipv4-fix-incorrect-route-flushing-when-source-address-is-deleted.patch
queue-5.4/revert-ipv4-fix-incorrect-route-flushing-when-source-address-is-deleted.patch
