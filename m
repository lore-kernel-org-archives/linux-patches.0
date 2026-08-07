Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D05DB37E2E9;
	Fri,  7 Aug 2026 14:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114262; cv=none; b=tTEdL9pDCZkE/phNHlZ8lWPekJRsUb5iLk7FALsOYKhS6/OFlqR+lK/AwWiISnoAAAO97VwSpbGTtHSz6GWX1JtxStlBvJytehk8BMD2K/42198/mOcMpcNt5D8Yp34ZVTDte05Zy7ywUOn7cVIGa39VT2yg5qXj9lijH3LmjaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114262; c=relaxed/simple;
	bh=DSBX5vpEx2I4Y2mV2l40oNT1jVIw+TLtM1b8MzPQDIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e3/oh/9JBFCMiRiHqXmv9zfno8jdy0BUoDCIV4u+PXePdI4SHRJd1pdZ3ZHT3bkb2KdP+auAtrWhh//9r7h1tJlcHtuXt9reU6bo6vVbUV4o/k2L681vN4p1t9vHR3dn1Jo6THk30niTNKiGmm2pxt7pjYeTK+PxrZ/E0Z4HPmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MbusODVv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MbusODVv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 723371F00A3A;
	Fri,  7 Aug 2026 14:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114255;
	bh=PNkytX3tYO3CKZScBuNK/6AocV+0781E2KaVu/F4R8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MbusODVvF5OUv1x7VC5sh533RMifCFwp/E6HB0vfLIQZ5vje9pVxtDNQ3wpkNuV+A
	 NOWKEo5TuC5Ktbl5pBYspGX2h+Ea5CE3oeWZ2ni8HdlLIIjDpX+qcYIvcst5i6d1tR
	 s3eVj/CXAh55DzCeeNq/wOITJzk4rwc3pbcocd7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Vollrath <tactii@gmail.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 6.12 172/337] igbvf: Fix leak in TX DMA error cleanup
Date: Fri,  7 Aug 2026 16:36:15 +0200
Message-ID: <20260807143422.287937244@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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
@@ -2201,8 +2201,6 @@ dma_error:
 	buffer_info->time_stamp = 0;
 	buffer_info->length = 0;
 	buffer_info->mapped_as_page = false;
-	if (count)
-		count--;
 
 	/* clear timestamp and dma mappings for remaining portion of packet */
 	while (count--) {


