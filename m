Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E69E3128C9;
	Mon, 27 Oct 2025 18:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591187; cv=none; b=qUn47jlvikcxyvlDknWpt22e4wOLTWj4HT3Dg+DovZrkARzNrDY8IsgNrP1NuJDJd8o9DfziF2SSft2urIHBTdA9qDhLmqBi1bu+GKM9XtRMsEUTJNqQKq4k1Kt9AmJLKGDX9xDgIGNKoFMYap/nPkN7wWRLSCX0+G0ij71LG4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591187; c=relaxed/simple;
	bh=871enaCyVnzKaAcIFoLCB0Uf8ny6DwoJqiyCyKAh048=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gnR1G2rwy1HypgNlC3o5xIpknkVKkH6OP0bhgsgbkmxK+HRVQnmUT/mZ0icMyf4KDmlxju7tVukvGYQ5IwIorHNIq6bsTJFq2xbMA6WIAcEnU7FRiv1MJ+3FUrv/ver4ybhlH/Qg8mQOcaJzkocIA86oiMipha+aCRcZUhZoFOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q8s73cVH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q8s73cVH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14F09C4CEF1;
	Mon, 27 Oct 2025 18:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591187;
	bh=871enaCyVnzKaAcIFoLCB0Uf8ny6DwoJqiyCyKAh048=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q8s73cVH6hyYnJILNqLSXhZRDpsJarUiktjhxhGLxHpeCL1akCVvJuvPJlAm4bM7e
	 7LW8Y8xAIz5kCby+GAUlV37+znAtlmuRnHurisAWZQPQchZQ6qL4I1yIam+U+wylsV
	 S28Ulqs2Qt1Enr91zjA7vL0YsHccWuj+Wh07PTUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Sverdlin <alexander.sverdlin@gmail.com>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 100/332] clk: at91: peripheral: fix return value
Date: Mon, 27 Oct 2025 19:32:33 +0100
Message-ID: <20251027183527.260158743@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Masney <bmasney@redhat.com>

[ Upstream commit 47b13635dabc14f1c2fdcaa5468b47ddadbdd1b5 ]

determine_rate() is expected to return an error code, or 0 on success.
clk_sam9x5_peripheral_determine_rate() has a branch that returns the
parent rate on a certain case. This is the behavior of round_rate(),
so let's go ahead and fix this by setting req->rate.

Fixes: b4c115c76184f ("clk: at91: clk-peripheral: add support for changeable parent rate")
Reviewed-by: Alexander Sverdlin <alexander.sverdlin@gmail.com>
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/at91/clk-peripheral.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/at91/clk-peripheral.c b/drivers/clk/at91/clk-peripheral.c
index 7a27ba8e05779..7605ab23dc8ed 100644
--- a/drivers/clk/at91/clk-peripheral.c
+++ b/drivers/clk/at91/clk-peripheral.c
@@ -268,8 +268,11 @@ static int clk_sam9x5_peripheral_determine_rate(struct clk_hw *hw,
 	long best_diff = LONG_MIN;
 	u32 shift;
 
-	if (periph->id < PERIPHERAL_ID_MIN || !periph->range.max)
-		return parent_rate;
+	if (periph->id < PERIPHERAL_ID_MIN || !periph->range.max) {
+		req->rate = parent_rate;
+
+		return 0;
+	}
 
 	/* Fist step: check the available dividers. */
 	for (shift = 0; shift <= PERIPHERAL_MAX_SHIFT; shift++) {
-- 
2.51.0



