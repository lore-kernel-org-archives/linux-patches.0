Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0CA32DBF75;
	Tue, 21 Jul 2026 18:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660256; cv=none; b=kTl+VFLJVCI5G6PTH+Cg/cAA+RD3ipIaPK3saXnZGf93LoumTJBOaicosaurtAAU70AxUwLlI35wPRcQOOCSrbwyfvyk+v7vBV7Qdy1/njRubjXXX1JqN3TxEDEl7BPgVtPFwnHsv8p3MLaWEFyZvz7eeF7amKImLSCuU/p2odc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660256; c=relaxed/simple;
	bh=8UaybSvZmyHAckXIzgBX56kk0eKOqv12jXd/tGV8fwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c+TRb88tCnj1IJaDIrfqdVG+Hk+4Vi0hxD12wEJtTpO7L9WLrdiEdMavfOM1BErVnOQ3LoJZu9Ee8KmVtu4Ws3kxrCNEPF7XDj1G5kUlMu+c/qud1Ai6ypyac4fYspe4YRFZ8lMN+otZogNHUepmDEiFv18bo2knPYoeKCRvAp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MtxoXu93; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MtxoXu93"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 422781F00A3A;
	Tue, 21 Jul 2026 18:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660255;
	bh=8OU1vH2+NSUELmz6BvOWqOTdOM6Ms1Wf8tkOu4rBc94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MtxoXu93W1H8X/uCO4MTQqtfLeAajOIL/nK9jK3c+JwWaSICJBFzkDUm3yUzyWuFS
	 T35q/jrXv8CrIsSe9hxMWgIuqdChI+hOm+xlYM+F2l+l5kr4FDw1opdN4wVXOTNlvf
	 Wxb/YLRAaNmj2x2II1xptN1e/4yM2zJB/GhwoFuA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanjay Chitroda <sanjayembeddedse@gmail.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0910/2077] iio: accel: mma8452: handle I2C read error(s) in mma8452_read()
Date: Tue, 21 Jul 2026 17:09:43 +0200
Message-ID: <20260721152614.281924150@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sanjay Chitroda <sanjayembeddedse@gmail.com>

[ Upstream commit 5bdff291d20c31b365d9ddfe9c426fbfb41da5bb ]

Currently, If i2c_smbus_read_i2c_block_data() fails but
mma8452_set_runtime_pm_state() succeeds, mma8452_read() returns 0.

As a result, the caller mma8452_read_raw() assumes the read was
successful and proceeds to use a buffer containing uninitialized
stack memory.

Add proper checking of the I2C read return value and propagate errors
to the caller.

Fixes: 96c0cb2bbfe0 ("iio: mma8452: add support for runtime power management")
Signed-off-by: Sanjay Chitroda <sanjayembeddedse@gmail.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/mma8452.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iio/accel/mma8452.c b/drivers/iio/accel/mma8452.c
index 15172ba2972c59..cefc7cf4bd8353 100644
--- a/drivers/iio/accel/mma8452.c
+++ b/drivers/iio/accel/mma8452.c
@@ -252,6 +252,8 @@ static int mma8452_read(struct mma8452_data *data, __be16 buf[3])
 
 	ret = i2c_smbus_read_i2c_block_data(data->client, MMA8452_OUT_X,
 					    3 * sizeof(__be16), (u8 *)buf);
+	if (ret < 0)
+		return ret;
 
 	ret = mma8452_set_runtime_pm_state(data->client, false);
 
-- 
2.53.0



