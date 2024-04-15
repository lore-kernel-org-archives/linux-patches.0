Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5AB076025;
	Mon, 15 Apr 2024 14:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713192009; cv=none; b=uzxqYykScElgC12c6IhKQwLCG4stdpwNXMcJot7wTwXEWQWnUc2LJlnDvTGyiS6zIbW1jSzYTA4yb3pc5gIEas0wJ5HQ5U5rPYIXrG9AbHIfEoCQrHO4k1ptm+sYZGaLyw3ACMpOO5cI82OxeTkIMWgQJlsbYnctTaIVPWAdBKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713192009; c=relaxed/simple;
	bh=BLfD3HFDxEOJQh8hPdR/YmarcHY8281QjPR5QyBP9kc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CO4zDnGkm5EtZ5tEa+XH6G9YAUk6hN16Y7AK77SetG5Ueqs6ri8AbrAKLVN2uAbtBHxqgxlJmbPEb69KCjoqU+3whbmEPnogAYHtWpaZEQHLnDIVLy8faM0ttTVJsWOdTEywrdWAnlvYp1eSl/vErpU6jwxq/wEcYoXPcRe5yk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XmOYIne6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XmOYIne6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B637C113CC;
	Mon, 15 Apr 2024 14:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713192008;
	bh=BLfD3HFDxEOJQh8hPdR/YmarcHY8281QjPR5QyBP9kc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XmOYIne6a9GZu5MA11faRNyDOfG1hjGDP+GXZSidcLAyExykkgqScAgjStfwLjGOG
	 qvUOMKwvnse3DvyzQJwdkw6bVFMdf3zXjjpmrIrymvDR8idm6Ap2YzSC161a2odJYF
	 PCwt/p0MV0Ca/ZQi5rraHrRSHcgSE0+xM8PzmxLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arthur Kiyanovski <akiyano@amazon.com>,
	David Arinzon <darinzon@amazon.com>,
	Shannon Nelson <shannon.nelson@amd.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 36/69] net: ena: Fix potential sign extension issue
Date: Mon, 15 Apr 2024 16:21:07 +0200
Message-ID: <20240415141947.250561028@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141946.165870434@linuxfoundation.org>
References: <20240415141946.165870434@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Arinzon <darinzon@amazon.com>

[ Upstream commit 713a85195aad25d8a26786a37b674e3e5ec09e3c ]

Small unsigned types are promoted to larger signed types in
the case of multiplication, the result of which may overflow.
In case the result of such a multiplication has its MSB
turned on, it will be sign extended with '1's.
This changes the multiplication result.

Code example of the phenomenon:
-------------------------------
u16 x, y;
size_t z1, z2;

x = y = 0xffff;
printk("x=%x y=%x\n",x,y);

z1 = x*y;
z2 = (size_t)x*y;

printk("z1=%lx z2=%lx\n", z1, z2);

Output:
-------
x=ffff y=ffff
z1=fffffffffffe0001 z2=fffe0001

The expected result of ffff*ffff is fffe0001, and without the
explicit casting to avoid the unwanted sign extension we got
fffffffffffe0001.

This commit adds an explicit casting to avoid the sign extension
issue.

Fixes: 689b2bdaaa14 ("net: ena: add functions for handling Low Latency Queues in ena_com")
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
Signed-off-by: David Arinzon <darinzon@amazon.com>
Reviewed-by: Shannon Nelson <shannon.nelson@amd.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amazon/ena/ena_com.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_com.c b/drivers/net/ethernet/amazon/ena/ena_com.c
index 633b321d7fdd9..4db689372980e 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_com.c
@@ -362,7 +362,7 @@ static int ena_com_init_io_sq(struct ena_com_dev *ena_dev,
 			ENA_COM_BOUNCE_BUFFER_CNTRL_CNT;
 		io_sq->bounce_buf_ctrl.next_to_use = 0;
 
-		size = io_sq->bounce_buf_ctrl.buffer_size *
+		size = (size_t)io_sq->bounce_buf_ctrl.buffer_size *
 			io_sq->bounce_buf_ctrl.buffers_num;
 
 		dev_node = dev_to_node(ena_dev->dmadev);
-- 
2.43.0



