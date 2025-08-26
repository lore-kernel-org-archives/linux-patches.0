Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1EA9350D4E;
	Tue, 26 Aug 2025 14:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218517; cv=none; b=fzaAxiIbxBu8buEgFreLqO9f0AOWFtibq1rl4yO/rsqSulKCFxUt7hh3c0qo5zFfM83leEtaRhwmXi1AO7NV51JGkhz+grIE3scq1c5X8JUhwU8jZ8JBJxz9noew/MyATXE9QWMwLzRFGiRWqk2uj78msn4m9Gv08RKA2sfJGfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218517; c=relaxed/simple;
	bh=cME+I6NEOFQfpRJGF3L2b+2d/KgB06N2TMHaP3IsWLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jmq8+8KG4XH9SSB/qdLljX93mlKquKCmq/8RFFH9180qplW4IkO0a14UmHwL/TB7hLdoqm3Y21552AssZ70Z1lgUd6lBzTPgSigwWYY/pMY+wWBHLcbSnZuxseAfs/ovUfWMmUAhkSx/fyhMJZOpLaYV917rRy98ZJIAw9HyrWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j+M+BKDF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j+M+BKDF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B9DCC4CEF1;
	Tue, 26 Aug 2025 14:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218517;
	bh=cME+I6NEOFQfpRJGF3L2b+2d/KgB06N2TMHaP3IsWLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j+M+BKDFWJLQkxuNoHeRpcyzFVt+K7Urm85gtCSIKOnDeNe6+6MNX4cS6cYv1NxFU
	 LvtC65yYRWvnADBDXRSqw/k7KWupHztRnAsuVvBuST3TUoU2imjn0cfTGB0L2qTc4J
	 qDv21yNUtyV9r5CBhtAvNXR4Lk7OKckC6/KUNtd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 031/403] net: emaclite: Fix missing pointer increment in aligned_read()
Date: Tue, 26 Aug 2025 13:05:57 +0200
Message-ID: <20250826110906.672492986@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 951482d899f9f..a834a0c7f7705 100644
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



