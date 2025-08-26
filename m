Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 854D935CEA5;
	Tue, 26 Aug 2025 14:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219055; cv=none; b=CrstlvaxfyGgWGCQTCVwojKvvCl2F67KVDjT/DiY8Aa8Yd70iMjqfxFKH5fKMEPvOewXDy5+8UAD+ysPGXC2m1aRdeR+kjqiYI+69nOZ+pqg1PvH5ZOm5MU8Scs98vCnRCaz1JEtAoSWCugdayKnae96DozPQz0ggp6w448ySHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219055; c=relaxed/simple;
	bh=Q2pYgo+qZp9khSk9yPlTksS4kza6pDaEo7OhmQJebj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XgJqhaZ0a5Du49yiV5UzdfLSadVXxK/8VMCIhkeHx1NYKK2Itidzm7VCKF6vC4lQcSBX/CYSKUUOMB3eFTmKsCcTuvT1/DutqfMvrlsNySjNRsSV/WP0DUTDmAxuERguR2FLkzwceD/c6oHI1uQM5clXDrBE9UQX1sn49hbkhs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Db4OtjY+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Db4OtjY+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1698BC4CEF1;
	Tue, 26 Aug 2025 14:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219055;
	bh=Q2pYgo+qZp9khSk9yPlTksS4kza6pDaEo7OhmQJebj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Db4OtjY+f//GYggI/t7RiwutHCcqprlqfewZtgb92tQ+7Hfx1nHHW+GqUpJAlhgNn
	 gNAR+Il9WQYOxWITyqHhlD8Ous1ab8ExX45dvYGAsOfIBasJpIvqmXwHGmAwviGwJg
	 Qafusu1mZqH/JRLL5lc6aSfFxjmX3v5jAV6fq7CQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 218/403] (powerpc/512) Fix possible `dma_unmap_single()` on uninitialized pointer
Date: Tue, 26 Aug 2025 13:09:04 +0200
Message-ID: <20250826110912.860164524@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 13631f35cd14..12fb94968f3c 100644
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



