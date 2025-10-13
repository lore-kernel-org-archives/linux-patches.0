Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6738E2FB978;
	Mon, 13 Oct 2025 15:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368936; cv=none; b=SxBs1FlokS78rL+ohiroFjjXO60vlFnigkDeLbfLDlDqXCgYJveCwRtdkiEaS6AmgpBqx+mZyUqXPHRppw3ZTy4MKx72rFPgy66/nMivmlbKTOhFazn8ncvoqZWe8MCTX5LnduxmnTZOoDIxTIMYzegoyU31cF9XVxan90KlXKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368936; c=relaxed/simple;
	bh=lSo3+/Tl4u93n7hhFsdozMZfk6fFTE/wb9eUxZUC4cY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P5MBYYLuJJWQzV4m/rwYNADwtvlf6DqEFRiTlGQ+JHEwbR3ZXP8IqE8FeqiQ57dxKALXqUJ5GbyxWBq4OEGe6AlP2AcEs7BcV0tmXqCs/siifHLJVWQwDLu8WkKkGEADvdQ21TchBgy/ZlWCd5Yr+VT8GpltRaeKGdcTJSNuXQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zEMbuZwg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zEMbuZwg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91DFEC116B1;
	Mon, 13 Oct 2025 15:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368935;
	bh=lSo3+/Tl4u93n7hhFsdozMZfk6fFTE/wb9eUxZUC4cY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zEMbuZwggB97Y1nEEuBrfH5Qii58F0gZrtzYSL+AdiMdXmFTxfM08wKzGuT9dvkVM
	 zDuLlD4aEDA4R78ru2moVqbS0dF+AeGvZcZ7LUne2MjrfTQaOTiqgu4l7h4R5ZwKOq
	 1FXMpprmBxQ+veWMXCe8KO2n/Ssb6wV38U3iyuDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sneh Mankad <sneh.mankad@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 071/563] soc: qcom: rpmh-rsc: Unconditionally clear _TRIGGER bit for TCS
Date: Mon, 13 Oct 2025 16:38:52 +0200
Message-ID: <20251013144413.864602044@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sneh Mankad <sneh.mankad@oss.qualcomm.com>

[ Upstream commit f87412d18edb5b8393eb8cb1c2d4a54f90185a21 ]

Unconditionally clear the TCS_AMC_MODE_TRIGGER bit when a
transaction completes. Previously this bit was only cleared when
a wake TCS was borrowed as an AMC TCS but not for dedicated
AMC TCS. Leaving this bit set for AMC TCS and entering deeper low
power modes can generate a false completion IRQ.

Prevent this scenario by always clearing the TCS_AMC_MODE_TRIGGER
bit upon receiving a completion IRQ.

Fixes: 15b3bf61b8d4 ("soc: qcom: rpmh-rsc: Clear active mode configuration for wake TCS")
Signed-off-by: Sneh Mankad <sneh.mankad@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250825-rpmh_rsc_change-v1-1-138202c31bf6@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/rpmh-rsc.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/soc/qcom/rpmh-rsc.c b/drivers/soc/qcom/rpmh-rsc.c
index fdab2b1067dbb..c6f7d5c9c493d 100644
--- a/drivers/soc/qcom/rpmh-rsc.c
+++ b/drivers/soc/qcom/rpmh-rsc.c
@@ -453,13 +453,10 @@ static irqreturn_t tcs_tx_done(int irq, void *p)
 
 		trace_rpmh_tx_done(drv, i, req);
 
-		/*
-		 * If wake tcs was re-purposed for sending active
-		 * votes, clear AMC trigger & enable modes and
+		/* Clear AMC trigger & enable modes and
 		 * disable interrupt for this TCS
 		 */
-		if (!drv->tcs[ACTIVE_TCS].num_tcs)
-			__tcs_set_trigger(drv, i, false);
+		__tcs_set_trigger(drv, i, false);
 skip:
 		/* Reclaim the TCS */
 		write_tcs_reg(drv, drv->regs[RSC_DRV_CMD_ENABLE], i, 0);
-- 
2.51.0



