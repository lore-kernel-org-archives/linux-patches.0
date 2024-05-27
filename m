Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A03C262BE;
	Mon, 27 May 2024 19:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838191; cv=none; b=V+1z3tl6Kq77tBt8JIVr/vKkORp9PK04WgajxIbRVb39ml2Nks0NsQ9l0FewQIKUU7Njhmo1uNHN/IiezBpDoFMhwQG4bdx3EWT1PiqEoFe+UrMq5JIU2MCbxnbqSw68HEQ1Fve/6VOMyE90U5XMODlw5J5gFIOkTMwUMzjjtS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838191; c=relaxed/simple;
	bh=cdDbtWLRi5K0wHCH3l0lVIUWlm5keOitGJ3NihutZkw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TBfdvVwZ2U28vM0aVsGXxA7blAjcJcbd847lIfrfi36Qr5SC27QhTNlp6vQrNmAtS+iaBIRHI0yu7aVWkaflpTQ0MdRlKph7K554Fi40QDIQd8+wph0xqyNaWMyQ+E1GwSwDw9YrnTVGsyMEysBxeCg2Eo1ghU18DNYowt7Zhlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PfKTtZH1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PfKTtZH1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3EBAC2BBFC;
	Mon, 27 May 2024 19:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838191;
	bh=cdDbtWLRi5K0wHCH3l0lVIUWlm5keOitGJ3NihutZkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PfKTtZH1rwt+SoYGcL6ntXDwsEuYFvBFwQVBxDxG9npsOTC1pYOQ+dDcLsevanRrS
	 01fsCnEBVb6fsVppomy+afevO2nMlOQP0elZGJDVr9OTb2+U/AUGB4zxlt+/q+12aO
	 JXQQZ8fImVuO0IoUWnf6WHxWCwtjpyGb9849tT8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 300/493] ptp: ocp: fix DPLL functions
Date: Mon, 27 May 2024 20:55:02 +0200
Message-ID: <20240527185640.118978457@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 5f858e426bbd5..05b8f325a887d 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -4277,7 +4277,7 @@ static int ptp_ocp_dpll_direction_set(const struct dpll_pin *pin,
 		return -EOPNOTSUPP;
 	mode = direction == DPLL_PIN_DIRECTION_INPUT ?
 			    SMA_MODE_IN : SMA_MODE_OUT;
-	return ptp_ocp_sma_store_val(bp, 0, mode, sma_nr);
+	return ptp_ocp_sma_store_val(bp, 0, mode, sma_nr + 1);
 }
 
 static int ptp_ocp_dpll_frequency_set(const struct dpll_pin *pin,
@@ -4298,7 +4298,7 @@ static int ptp_ocp_dpll_frequency_set(const struct dpll_pin *pin,
 	tbl = bp->sma_op->tbl[sma->mode];
 	for (i = 0; tbl[i].name; i++)
 		if (tbl[i].frequency == frequency)
-			return ptp_ocp_sma_store_val(bp, i, sma->mode, sma_nr);
+			return ptp_ocp_sma_store_val(bp, i, sma->mode, sma_nr + 1);
 	return -EINVAL;
 }
 
@@ -4315,7 +4315,7 @@ static int ptp_ocp_dpll_frequency_get(const struct dpll_pin *pin,
 	u32 val;
 	int i;
 
-	val = bp->sma_op->get(bp, sma_nr);
+	val = bp->sma_op->get(bp, sma_nr + 1);
 	tbl = bp->sma_op->tbl[sma->mode];
 	for (i = 0; tbl[i].name; i++)
 		if (val == tbl[i].value) {
-- 
2.43.0



