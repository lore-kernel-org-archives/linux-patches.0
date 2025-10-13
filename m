Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B39BE31A805;
	Mon, 13 Oct 2025 15:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369330; cv=none; b=R4k5XzLQbB7kmDvofJynMhTvjYWaSRXpZNDONGZR7EP3lsBObmeHdQXTnb1kXD3haJ1B7yASNdu6nCNMPctk9p1qF6CEUpHJ5XilsihpfgbPJre2uuNQN3rbzkmvSzJ+26jRqY1DjxgHuJtlgv5abMUnpTit685F5aWcauOSt7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369330; c=relaxed/simple;
	bh=5zZwYoh/NuQkij9+yefiYZAfwJJW7obrLAZ4chrPKwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GzOeUo7EfkBb60EOJBCA6yKGjVuA8lISrKLQa/gNuFekpH7eLnqf/4id6pj6g4XtSuFR9o46I/yQj6FDbh8Ec2Tq70+Dlb8ZUAqp2fhqRhB26rii/wmuSXC57MROqRtgk+Jy5gfvCRcSFlmlMSTZOVUwLRYeat56wmBzjSeOR6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TbGiNPXu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TbGiNPXu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF745C4CEFE;
	Mon, 13 Oct 2025 15:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369330;
	bh=5zZwYoh/NuQkij9+yefiYZAfwJJW7obrLAZ4chrPKwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TbGiNPXufKPjJHqHGhI9QQlb8HCKUI0l9EA7R6iuWExSXdpm4QtjwFCLBaaMFb/7+
	 k8Im+f6pnrDrx53+c2ZdO35+GCSLUhIR0TM7uic8IHkgKMSwXr0UUki4GIo9Zx9RMw
	 /yqsl+XTzdRpvuaj5R2fyRuxrjJBpSMfm6KD3c3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manikanta Guntupalli <manikanta.guntupalli@amd.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Jorge Marques <jorge.marques@analog.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 209/563] i3c: fix big-endian FIFO transfers
Date: Mon, 13 Oct 2025 16:41:10 +0200
Message-ID: <20251013144418.857494703@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit d6ddd9beb1a5c32acb9b80f5c2cd8b17f41371d1 ]

Short MMIO transfers that are not a multiple of four bytes in size need
a special case for the final bytes, however the existing implementation
is not endian-safe and introduces an incorrect byteswap on big-endian
kernels.

This usually does not cause problems because most systems are
little-endian and most transfers are multiple of four bytes long, but
still needs to be fixed to avoid the extra byteswap.

Change the special case for both i3c_writel_fifo() and i3c_readl_fifo()
to use non-byteswapping writesl() and readsl() with a single element
instead of the byteswapping writel()/readl() that are meant for individual
MMIO registers. As data is copied between a FIFO and a memory buffer,
the writesl()/readsl() loops are typically based on __raw_readl()/
__raw_writel(), resulting in the order of bytes in the FIFO to match
the order in the buffer, regardless of the CPU endianess.

The earlier versions in the dw-i3c and i3c-master-cdns had a correct
implementation, but the generic version that was recently added broke it.

Fixes: 733b439375b4 ("i3c: master: Add inline i3c_readl_fifo() and i3c_writel_fifo()")
Cc: Manikanta Guntupalli <manikanta.guntupalli@amd.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Jorge Marques <jorge.marques@analog.com>
Link: https://lore.kernel.org/r/20250924201837.3691486-1-arnd@kernel.org
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/internals.h | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/i3c/internals.h b/drivers/i3c/internals.h
index 0d857cc68cc5d..79ceaa5f5afd6 100644
--- a/drivers/i3c/internals.h
+++ b/drivers/i3c/internals.h
@@ -38,7 +38,11 @@ static inline void i3c_writel_fifo(void __iomem *addr, const void *buf,
 		u32 tmp = 0;
 
 		memcpy(&tmp, buf + (nbytes & ~3), nbytes & 3);
-		writel(tmp, addr);
+		/*
+		 * writesl() instead of writel() to keep FIFO
+		 * byteorder on big-endian targets
+		 */
+		writesl(addr, &tmp, 1);
 	}
 }
 
@@ -55,7 +59,11 @@ static inline void i3c_readl_fifo(const void __iomem *addr, void *buf,
 	if (nbytes & 3) {
 		u32 tmp;
 
-		tmp = readl(addr);
+		/*
+		 * readsl() instead of readl() to keep FIFO
+		 * byteorder on big-endian targets
+		 */
+		readsl(addr, &tmp, 1);
 		memcpy(buf + (nbytes & ~3), &tmp, nbytes & 3);
 	}
 }
-- 
2.51.0



