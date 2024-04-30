Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E513D12CD9B;
	Tue, 30 Apr 2024 11:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476031; cv=none; b=XnDZAbvkcAcHZGzG80lwMHoiK2IDgOBO3e+WtlyLrf03JOkFp7owpMZ2P3vLuId2u3n1gg4kC0kKqlkanUEYFV6Za/oHd9R4mFeKDCnWBqJl0OPz3aS2031bBNQd2ZiSb/j9jYsM45fS04KRB4uvJcCC45bnyrpldQ5s9xpK7QY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476031; c=relaxed/simple;
	bh=4UMNnpA0NQjNhmkfhC9eopfMuoeUzdP+4urZn8yR+WY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SE8el207oc3DUn0SetMl9TCjD2i/BHEym0jvpr7CnUU1hP4uVwhiuztWfmCkT59gs0tmV3tGXdvHsYkxiCoA4FzrrR+CNch5x0UwJiUhMfK6aVLtwstT6aSLk8AUdog011KAI5+FTLAEHv2fNL3QyEzhc37+uTQEpQ0Damjz2lE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fbeZ0gZQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fbeZ0gZQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A6C3C2BBFC;
	Tue, 30 Apr 2024 11:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476030;
	bh=4UMNnpA0NQjNhmkfhC9eopfMuoeUzdP+4urZn8yR+WY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fbeZ0gZQ/CDZVYeVXhET179N1JWIiBX+lK97waxNOZ3edeLpkxTEQExh5r9TFgq78
	 v6sOnPCHjZA+B2v/NDkahUxoPM+C7dcLOQpvO1gjVh4jehB3m1xG/LJRSUT9Qwr8Gz
	 F3Ouz/Q3fAW5Ep9/L6EnHG18oZMJrEcUNhUKTBq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arthur Kiyanovski <akiyano@amazon.com>,
	David Arinzon <darinzon@amazon.com>,
	Shannon Nelson <shannon.nelson@amd.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 013/107] net: ena: Fix potential sign extension issue
Date: Tue, 30 Apr 2024 12:39:33 +0200
Message-ID: <20240430103045.052308571@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103044.655968143@linuxfoundation.org>
References: <20240430103044.655968143@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 29700fee42e9d..46a796576f6b6 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_com.c
@@ -374,7 +374,7 @@ static int ena_com_init_io_sq(struct ena_com_dev *ena_dev,
 			ENA_COM_BOUNCE_BUFFER_CNTRL_CNT;
 		io_sq->bounce_buf_ctrl.next_to_use = 0;
 
-		size = io_sq->bounce_buf_ctrl.buffer_size *
+		size = (size_t)io_sq->bounce_buf_ctrl.buffer_size *
 			io_sq->bounce_buf_ctrl.buffers_num;
 
 		dev_node = dev_to_node(ena_dev->dmadev);
-- 
2.43.0



