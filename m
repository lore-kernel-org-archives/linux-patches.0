Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4D721E485;
	Tue,  8 Oct 2024 12:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390782; cv=none; b=AJFz6MLehDQzJw3pi1RevnHgzVv4Wl5gnCoSctVlr3sKWWoPJu20zw9anHJ5i0hL6I8Ty9M4zCEFB3pDi9+8lbEQjjmvesZ46xfmrKCUSLCOePbzF036WiQS36szRpJm3ka9TR8J5T9CLBfdoZKjxb2okOMgc5pykTKVK9IY3rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390782; c=relaxed/simple;
	bh=V9PpaBUoayG+Xkus4Yi1NvTLXpYp7m1RbkFgmpt46XA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qngx7qoJLRpHpwQwWyQWGxFMwtT/n2cu5NiXy83DSMYnAvUEXtpHTOH+tlNy+jTRCoOO3xj/Vw1AGPtJJQn1XlPEQNSAUWKRHZg5n4FrASFDoPf5WPmo1B+yhgqBGKk8maYljqJpWh58WFCvrO6p+8MCs7bQfCIZyvZbuHH8aCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F/6RXrgk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F/6RXrgk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25FFAC4CEC7;
	Tue,  8 Oct 2024 12:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390782;
	bh=V9PpaBUoayG+Xkus4Yi1NvTLXpYp7m1RbkFgmpt46XA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F/6RXrgkwSgMprqtXNzl0wIFB3ACbBfdWTU673etUXK1IMAoReGp2YFYAXAqQ6alT
	 PpJWYLRgboGGPzrG4bU4k0hd1JDCV/3MDgErlzkdpSQ/MjzzwcC0o52cHU9n0gXDcO
	 9V78gdwgqGZe0cQp68ssBhYwTHJI5SSNXrcCMubc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Tipton <quic_mdtipton@quicinc.com>,
	Taniya Das <quic_tdas@quicinc.com>,
	Imran Shaik <quic_imrashai@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.10 390/482] clk: qcom: clk-rpmh: Fix overflow in BCM vote
Date: Tue,  8 Oct 2024 14:07:33 +0200
Message-ID: <20241008115703.761151477@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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


