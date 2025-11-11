Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3817B33C513;
	Tue, 11 Nov 2025 01:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824563; cv=none; b=VYdj8Jj/ccfPECYb3TTnFdqwyRh/xUlKe/hSJmZEMNIWnpa1tqYDzWUOEjNfKVKEHsdA1yFevjgAg1ij9kRyVqcKbTvsdHbup7mOiILhIv0DKvlWjViqupuIh0CxWgq/Tc0KMclm7QkUeYyFjxKGzjk1Pytt/zIxKjXtr9eoQ/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824563; c=relaxed/simple;
	bh=2EiQv7RJimr0oRqvcr8N5YAZEK/LFJxDMf+a4CPdgQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tW9OsfJn5E7uCMfoetQfbwpoX5E2eakJB/790JmAovS3/lcnwg56cVdsCemx89M5xUt0uNPzRqh6c05H+I4/DiigVoUTJpJqb0MQkD5mObwb9SUknrl+/UzkYxQHJxXEfVD/S975v0CSBpybmEYMweQZX83WC8MpPPfhFrB7U2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mtN+pcvb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mtN+pcvb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB890C4CEFB;
	Tue, 11 Nov 2025 01:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824563;
	bh=2EiQv7RJimr0oRqvcr8N5YAZEK/LFJxDMf+a4CPdgQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mtN+pcvbNg5IM2IhqlDnCc0tvzjqKLn8wfI2ZZ+ogWDh3Zo4hiYWI9UkfbeQ3JT4s
	 v9WWN2F5IfALH66pCDCGgawIlzImz74qDk7uN/WIRuxdf1dla0PkNCFgKaKa7pGQXP
	 TbHs8k8ExWZGhTh/WlATcMpuvunJ49TCES5SUs3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Wanner <Ryan.Wanner@microchip.com>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 470/565] clk: at91: clk-master: Add check for divide by 3
Date: Tue, 11 Nov 2025 09:45:26 +0900
Message-ID: <20251111004537.482131580@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Ryan Wanner <Ryan.Wanner@microchip.com>

[ Upstream commit e0237f5635727d64635ec6665e1de9f4cacce35c ]

A potential divider for the master clock is div/3. The register
configuration for div/3 is MASTER_PRES_MAX. The current bit shifting
method does not work for this case. Checking for MASTER_PRES_MAX will
ensure the correct decimal value is stored in the system.

Signed-off-by: Ryan Wanner <Ryan.Wanner@microchip.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/at91/clk-master.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/clk/at91/clk-master.c b/drivers/clk/at91/clk-master.c
index 15c46489ba850..4c87a0f789de1 100644
--- a/drivers/clk/at91/clk-master.c
+++ b/drivers/clk/at91/clk-master.c
@@ -580,6 +580,9 @@ clk_sama7g5_master_recalc_rate(struct clk_hw *hw,
 {
 	struct clk_master *master = to_clk_master(hw);
 
+	if (master->div == MASTER_PRES_MAX)
+		return DIV_ROUND_CLOSEST_ULL(parent_rate, 3);
+
 	return DIV_ROUND_CLOSEST_ULL(parent_rate, (1 << master->div));
 }
 
-- 
2.51.0



