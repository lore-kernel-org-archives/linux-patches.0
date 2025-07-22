Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40071548EE;
	Tue, 22 Jul 2025 14:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192897; cv=none; b=WD75E23PgShP0CWIHPx2VnkGyLDqeVdbcVW/R09AiBOk41kqsEwrD96pGJGRjaXq3OUZZuOjeNe0t0MzqE+jD0mrazDIMVIM+DTJdw0ZR5M7AKbhJWcLnnhxlsR+DLi3QHTNQ3xbp6AlROSBfFUa0Ddm9KG99lnNCXy8rtzN2Rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192897; c=relaxed/simple;
	bh=a31M/d2Q5YZkXc0I2gtZoqXr5L91Wfm80ROcfdsbBxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U0VUdtLVgRr6E6aFTq3UN5QaC0lD4gSXeS9SV5hDYYDBDBXJqc6heZpTfA8TaJCcPFmD7FNyOJQ7o+3JPTFzHUm9fIWFOhW4PkPhJXqiV/YPDzIUlvNJlcFK7Qbyzj88kqwz4iMZ/nZ64qQ0ThgPSVn0poalvN7i0XcxARjKUuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iwQDJ9qB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iwQDJ9qB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFBBCC4CEEB;
	Tue, 22 Jul 2025 14:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192897;
	bh=a31M/d2Q5YZkXc0I2gtZoqXr5L91Wfm80ROcfdsbBxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iwQDJ9qBoTn0E2id3reOOzzFihzopKLlI06emVmg93Ub4utvMSFnCIc2s+wcIj/i/
	 bWNLtM6qT4HwOZ3GaSwcKJZvdUf4PO0QA7lUGvkJFlhyvNVdH/+5E95VLQlIgv4hjY
	 MUalhTsr6MvqRNHIBB7y32xyeDvB89r8gj2nndU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 090/158] net: emaclite: Fix missing pointer increment in aligned_read()
Date: Tue, 22 Jul 2025 15:44:34 +0200
Message-ID: <20250722134344.120307303@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
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
index 940452d0a4d2a..258096543b08a 100644
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



