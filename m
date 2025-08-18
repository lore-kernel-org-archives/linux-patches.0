Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9A3A31E0EB;
	Mon, 18 Aug 2025 13:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523682; cv=none; b=NdtSjyuU7Qu+o5wRBhBwQk1uaM2dRm5Qr7Nz/RkeyNwXsZsxXT3Z5be1DZmWXaBd8VFmZNo0iRB5BrG5nrprn9wUJlzuK7ISPLcxmSTnzShaU541fQhWBsiFgezAO0fqcZhZxvbhB9vF8lM+otqxXS7PN6vaAnsRGXE+lDjs+JE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523682; c=relaxed/simple;
	bh=GTvZuw9X5Q7H1qVI1K2BZdP+u5lFfxil+zcgTjMC7M8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mGDdHOf4OZxtLzh9yIZGViz+Q9b0LUFHZILPkEE30KYvo8dH+7//jmrWIXbWI1tsMprzmizJGmcnedj/1ufX7p3OEQJdiuaosdfBzpEALQqw7ic2p6kUnuCcpsOpf9HKcTJxkVmTDHeiUXSuiFZHULrQckrZI3lWOnaNEY/LoxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rCBG9IEY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rCBG9IEY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AFFEC4CEEB;
	Mon, 18 Aug 2025 13:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523682;
	bh=GTvZuw9X5Q7H1qVI1K2BZdP+u5lFfxil+zcgTjMC7M8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rCBG9IEYXfEUb1OEwoUocqIl2nwC6ls2JqZk6Zfi74VMxXxBUQGI+A4ShOALYD7Wh
	 lcQWaKdz4s157m8YFfNcmOYE5DpcmQWdGwx9QJ6W1qh4Ll0e4KVQ5Cd6j+S0brgert
	 /I6w9ri77cdNcBWGkdmLfBTIrlXWN3a9ZZJ0bvVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 246/515] (powerpc/512) Fix possible `dma_unmap_single()` on uninitialized pointer
Date: Mon, 18 Aug 2025 14:43:52 +0200
Message-ID: <20250818124507.856150925@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 9668b052cd4b..f251e0f68262 100644
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



