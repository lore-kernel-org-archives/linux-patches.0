Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68EB943BDDE;
	Mon, 17 Aug 2026 14:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977407; cv=none; b=rg8ukzECgVAcMPto4+3rP8JbaLTb+1QURiJ+pcPOKWfSMtFc6XvG7fH5S8jMEL7dnn1OF1ual+xnMFD1pG3JeCuHwGguyNfxh73Bi/0gGoZxgzUhhw6CE94kAd9ZqoJ7Krv/U2+UM1TCLY7qjNibxAFEPT2DW8BEQFD5GxWn4o0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977407; c=relaxed/simple;
	bh=RkA9twTGk8XX14phoTNLBowt9PVs8uDgvM6WWFPnyDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HpMvbe4uFcuN3Whgl2u9medVQm02qXQu8fs/sszR4QU23TE/31nmZCLriEmocB9LE9jNzhE9nQIuvsICZ8YE2sSwBMsGi2PHi0dPDDWSc5nNa/yLx7eJScd90aSIkCWiC8Rq4CN9RDNnF6ueIICWiPC2DYhVY18bh2FDscMTOTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kTYJKul9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kTYJKul9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A88E31F000E9;
	Mon, 17 Aug 2026 14:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977406;
	bh=eOxLYK1cH4yD1iHXvmGmCcEGzik9rJV7UoH21NaTc9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kTYJKul9HvGoiB/nhTaSaelI8F52F1ydxKc+03AQVtVHvxxiNPCj/MSfPsvQeY5NL
	 XxVGW4FOlhe5H88+99q5LR4EB00I5hkYm4mSh4WehNJ4b259dE0FgAF0ndFX0JdRhP
	 acEWJQT+XXj6rSgqgls8v30DwJ2CPvr0WPDru3hc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Vollrath <tactii@gmail.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.15 311/456] igbvf: Fix leak in TX DMA error cleanup
Date: Mon, 17 Aug 2026 15:31:41 +0200
Message-ID: <20260817132551.917499819@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2203,8 +2203,6 @@ dma_error:
 	buffer_info->time_stamp = 0;
 	buffer_info->length = 0;
 	buffer_info->mapped_as_page = false;
-	if (count)
-		count--;
 
 	/* clear timestamp and dma mappings for remaining portion of packet */
 	while (count--) {


