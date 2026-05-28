Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBB7130C343;
	Thu, 28 May 2026 20:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000640; cv=none; b=Ea6rQlQa8/54Afh6ZgAGtB71wosva6Oy+knsg5qGs5LyBYFzAwLiqlWAN85X9i5aMOAQ5EaJkTJL6G0tO9hh8cphrzdKdl4DFsehdNkJ7l8zuJhoCxFb1kayAt2vQbnpADv0Yj63prNpm/b40CTjv74mJSKjTkMpNgd05b3fea8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000640; c=relaxed/simple;
	bh=f9Ua00AYRq1C+T5EwhJdmaDNC4vyX63uEjuF5PLxHww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ocNFt/rZRxoPKSehOOId3aqxAlO4ueDeDlJkNNyxjUHb2NxCfLSb2zoL65HuLcwhY6FGDkSLzaUmzcVpCcV7Uqf8QxsPiAdWbjZ1pQ+9d+hG2ZSchFkb99WUbYEs0GpacCH07PsZCpo/r2TDCNgkCpUbi+ZnN/sVk/uN2355izo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HT5pwHNU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HT5pwHNU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7EB21F000E9;
	Thu, 28 May 2026 20:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000639;
	bh=S0Q5l8NzfOozXxJ+tXT5vQ3J9U5ZPtJCT44BvzVrkxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HT5pwHNUnngPV53Gprxdi58gwqyF0jaIR1vEYasWQWjsaOPAy0FssTbaMBjgFzfIU
	 QRg9GhGRmN/gxu0/6GkdavDn8Gt+1Th3EFN6ixMmEb2hBBwemnUr8uwUhUFALJTWE5
	 HIzc36SZUgTecQBKay7xrcpE3Bd4HkXDeAzdj9Z8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 089/272] ixgbevf: fix use-after-free in VEPA multicast source pruning
Date: Thu, 28 May 2026 21:47:43 +0200
Message-ID: <20260528194631.870590687@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

commit 5d49b568c188dc77199d8d2b959c91da8cc27cf1 upstream.

ixgbevf_clean_rx_irq() prunes frames whose source MAC matches the VF's
own address (VEPA multicast workaround) by freeing the skb and
continuing to the next descriptor:

    dev_kfree_skb_irq(skb);
    continue;

The skb pointer is declared outside the while loop and persists across
iterations.  Because the continue skips the "skb = NULL" reset at the
bottom of the loop, the next iteration enters the "else if (skb)" path
and calls ixgbevf_add_rx_frag() on the freed skb, dereferencing
skb_shinfo(skb)->nr_frags - a use-after-free in NAPI softirq context.

The sibling driver iavf already handles this correctly by nulling the
pointer before continuing.  Apply the same pattern here.

I do not have ixgbevf hardware; the bug was found by static analysis
(scan_drop_continue_loops.py + semgrep drop_continue_in_loop, multi-tool
corroboration with the highest score in the scan).  The UAF was confirmed
under KASAN by loading a test module that reproduces the exact code
pattern (alloc skb, kfree_skb, then read skb_shinfo(skb)->nr_frags):

  BUG: KASAN: slab-use-after-free in ixgbevf_uaf_test_init+0x100/0x1000
  Read of size 8 at addr 000000006163ae78 by task insmod/30
  freed 208-byte region [000000006163adc0, 000000006163ae90)

QEMU emulates igb (82576) but not ixgbe (82599), and the igbvf VF
driver does not include the VEPA source pruning path, so a full
end-to-end reproduction with emulated hardware was not possible.

Fixes: bad17234ba70 ("ixgbevf: Change receive model to use double buffered page based receives")
Cc: stable@vger.kernel.org
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Link: https://patch.msgid.link/20260515182419.1597859-8-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -1224,6 +1224,7 @@ static int ixgbevf_clean_rx_irq(struct i
 		    ether_addr_equal(rx_ring->netdev->dev_addr,
 				     eth_hdr(skb)->h_source)) {
 			dev_kfree_skb_irq(skb);
+			skb = NULL;
 			continue;
 		}
 


