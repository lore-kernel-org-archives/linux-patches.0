Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A8521AAE02;
	Mon, 14 Oct 2024 15:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919355; cv=none; b=XaiaOxHATszCrW2Y+5TqBHsRLDGgs6y0IWydKgZPwwiEGJvCG5a2PLJPS0p0difEzDqeF/7va33IgQQDDwhI46J6xzQrRaFLn1zNFU2PCHpDSgaCumWFz+5pOq6y1+QhOZkV9PbIK2VN3nVfq6izwEu08y6AegJtLrzNKhiCuLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919355; c=relaxed/simple;
	bh=1gOU9hbp2cWPiZc8wqtVIjy6p3Fv9Ian66CAhm5MfSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M2k41CpOBfElBB37UCs3BmTnuAHpGZUY6ApHt0vRatGS9reU639eIOQSr4kWM9SES42EXufBIeyyj9WhQekJgCQVWgBTaGTk7sx90aCpS71y0h4P8MOm0Um24hTLExVR/lJ/mp8LumawGEGaQsnd230W7biOMV8i9VOXiiqGbps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yIN9Kptr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yIN9Kptr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46BDFC4CEC3;
	Mon, 14 Oct 2024 15:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919354;
	bh=1gOU9hbp2cWPiZc8wqtVIjy6p3Fv9Ian66CAhm5MfSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yIN9Kptrll9kGk5jdDo+JHItk5K572lAOH6SD7nFtpD2wjhrS1/piuA+IMCiTanRj
	 n9v6GAZiX2gb6gLDneLb1VsPQdJEhDEQ71Xs4d67sQSJzA27dLrOd8Sg3hi0dwbS0h
	 xd6YjTKWbnGR23h8LRPbqBZcjt7ndROFXrJV3Dsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Tipton <quic_mdtipton@quicinc.com>,
	Taniya Das <quic_tdas@quicinc.com>,
	Imran Shaik <quic_imrashai@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.1 586/798] clk: qcom: clk-rpmh: Fix overflow in BCM vote
Date: Mon, 14 Oct 2024 16:19:00 +0200
Message-ID: <20241014141241.025344976@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -266,6 +266,8 @@ static int clk_rpmh_bcm_send_cmd(struct
 		cmd_state = 0;
 	}
 
+	cmd_state = min(cmd_state, BCM_TCS_CMD_VOTE_MASK);
+
 	if (c->last_sent_aggr_state != cmd_state) {
 		cmd.addr = c->res_addr;
 		cmd.data = BCM_TCS_CMD(1, enable, 0, cmd_state);


