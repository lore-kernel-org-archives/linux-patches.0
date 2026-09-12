Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D68281DE4EF;
	Sat, 12 Sep 2026 14:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222392; cv=none; b=pcx6pV4KfGO950niNp3CtgvD6PB81VDQToFfB7V5JUewemD/ca6IMRfC3v5mogB8hRrq84O0gSaCNmdzp2ih9dGU+npcd5fEbMAK9O/fHA9MB5Oh2TGN+Y5/QRxdJ+uskrvueiJI5BNxVeaFvE+ew1uV4AxwnvMoTUB4ssiD0uA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222392; c=relaxed/simple;
	bh=ibDQFuqIYrSnTXBtOO+6+ziPlaR0hUjlWF1+c92t5hc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C0quRnwvpTY5YbZISDPk8QoO+74IahbRj6L/FTYhsKkKLMjsxBFByi6tPIn81tmk/I82SScDst+HALlGGw4ql2FsaS2OghAw0aEHVEZBJv9v4Zz8ve6idgsUlTG5+yTCZinFxgoV/ZgvKSW34W0q4aKN69nugGstmfmGmAXxXwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TOMOYu4o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TOMOYu4o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FBF01F000FF;
	Sat, 12 Sep 2026 14:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222391;
	bh=ClBC7mOfGkrRrMx6RnfBQo7oRc0aO/V5TXH2VqNEwR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TOMOYu4owGBEyRozMU9Kuy+dsNytM3zCwqizGfEstwmBwnaMVQ/Nvk7fOSK4JVoFA
	 BLIjq69OQ8CGZTREXsS5e2hNtzYBS06EDm1GOXFLHmfu3M73b65IGI8vVU1SqemIQF
	 uT0jmNGB2BBDdzFtKPs74YQfQpEU7WN3RKPKPSJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0576/1424] clk: versaclock7: Fix APLL clock leak on probe failure
Date: Sat, 12 Sep 2026 08:50:08 +0200
Message-ID: <20260912065620.198120846@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 9ab35c1af0ff9..7db12918b84d4 100644
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



