Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19FD42745E;
	Fri, 17 Oct 2025 15:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714589; cv=none; b=o55xHxQpx7WBN8tpRZM60TYJBt/HzjT53qfBUFB56yxlrhAc3oHnpzo66paB6//ppGnXShyMR6yGnhEQLvCfg7ATXoAV/Udbf8Ajl9Nj2hTIdWZH9Og23w/+WJv54U8YaSB7jnwoGS3Pl2LuKzLia6BKnTucM+DOQv0LdX0bhig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714589; c=relaxed/simple;
	bh=lIjRt/ZenAZ6zc6vE26sBj2CU1hiN9aj3DDAhniwphE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dLn0/DLvxs1LaptRJcyCRgTMWp7pZ8bQdzZgtj7z89cMB49IFcf/umlUw81yt7PBsSyyphI1hSebnszid43FEQB1kSHdCEytbXk/EdFgTDu4gSuBtL8sDUrMevj4yn6vbOX2mycl/CAIuYSPb/JGWNStH8e++dN3sVbK35E6SWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WiHmb6+D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WiHmb6+D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 425C6C4CEE7;
	Fri, 17 Oct 2025 15:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714588;
	bh=lIjRt/ZenAZ6zc6vE26sBj2CU1hiN9aj3DDAhniwphE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WiHmb6+Dk5bI3o6wq27+fIrV9zkCk/BL3jxt61UWIDsmT7Ki145fj4+F11rTde+qK
	 iK+jqO156Dv33/YNRtmBA+FfnsT0T0ircVQVBPlK3jEho8rCjRB3jHP6T6eFzRNDjP
	 eaHvKWKVZoEs5OV9vQN5oIqkX+WOG7M2tZVMx0cA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Haberland <sth@linux.ibm.com>,
	Jaehoon Kim <jhkim@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 197/277] s390/dasd: enforce dma_alignment to ensure proper buffer validation
Date: Fri, 17 Oct 2025 16:53:24 +0200
Message-ID: <20251017145154.312286599@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

From: Jaehoon Kim <jhkim@linux.ibm.com>

commit 130e6de62107116eba124647116276266be0f84c upstream.

The block layer validates buffer alignment using the device's
dma_alignment value. If dma_alignment is smaller than
logical_block_size(bp_block) -1, misaligned buffer incorrectly pass
validation and propagate to the lower-level driver.

This patch adjusts dma_alignment to be at least logical_block_size -1,
ensuring that misalignment buffers are properly rejected at the block
layer and do not reach the DASD driver unnecessarily.

Fixes: 2a07bb64d801 ("s390/dasd: Remove DMA alignment")
Reviewed-by: Stefan Haberland <sth@linux.ibm.com>
Cc: stable@vger.kernel.org #6.11+
Signed-off-by: Jaehoon Kim <jhkim@linux.ibm.com>
Signed-off-by: Stefan Haberland <sth@linux.ibm.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/block/dasd.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/s390/block/dasd.c
+++ b/drivers/s390/block/dasd.c
@@ -332,6 +332,11 @@ static int dasd_state_basic_to_ready(str
 	lim.max_dev_sectors = device->discipline->max_sectors(block);
 	lim.max_hw_sectors = lim.max_dev_sectors;
 	lim.logical_block_size = block->bp_block;
+	/*
+	 * Adjust dma_alignment to match block_size - 1
+	 * to ensure proper buffer alignment checks in the block layer.
+	 */
+	lim.dma_alignment = lim.logical_block_size - 1;
 
 	if (device->discipline->has_discard) {
 		unsigned int max_bytes;


