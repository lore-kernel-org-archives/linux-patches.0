Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15B7C1CF7A2;
	Tue,  8 Oct 2024 12:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390259; cv=none; b=mHcxmVlq11dbk1V8CYHJJoKIGAlLUKOkdv/WE/NwTlQXP/YLxwQt0L5Kf/PjIhC9X22ygcSpMqcZJ3zHRNd9U6WQ/3uoQFipoUmAF5OOZZDpHO0w/D1xpuHXrTEVz+RZSTl6GKhP4ZkVbzWSXW1nCoEtcuek4EUNk4KQHXiuE1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390259; c=relaxed/simple;
	bh=xiXtpR2ZNL+Um93SNZD9cTNxkFSbjXWNL2gRFQC3gQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bDlMV9D2Rsl7yg4Nvv+EP9OSrk9TJ1A6JOPIIJO9ynCSvU1FsuuWzA2nBGRds0lyyiHG6/g70XMJQb4bQrCb24fLinoY42a524G3fCMWPCj2nA224KZAlK8yPlkkIXKUxnT2ph1xm42WNKN0KZIYx4X2i+KH3RUeH3orsNExWVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p40ZIn3R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p40ZIn3R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C148C4CEC7;
	Tue,  8 Oct 2024 12:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390259;
	bh=xiXtpR2ZNL+Um93SNZD9cTNxkFSbjXWNL2gRFQC3gQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p40ZIn3R5JVIbQHijXkf/Z/RrPmGt8LOvvTmQsP6FHrP/DlfVOuna5lPiKQhdNojf
	 mNBe3g0OnrjsF3gtZbomdbo5umKmmA7K3mRDt2OKfCW2JR6yDiARbYtQv2O4f9HwSZ
	 cjjT0Quc6uosNhXQMmmeJO04DxdYouUioAoYq1G4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 238/482] of/irq: Refer to actual buffer size in of_irq_parse_one()
Date: Tue,  8 Oct 2024 14:05:01 +0200
Message-ID: <20241008115657.662983995@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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



