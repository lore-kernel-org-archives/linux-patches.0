Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CB30476CC8;
	Fri,  7 Aug 2026 15:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117311; cv=none; b=hujWm0gzM92vn9OXsKv1BUoAGmNRWN/39kdkD1yYA6pD4y4CKv50yyBTYMWtpUTY11cqBpBw01AtuP73vWAnKrokdqi8/rFxF5DINLRceFXBcoVwhozASWtrTIsmO7k3B6oQ9gYRT46m9XwA14ceF/X+HU07X+uh2QJmNWhq1og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117311; c=relaxed/simple;
	bh=P7G5jpSnDHFEFmyup8lgk0UtKObwnRioXB7v1qkqAgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DBRVQQRSW4FCV9GzwyzDVorEcq2AWuJ14cfbRBKwaTkrKmCL1l6yTZbMxHfto7kgDnn1TpvNoo7C2/fG2sLY7rjhkhxELyDOke/j7Xvtif1I/lZnSVEXXJgFV4tLUFodR/HATGiYKusp2Dk0K2aAk8GCFVuwRwAp5hIb+9bfPP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TyQk9ldr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TyQk9ldr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DDFB1F000E9;
	Fri,  7 Aug 2026 15:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117310;
	bh=4r3Hy7ed3rvWOdpea24z1aEl/34OWiO8W9f0m1ygmQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TyQk9ldrv+kq4+rvlPL0wwcuo19CLdM+73nEnnsuRtaISFqkKcixt4EnVSgDrYL2t
	 V32ukusXGr0/+pF1fjk+z7hsAe7p1D2EStu/Xgq11B0XLcoditlgmqwjcxykXwWlN/
	 8JjSGlpHctfEGeTybWahtgEolegroIXhhhlVoZpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Vollrath <tactii@gmail.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 7.1 275/438] igbvf: Fix leak in TX DMA error cleanup
Date: Fri,  7 Aug 2026 16:37:51 +0200
Message-ID: <20260807143433.845617300@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

From: Matt Vollrath <tactii@gmail.com>

commit 0565052b7e2f436b7f1541f4849da96dc0aa7a0e upstream.

If an error is encountered while mapping TX buffers, the driver should
unmap any buffers already mapped for that skb.

Because count is incremented before each frag mapping, it will always
match the correct number of unmappings needed when dma_error is reached.
Decrementing count before the while loop in dma_error causes an
off-by-one error. If any mapping was successful before an unsuccessful
mapping, exactly one DMA mapping (the head) would leak.

This bug was introduced by a 2010 fix for an endless loop in dma_error.
All other affected drivers have already been fixed.

Fixes: c1fa347f20f1 ("e1000/e1000e/igb/igbvf/ixgb/ixgbe: Fix tests of unsigned in *_tx_map()")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-4-7-opus
Signed-off-by: Matt Vollrath <tactii@gmail.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/igbvf/netdev.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/net/ethernet/intel/igbvf/netdev.c
+++ b/drivers/net/ethernet/intel/igbvf/netdev.c
@@ -2190,8 +2190,6 @@ dma_error:
 	buffer_info->time_stamp = 0;
 	buffer_info->length = 0;
 	buffer_info->mapped_as_page = false;
-	if (count)
-		count--;
 
 	/* clear timestamp and dma mappings for remaining portion of packet */
 	while (count--) {


