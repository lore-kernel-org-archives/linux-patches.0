Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E4021C84D0;
	Fri,  7 Aug 2026 15:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115284; cv=none; b=nOFIjl1u8u+ulOJ2I10Gz2Xykq1v1ziHKGyB6p9FNFKCefgKCL5BiIveEM/sxDCrsgM1wpCFVa68StwXeF2PLL1sjACljkhedZkNUms9eBNYES1ZaNDFJL/uLA1pGbpl9GAVh2ZUaWYd5Zy3dbW1f7adegzjTqyoeUcEiN6HgAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115284; c=relaxed/simple;
	bh=iIzHv6LI0JRXvlYY8YQyrQUSxp00f4D/NfiMl7p1XyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rABfxqkrEBNRhS3zglLNocY3au7WpuFKJHwGKw+R2w6cpi3c5FiKSBucLN9tvfxtUuMXOSFnfjBzMEk90lcxmk9wxriMMYIlBTVPTn9hz8XIzSnD2chWT/QCV6alww7bHEir1v+jgEl7F0oYRgI0EdOCAY4qjTX99NAy4Xp44y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mc0ywwvc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mc0ywwvc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D57E21F000E9;
	Fri,  7 Aug 2026 15:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115283;
	bh=sVspKSCJuadO4CDOKQ0U/5TQ4s8xTzzUZSPZTFsHmnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mc0ywwvcTMXL3O4bUNrIbMzobNQspf3HuxbfvbLgwdK1r1Cpp/YvovQ8p96SQdx8r
	 PVuhKA8Z5xE2oL+WsDgE7UXlyL8w0ujK6jQtxzkOFz0+y7sN/pPIiPKcX+iap0emSf
	 BdwfVlJbcote09ctoSKfYhgfcP6En+a0H4hWECFw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Vollrath <tactii@gmail.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 6.18 221/396] igbvf: Fix leak in TX DMA error cleanup
Date: Fri,  7 Aug 2026 16:36:21 +0200
Message-ID: <20260807143429.031953266@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2191,8 +2191,6 @@ dma_error:
 	buffer_info->time_stamp = 0;
 	buffer_info->length = 0;
 	buffer_info->mapped_as_page = false;
-	if (count)
-		count--;
 
 	/* clear timestamp and dma mappings for remaining portion of packet */
 	while (count--) {


