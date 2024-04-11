Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C4E13DDDD;
	Thu, 11 Apr 2024 09:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829572; cv=none; b=I7Uoft15KAT68RV6My+a0MUnGxhzCd68VgDHxv6XRQkkrfqlerCZJ4lFHDpA4s0IVI6LOU+IjqYEoQ6kt0KTSTPeyA7UrGi/a+lEvQ6mogcR/cDWlIbUCdwBRw5Bm5M1Y1oAqxeytb7jOuYdVRNtY0uvgs5grbVbtWGoQJx7tPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829572; c=relaxed/simple;
	bh=F4jos7qrq0Cf1BQGNH1C2F3Hg0bavKI1GmZAXDTVNxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RyZTLZo+D2T38w47n5uHm9pwJffXixBWTFQsNAQ1lCoQ4TGjRyyVwzZBjvqG4vyY3qa3qKfG6j0x4H8Gmi4NWc/H/cDWOB/pnCX6tmFwEAy7JssWMBj0vWkbTu75sX4M6OUWOqvpYuDpDTmRSDho6wr+nY07ysljF/SSJN+Q868=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O/EhdNC9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O/EhdNC9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFF90C433F1;
	Thu, 11 Apr 2024 09:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829572;
	bh=F4jos7qrq0Cf1BQGNH1C2F3Hg0bavKI1GmZAXDTVNxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O/EhdNC9bXSo+3c6dOdDKjZUePfxnobRXGTVZX7sGlil5lt5DPvGuA/WfnYNi/Dzy
	 uM+xiHFhhESOULevPquuMRODdOWygTH8YrPIkH7HJEUKvw9x+u0LS6o91kaopp4OI8
	 /eOg/7dA5/EQNlWVv1P1ovkN/GPRr8JrFFau3J9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabor Juhos <j4g8y7@gmail.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 031/175] clk: qcom: gcc-ipq8074: fix terminating of frequency table arrays
Date: Thu, 11 Apr 2024 11:54:14 +0200
Message-ID: <20240411095420.494852895@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabor Juhos <j4g8y7@gmail.com>

[ Upstream commit 1040ef5ed95d6fd2628bad387d78a61633e09429 ]

The frequency table arrays are supposed to be terminated with an
empty element. Add such entry to the end of the arrays where it
is missing in order to avoid possible out-of-bound access when
the table is traversed by functions like qcom_find_freq() or
qcom_find_freq_floor().

Only compile tested.

Fixes: 9607f6224b39 ("clk: qcom: ipq8074: add PCIE, USB and SDCC clocks")
Signed-off-by: Gabor Juhos <j4g8y7@gmail.com>
Reviewed-by: Stephen Boyd <sboyd@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240229-freq-table-terminator-v1-3-074334f0905c@gmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-ipq8074.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/clk/qcom/gcc-ipq8074.c b/drivers/clk/qcom/gcc-ipq8074.c
index eff38d22738c4..e38a1f87263b8 100644
--- a/drivers/clk/qcom/gcc-ipq8074.c
+++ b/drivers/clk/qcom/gcc-ipq8074.c
@@ -980,6 +980,7 @@ static struct clk_rcg2 pcie0_axi_clk_src = {
 
 static const struct freq_tbl ftbl_pcie_aux_clk_src[] = {
 	F(19200000, P_XO, 1, 0, 0),
+	{ }
 };
 
 static struct clk_rcg2 pcie0_aux_clk_src = {
@@ -1085,6 +1086,7 @@ static const struct freq_tbl ftbl_sdcc_ice_core_clk_src[] = {
 	F(19200000, P_XO, 1, 0, 0),
 	F(160000000, P_GPLL0, 5, 0, 0),
 	F(308570000, P_GPLL6, 3.5, 0, 0),
+	{ }
 };
 
 static struct clk_rcg2 sdcc1_ice_core_clk_src = {
-- 
2.43.0



