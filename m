Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E16E427466A;
	Fri,  7 Aug 2026 15:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116253; cv=none; b=TNd95sP4qhXjo+P4Oqul6w5KAOzuRajOe9NjewQ28YjidJWCTj7ghvcvXq/l41L60dG4xtRBkeyTfheRo4FYnJt4nUVil33325HdHuE/EKpCHmnLwp4QChfln/c4nEruVAyeUhMLv086J7NHEPytWhAKHPQRszA4AuLP+HkFHt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116253; c=relaxed/simple;
	bh=A+Yr/XFYKopk3bRjymO/2+VPiXsbzVaGT9oWOn+upe0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QKJ9Z+OxpR/fmULG7d1sJehOp7e1bw+pQEqVaK+lNn2MOmVmamb+ilT/41OWpCxWYgavt/dOo8fNDjAmCJByv7MZJn6MjwmO7dgq65efcxDyL0wytYBeUWsqvulB9a3wI/UmT2haLn6LDP/Y7YMxFk41EufsdRn+nbl7bn58FVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mak4I2KI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mak4I2KI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FD341F000E9;
	Fri,  7 Aug 2026 15:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116251;
	bh=6hFxGBKZ9cDmVV6QnHQRoLsMNfG7FkRIHQVMeM6xl6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mak4I2KIWRJUEhc4VoGnGcwtIyvCfE2E9e7xtYdtUHkN/C/Mtn2AknFbp15cDHNU8
	 L4cABMtJEKJZ7b2ySVu/xsds7s4G7OgFeHdn+a09JmLWbybeQKVUsgY8uANytAp8LG
	 DRwnIfgIodjwptbq2ZaakxL5okuqnUR23XvJwfI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Vollrath <tactii@gmail.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 6.6 122/261] igbvf: Fix leak in TX DMA error cleanup
Date: Fri,  7 Aug 2026 16:37:59 +0200
Message-ID: <20260807143418.002428681@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


