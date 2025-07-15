Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBFB32DEA96;
	Tue, 15 Jul 2025 13:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587550; cv=none; b=ICikG79YQfi14pF6QAi0MYrTApekEbqJ3hrcLt+oyU419b1sdtT3SRqY4G+hYc8ADIUrYr6iNPOsdAptD+u0xMF5QsvGtbu3YS4stc6Modal2jbPLHnFaDDduviXYiaGDcbXchVIrOfQ/C2/+LQznKmE/TRHH42eVLbPy+b1qow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587550; c=relaxed/simple;
	bh=ey6NyqYRBQL77DevxA5d7mNDKQPdQDNhXV7JTWWfXKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NvlTbupoIckF1umZcdTCwOePCyZyxQ4U31oVzZ/OI12t0GBv76lL2k3FHDeYbn0P6qoKzeY7Ra6qyXBH1WEv8uh/x3Wt+/NTPosu9IJghzM8QhABjswoa5Q0Ge4t5Bh7NSPKO0nKt1ZY3kYSWNNmP+PptJIXXkT9HsPUmEWdAzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ax/wESwW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ax/wESwW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E124C4CEE3;
	Tue, 15 Jul 2025 13:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587550;
	bh=ey6NyqYRBQL77DevxA5d7mNDKQPdQDNhXV7JTWWfXKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ax/wESwWOy3LQK/HwiKJucf1sZMgfTIt50xkAsrlk4XNvvWtU87rZcBNjGx6BdOwZ
	 t5FFMzSV4gzuJ6L7qJWoLYZx31KTq+cn8hsxq7Clf97GW2HxhGfaPhsqF0TCeN6zGx
	 eOky5HPxDINRuECldZtLyOIOitcZ7rbJsYXJuC8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Wei Fang <wei.fang@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 054/208] net: enetc: Correct endianness handling in _enetc_rd_reg64
Date: Tue, 15 Jul 2025 15:12:43 +0200
Message-ID: <20250715130813.114455635@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

From: Simon Horman <horms@kernel.org>

[ Upstream commit 7b515f35a911fdc31fbde6531828dcd6ae9803d3 ]

enetc_hw.h provides two versions of _enetc_rd_reg64.
One which simply calls ioread64() when available.
And another that composes the 64-bit result from ioread32() calls.

In the second case the code appears to assume that each ioread32() call
returns a little-endian value. However both the shift and logical or
used to compose the return value would not work correctly on big endian
systems if this were the case. Moreover, this is inconsistent with the
first case where the return value of ioread64() is assumed to be in host
byte order.

It appears that the correct approach is for both versions to treat the
return value of ioread*() functions as being in host byte order. And
this patch corrects the ioread32()-based version to do so.

This is a bug but would only manifest on big endian systems
that make use of the ioread32-based implementation of _enetc_rd_reg64.
While all in-tree users of this driver are little endian and
make use of the ioread64-based implementation of _enetc_rd_reg64.
Thus, no in-tree user of this driver is affected by this bug.

Flagged by Sparse.
Compile tested only.

Fixes: 16eb4c85c964 ("enetc: Add ethtool statistics")
Closes: https://lore.kernel.org/all/AM9PR04MB850500D3FC24FE23DEFCEA158879A@AM9PR04MB8505.eurprd04.prod.outlook.com/
Signed-off-by: Simon Horman <horms@kernel.org>
Reviewed-by: Wei Fang <wei.fang@nxp.com>
Link: https://patch.msgid.link/20250624-etnetc-le-v1-1-a73a95d96e4e@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/enetc_hw.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_hw.h b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
index 2b90a345507b8..e0a58471ff592 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
@@ -444,7 +444,7 @@ static inline u64 _enetc_rd_reg64(void __iomem *reg)
 		tmp = ioread32(reg + 4);
 	} while (high != tmp);
 
-	return le64_to_cpu((__le64)high << 32 | low);
+	return (u64)high << 32 | low;
 }
 #endif
 
-- 
2.39.5



