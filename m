Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F37A347ACFA;
	Sat, 12 Sep 2026 12:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214463; cv=none; b=jGNwmINGBHYmW76mGkCAP4gi4E2h2kuj5Hvf6DXaURvOP2viPanJOUbx0p6ZJxDAqagvzWptyb4PLcCqe6NtQ0yO1lupdCigkjdlvtxQjWKvuaEJtExbvR2weJGnPSINxv9p2GEdU67T+ZC2Ey3IEUCnVIy8yJXSLLDzUFq3+ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214463; c=relaxed/simple;
	bh=4fboB9wX6Fg4FB2lJ5dHTUDjoJZyuzXiAtXdURYiv2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qc/obYe37dlX0rH0Xd0fxIxjBmNGEMKtI+sFksA49L8dHS4+0MP9U0lggyJHlS1ajIQQPNSomP41KsNigDEk2Y3NeuLX8DrA16MCuBTbwNEZyMWxXNO8iwiuTVZMVFZeCYwl125HOeoSXi9TY/AAMxaFYRuv4z/oIKjrrGxBfZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wPhXhxUR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wPhXhxUR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1714F1F000FF;
	Sat, 12 Sep 2026 12:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214461;
	bh=+5lyuJv853ErhunaEY4uqUQhrqn77WJIM67xIHnhfQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wPhXhxURV2oikR9N5su/WTg8FchJ/mGMoXXP/QgAVON+X7d0uXGabZQReP21CAql+
	 hzy1jyLwEanr0Hqx/qCPtlAHcoe7CPnczuW25Eb57d7V19yLPdx4WpKcIoL4Pooahp
	 DEt1+A55bTj4YfKBSOiM5lc3Wzi0ZO9TCMcsGOhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0329/1376] clk: versaclock7: Fix APLL clock leak on probe failure
Date: Sat, 12 Sep 2026 08:45:55 +0200
Message-ID: <20260912065614.880132866@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index f323263e32c38..e1d6d88b6635f 100644
--- a/drivers/clk/clk-versaclock7.c
+++ b/drivers/clk/clk-versaclock7.c
@@ -1191,7 +1191,7 @@ static int vc7_probe(struct i2c_client *client)
 		if (ret) {
 			dev_err_probe(&client->dev, ret,
 				      "unable to register output %d\n", i);
-			return ret;
+			goto err_clk;
 		}
 
 		switch (bank_src_map.type) {
-- 
2.53.0



