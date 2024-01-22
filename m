Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2205D6A03B;
	Tue, 23 Jan 2024 02:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975337; cv=none; b=e4h+tNYYiLl0oAD7h1E42okICfzPsUIoPcKBJ1xya4iCFlOhVrKYXimkuBucRpe3m0/nriOlfLi7ddhLDiJyH5ilR0yeHIu2zpkfNFPg8nfMLMglpEL9HXl5GvCj5vpQRUM9NTreSF65sW5iA4D+YpVcWmzdsjKEmDXI2NcafgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975337; c=relaxed/simple;
	bh=DH1R3A5mRFi3T6MFY6KR4UCynwpXjq1k3gzAKtsvk4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ICcI0yOHc4Q3lFY1P1SFNQ5WPh/br+143RKAEy5fNjQrMWOs35XdncyV1Id2OPjtO484iFG8oL6x5xbXHjgV5Q4QnnjR9rueDN6fRFHmYFsIEM9OQmaLbElFySGQpJxh3+Umimi6r2gcYQkhXbrPe0K+uExVwtYsb+Iie2V1SUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ij66JbXX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ij66JbXX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A16E0C43390;
	Tue, 23 Jan 2024 02:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975337;
	bh=DH1R3A5mRFi3T6MFY6KR4UCynwpXjq1k3gzAKtsvk4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ij66JbXXTD7ejc6YOkzcWNV0yNRkPPQRuX1bWIaqoaAydWB0cNXfU9cQbwHi0/zHc
	 mYkmN+dqPeZ6kGujrWg/2XpWyYveJqffUDRgtllBjvKbf9WiOzNhDQut3WmHRk+UuK
	 hTslHhzWi1PKIzyqlISaOyZ21BJjNJ516ltUCwNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jay Buddhabhatti <jay.buddhabhatti@amd.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 298/583] drivers: clk: zynqmp: calculate closest mux rate
Date: Mon, 22 Jan 2024 15:55:49 -0800
Message-ID: <20240122235821.138469117@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jay Buddhabhatti <jay.buddhabhatti@amd.com>

[ Upstream commit b782921ddd7f84f524723090377903f399fdbbcb ]

Currently zynqmp clock driver is not calculating closest mux rate and
because of that Linux is not setting proper frequency for CPU and
not able to set given frequency for dynamic frequency scaling.

E.g., In current logic initial acpu clock parent and frequency as below
apll1                  0    0    0  2199999978    0     0  50000      Y
    acpu0_mux          0    0    0  2199999978    0     0  50000      Y
        acpu0_idiv1    0    0    0  2199999978    0     0  50000      Y
            acpu0      0    0    0  2199999978    0     0  50000      Y

After changing acpu frequency to 549999994 Hz using CPU freq scaling its
selecting incorrect parent which is not closest frequency.
rpll_to_xpd            0    0    0  1599999984    0     0  50000      Y
    acpu0_mux          0    0    0  1599999984    0     0  50000      Y
        acpu0_div1     0    0    0   533333328    0     0  50000      Y
            acpu0      0    0    0   533333328    0     0  50000      Y

Parent should remain same since 549999994 = 2199999978 / 4.

So use __clk_mux_determine_rate_closest() generic function to calculate
closest rate for mux clock. After this change its selecting correct
parent and correct clock rate.
apll1                  0    0    0  2199999978    0     0  50000      Y
    acpu0_mux          0    0    0  2199999978    0     0  50000      Y
        acpu0_div1     0    0    0   549999995    0     0  50000      Y
            acpu0      0    0    0   549999995    0     0  50000      Y

Fixes: 3fde0e16d016 ("drivers: clk: Add ZynqMP clock driver")
Signed-off-by: Jay Buddhabhatti <jay.buddhabhatti@amd.com>
Link: https://lore.kernel.org/r/20231129112916.23125-2-jay.buddhabhatti@amd.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/zynqmp/clk-mux-zynqmp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/zynqmp/clk-mux-zynqmp.c b/drivers/clk/zynqmp/clk-mux-zynqmp.c
index 60359333f26d..9b5d3050b742 100644
--- a/drivers/clk/zynqmp/clk-mux-zynqmp.c
+++ b/drivers/clk/zynqmp/clk-mux-zynqmp.c
@@ -89,7 +89,7 @@ static int zynqmp_clk_mux_set_parent(struct clk_hw *hw, u8 index)
 static const struct clk_ops zynqmp_clk_mux_ops = {
 	.get_parent = zynqmp_clk_mux_get_parent,
 	.set_parent = zynqmp_clk_mux_set_parent,
-	.determine_rate = __clk_mux_determine_rate,
+	.determine_rate = __clk_mux_determine_rate_closest,
 };
 
 static const struct clk_ops zynqmp_clk_mux_ro_ops = {
-- 
2.43.0



