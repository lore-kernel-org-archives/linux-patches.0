Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BFE11C4A01;
	Tue, 15 Oct 2024 13:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998185; cv=none; b=r6dpkY/Q9rxO79ToqnlAyPkXtHITtPLJ6SobUjYX025a2JibVsLYgxKLVGVsdOdAUwf4y++KTHGMPulPZwTyIWB3kRyZ/i9Rtg6DyPhgoOx/yWR5JykN2cnGok6PMjoN8j/TZdmZYugmkvIJBMn3yZMFOGMpwNxd90a9MoL9eUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998185; c=relaxed/simple;
	bh=n+yOkFADLdKHLIOcNKaLKaIJIO1Q1ZN3+ek+omAB2HE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z/YO7VIRbLMymNyoFItZSvZMGmojJx2LEdPyGLKEDF1TMPl7to9pBAUIV/jT4ulLV/DTzNE6GteVcfhncv1KuxyY7LiFqZBYQEQDYu98o8Z6UwUagHVwWsfNRCt0VTbByh143b/VpCiuUsSreVki+73+3diFrN3WzuzKxeaLYzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cr+FHVqg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cr+FHVqg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A773DC4CEC6;
	Tue, 15 Oct 2024 13:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998185;
	bh=n+yOkFADLdKHLIOcNKaLKaIJIO1Q1ZN3+ek+omAB2HE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cr+FHVqgqAwjmruGRnkvRBbwa67b7UCU08alNvOTLZU933cuB+m4kko+Nzt5ycAG9
	 YMJDUdTpoDYQJ6BTOIkpf+K3x9kVciU1IU6Nz2mUIJntm9fKzdFe+MHdFfy8PllNkH
	 JuRHzx0ri8euVy4zJ2f5qVVTMKEa4R9jY5pZ1eNM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Tipton <quic_mdtipton@quicinc.com>,
	Taniya Das <quic_tdas@quicinc.com>,
	Imran Shaik <quic_imrashai@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 5.10 402/518] clk: qcom: clk-rpmh: Fix overflow in BCM vote
Date: Tue, 15 Oct 2024 14:45:06 +0200
Message-ID: <20241015123932.489748250@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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


