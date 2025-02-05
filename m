Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1E081632D3;
	Wed,  5 Feb 2025 14:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767036; cv=none; b=cxTR1O21fNfZsxhB1aiXO28wmRF1mCQQBtVnNsohOP2B+gx+TVI2wTH61v07awUUUBfX/iBE72SDaJYsLDi/TcVbSDd/AQAYUfcRx4sTJtgVeRyLeQeEFEHYT2fDcIFaOa05ZMl1H/HAHEGTDc0/Dyy0LwAT+ukpGdDcwCXu4hA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767036; c=relaxed/simple;
	bh=QLtI5mYeazMt34dhZCLK2hJg0yHV/dSmRnG+cRtywSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A1bWWN9C7Joj7HJBKboBWonW8H1WEUOk7jLs/MGKiqy3lux1P86ZOQUxfDVkpR4cSjujnITKmMTuvk5weDEJ9l9a4xVnr7j5OLR7GQd9RjHw8Jvx92cH7E4i79uNmCJ4BZLnC/kBS5iz43M9qS1W7D8fEXu2sXr55zlbKvFLv2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PHRcIto6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PHRcIto6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 218D5C4CED1;
	Wed,  5 Feb 2025 14:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767036;
	bh=QLtI5mYeazMt34dhZCLK2hJg0yHV/dSmRnG+cRtywSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PHRcIto6xlvjznkiqJUq1uYI+IHo1S9LPz163Xswps8ycz2uHIWhLHjQBtkMD29cF
	 M3grAYDcaZda8noN2q8BuvWwy+yl+1ySnHkg/H+udVPfhvgxBPy6QwLXqvwqMmhwSJ
	 h6E5Md9B+s6dHxBhMk0xZl5hMrhqW/FEp71jH+ME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 397/590] of: reserved-memory: Do not make kmemleak ignore freed address
Date: Wed,  5 Feb 2025 14:42:32 +0100
Message-ID: <20250205134510.453615559@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <quic_zijuhu@quicinc.com>

[ Upstream commit 29091a52562bca4d6e678dd8f0085dac119d6a21 ]

early_init_dt_alloc_reserved_memory_arch() will free address @base when
suffers memblock_mark_nomap() error, but it still makes kmemleak ignore
the freed address @base via kmemleak_ignore_phys().

That is unnecessary, besides, also causes unnecessary warning messages:

kmemleak_ignore_phys()
 -> make_black_object()
    -> paint_ptr()
       -> kmemleak_warn() // warning message here.

Fix by avoiding kmemleak_ignore_phys() when suffer the error.

Fixes: 658aafc8139c ("memblock: exclude MEMBLOCK_NOMAP regions from kmemleak")
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Link: https://lore.kernel.org/r/20250109-of_core_fix-v4-10-db8a72415b8c@quicinc.com
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/of_reserved_mem.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
index 46e1c3fbc7692..fa5ecac0b6e98 100644
--- a/drivers/of/of_reserved_mem.c
+++ b/drivers/of/of_reserved_mem.c
@@ -51,7 +51,8 @@ static int __init early_init_dt_alloc_reserved_memory_arch(phys_addr_t size,
 			memblock_phys_free(base, size);
 	}
 
-	kmemleak_ignore_phys(base);
+	if (!err)
+		kmemleak_ignore_phys(base);
 
 	return err;
 }
-- 
2.39.5



