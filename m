Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FDAD38DC72;
	Sat, 12 Sep 2026 16:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228891; cv=none; b=vE/40iHStmsF+k50UtnSvU01KlcOyQumlrEFnLCLI7giLmGLZMFnpMsnXLW5N0fXgUFaCpG0yXAUy/dgq0x0/5j/ZHumzyaQLmF5I2VhQZeYHRq5zVQsSqoFaPEmRNmPYJS0EOS2WNJa9ITIxzjsy1Ng/81xPuu3r8VrBzo/CDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228891; c=relaxed/simple;
	bh=7LqkPP4csS9IX+8j48GZ/BT6jq5uGZ4HWjRE/qRfpgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T4ZVD2PcFK3qcCmy2F/fQUR5ZC3mEBbmwkiMP86e/lS940kKbgPxtqC6ws8LElB8oo5Ifj0/8kF5yQ4lNSeNQODjz07arvq1F11n6Zs1xEHEqiYeZV5DzwXRIXKhQMo3+7N6zHLzadEcITew63cNgDV048TMiLg4iDZpq/MqVfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qrA/26gx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qrA/26gx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C0761F000FF;
	Sat, 12 Sep 2026 16:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228890;
	bh=/AEze/t170rsP3lZjB7VGe4M6tTLFL2mmSPzWFWuq0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qrA/26gxs7kWH64bKlPdxY99SbTmM+LOBfHHPNWkb+d94LRdFoZrOr8YPF2aQosqa
	 0rmX4a5LHHH9H2KLiud73ucWAeniykTxWD19VDtjzNVgCHZigrfgBFKV7JN56Cm3p+
	 4fZ3MQdIycZX98gvl4nHh3X2ix+iacdHNyOwAvtY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0479/1191] clk: versaclock7: Fix APLL clock leak on probe failure
Date: Sat, 12 Sep 2026 08:53:27 +0200
Message-ID: <20260912065558.991336102@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 0ae191f50b4b2..f1d83a2b93d33 100644
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



