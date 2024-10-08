Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8337D1DFD1;
	Tue,  8 Oct 2024 13:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392576; cv=none; b=ED+QLPY8hTKN2lXsphBFjR3rvDJjcC29y3ghdy4k6CaO03HvQqmoX6XdsyKltJq2zo++YEvtL5R4kVb5ytmK5OKjFWMfQpkJ8BfA/xa2GfsZIL4agAco4mNFdEMARIVAVg/CSS6V/WHuHR8jZVT87xzypcmTr4QQz/1wm+G9IW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392576; c=relaxed/simple;
	bh=/To6JJ95B0/uwAxFys6rqVgfiYnNBOtRI0zFv3NxQbg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LXz3mqhYp5Rers7t3jO6k///ChqZaUiuqzT9baPZDgXtgBIMl+M6EyBgh+NJFiHnxXtcOycKD7lXZcPOkHcmBC6k6SjdEBtQEQNjoq63cj+3EEuUdaROg35yZwHTzo6TPQOyCWER3TDRToAmRVuJL9AtOVHh8ucmj3bC+x04p0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VljJJ1YO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VljJJ1YO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04C63C4CECE;
	Tue,  8 Oct 2024 13:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392576;
	bh=/To6JJ95B0/uwAxFys6rqVgfiYnNBOtRI0zFv3NxQbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VljJJ1YO+6H9CCuG650tpBiw9D2LwnazRaZoFm6qPL/H+kHchQqvR/Tkrh1Xquq6T
	 0T3KP2Px2y1yg13PHo0cs4kgNGbrxDKyIN2TcsCab7Zu3vWWHKrgHkSOspW69u2e+l
	 mWg+vitYX3P+3N1y3H6n1JnbnPTHGFGYC5aCgEK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Tipton <quic_mdtipton@quicinc.com>,
	Taniya Das <quic_tdas@quicinc.com>,
	Imran Shaik <quic_imrashai@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.11 457/558] clk: qcom: clk-rpmh: Fix overflow in BCM vote
Date: Tue,  8 Oct 2024 14:08:07 +0200
Message-ID: <20241008115720.242509476@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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


