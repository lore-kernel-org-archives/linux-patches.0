Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3705B3DB324;
	Mon, 17 Aug 2026 15:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980072; cv=none; b=bY/MGnmh1hH8RuX2cao0h3+L6gET/PByy0wF3wudqKlkfSie5hGz+gl5smVMzPdfwLtz3d/FgLJlHyAsb8Ad/JDeX2Vmrup0YI7ySKJZo0eLmH3PhdPAae5oZTh5xnEmAHKem8CXm6QzCpwjkCqV7KFtMxqHMo/PiIVGPZUrCF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980072; c=relaxed/simple;
	bh=W904a0h0qSdl6IZ01+oGrHcdwJRtbR/qtUJ/SGdXJ+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BuPnHSNV4bXE223UL6kEv1kzBa7gWHVhlWM0BywJQ68Z+eBRhDCx/y+ztvCFXfvNp9XoaJcGEx8c8D5oGh0YGfhthtIeE+UdqHrxk++nmEJNgSrfcr1UxdHU8aDn+e+mw+q1uzM2sCY6VTYR11EyoSRmDWGW8isbJK6XkatL0LE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d+UJ0DHK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d+UJ0DHK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9101D1F000E9;
	Mon, 17 Aug 2026 15:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980071;
	bh=RVb/pmt9HOkODGfDzmQYepczaZTeuCG/sqZwmls6fH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d+UJ0DHKkpzbrh+HWpIUZ7MRFKKu4P6cM8lGcjWlA1aFpbhQ0GNBf4pRq/29jcRom
	 Lxk4RxwbIPIClaIqxYA2s2jOTOFYYOS/7y1FXNfXNwr2g23c/rSwniE3PeRaIq3LCf
	 cJ8fVIs11Q5J59PReGxQO4fKQnjAcpDZ1Eof3jgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Vollrath <tactii@gmail.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 6.1 407/609] igbvf: Fix leak in TX DMA error cleanup
Date: Mon, 17 Aug 2026 15:31:43 +0200
Message-ID: <20260817132557.792831863@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2202,8 +2202,6 @@ dma_error:
 	buffer_info->time_stamp = 0;
 	buffer_info->length = 0;
 	buffer_info->mapped_as_page = false;
-	if (count)
-		count--;
 
 	/* clear timestamp and dma mappings for remaining portion of packet */
 	while (count--) {


