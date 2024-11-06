Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A526F1DF252;
	Wed,  6 Nov 2024 12:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895424; cv=none; b=pYy1dHtZhQcSiHP4cMv/olQwFYMshOIBbpE6n6otndUhOQGzppoaTP1mdTX1QCxAZoz6b74ztWnjthbF5rKLBL1GEkujMdsZjXTdSl8N7jU2iFfvreY+wYi1IA7SW0/pIau7Pyxuk90KI1LOS8ol26xIIrO6eRtNakObcTRWndo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895424; c=relaxed/simple;
	bh=6dxmWmRyWe1831x0ghUTUVOHUfrpOToGjtychOiJji0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=plvDn53OQ8ja91w4Oafwd0EYJDTurIDzVWJrGkBaYScBH9CbS3QsS5jZf7cJfWrVv4mwsTdiEoCj5OOGtSbz1L++VMkcyJKaWlxCHtC6PTGXISy4XoOo/EbTBv6N0fXrdP7BeKBJ4+OKtl9rgmJp2RuTZv/4Ll+9A9EUznQhwww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0oAWGEpT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0oAWGEpT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F337EC4CECD;
	Wed,  6 Nov 2024 12:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895424;
	bh=6dxmWmRyWe1831x0ghUTUVOHUfrpOToGjtychOiJji0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0oAWGEpT+SZn5vC1pXDMa22qEdQDFrlHnXXCNAvN6mLK7Vy5g3caZYT2FqU4+IE6I
	 u8HHLI48utvSpG3aN5GkapddxxZukDQ8XhlNxVxjzcGn1U3LiSSznuDiuhHeysoxzU
	 3JMdztQEWBJBDSymX8ddJEXCPSNnjgUeQbo7Rs/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 177/350] of/irq: Refer to actual buffer size in of_irq_parse_one()
Date: Wed,  6 Nov 2024 13:01:45 +0100
Message-ID: <20241106120325.302695012@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index f06c9df60e34d..35d83888071ea 100644
--- a/drivers/of/irq.c
+++ b/drivers/of/irq.c
@@ -302,8 +302,8 @@ int of_irq_parse_one(struct device_node *device, int index, struct of_phandle_ar
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



