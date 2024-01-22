Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6708C651AD;
	Tue, 23 Jan 2024 00:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971572; cv=none; b=YIUQvbxjgILLhQOr35hBR6LsepihVFEr6GuW4hcVxvLNc44+ExRXR7lvj+nTXSZleae6qqs0JnRP6WiSHN5OiWGJBNhxh6DP2vNtHkMenX8bhrJHHRiOC/UHzhNkzrypgbVuoQZfNkxwW8m6p8e3oImt59as3+5gH6LhZiJpKjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971572; c=relaxed/simple;
	bh=avsU0DXmb3q6D0Dv2uzRP7T7OP3qJilcq0fVALbfYt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=daAUzWXPgg+cYb3VLfsbIvqn31rOTCVdxhuWco9n2xVkptzwqNJFemvLcuZmAt/OeTgki18LfFnc4RYVV2MRBeYn0c5tYCLJt4RLHT3n5J9lS41cPl1KfqcQX8CxHDVNLPX9O+QKmATiQYhpAONszHSFsgAQ23Hi/dz6kxHOGvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UlsjpQ9J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UlsjpQ9J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24ED0C433F1;
	Tue, 23 Jan 2024 00:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971572;
	bh=avsU0DXmb3q6D0Dv2uzRP7T7OP3qJilcq0fVALbfYt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UlsjpQ9JgCBJHsBClS+odLee6HO9XitnlHWbTZbwNRFQOsyAabKirZ21SXsGKeiuh
	 fpgr+p8UnCIw+G4wNKYr7vpeY8FqL7XwMx6NkmSDD9T4q6NZzpW5Daz9g7yO8bWI5g
	 mO/d2Ofi5bG17xkngKBU4EgXM9b2eSV/ZYny2PEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jay Buddhabhatti <jay.buddhabhatti@amd.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 178/286] drivers: clk: zynqmp: calculate closest mux rate
Date: Mon, 22 Jan 2024 15:58:04 -0800
Message-ID: <20240122235739.017144952@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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
index 06194149be83..46ff5cb733ee 100644
--- a/drivers/clk/zynqmp/clk-mux-zynqmp.c
+++ b/drivers/clk/zynqmp/clk-mux-zynqmp.c
@@ -83,7 +83,7 @@ static int zynqmp_clk_mux_set_parent(struct clk_hw *hw, u8 index)
 static const struct clk_ops zynqmp_clk_mux_ops = {
 	.get_parent = zynqmp_clk_mux_get_parent,
 	.set_parent = zynqmp_clk_mux_set_parent,
-	.determine_rate = __clk_mux_determine_rate,
+	.determine_rate = __clk_mux_determine_rate_closest,
 };
 
 static const struct clk_ops zynqmp_clk_mux_ro_ops = {
-- 
2.43.0



