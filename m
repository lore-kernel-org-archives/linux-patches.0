Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C642FA63F;
	Tue, 17 Jun 2025 16:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179164; cv=none; b=RoOLJrKz1aHY+u76UyF/ziTjsRlPN93qaeamPjqK2VQkae1WYB/kBOHK+kGFH39+dKP3+Wa3f2o/HoBfQcHwaLKMWrg1jnSM0b7tEVo1UHsrIiU7mtCJfvgzsY6tWs/XXKCxXk/JeR2DuuiF7Xm1INTNUsRBz01dv8giXBWaU0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179164; c=relaxed/simple;
	bh=rjXIossGE1O0SzeLBLti8LhdsQDuudpprau3E22E5pQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sLwoG9WvzbOYwXolBWyWJT+vDeqInL7X2bKPDFl9JCpJYFnl+qnFRAGBu+6lnxiEo4m9pqf2YhumnVjpWnVavJwtRLMOkWYVQx6IUCIdFMUPyJgTWx5I5uUE7rNyxUPOeYGMeKWiQSTgufUNar0/sDpd0JVaU5do9+uLcojYF6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z3pwDr5A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z3pwDr5A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B935C4CEE3;
	Tue, 17 Jun 2025 16:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179162;
	bh=rjXIossGE1O0SzeLBLti8LhdsQDuudpprau3E22E5pQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z3pwDr5AQk8O3i2z4GkCf5r8oxpyBrOl1vx/9Kl8i6Llyh2j7rgG7WLkigMujLtUA
	 cuSsYp78XTaFdIOFY17w62Ce1TUgl6/7zVU8bY1nGlnGwXHb5gH3lovuRnWKizJ091
	 aZE5eagh9f9DcZd2pwyM7hLo9+SRNyZv4pANZRhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>,
	Kiran K <kiran.k@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 666/780] Bluetooth: btintel_pcie: Reduce driver buffer posting to prevent race condition
Date: Tue, 17 Jun 2025 17:26:14 +0200
Message-ID: <20250617152518.589762287@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

From: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>

[ Upstream commit bf2ffc4d14db29cab781549912d2dc69127f4d3e ]

Modify the driver to post 3 fewer buffers than the maximum rx buffers
(64) allowed for the firmware. This change mitigates a hardware issue
causing a race condition in the firmware, improving stability and data
handling.

Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
Signed-off-by: Kiran K <kiran.k@intel.com>
Fixes: c2b636b3f788 ("Bluetooth: btintel_pcie: Add support for PCIe transport")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btintel_pcie.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btintel_pcie.c b/drivers/bluetooth/btintel_pcie.c
index a4883523ccc9e..385e29367dd1d 100644
--- a/drivers/bluetooth/btintel_pcie.c
+++ b/drivers/bluetooth/btintel_pcie.c
@@ -305,7 +305,11 @@ static int btintel_pcie_start_rx(struct btintel_pcie_data *data)
 	int i, ret;
 	struct rxq *rxq = &data->rxq;
 
-	for (i = 0; i < rxq->count; i++) {
+	/* Post (BTINTEL_PCIE_RX_DESCS_COUNT - 3) buffers to overcome the
+	 * hardware issues leading to race condition at the firmware.
+	 */
+
+	for (i = 0; i < rxq->count - 3; i++) {
 		ret = btintel_pcie_submit_rx(data);
 		if (ret)
 			return ret;
-- 
2.39.5



