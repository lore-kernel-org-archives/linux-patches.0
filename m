Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AA3E770FE;
	Tue, 26 Aug 2025 12:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213032; cv=none; b=tD40XiJ01xQLBopBEFaIx9qARG5HLXS0Nao/Z/9Ovf6BU9DA4ptpXv94jQpfQm+MM1clU/qOY215zYR+3jFR02ScVGgOqLECmyP0H64YupAMoehPCzWM5nGboA+KFhdxSAOmViUeKZzIhaReMhGF/lPik4zy0IvmKOLefpliS0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213032; c=relaxed/simple;
	bh=8u1p7njBNiB5iO7z9ZEBvgYvISXb/oo3OJ8T4it1Pgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h28ugFaM1i47keztbVtx4D7X11JvR0tf8DTWnQyJ4qlGCaGRzuCjMGZ1Q/To6BIpgjpCSWZVNMoJcgndiWaWdtsivMftw+a9tZbtRWmP/hV/JL/GNEMiZLn6fQdpB37JDmxRrlE7z5jjz7UGr4qITYkwz4YNhx9O3t8HCOK0DgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RvETi1TZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RvETi1TZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA71FC4CEF1;
	Tue, 26 Aug 2025 12:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213032;
	bh=8u1p7njBNiB5iO7z9ZEBvgYvISXb/oo3OJ8T4it1Pgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RvETi1TZeIbgh5pEcIym1D63w4Vs6wvuw2eIzvdrHSYiv6+RY3C5j2LH5B2aLjotP
	 3rKfGhGKzt2Qx/mPA+YlRu3/QxcM+KMBrcVmEPP7Vho7QF/yPat2JgPBD6QUSBmc66
	 ByIxHgaUARpmxTw/mUq05oVy2p+5WH2gpRSaeTM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 188/587] powerpc: floppy: Add missing checks after DMA map
Date: Tue, 26 Aug 2025 13:05:37 +0200
Message-ID: <20250826110957.723893353@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Fourier <fourier.thomas@gmail.com>

[ Upstream commit cf183c1730f2634245da35e9b5d53381b787d112 ]

The DMA map functions can fail and should be tested for errors.

Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20250620075602.12575-1-fourier.thomas@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/floppy.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/include/asm/floppy.h b/arch/powerpc/include/asm/floppy.h
index f8ce178b43b7..34abf8bea2cc 100644
--- a/arch/powerpc/include/asm/floppy.h
+++ b/arch/powerpc/include/asm/floppy.h
@@ -144,9 +144,12 @@ static int hard_dma_setup(char *addr, unsigned long size, int mode, int io)
 		bus_addr = 0;
 	}
 
-	if (!bus_addr)	/* need to map it */
+	if (!bus_addr) {	/* need to map it */
 		bus_addr = dma_map_single(&isa_bridge_pcidev->dev, addr, size,
 					  dir);
+		if (dma_mapping_error(&isa_bridge_pcidev->dev, bus_addr))
+			return -ENOMEM;
+	}
 
 	/* remember this one as prev */
 	prev_addr = addr;
-- 
2.39.5



