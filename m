Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2370C208D0;
	Sat, 12 Sep 2026 09:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206053; cv=none; b=L69QqdGT4NS3lZzm7Zspm1Oq48fO3Lc/HO07z/+pK0cjctoIAZFmc4fxnNd8JwtPO6T0MW5fwwyf//E/SYYXSGIhXZ218fRiVAlyHOFOkxXAFVq570K/WrAfND5Bf85ll+qz8ATa0NutbsUycbbgWmMz6bUmD9b4smZmRo9pTPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206053; c=relaxed/simple;
	bh=68rLYdVjiP/LTcviVuQqujr7wDEmioDbviB3Kd06zSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bEx9/wiBXF1/p7vp2EerlVB67wEylR/uhbq2oWlk1+VqMTwpn2yTiCtUzQEK4q8dENIozCtnkJ0bub4dbNxYJY1lmLudAFgXnHgoTA46hQecsBqaHgSwkWvqEsb4XquuXMy+DcCKlxPRBhzYcqbbXBoLSfi8Rgdq4xCl943iL8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1XsEhBLb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1XsEhBLb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 221961F000FF;
	Sat, 12 Sep 2026 09:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206052;
	bh=ejPVQv9Y4wlCXXPhbzFTpIUsE1J/HtTBzApL3Ut6FVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1XsEhBLbkBnLDkC7dVjlr1HyCsaDWgkFB8vtP759l7ziuhBQc8Wfqmx96L5yU2UhP
	 8Jaauj7UIRenwJHEi5on8BUapJhglPWccnvixl/NpLQVOlwTNDSQ2VWhEGyyx9vSJZ
	 gkp3hqnLWpJe4+OVNkuNMp1UfarMfWeDDlyQMXBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0126/1518] clk: versaclock7: Fix APLL clock leak on probe failure
Date: Sat, 12 Sep 2026 08:38:15 +0200
Message-ID: <20260912065626.338591208@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit e25d8d35e8cbc1a4c04a8b86eed6aa7229f6449e ]

vc7_probe() registers the APLL with clk_register_fixed_rate(), which is
not devm-managed and must be explicitly unregistered on probe failure.

Most later errors already unwind through err_clk, but a failure from
vc7_get_bank_clk() in the output registration loop returned directly.
That skipped clk_unregister_fixed_rate() and leaked the APLL clock.

Route that error through the existing err_clk label so the fixed-rate
clock is released consistently with the other probe failure paths.

This issue was identified during our ongoing static-analysis research while
reviewing kernel code.

Fixes: 48c5e98fedd9 ("clk: Renesas versaclock7 ccf device driver")
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Reviewed-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-versaclock7.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/clk-versaclock7.c b/drivers/clk/clk-versaclock7.c
index adcc603e32593..e3a36dcd98b80 100644
--- a/drivers/clk/clk-versaclock7.c
+++ b/drivers/clk/clk-versaclock7.c
@@ -1197,7 +1197,7 @@ static int vc7_probe(struct i2c_client *client)
 		if (ret) {
 			dev_err_probe(&client->dev, ret,
 				      "unable to register output %d\n", i);
-			return ret;
+			goto err_clk;
 		}
 
 		switch (bank_src_map.type) {
-- 
2.53.0



