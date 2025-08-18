Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 999022D8DD4;
	Mon, 18 Aug 2025 14:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526224; cv=none; b=Ttf8jySgCM5GqutjdirdsAG/RLNbzM2ExR+Av4fegmUT4JLQweyRaTY6Ge+x3/wT6fQ5g3Tf4H8K8D8lwPuihHQd1/cY/tZvqt+kZBLqBJbCe21EZ2IpAdvP4oHm2uOn/3rWJ7aDJBsY7xJoEMXBWFZ3nHnkknAWoE4K6ern9nQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526224; c=relaxed/simple;
	bh=3Hk87/Nq6+8whD9K86QM2jBKlf3YxRYdzl9WZPyJ2Xo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Aaw82l+UIbsr9HpOsGcq9mitCz8N7Yd/OdTr7wkUhrH/7Q4jhFwMJ4WexwgpOqTXLEYFW4HvyW3aTNfI2ql4mWSSDYqbl8pdFoiJM5a/lo402qHisPBZgo3YLOQgcN8AV3Q3o9kVzDY8lqp7FbHYMeZUG2f51EsByud9viXBp4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e+W/hu9O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e+W/hu9O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B38D7C4CEEB;
	Mon, 18 Aug 2025 14:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526224;
	bh=3Hk87/Nq6+8whD9K86QM2jBKlf3YxRYdzl9WZPyJ2Xo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e+W/hu9O9T9Mm9yk0wuYFEqrXrXDh82mg4s+5qIXokmAh42mp+EhbMhSKJ6NHeez2
	 t4dEXlJEgljCXZP6kjY99BtJKATvqh3WFc7+EXfOAxC0/2x/N/NWDwbIbh4L0hHQ54
	 2yeLtACdIrQyZnPIIDnJvZOylk74SYEVc2jyVDO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Marangi <ansuelsmth@gmail.com>,
	Robert Marko <robimarko@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.16 494/570] clk: qcom: gcc-ipq8074: fix broken freq table for nss_port6_tx_clk_src
Date: Mon, 18 Aug 2025 14:48:01 +0200
Message-ID: <20250818124524.900248284@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Marangi <ansuelsmth@gmail.com>

commit 077ec7bcec9a8987d2a133afb7e13011878c7576 upstream.

With the conversion done by commit e88f03230dc0 ("clk: qcom: gcc-ipq8074:
rework nss_port5/6 clock to multiple conf") a Copy-Paste error was made
for the nss_port6_tx_clk_src frequency table.

This was caused by the wrong setting of the parent in
ftbl_nss_port6_tx_clk_src that was wrongly set to P_UNIPHY1_RX instead
of P_UNIPHY2_TX.

This cause the UNIPHY2 port to malfunction when it needs to be scaled to
higher clock. The malfunction was observed with the example scenario
with an Aquantia 10G PHY connected and a speed higher than 1G (example
2.5G)

Fix the broken frequency table to restore original functionality.

Cc: stable@vger.kernel.org
Fixes: e88f03230dc0 ("clk: qcom: gcc-ipq8074: rework nss_port5/6 clock to multiple conf")
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Tested-by: Robert Marko <robimarko@gmail.com>
Link: https://lore.kernel.org/r/20250522202600.4028-1-ansuelsmth@gmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/qcom/gcc-ipq8074.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/clk/qcom/gcc-ipq8074.c
+++ b/drivers/clk/qcom/gcc-ipq8074.c
@@ -1895,10 +1895,10 @@ static const struct freq_conf ftbl_nss_p
 static const struct freq_multi_tbl ftbl_nss_port6_tx_clk_src[] = {
 	FMS(19200000, P_XO, 1, 0, 0),
 	FM(25000000, ftbl_nss_port6_tx_clk_src_25),
-	FMS(78125000, P_UNIPHY1_RX, 4, 0, 0),
+	FMS(78125000, P_UNIPHY2_TX, 4, 0, 0),
 	FM(125000000, ftbl_nss_port6_tx_clk_src_125),
-	FMS(156250000, P_UNIPHY1_RX, 2, 0, 0),
-	FMS(312500000, P_UNIPHY1_RX, 1, 0, 0),
+	FMS(156250000, P_UNIPHY2_TX, 2, 0, 0),
+	FMS(312500000, P_UNIPHY2_TX, 1, 0, 0),
 	{ }
 };
 


