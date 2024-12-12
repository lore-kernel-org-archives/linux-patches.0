Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43E3A2210EA;
	Thu, 12 Dec 2024 17:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024997; cv=none; b=jn5wCOQzQrGLy+2DpY3gfxA3+WrMMP4zJQhmgZ/Q/QPXLAqfwAcJvgunaAvv9hIrpOax6EKh5I7qWFxuWPHh0kB8uSaxVXXpDUrtPB6tSZsfc83dcVV7FgzQsOsYHWrab6OY7mnWJEi2BWElNl+hPr9sq1M3SceD/k4LIOQfj18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024997; c=relaxed/simple;
	bh=n913A8lQmWHYOZtAKe+0+tRY1oZPqaLpnTcHVh+NIAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QnfnjfBeKtX0eUNW8olFMpEwVXqsF4k/ozBovKhFwfDAg8ib1CwwZMT0+RzXuBdyj/9UW6yNWqrDNzkVL89ywY/D9wOubhXYFa7G5d8rUk6Q1lV72eO0DJOE9eA4p33n1ATQJGWygWj2HQcZGSk00HzjCorHHtxIIBMtKpbjOgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uDhkXBmo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uDhkXBmo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B328AC4CED0;
	Thu, 12 Dec 2024 17:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024997;
	bh=n913A8lQmWHYOZtAKe+0+tRY1oZPqaLpnTcHVh+NIAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uDhkXBmovdZvHnBkhPXAb2QeiQRPkGAXPon/wzuLgtoCRnJRaxiMD4qLAtgvjyj9s
	 XCJzbko+JGkyizzgTJtwRzGqxy8KRqVSgdkCfM3SyDHnoTXIMirpiS8KetN2MSD5Jn
	 wH3z9aZiHWl5dVw9DcpKu+Xzk44gDYsS3Ld7tKfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luo Yifan <luoyifan@cmss.chinamobile.com>,
	Olivier Moysan <olivier.moysan@foss.st.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 022/321] ASoC: stm: Prevent potential division by zero in stm32_sai_get_clk_div()
Date: Thu, 12 Dec 2024 15:59:00 +0100
Message-ID: <20241212144230.523973626@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luo Yifan <luoyifan@cmss.chinamobile.com>

[ Upstream commit 23569c8b314925bdb70dd1a7b63cfe6100868315 ]

This patch checks if div is less than or equal to zero (div <= 0). If
div is zero or negative, the function returns -EINVAL, ensuring the
division operation is safe to perform.

Signed-off-by: Luo Yifan <luoyifan@cmss.chinamobile.com>
Reviewed-by: Olivier Moysan <olivier.moysan@foss.st.com>
Link: https://patch.msgid.link/20241107015936.211902-1-luoyifan@cmss.chinamobile.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/stm/stm32_sai_sub.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/stm/stm32_sai_sub.c b/sound/soc/stm/stm32_sai_sub.c
index b7dc9d3192597..e8cd58c0838ee 100644
--- a/sound/soc/stm/stm32_sai_sub.c
+++ b/sound/soc/stm/stm32_sai_sub.c
@@ -318,7 +318,7 @@ static int stm32_sai_get_clk_div(struct stm32_sai_sub_data *sai,
 	int div;
 
 	div = DIV_ROUND_CLOSEST(input_rate, output_rate);
-	if (div > SAI_XCR1_MCKDIV_MAX(version)) {
+	if (div > SAI_XCR1_MCKDIV_MAX(version) || div <= 0) {
 		dev_err(&sai->pdev->dev, "Divider %d out of range\n", div);
 		return -EINVAL;
 	}
-- 
2.43.0



