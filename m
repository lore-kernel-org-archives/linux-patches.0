Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DF73303A28;
	Wed,  3 Dec 2025 16:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777952; cv=none; b=Qokcnsaxi1Zxwf1uJxKc/8UedJs5xoA/gNn07g0zMt4KMZjfU/7xUqtKPDJI1JOK06Iwez5BQ/092DOQGwbVYY9VG82jsa7GY7JmGrMksBw6WE46xTZ3/6pMd14rO5719WfBuvVH4V5evn4QdO9gf1tnQGnPExKYtAdJDiQMPxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777952; c=relaxed/simple;
	bh=Ei2l36Wq9BD/HFPStXUOxlWa8Bg/alQobCroVNQDKNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tZ3t02NYaQG+EAkHi5yor3JGboqdAS5wdYCbtG7OzojK7K1wAel2D59IecDYtfY/6qeLobfCKrGa4Z/pTEkd5WGhchD2qsHXy18s0rF6hQ3oY9JXPWRHELmYeuryxeZsy8UeMIk8a0QA/j7BAWwWzoQQT9I5Hm/bTqh7SEZIHXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IhOlFpux; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IhOlFpux"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0E64C4CEF5;
	Wed,  3 Dec 2025 16:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777952;
	bh=Ei2l36Wq9BD/HFPStXUOxlWa8Bg/alQobCroVNQDKNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IhOlFpuxuficMzV6bdqSIC6sZNWOPCs6Lf0yA3QUVJ21vYKN+BBMinhtfVpLcjsWf
	 lxkOsyaLnSQ+Sq4GRF1umSxDMjsUBQ46u7WwoDX0fnY+BvYa9vXmtKu+p8VOalWiiy
	 44Nro7q3YIry1TYj8Tq3+naYOjptwXFqEfARIbhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Wanner <Ryan.Wanner@microchip.com>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 196/392] clk: at91: clk-master: Add check for divide by 3
Date: Wed,  3 Dec 2025 16:25:46 +0100
Message-ID: <20251203152421.285590977@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 04d0dd8385945..3f4a071e4dab4 100644
--- a/drivers/clk/at91/clk-master.c
+++ b/drivers/clk/at91/clk-master.c
@@ -437,6 +437,9 @@ clk_sama7g5_master_recalc_rate(struct clk_hw *hw,
 {
 	struct clk_master *master = to_clk_master(hw);
 
+	if (master->div == MASTER_PRES_MAX)
+		return DIV_ROUND_CLOSEST_ULL(parent_rate, 3);
+
 	return DIV_ROUND_CLOSEST_ULL(parent_rate, (1 << master->div));
 }
 
-- 
2.51.0



