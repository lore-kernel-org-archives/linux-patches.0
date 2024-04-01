Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 846A7BA3F;
	Mon,  1 Apr 2024 17:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990837; cv=none; b=eWktAhNB3kebHedUn+psAEPaSzk2jpHWXdF/ta3v1R0QWD7mdg1PCHP3BF0FqI15s5lydTna6xtOgmkdBgWkQxt1GJtOqKgbU09C5AKV9yBTVmMtIh+EcbRorsdi2kZGLHwzcheLC3A33NZ7eVEEeU80mJnwV6IQwxnG2q58FSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990837; c=relaxed/simple;
	bh=byCPQEDt8rAVYfPl4d6hc4HRcogUxRe1GJNpHR8PScM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iDkyQwWcBXn8RkVAxss6mB3WhyOGq4wMrJrpRmEbrcH9BUH+OUikDPYlAzj04RaOMFAVTwHMaN5VWEtPC5M4wPdIVGylNQfZamZN5Gzc2kVb3z+EZAJC43IG3J3GwIY1ClKG28ZujnTjtyTGH+WWQKmaSiY5tKubmLmkFUynHX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rVdQCV22; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rVdQCV22"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF62CC433F1;
	Mon,  1 Apr 2024 17:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990837;
	bh=byCPQEDt8rAVYfPl4d6hc4HRcogUxRe1GJNpHR8PScM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rVdQCV22SCO7QvRMExHulJBXsVqRbd8aZKo9guOIj+IRRra0pM0+bH7KeG3UgLfH5
	 zjdWN4KwJzOvvHJr6rgu7yDSrt/fiRSbgqrs3Jxj0rTQhvH+a04QPyHZQiOVpj4Vyy
	 pLSnxWFJbS8GtE2An48GSVS+es4V/IXqNClRcVWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabor Juhos <j4g8y7@gmail.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 054/272] clk: qcom: gcc-ipq8074: fix terminating of frequency table arrays
Date: Mon,  1 Apr 2024 17:44:04 +0200
Message-ID: <20240401152532.232059680@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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
index b2e83b38976e5..b52c923a2fbca 100644
--- a/drivers/clk/qcom/gcc-ipq8074.c
+++ b/drivers/clk/qcom/gcc-ipq8074.c
@@ -973,6 +973,7 @@ static struct clk_rcg2 pcie0_axi_clk_src = {
 
 static const struct freq_tbl ftbl_pcie_aux_clk_src[] = {
 	F(19200000, P_XO, 1, 0, 0),
+	{ }
 };
 
 static struct clk_rcg2 pcie0_aux_clk_src = {
@@ -1078,6 +1079,7 @@ static const struct freq_tbl ftbl_sdcc_ice_core_clk_src[] = {
 	F(19200000, P_XO, 1, 0, 0),
 	F(160000000, P_GPLL0, 5, 0, 0),
 	F(308570000, P_GPLL6, 3.5, 0, 0),
+	{ }
 };
 
 static struct clk_rcg2 sdcc1_ice_core_clk_src = {
-- 
2.43.0



