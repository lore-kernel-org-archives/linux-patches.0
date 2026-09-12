Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36A5D284B37;
	Sat, 12 Sep 2026 13:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218885; cv=none; b=Q4hzucg6Ay2APzmFNa8hNm4uDm49kStvhFU1gnYTb4aj+EDLrniBPda2cGybue2F5Wqo5/VWBbN5j6AFuKWzTrq5lhqFTS1DlQNkKifpasLWTSy1PyLJzYT9t4wqrKXSY0v9F08bLZuH3Kh07YFaaLy48bATJhKxSvtUe10GJRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218885; c=relaxed/simple;
	bh=4QK2h9XMQ/6x1AxNfyjETcWB7zZEtwFZKvgbbooPqXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z7L+VgLJ3+HyWU/FfwNH7zm4ySU/MEgdcthNJte7VEl2jucdDf9norBGcMLB+2uJCLBNu5Bo9YqznE4A09K5jLms5oCuyIq01dk6Xd5ipyuer+P4A/ASSbPExuTVdQ2MQg1cGwIZidVSmbSrjmBwShtrxjrUmPvw2FTv3pYZg9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HdD7L0yD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HdD7L0yD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08FA51F000FF;
	Sat, 12 Sep 2026 13:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218883;
	bh=+K3IuXBS474pMIby/5bzxdiBZgaEIrN+LnMjVdSv0Qs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HdD7L0yD4tnnnIfNpyytgauY4mMAU0A+2gyPwjQJip/BPskG55OEh2gbX8QPy6Gsb
	 i/SCXP2OXlIsvbeJXMS7dW4NGJNkqseNT1d0clNxg076p5306W4rqQV+JJly9zMXZb
	 eV/1/fteoQCeB/RjLbVm5SzUxpHRdieAFxZL4axA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Max Filippov <jcmvbkbc@gmail.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1236/1376] i2c: ocores: Disable clock on failed resume
Date: Sat, 12 Sep 2026 09:01:02 +0200
Message-ID: <20260912065635.092999942@linuxfoundation.org>
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

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit 43eb13f13385a1e7251978a1977ac61b99edef01 ]

ocores_i2c_resume() enables the controller clock before reinitializing
the hardware. If the clock rate changed while the device was suspended,
ocores_init() may reject the resulting prescaler. The callback then
returns an error with the clock still enabled, while the controller
itself remains disabled.

Disable and unprepare the clock when ocores_init() fails so the failed
resume path balances the successful clk_prepare_enable() call.

This issue was found by a static analysis checker and confirmed by manual
source review.

Fixes: e961a094afe0 ("i2c: ocores: add common clock support")
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Reviewed-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://patch.msgid.link/20260813153155.3953577-1-ruoyuw560@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-ocores.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-ocores.c b/drivers/i2c/busses/i2c-ocores.c
index 482b37c8a1297..d62a664a94d54 100644
--- a/drivers/i2c/busses/i2c-ocores.c
+++ b/drivers/i2c/busses/i2c-ocores.c
@@ -761,7 +761,11 @@ static int ocores_i2c_resume(struct device *dev)
 	rate = clk_get_rate(i2c->clk) / 1000;
 	if (rate)
 		i2c->ip_clock_khz = rate;
-	return ocores_init(dev, i2c);
+	ret = ocores_init(dev, i2c);
+	if (ret)
+		clk_disable_unprepare(i2c->clk);
+
+	return ret;
 }
 
 static DEFINE_NOIRQ_DEV_PM_OPS(ocores_i2c_pm,
-- 
2.53.0



