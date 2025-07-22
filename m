Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAFD82DC32B;
	Tue, 22 Jul 2025 13:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192435; cv=none; b=DLCdLij9X6uTzJdU6jVSk+PlayXcz4o9K/GJ8ob/pAnQdFGZyFU+JQZOkggvuI5yeU2GQ2GG1TeX/ni1lGJPSrFeIairX3n7XwG7AUbQknPyu1Sx6nSE8d7u6nWA4hFQZ0LuKyGzlnk9zEUMBCJ5npIAVt+gRdyB1Nse/fKU44I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192435; c=relaxed/simple;
	bh=nkMuxkOJMesAmBGufn+2ieOgfoj1IzGpJGVbF+ReVNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WoJKDTN4m92wUmGzBHsPQu8vFFuKyTSWsec1zrFC/Hdav1b9DoYHXFnDj18mUke7zMcQYMM9nxzmXkma7S4d+sqX/0tppANcqpNAsXNf2EKTkCiBNWMJchnFuZTYDNxZZh1TdA/RKLXd/A2jJGNaxQCRZYrd7Vol6tn4eQUms1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OYrIQDcn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OYrIQDcn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CDAAC4CEEB;
	Tue, 22 Jul 2025 13:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192434;
	bh=nkMuxkOJMesAmBGufn+2ieOgfoj1IzGpJGVbF+ReVNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OYrIQDcnww7GioRclfKUnoqd45xOXbTGx27j4DgLwlq1a4nECucSX1Y47A2PbfwQh
	 d82n2X4OcPqkOce1cj9ryS4wXPdbIml6O4zCkjfMtUxZqyE9v/zc2HdBOJfs6mZBKT
	 +TIKR3J97iBg+AdZBdNFTxhh5fFvqGrGKgSi9NBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 063/111] net: emaclite: Fix missing pointer increment in aligned_read()
Date: Tue, 22 Jul 2025 15:44:38 +0200
Message-ID: <20250722134335.731897331@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134333.375479548@linuxfoundation.org>
References: <20250722134333.375479548@linuxfoundation.org>
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

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit 7727ec1523d7973defa1dff8f9c0aad288d04008 ]

Add missing post-increment operators for byte pointers in the
loop that copies remaining bytes in xemaclite_aligned_read().
Without the increment, the same byte was written repeatedly
to the destination.
This update aligns with xemaclite_aligned_write()

Fixes: bb81b2ddfa19 ("net: add Xilinx emac lite device driver")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Link: https://patch.msgid.link/20250710173849.2381003-1-alok.a.tiwari@oracle.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xilinx/xilinx_emaclite.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
index b358ecc672278..0eff5d4fe35df 100644
--- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
+++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
@@ -285,7 +285,7 @@ static void xemaclite_aligned_read(u32 *src_ptr, u8 *dest_ptr,
 
 		/* Read the remaining data */
 		for (; length > 0; length--)
-			*to_u8_ptr = *from_u8_ptr;
+			*to_u8_ptr++ = *from_u8_ptr++;
 	}
 }
 
-- 
2.39.5



