Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C23031DF745;
	Tue,  8 Oct 2024 13:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393896; cv=none; b=o9mv02nkvG4qQNQJwvHEIg22QSwxIddrfFp33/W72aHwaYgS/xPGldeSKDmSHM8GKL4OPVN0p26StgtUkZySkfFcymk/xn9+l6E92B9NOkl6p0UK/uV3Gd8RF+I2adWPIdtAs1LJJJQTmb7MaE6BbQf0Rijdt5Q8DTUZ9l/HRwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393896; c=relaxed/simple;
	bh=OXiGRX/5oK5iBvXW99MlO7u/4DBlNqdaLRPf+hySYz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RMjFPvvI2p/S9wF3kKjBo38k0RyfEbRzrVduQJZG8zSwPZ97iTWBM1FjXRrCukKLJ4BehA/9gTovej7maUaPMIXuOaiBoDRk3ShdcdwhZ1Yo5CtycTr6lLf/1EQMMrMHrTVKO9DxnfZxVlKH1Imy/r/nJC+H5jYM6XQXKThrosQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K2ZcyyJq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K2ZcyyJq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3077AC4CEC7;
	Tue,  8 Oct 2024 13:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393896;
	bh=OXiGRX/5oK5iBvXW99MlO7u/4DBlNqdaLRPf+hySYz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K2ZcyyJqMKWAY6TOP5f+xgYmEv3qjC5N7A6VH3XBLv5h7gtTYQxNZBR6nsRKEQKbt
	 gEga1Rweb25xVBO/jANZhap3YraskL2gA8+rac9cxDiKHh+JQGBPaT8q0b2WX3bBlE
	 hA70T2WNHm7adW2IqCbLHwLWWAQ2fXJMUJdA9kUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Tipton <quic_mdtipton@quicinc.com>,
	Taniya Das <quic_tdas@quicinc.com>,
	Imran Shaik <quic_imrashai@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.6 286/386] clk: qcom: clk-rpmh: Fix overflow in BCM vote
Date: Tue,  8 Oct 2024 14:08:51 +0200
Message-ID: <20241008115640.641289000@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

From: Mike Tipton <quic_mdtipton@quicinc.com>

commit a4e5af27e6f6a8b0d14bc0d7eb04f4a6c7291586 upstream.

Valid frequencies may result in BCM votes that exceed the max HW value.
Set vote ceiling to BCM_TCS_CMD_VOTE_MASK to ensure the votes aren't
truncated, which can result in lower frequencies than desired.

Fixes: 04053f4d23a4 ("clk: qcom: clk-rpmh: Add IPA clock support")
Cc: stable@vger.kernel.org
Signed-off-by: Mike Tipton <quic_mdtipton@quicinc.com>
Reviewed-by: Taniya Das <quic_tdas@quicinc.com>
Signed-off-by: Imran Shaik <quic_imrashai@quicinc.com>
Link: https://lore.kernel.org/r/20240809-clk-rpmh-bcm-vote-fix-v2-1-240c584b7ef9@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/qcom/clk-rpmh.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/clk/qcom/clk-rpmh.c
+++ b/drivers/clk/qcom/clk-rpmh.c
@@ -263,6 +263,8 @@ static int clk_rpmh_bcm_send_cmd(struct
 		cmd_state = 0;
 	}
 
+	cmd_state = min(cmd_state, BCM_TCS_CMD_VOTE_MASK);
+
 	if (c->last_sent_aggr_state != cmd_state) {
 		cmd.addr = c->res_addr;
 		cmd.data = BCM_TCS_CMD(1, enable, 0, cmd_state);


