Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C0036A354;
	Tue, 23 Jan 2024 02:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975368; cv=none; b=oeDB+zOB6e8H52gxmUyMApvKCoTdKGYljkr2dcD6fJ2BCOY60OJunG5chuQLK5Q5uc3/yKnQO54/KsCY7W3eKtDp+AMC246HXnRdwo/fFFiATXy02YYX4TMLG8qV7Jkit+9U/Lknr8MEcTYFvOZXP78+h3fpzYXtZvGhpfM5J4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975368; c=relaxed/simple;
	bh=DEvTQC0gKGWHLSTymDSg+yplk7T4Zj/w/zievL2wPSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NtZBk764+uD1Qpbb0dUxgp9z0DIja/7N6XksI5hkh4dfqnMSR38iQO19gjF3P85IwTDb7zVA2Wjk+RdhsZrtZjVtQQaQr58Es49RS6qxC+JfwrBp2SI2SzfKVE5ShNN3oyPjOeqrc854Q7dotGLHKoYYkTnNR2mlkCcDiDwyYtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZlQk2gvv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZlQk2gvv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3788C43390;
	Tue, 23 Jan 2024 02:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975368;
	bh=DEvTQC0gKGWHLSTymDSg+yplk7T4Zj/w/zievL2wPSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZlQk2gvvgxXTKw6ldHWXPdrFb8DFredSKCayq/mEKCJlCJk/cgUjAMd6/MDAYbI7u
	 NvnVSvCm/9pEbgsYQA9eH3MJatyzx6WsO4IcjThl2+kiD6vDLgD4/F1czkphvAHZz+
	 ZgRx3OKJYcKJL5hvAoB7GS04f0GczXJcZAfTAMtg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Looijmans <mike.looijmans@topic.nl>,
	Su Hui <suhui@nfschina.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 305/583] clk: si5341: fix an error code problem in si5341_output_clk_set_rate
Date: Mon, 22 Jan 2024 15:55:56 -0800
Message-ID: <20240122235821.361732844@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Su Hui <suhui@nfschina.com>

[ Upstream commit 5607068ae5ab02c3ac9cabc6859d36e98004c341 ]

regmap_bulk_write() return zero or negative error code, return the value
of regmap_bulk_write() rather than '0'.

Fixes: 3044a860fd09 ("clk: Add Si5341/Si5340 driver")
Acked-by: Mike Looijmans <mike.looijmans@topic.nl>
Signed-off-by: Su Hui <suhui@nfschina.com>
Link: https://lore.kernel.org/r/20231101031633.996124-1-suhui@nfschina.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-si5341.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/clk/clk-si5341.c b/drivers/clk/clk-si5341.c
index 9599857842c7..2920fe2e5e8b 100644
--- a/drivers/clk/clk-si5341.c
+++ b/drivers/clk/clk-si5341.c
@@ -895,10 +895,8 @@ static int si5341_output_clk_set_rate(struct clk_hw *hw, unsigned long rate,
 	r[0] = r_div ? (r_div & 0xff) : 1;
 	r[1] = (r_div >> 8) & 0xff;
 	r[2] = (r_div >> 16) & 0xff;
-	err = regmap_bulk_write(output->data->regmap,
+	return regmap_bulk_write(output->data->regmap,
 			SI5341_OUT_R_REG(output), r, 3);
-
-	return 0;
 }
 
 static int si5341_output_reparent(struct clk_si5341_output *output, u8 index)
-- 
2.43.0



