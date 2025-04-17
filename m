Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 584EB152532;
	Thu, 17 Apr 2025 18:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913505; cv=none; b=GElktQWLT3ZZ5DqkkSTFhtMR7ggPdiNLLrsdDbjYO+HeGzgrw8by9FYohrTLytSFhIlfIoC3Uv+ZqD4T6PqVJVdf0AlqG+pBUDfA5nvEevpkEpwg/BbMH8nb3+OCMxeR1sRADmlDHZvaNKzFviYAzppIXQ/z5wk45D8ftH4OYYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913505; c=relaxed/simple;
	bh=2ZJecF/TyxZ7BdGdQGXHA+hTtz4G/uj5r+Dx0af6nsw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cov3itMU2zfMR5bWaXrXoEKAP9KQ3cKRQtkOKysWT9z7ISimAnC2jj1UbzeEUUJ0856PvEZif9mk7BJLBBQr4aC+BY5TQqp+ql+yKgrtqMirxYppHM9muqxrbg4vBsNll5WFa7m/BcaTtVothvMW1LRPYChEaleK+GlR41E3vPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nylzSogV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nylzSogV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77548C4CEE4;
	Thu, 17 Apr 2025 18:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913504;
	bh=2ZJecF/TyxZ7BdGdQGXHA+hTtz4G/uj5r+Dx0af6nsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nylzSogV5G4QRG/zFxm6KQuUI2FcAW35XENAlF4SnG42WpzgfYaWQi86qNQZmm1ub
	 xER5nL+/4kPmZch8PZq/2aYy5ug1QwujsJzfa7iYx+Exgs9CoFdh1loPgP2+9AM98R
	 TlicjeaMttx2Xe4eR3siy2QDIq1JNY9NTkJE4VIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Jean Delvare <jdelvare@suse.de>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.14 333/449] mtd: spinand: Fix build with gcc < 7.5
Date: Thu, 17 Apr 2025 19:50:21 +0200
Message-ID: <20250417175131.577587692@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miquel Raynal <miquel.raynal@bootlin.com>

commit 1c1fd374a2fe72b8a6dde62d3c3a9fd153e7581c upstream.

__VA_OPT__ is a macro that is useful when some arguments can be present
or not to entirely skip some part of a definition. Unfortunately, it
is a too recent addition that some of the still supported old GCC
versions do not know about, and is anyway not part of C11 that is the
version used in the kernel.

Find a trick to remove this macro, typically '__VA_ARGS__ + 0' is a
workaround used in netlink.h which works very well here, as we either
expect:
- 0
- A positive value
- No value, which means the field should be 0.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202503181330.YcDXGy7F-lkp@intel.com/
Fixes: 7ce0d16d5802 ("mtd: spinand: Add an optional frequency to read from cache macros")
Cc: stable@vger.kernel.org
Tested-by: Jean Delvare <jdelvare@suse.de>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/mtd/spinand.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/mtd/spinand.h
+++ b/include/linux/mtd/spinand.h
@@ -67,7 +67,7 @@
 		   SPI_MEM_OP_ADDR(2, addr, 1),				\
 		   SPI_MEM_OP_DUMMY(ndummy, 1),				\
 		   SPI_MEM_OP_DATA_IN(len, buf, 1),			\
-		   __VA_OPT__(SPI_MEM_OP_MAX_FREQ(__VA_ARGS__)))
+		   SPI_MEM_OP_MAX_FREQ(__VA_ARGS__ + 0))
 
 #define SPINAND_PAGE_READ_FROM_CACHE_FAST_OP(addr, ndummy, buf, len) \
 	SPI_MEM_OP(SPI_MEM_OP_CMD(0x0b, 1),			\


