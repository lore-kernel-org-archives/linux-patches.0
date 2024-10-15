Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24C751C57B1;
	Tue, 15 Oct 2024 12:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993826; cv=none; b=C7LO1+lEVNDuyk6Ca8LKYeSqtcFRRokqA5ZDW5aQJd/bZaeV+Sg9zjJNyc3JHSL1JFD+6T1g8N+4Lg6MjfMICr+KGIAlWFDug+KLdV0YRrYcmUuBvgL9DGOvDl9eTITnx1csv6qrlVICAqGhs5WuaJuPY2jXJbgKMjq6Oujw6XM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993826; c=relaxed/simple;
	bh=24fSkzDe/IquznilzP8WF9Fiql063YV6WNvFiHlnWf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eTERUN54FOGyGcYWX+6vGZQUzTf/iOAcn9FKBPh76gInYnsVWarqeFeU7ZPXyKzr6dXoJyN5IYXLd13Yj/NFHC6V0R3q+o6okvAhUG7g9pzzEl67ghM1+ynIhovj2zaZG9MbqqP3hjh58l0unYFZjx9NXRmlixDpoHHx9v8plcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2ODRDmgg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2ODRDmgg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8818AC4CEC6;
	Tue, 15 Oct 2024 12:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993826;
	bh=24fSkzDe/IquznilzP8WF9Fiql063YV6WNvFiHlnWf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2ODRDmggm753mUTan1k5P8amIInJr2i8o7N5H3kC1FFw0gSDem14ggwOTFJJMuSL+
	 LSnehWpnQkQW6q2ytiJQoOT2BhySF+A8/FcmWEoIM3XLKEVEXy/FU8Rt/RYd7J0xsF
	 ryCgQYsUPKnp4rE09uIG4C4sDLSp/rstCdEMKbf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Tipton <quic_mdtipton@quicinc.com>,
	Taniya Das <quic_tdas@quicinc.com>,
	Imran Shaik <quic_imrashai@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 5.15 528/691] clk: qcom: clk-rpmh: Fix overflow in BCM vote
Date: Tue, 15 Oct 2024 13:27:56 +0200
Message-ID: <20241015112501.298053187@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -270,6 +270,8 @@ static int clk_rpmh_bcm_send_cmd(struct
 		cmd_state = 0;
 	}
 
+	cmd_state = min(cmd_state, BCM_TCS_CMD_VOTE_MASK);
+
 	if (c->last_sent_aggr_state != cmd_state) {
 		cmd.addr = c->res_addr;
 		cmd.data = BCM_TCS_CMD(1, enable, 0, cmd_state);


