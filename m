Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE5972EACEE;
	Tue, 22 Jul 2025 14:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193608; cv=none; b=b4RNoeX0dyV8D5RN5yy89lNq7wbaoAtR7teRVHAKbwxWr004GJLvxATeKgLKRcG+cuObuIgSMVxqH1W8qYtm9wsyPhIrRBChN4QLKABVaIlbC7R9gmZIuL+n8GEb33JrjrXXxbLnn+g4a4zouteEwjCjzULuaKYU+zZN9hWx8+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193608; c=relaxed/simple;
	bh=pkO31r+I7tn6kI0CVt+XxllLdybK5duPsdu5TGEG5X8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qO8/Bt9hjMlCFO+IGB6GCGpR2rBTEB/4KDbn51cspjh1AZQhoubn0mOvvVitSUfK7PaQAaYizsQw+2bMAS+6s0UdoI38LZlQTNq8qRHFMUSUxD7fataJRwsUgqJavhfX/1JeIv1D9/J6dQrn9dvoERmFsNE4s1q0QqarcjiEnj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PfnhzLAV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PfnhzLAV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E5D3C4CEEB;
	Tue, 22 Jul 2025 14:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193607;
	bh=pkO31r+I7tn6kI0CVt+XxllLdybK5duPsdu5TGEG5X8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PfnhzLAVjGQuu7iFvehGiIONjqZRHUlV+onWvAue2yD/jQ2hDGgAvHcQn3TwMfsRK
	 c2lfN3vieMK7AcAaW8FQkXrsXsk9Z0/m89Xp59UGaNV86IOy6D5+DN0dDAcLkai5K8
	 Ui59zgKKte0O/m41WUbu8wkI6ojoTqk4nZLio1A8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 110/187] net: emaclite: Fix missing pointer increment in aligned_read()
Date: Tue, 22 Jul 2025 15:44:40 +0200
Message-ID: <20250722134349.863054669@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index ecf47107146dc..4719d40a63ba3 100644
--- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
+++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
@@ -286,7 +286,7 @@ static void xemaclite_aligned_read(u32 *src_ptr, u8 *dest_ptr,
 
 		/* Read the remaining data */
 		for (; length > 0; length--)
-			*to_u8_ptr = *from_u8_ptr;
+			*to_u8_ptr++ = *from_u8_ptr++;
 	}
 }
 
-- 
2.39.5



