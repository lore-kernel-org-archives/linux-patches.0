Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EED21DEFDD;
	Tue,  8 Oct 2024 13:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393503; cv=none; b=o/0AqNAlILb4KFB67TaMeU6W48Gf4ywHqHvy2D2LSOpQ1UzpajrYqk6uDPlU3yoHMpjLO1XLjb2T/5Z0ABUGg3VDjhOAKqGwvukhcx6Nr49TQekJv6sknAQNUhUhfJIGZkzjJDFd6RXfOGPeD13iZtI4DQH1QXlyoYfPHULdA88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393503; c=relaxed/simple;
	bh=8vd5LJAatc3AZkOdCWmlAgFSju7hxHm8J/u1G/ThJMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T5QXIZ2BPMACeK+jDblPOUL1WKZFT2XokjX5IVXKw+9uOJnXG3MhBhAqF5j0L2wIFSqP0DWlNW/JtHsJh7xzZxHqK21+xdKifUUQAHDZYUNohLhvcuQroFUuLqwZxYR6DKQkUFNE10J+V24vmGrqXcpNFIncYfb/zbG1hgwRsAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gif7BTi2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gif7BTi2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF15EC4CEC7;
	Tue,  8 Oct 2024 13:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393503;
	bh=8vd5LJAatc3AZkOdCWmlAgFSju7hxHm8J/u1G/ThJMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gif7BTi2tjJcqUmI9F72ZF2zUjEKfllxSEAnTN8EpYChW6d3STAn2SHwtANJxEoXy
	 bnTIYXQu1mmgsRZwLocOxZxg2XjaRWowLOEdO/gxzYRBi5X9QlQB6+lkR/NAL647tw
	 Apwc0dSI28vVqszQeXWDaiLhNfEmvEFk09DXUyKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 172/386] of/irq: Refer to actual buffer size in of_irq_parse_one()
Date: Tue,  8 Oct 2024 14:06:57 +0200
Message-ID: <20241008115636.191288447@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 39ab331ab5d377a18fbf5a0e0b228205edfcc7f4 ]

Replace two open-coded calculations of the buffer size by invocations of
sizeof() on the buffer itself, to make sure the code will always use the
actual buffer size.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/817c0b9626fd30790fc488c472a3398324cfcc0c.1724156125.git.geert+renesas@glider.be
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/irq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/of/irq.c b/drivers/of/irq.c
index 8fd63100ba8f0..d67b69cb84bfe 100644
--- a/drivers/of/irq.c
+++ b/drivers/of/irq.c
@@ -357,8 +357,8 @@ int of_irq_parse_one(struct device_node *device, int index, struct of_phandle_ar
 	addr = of_get_property(device, "reg", &addr_len);
 
 	/* Prevent out-of-bounds read in case of longer interrupt parent address size */
-	if (addr_len > (3 * sizeof(__be32)))
-		addr_len = 3 * sizeof(__be32);
+	if (addr_len > sizeof(addr_buf))
+		addr_len = sizeof(addr_buf);
 	if (addr)
 		memcpy(addr_buf, addr, addr_len);
 
-- 
2.43.0



