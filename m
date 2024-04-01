Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96F0347A57;
	Mon,  1 Apr 2024 16:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988081; cv=none; b=niG7FEgk/1FjL2J5lW8k3NL4QRV5JBLF6ktBm24rrpIp7YSyUpnQa6wFzcY1LSNa1KTHMCW822uZfX5AFS7AqZWm8//6z8pbsMjFHT2iLdZ3fWiNCXVwlJyhI24/TInoFukpbekJVSIZgUL/wEAV4ihVH75uZ+Tza1idReXPkMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988081; c=relaxed/simple;
	bh=8Cbmfc7KUb1rQHQqQ7OdlwiO48v2jKnVZnJG6WkuWQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tSLAQ2F6NH6vZAcxIgRrtNx0Qxla+BvYRl2aFVHSDRq0XhvQ1kERf4Bic/34q8VKmUf3JCLATsDiXiw3I0oDM6z8q4h7ST9Ponyk02cBwhsTE4aWgvBzTfMBsnRZSZLT6pA4SBuwudfhTT50Prt5nJH6PVOJwR9R3IVQxCs12PA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CEGBU8IO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CEGBU8IO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 068DFC433C7;
	Mon,  1 Apr 2024 16:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988081;
	bh=8Cbmfc7KUb1rQHQqQ7OdlwiO48v2jKnVZnJG6WkuWQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CEGBU8IOG8qCfYlCdIsFqmh9+YEJL9Q956+N32M3yJH3Qt0yrXj/a2wfe35eRKRM0
	 SIo0bwqq6tYsClAWLpA6xswyVbooxP9hcObOcUhqtIAdfqRjm6MGHUu6oIPL17qXXX
	 Y9pO4fYj0lFn46vb23KSChr+n9EnnsrvbuWHgWCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabor Juhos <j4g8y7@gmail.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 071/432] clk: qcom: gcc-ipq8074: fix terminating of frequency table arrays
Date: Mon,  1 Apr 2024 17:40:58 +0200
Message-ID: <20240401152555.242466691@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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



