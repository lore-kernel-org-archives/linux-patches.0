Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A65F1F2381;
	Thu, 12 Dec 2024 17:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023794; cv=none; b=Ccznp2bOdvF3CA2R4tirmL2EfVnHhR7fLbq5qwhG8SmZNX73jmnwlfe8uh/Nj/lZWec+ZbLuYMDbrdMJwHoSmBD6OK8owhdTnZbTDagOvya5WjmN2pIE3fPU6WzJO8JqOGfc/qad4EfQILwwJp9v9YsskEXd/Bq+b9PuTejUqG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023794; c=relaxed/simple;
	bh=gPrRNxUZfnu4c33NwyVaxZFdcKNWPLGNTs6+q6k/f6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gPiQ4no16cFHihv9Wu3/HV+JATjnifokNUzkEI69GZ/PTFqBL63/DqgXOyJwYOWYe/Qe9HEMYHrpkkekTnIViAdFKqcn1eB4ZzqF6GC9SAYCQe4QL4cZc5Ik9hFu440IqSzI1YstlokfgRoKKENU2gXK1cvSMeayENgogsaOthY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w9etNfx4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w9etNfx4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEED7C4CECE;
	Thu, 12 Dec 2024 17:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023794;
	bh=gPrRNxUZfnu4c33NwyVaxZFdcKNWPLGNTs6+q6k/f6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w9etNfx4QWiIy7qL30wacZ4dbN519udr62gvCI3ZiOVCc2Tf50vNpzqHT1GuRIGxo
	 wWOssayd6ev21/mxtALNpPvh4b80dLqcW8gieuMiACisDbjp/AidnydfoCfMsY40jV
	 rZxb2aZtXi33oGaTAGe7Zr8j1ucD82pWiXXqz/uA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 083/459] soc: qcom: geni-se: fix array underflow in geni_se_clk_tbl_get()
Date: Thu, 12 Dec 2024 15:57:01 +0100
Message-ID: <20241212144256.796753053@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 78261cb08f06c93d362cab5c5034bf5899bc7552 ]

This loop is supposed to break if the frequency returned from
clk_round_rate() is the same as on the previous iteration.  However,
that check doesn't make sense on the first iteration through the loop.
It leads to reading before the start of these->clk_perf_tbl[] array.

Fixes: eddac5af0654 ("soc: qcom: Add GENI based QUP Wrapper driver")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/8cd12678-f44a-4b16-a579-c8f11175ee8c@stanley.mountain
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/qcom-geni-se.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/soc/qcom/qcom-geni-se.c b/drivers/soc/qcom/qcom-geni-se.c
index 0dbca679bd32f..0d4b48f135855 100644
--- a/drivers/soc/qcom/qcom-geni-se.c
+++ b/drivers/soc/qcom/qcom-geni-se.c
@@ -553,7 +553,8 @@ int geni_se_clk_tbl_get(struct geni_se *se, unsigned long **tbl)
 
 	for (i = 0; i < MAX_CLK_PERF_LEVEL; i++) {
 		freq = clk_round_rate(se->clk, freq + 1);
-		if (freq <= 0 || freq == se->clk_perf_tbl[i - 1])
+		if (freq <= 0 ||
+		    (i > 0 && freq == se->clk_perf_tbl[i - 1]))
 			break;
 		se->clk_perf_tbl[i] = freq;
 	}
-- 
2.43.0



