Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54C0B487A7;
	Mon,  1 Apr 2024 15:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711986841; cv=none; b=L57YV48CPqIAh8bKQfdCPTvejVUWHmeTJOf7rpwGHdCUr6IVK3gaTDawJ4X7uFAkYCVkvhGRkotKd+jICTt8gnXkjMxo4C0A5MqWmt+5qHbJGRbKQGyDNgXjT6Rlxg597JCpLv4/MSDAc+LNR8XGX54UrUFZWBDWaMkS5Ipisgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711986841; c=relaxed/simple;
	bh=yZbDxTKI7J7om8woPf4+0385NImAYZmCG6cQDv0x2Tc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LwuViFb8NZAQvKLAUp+Oal0Gal1uqgwvg11eESlpgt1PB1cu1PlBQHZLrFAttiHK0fQlynZska9mDLr62SNFsUgMJaHX+NgLTx4difFg9yfEanc4isWemh9w5DX+qGgg1Jau0seQdqTI58td/x4gHjA0TfXhkRyS/k5JNNN2iR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=blVGLd0R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="blVGLd0R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEE88C433F1;
	Mon,  1 Apr 2024 15:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711986841;
	bh=yZbDxTKI7J7om8woPf4+0385NImAYZmCG6cQDv0x2Tc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=blVGLd0R3V9etvTtP53MrptdF/y8+gs9QqKxUmBoXMqV6FjhgpagAOjmOtwrSijec
	 3du8zgx2biAtbKLE7L68MuADszQwtJPMhTORPXjCtJTx/0NbFp5Oyx65nVtZlx38Vz
	 znQytCKe4CtJGnMZouH0fOHsbI9K40OszygvEh/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabor Juhos <j4g8y7@gmail.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 072/399] clk: qcom: gcc-ipq8074: fix terminating of frequency table arrays
Date: Mon,  1 Apr 2024 17:40:38 +0200
Message-ID: <20240401152551.333900171@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index b7faf12a511a1..7bc679871f324 100644
--- a/drivers/clk/qcom/gcc-ipq8074.c
+++ b/drivers/clk/qcom/gcc-ipq8074.c
@@ -644,6 +644,7 @@ static struct clk_rcg2 pcie0_axi_clk_src = {
 
 static const struct freq_tbl ftbl_pcie_aux_clk_src[] = {
 	F(19200000, P_XO, 1, 0, 0),
+	{ }
 };
 
 static const struct clk_parent_data gcc_xo_gpll0_sleep_clk[] = {
@@ -795,6 +796,7 @@ static const struct freq_tbl ftbl_sdcc_ice_core_clk_src[] = {
 	F(19200000, P_XO, 1, 0, 0),
 	F(160000000, P_GPLL0, 5, 0, 0),
 	F(308570000, P_GPLL6, 3.5, 0, 0),
+	{ }
 };
 
 static const struct clk_parent_data gcc_xo_gpll0_gpll6_gpll0_div2[] = {
-- 
2.43.0



