Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B23752BE653;
	Tue, 26 Aug 2025 13:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214543; cv=none; b=bTnXdjiOqTXohH2xXQ761YycoLdIs296b2iBJbfgrr6d+0muLBRSvmuZ9uwBG2iBdDnMYh8DYSHoJSSd284OUMKff54jw1Q4Sr56LJNvb8ayesRGL6LnIURTSPIY5lcDkMXnm9CyBA+AZs25v3TZqmM+lwanII+hYKODFOwdNj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214543; c=relaxed/simple;
	bh=BR8DHIVy1BXgng6Hienw4W1Ps/VaKLK9EI0JuDuMVtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bUboO6Aycy3gmtepCCcMtgYaaM3WWvNYrH3+GSrekyWjqlF6YGePb275gHfiXKUvrFHCU7QWtTC6NvFJxSnJwqSYk44xDhhCGtcVStC2XkZsRlg6ap3ffylfZrJ44/7vLQNA2ci8GhyM24i4+18QOwcFIXPkVkWYPBNhU4Ly76A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HIJDEECG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HIJDEECG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E54CAC4CEF1;
	Tue, 26 Aug 2025 13:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214543;
	bh=BR8DHIVy1BXgng6Hienw4W1Ps/VaKLK9EI0JuDuMVtA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HIJDEECGRZtE4qFVbVU6WzzVsDrFf32AqSv3aJVQRUk6+H2oWBX7SPBR9VGlA/9kg
	 5rtgbMv3uE+xV7EnpHNxULWxs4a8fM/30AYkh2trA5qoLbkuXV40bPnm3xkLk0DWpR
	 oz2KI6VwbLQFPsBIWa5a9xjrvxDEGIt8Ulb7fO60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 150/482] powerpc: floppy: Add missing checks after DMA map
Date: Tue, 26 Aug 2025 13:06:43 +0200
Message-ID: <20250826110934.523652241@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



