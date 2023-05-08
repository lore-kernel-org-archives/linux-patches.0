Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A5C0168B4
	for <patches@lists.linux.dev>; Mon,  8 May 2023 09:50:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D13DC433D2;
	Mon,  8 May 2023 09:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683539435;
	bh=++5gnSPH5suOIckcoNOW3Cu+lShLaYYyqEza+Scb1Ps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EK5Hwum0bv1BwdocpEkaxWzIYuBsNj6tH3Cy4WhDF6+Nq39Q9cVgNgBNjro07serH
	 DqCItvhrNfsLId9vWBfXmMVnG30oLwNUIZmAz5zhZApdAz44vU1yVuZfjI8Y5Gcfd5
	 7UCWS5HCHOMkm0D1/QCl/4SYAwZvKFDj150+MumQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 016/611] asm-generic/io.h: suppress endianness warnings for readq() and writeq()
Date: Mon,  8 May 2023 11:37:38 +0200
Message-Id: <20230508094422.221671932@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit d564fa1ff19e893e2971d66e5c8f49dc1cdc8ffc ]

Commit c1d55d50139b ("asm-generic/io.h: Fix sparse warnings on
big-endian architectures") missed fixing the 64-bit accessors.

Arnd explains in the attached link why the casts are necessary, even if
__raw_readq() and __raw_writeq() do not take endian-specific types.

Link: https://lore.kernel.org/lkml/9105d6fc-880b-4734-857d-e3d30b87ccf6@app.fastmail.com/
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/asm-generic/io.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/asm-generic/io.h b/include/asm-generic/io.h
index a68f8fbf423be..cde032f86856e 100644
--- a/include/asm-generic/io.h
+++ b/include/asm-generic/io.h
@@ -236,7 +236,7 @@ static inline u64 readq(const volatile void __iomem *addr)
 
 	log_read_mmio(64, addr, _THIS_IP_);
 	__io_br();
-	val = __le64_to_cpu(__raw_readq(addr));
+	val = __le64_to_cpu((__le64 __force)__raw_readq(addr));
 	__io_ar(val);
 	log_post_read_mmio(val, 64, addr, _THIS_IP_);
 	return val;
@@ -287,7 +287,7 @@ static inline void writeq(u64 value, volatile void __iomem *addr)
 {
 	log_write_mmio(value, 64, addr, _THIS_IP_);
 	__io_bw();
-	__raw_writeq(__cpu_to_le64(value), addr);
+	__raw_writeq((u64 __force)__cpu_to_le64(value), addr);
 	__io_aw();
 	log_post_write_mmio(value, 64, addr, _THIS_IP_);
 }
-- 
2.39.2



