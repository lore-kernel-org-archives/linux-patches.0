Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32D1A35082F;
	Tue, 26 Aug 2025 14:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217232; cv=none; b=igY7pZQvpdQIarwuTXBMGIyf9nth7n9VcjkM2yLpr9rcQD7F5pzV8UF3jDCVFS7t0yvr6m2c4N6Ns7rZjWi3oq2m1tufURXErG+lZZh1a/yyEd1V0Sp+ckGV6duZDW5dSSUeClwMoXsikQ7oqTLTDFwK0IO9sjtRwIdUjebw8MU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217232; c=relaxed/simple;
	bh=Y6bKuuyNiSeOpOgiG0RxfcJx7Vu4CFyyzp4sLKl8x70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xb+bBuXV/f8Qi+ucB/aKwOK7Dd6wXDyJ+C3XtBRlGXrR4aI4L5enUNdb5z7MRQkWKwcdfRhTR+EulVj3FCgjrQ2U5jWDacHGInJICg9RODwBswrrrrhS/71I+OOGfW5/WvUlRvCJqi9ey4tpqOAO4ICS2MbvXyTCbuom6RPgZaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H8e9FZbE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H8e9FZbE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1506C113D0;
	Tue, 26 Aug 2025 14:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217232;
	bh=Y6bKuuyNiSeOpOgiG0RxfcJx7Vu4CFyyzp4sLKl8x70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H8e9FZbEx+Y2D0hzctzLp3UzL2i3QmnLJ24s7u9uIbfZAn3p3F0f4LgX1KsLFZTF+
	 23RuGBckY5sKnzb4k43EDxRXTdpPvTacu7ZAnlV0tX5HdCN6o6nQ55ottwcJor08mZ
	 CsqqbxP51wsKa/JE1vRnhhgp5sEYOxkRweRrt9Ig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 034/523] net: emaclite: Fix missing pointer increment in aligned_read()
Date: Tue, 26 Aug 2025 13:04:04 +0200
Message-ID: <20250826110925.443765110@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 02b95afe25066..c8bd4880b609d 100644
--- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
+++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
@@ -293,7 +293,7 @@ static void xemaclite_aligned_read(u32 *src_ptr, u8 *dest_ptr,
 
 		/* Read the remaining data */
 		for (; length > 0; length--)
-			*to_u8_ptr = *from_u8_ptr;
+			*to_u8_ptr++ = *from_u8_ptr++;
 	}
 }
 
-- 
2.39.5



