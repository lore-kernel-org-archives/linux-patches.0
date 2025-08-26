Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 751202FFDEB;
	Tue, 26 Aug 2025 13:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216287; cv=none; b=uj1/We0W3vwhpmKGk+RXp4eWpxkS3x3uOH7qw3Wh8g3kBJ9UK4LaEbnvhZUQoMQh1UgwQDDfdbeOxEmBC54/gzpBV4KmX/pqO0rhCHjvAg7RKPNsW5zi4tZTSoY28uX+7EoGsEgxpIjMIqJYauUJrMGhMWtuKNSUtehdcH+nYcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216287; c=relaxed/simple;
	bh=PI1La/dwpmchGvh8RJttEe+F8tkqmF0n8gfI3QpzVW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t8OHkLR6/BPhHpFD5H4e5BmcUbLRG37v6bFR6T1XJYPSf2KBoLWJXaynOokOWjPo90yOISMBTBZXxvcbfZTxsTNHB2pqzP2l6Vu2B5QW2jXkXGCeDWFipXgFr+atxVPaF/eMsBvWKiCIa1yGrbYYT8G4yY+O9kDyFU0CX/AIGTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JowNlQpF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JowNlQpF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA17CC4CEF1;
	Tue, 26 Aug 2025 13:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216287;
	bh=PI1La/dwpmchGvh8RJttEe+F8tkqmF0n8gfI3QpzVW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JowNlQpFlLNrdggBPhGhmirVh2+MT2dc7GW2GDxPMQU/chJ33oWB2gVnVMvJtqlZB
	 zvfus7nI9w2JtEkkdQB14cIj+wES4QfUzlhAOC9u7DGWZGgcmj+W3dl8Eeq94ACotw
	 Y5BA8kc8CT8MB3ZpFIo/DtnO7PFXtmlVTZn7jxmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 355/644] (powerpc/512) Fix possible `dma_unmap_single()` on uninitialized pointer
Date: Tue, 26 Aug 2025 13:07:26 +0200
Message-ID: <20250826110955.197290799@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Thomas Fourier <fourier.thomas@gmail.com>

[ Upstream commit 760b9b4f6de9a33ca56a05f950cabe82138d25bd ]

If the device configuration fails (if `dma_dev->device_config()`),
`sg_dma_address(&sg)` is not initialized and the jump to `err_dma_prep`
leads to calling `dma_unmap_single()` on `sg_dma_address(&sg)`.

Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20250610142918.169540-2-fourier.thomas@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/512x/mpc512x_lpbfifo.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/platforms/512x/mpc512x_lpbfifo.c b/arch/powerpc/platforms/512x/mpc512x_lpbfifo.c
index 04bf6ecf7d55..85e0fa7d902b 100644
--- a/arch/powerpc/platforms/512x/mpc512x_lpbfifo.c
+++ b/arch/powerpc/platforms/512x/mpc512x_lpbfifo.c
@@ -240,10 +240,8 @@ static int mpc512x_lpbfifo_kick(void)
 	dma_conf.src_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
 
 	/* Make DMA channel work with LPB FIFO data register */
-	if (dma_dev->device_config(lpbfifo.chan, &dma_conf)) {
-		ret = -EINVAL;
-		goto err_dma_prep;
-	}
+	if (dma_dev->device_config(lpbfifo.chan, &dma_conf))
+		return -EINVAL;
 
 	sg_init_table(&sg, 1);
 
-- 
2.39.5



