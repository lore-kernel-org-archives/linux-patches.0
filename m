Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1FBA442B39;
	Mon, 17 Aug 2026 14:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976106; cv=none; b=XE2Hd5jQUw6zcouMlzUK2kkk4MGI/RJaHZi26+BpomAlheyqGO2l4+oqWko7C+Xwr1V3vO6mxpA0VQ15spF++r5YXP5pSHL9f0sg97e19x1EG+Mep2IC6Pobwqt+iCFNki96U+53AUjd/wEUZ0Eo4fKQN1OP6rcL08fvvsjbzDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976106; c=relaxed/simple;
	bh=CIdYC312AgJDsCOx8vj+gwa0aVSiuajfSPzb3FTARs4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WdlTTL4X8j/n1NeQcA9AonsYzqJFx+WyJxPnstQI2I3qhFuGjbBTEdBbL/9SKEVia/OeDDXdsfdF08pepyyG1tKF67l63gAU/aBi5Ghx+BAjckFbNiGvY4YkmIFrYtMnYItZeF313q+PnfNdpIiO+RRWPV0wxIN0XDbhCMkFcvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mzRfnZ0T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mzRfnZ0T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34F941F00A3A;
	Mon, 17 Aug 2026 14:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976105;
	bh=ljXyng6CPf9pCr3BbAA3U48A65xku0gRCy+44iv4y50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mzRfnZ0TK7xQ/5l7dTOy+rXevjrNU7ExlrucE1ovX/UIDI86QwvLUnJx5bEKEHP4B
	 4Ejehro4M5bFIzK+u1tVcUesJmSKJhZ9AJE9e/CylSJQoPfiCw1lRnALG3Iairxzon
	 g5P9JfXOtUXbh0JYylcx0FggBstCp9Hp4SV/lwb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Vollrath <tactii@gmail.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.10 259/389] igbvf: Fix leak in TX DMA error cleanup
Date: Mon, 17 Aug 2026 15:31:38 +0200
Message-ID: <20260817132549.308051793@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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
@@ -2215,8 +2215,6 @@ dma_error:
 	buffer_info->time_stamp = 0;
 	buffer_info->length = 0;
 	buffer_info->mapped_as_page = false;
-	if (count)
-		count--;
 
 	/* clear timestamp and dma mappings for remaining portion of packet */
 	while (count--) {


