Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48B6B330B1C;
	Fri, 17 Oct 2025 15:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715985; cv=none; b=CzlRMLrmIZQHhG6btqiQOGVp/7ugugLUPAg8tlOOMdV06zPJw3Mz10/2PHWgqgvYBpkKQmitLr8Jh8PwcGRYo2+c0nRsHzkei0YB/4hTr7rv9zXouXCmeRt51kp1Ccmse6LUSdp8sdXEfxplQkq3s4569MNsdXz53JSyZJMNyL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715985; c=relaxed/simple;
	bh=3rWlyWEyQLjjcLU1n/Lw/96I/AsKqiUHx+5h7595jso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gV7klninXJ5S8vDxAg+5JjO//9L1/6Dstg2SYIIOaxVlQfUzv1wdojLpj/RtIa3xcLPIXBrkETBSL+SF/NdHlX4iNGzjZvEozoODz+b+404+4gbqrOa/m1gHyhTGdXGvL8Eko0LxRsiNYdWFFhxkn7gA21G9jiE1D3NLZvW28v8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jSxEotS3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jSxEotS3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9D74C4CEE7;
	Fri, 17 Oct 2025 15:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715985;
	bh=3rWlyWEyQLjjcLU1n/Lw/96I/AsKqiUHx+5h7595jso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jSxEotS37T9DiVZ87+dPskuR6kWKReIGKfSyG8LD4JTc3iC5OJXr9j246OgOJJvbs
	 2i0bh9jX1OKPU8exzfq/m6mTabjr6mcGbfm8Cf6MPfwn220EFFYZCfKtTtO5C2Zy2D
	 0pauOsPEh/jkC1TkotKznNxAZXp3PUYi3WFFKePs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sneh Mankad <sneh.mankad@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 032/276] soc: qcom: rpmh-rsc: Unconditionally clear _TRIGGER bit for TCS
Date: Fri, 17 Oct 2025 16:52:05 +0200
Message-ID: <20251017145143.577773352@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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
index 4c9400cf6686b..5dc60ee0b07a1 100644
--- a/drivers/soc/qcom/rpmh-rsc.c
+++ b/drivers/soc/qcom/rpmh-rsc.c
@@ -415,13 +415,10 @@ static irqreturn_t tcs_tx_done(int irq, void *p)
 
 		trace_rpmh_tx_done(drv, i, req, err);
 
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
 		write_tcs_reg(drv, RSC_DRV_CMD_ENABLE, i, 0);
-- 
2.51.0



