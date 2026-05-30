Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3F7923D2A4;
	Sat, 30 May 2026 18:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780167145; cv=none; b=ZT1YJbeimiXlG3VRy1E8v74cNtIMlkPLMDXiUiVNYaEsNiClacws42uxxy9lsugwKjacqaufbxCai7oJ1jyqjXLaDSgfnHjwyEjcSTgFxJhgKzashYGcfIEywlM+PQa/URSqwSEci2J9FhXomsqFs5u0tb48BNcv8vgRkcMUnWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780167145; c=relaxed/simple;
	bh=fuL5ZnSS8wT0i3U1K4r06sxnyCsYlz5Rg7zqCOniPkw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C339RI/XxYmh67Nfe4QQ8AVB7A8cvVHCX5Ly54RV9spk7lxF/cva2uGdWEhiK8A6UwJqez2S2gOBu70Iura1UOxgBIDZvmCQd4EsSz97o5Vf3nczyS7NdW+/UcjiqVwOqZ+0AA8cq6j0mhqvNyXg9M9lGXcmTOa8v+SKB2oqeOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a7TBKL51; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a7TBKL51"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4665E1F00893;
	Sat, 30 May 2026 18:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780167143;
	bh=EHvdCB3Upa58Tp3lYUOUOpcFLxxrXkjjReUaXeQarwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a7TBKL51A5yfbbUzuEF09WyBDcp1P7ymmKZ7EolnOHLMQGFwSRJjVHQeFgi83EX+R
	 fcZWdsfc+OegojNu1PSZO8KGubmZ3+SA1+SXGIAAPA5E0nKtQ7P/tjE2PcztFLpZcd
	 HjIC/K4tVijvcGHeNKbyHBGknu2g2uuqymwP7F0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 541/589] ixgbevf: fix use-after-free in VEPA multicast source pruning
Date: Sat, 30 May 2026 18:07:02 +0200
Message-ID: <20260530160238.902025795@linuxfoundation.org>
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
@@ -1228,6 +1228,7 @@ static int ixgbevf_clean_rx_irq(struct i
 		    ether_addr_equal(rx_ring->netdev->dev_addr,
 				     eth_hdr(skb)->h_source)) {
 			dev_kfree_skb_irq(skb);
+			skb = NULL;
 			continue;
 		}
 


