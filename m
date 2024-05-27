Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 523A726ACA;
	Mon, 27 May 2024 19:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836908; cv=none; b=l4IpiT88DF3kGthVgDiv26FE9q+8kh4HvbFzi9sqr/2HDrZImvzPgRlJ3Ss994nQpq1Nem2PFMrB+ZdzHCQjZz0tGBmwi4IyAgXWv8pXSVzL/rjZdgezBHlzGMeS9l/q0sg3s4UeFIOSXTrg6dLOtaDPC2pr9UmIUzEG4ychQY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836908; c=relaxed/simple;
	bh=apXyX0m3vpohQmVgU/J5lMRL1mGqmMC2iqcUdlrLPEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=luU6Hqj+yqKFy9pFcJuhJQTWrY1g966op40PB0oDm8Vs3AaF0F1PK3uUETNfR+IGo7CZku6ETVzSAuQxf1ZdZyZ2LWNfKiXac64REffyS1VHMG0O5GKWpMLYxCNiXS9O9DTUDgYFbn2yh87PiJBwjSXlxEGgIkvB872/87emE5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y/5XWdOh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y/5XWdOh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCAA4C2BBFC;
	Mon, 27 May 2024 19:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836908;
	bh=apXyX0m3vpohQmVgU/J5lMRL1mGqmMC2iqcUdlrLPEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y/5XWdOhyjNBREQ0zpdoJ+5EgvFwcxQiMwuPfgEmjeKteIYpF1qwGkZZcOg0bKGJ8
	 txVFS+GahXUCGm+p8luMypP5SpyBpjaOD/+abu4qj55b/7BwUFcv6bXLOmyLZoyZC2
	 7cPaKC1jdJ1EP+NzGMdZjTfN2/uMlTc0a1lVHY0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 236/427] ptp: ocp: fix DPLL functions
Date: Mon, 27 May 2024 20:54:43 +0200
Message-ID: <20240527185624.514775260@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vadim Fedorenko <vadim.fedorenko@linux.dev>

[ Upstream commit a2c78977950da00aca83a3f8865d1f54e715770d ]

In ptp_ocp driver pin actions assume sma_nr starts with 1, but for DPLL
subsystem callback 0-based index was used. Fix it providing proper index.

Fixes: 09eeb3aecc6c ("ptp_ocp: implement DPLL ops")
Signed-off-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Link: https://lore.kernel.org/r/20240508132111.11545-1-vadim.fedorenko@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_ocp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 6506cfb89aa94..ee2ced88ab34f 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -4562,7 +4562,7 @@ static int ptp_ocp_dpll_direction_set(const struct dpll_pin *pin,
 		return -EOPNOTSUPP;
 	mode = direction == DPLL_PIN_DIRECTION_INPUT ?
 			    SMA_MODE_IN : SMA_MODE_OUT;
-	return ptp_ocp_sma_store_val(bp, 0, mode, sma_nr);
+	return ptp_ocp_sma_store_val(bp, 0, mode, sma_nr + 1);
 }
 
 static int ptp_ocp_dpll_frequency_set(const struct dpll_pin *pin,
@@ -4583,7 +4583,7 @@ static int ptp_ocp_dpll_frequency_set(const struct dpll_pin *pin,
 	tbl = bp->sma_op->tbl[sma->mode];
 	for (i = 0; tbl[i].name; i++)
 		if (tbl[i].frequency == frequency)
-			return ptp_ocp_sma_store_val(bp, i, sma->mode, sma_nr);
+			return ptp_ocp_sma_store_val(bp, i, sma->mode, sma_nr + 1);
 	return -EINVAL;
 }
 
@@ -4600,7 +4600,7 @@ static int ptp_ocp_dpll_frequency_get(const struct dpll_pin *pin,
 	u32 val;
 	int i;
 
-	val = bp->sma_op->get(bp, sma_nr);
+	val = bp->sma_op->get(bp, sma_nr + 1);
 	tbl = bp->sma_op->tbl[sma->mode];
 	for (i = 0; tbl[i].name; i++)
 		if (val == tbl[i].value) {
-- 
2.43.0



