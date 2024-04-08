Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1B28481A6;
	Mon,  8 Apr 2024 13:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581385; cv=none; b=HB1w1Xva0vEKzKTn4RZd7TR2p7dJptur8ajdJa/PUPoKsVw9cCQIUwjXhl7GVXyflDhDwzb2o9gGvvRcT23ijHZSJn69XSll/hNBMwgVatapPgRVojnaWJum1ChfhBXpOiqa7jaNdTcK1GIvajX2qSCAoU26BYn5ESiTW+B3rps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581385; c=relaxed/simple;
	bh=1HXMOW82XQO5SznJJ7z4X6VoVI+MdZkv13Bqa7gyJ2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nIocpua7HqEQfMG8l9aD3gtUDy4VO35w+XF/U3Vuvj0kpTnDRElPrqYu8ZSgKgAB0If4Rgu4nCVhrFi6EM94D+4nWvXmRZmToA1P3TIEE9kjDPxKyMugqLcLxmiTA+aa+gOO2lrjhHDkEKjTatGt3AMg/HGFtrcvu2CCJBHoidc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MfiUPJuo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MfiUPJuo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FC45C433C7;
	Mon,  8 Apr 2024 13:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581384;
	bh=1HXMOW82XQO5SznJJ7z4X6VoVI+MdZkv13Bqa7gyJ2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MfiUPJuoL485/01hmrELuVw1rhLusYkiGPqEke69D/iABrVvnGJAytB8rJ7xLxMri
	 FREY2heAO+hX6x6gWg/obHDJVkzyg8F/yGg3wHUJbH4+2A+SVSTp5AQvmQpq8leVQB
	 ODkCRWbFP0kYQGyQUoBF+NMpAFAYDZ5RNVLvDe/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabor Juhos <j4g8y7@gmail.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 042/690] clk: qcom: gcc-ipq8074: fix terminating of frequency table arrays
Date: Mon,  8 Apr 2024 14:48:28 +0200
Message-ID: <20240408125401.062151379@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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
index 0393154fea2f9..649e75a41f7af 100644
--- a/drivers/clk/qcom/gcc-ipq8074.c
+++ b/drivers/clk/qcom/gcc-ipq8074.c
@@ -972,6 +972,7 @@ static struct clk_rcg2 pcie0_axi_clk_src = {
 
 static const struct freq_tbl ftbl_pcie_aux_clk_src[] = {
 	F(19200000, P_XO, 1, 0, 0),
+	{ }
 };
 
 static struct clk_rcg2 pcie0_aux_clk_src = {
@@ -1077,6 +1078,7 @@ static const struct freq_tbl ftbl_sdcc_ice_core_clk_src[] = {
 	F(19200000, P_XO, 1, 0, 0),
 	F(160000000, P_GPLL0, 5, 0, 0),
 	F(308570000, P_GPLL6, 3.5, 0, 0),
+	{ }
 };
 
 static struct clk_rcg2 sdcc1_ice_core_clk_src = {
-- 
2.43.0



