Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8A7F47DD48;
	Thu, 20 Aug 2026 16:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243910; cv=none; b=KNuVmroNRW0/CV1xNlVV3329oeGQgJiP0JNuzHK4crtJcnGOOSkZ+X54bWwZY2CRQScORsNwUx5dxoS5GFxtXxR6FS7luzFhX1E3Dqq5mp8UKENjnWakfd6EQw5Xk9Vd4+rAa0L3fy08/vRTyyAT508NfALIB2brW+zVdaaP++8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243910; c=relaxed/simple;
	bh=WM4AJwx7PBjSoct66NK8KNFPh7HV3jnN3nPuIHdXmlc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lj25pDM8/frRK+acmHx32zsmDKPUZH8+KgKwDU6sAv9ayGI/DADD+zwuz4MBnAXgj4zod4W1sWpLxtBRbY7f3hO7dtrKiljRqm31CZtyz/j95dFwaYX41EgyFsS5+c0Yhf6ivB9ZdBphKMS+3DQEryfiXLAFswIh4To3azGp5tE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1LyAL4ok; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1LyAL4ok"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F23A1F000E9;
	Thu, 20 Aug 2026 16:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243908;
	bh=LBZb06A8I2bPRa32ZCIA8/R3XUGEdsz5F9LvNY8C5co=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1LyAL4okx6hAjTgunmJtvAGcXW9/GAD5NEphaAjrVrF0K8scMAtT20h85sx1VeM5R
	 y/cBdw4Af3mad+2UhahpLRIaaxvKmDHQvr1d4TYZJxS5DiZSf/qJ8jWkIdB+HY6l3B
	 8gXEjF5mo01kA13fyy70SXdfUqO0M6nMeOunP02Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 241/272] i2c: bcm-iproc: remove printout on handled timeouts
Date: Thu, 20 Aug 2026 16:57:05 +0200
Message-ID: <20260820145238.850921720@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit 796e2c260187e32530cf343546ba1cdf2e2f5491 ]

I2C and SMBus timeouts are not something the user needs to be informed
about on controller level. The client driver may know if that really is
a problem and give more detailed information to the user. The controller
should just pass this information upwards. Remove the printout.

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Stable-dep-of: 98f2e9e6d6f9 ("i2c: iproc: reset bus after timeout if START_BUSY is stuck")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-bcm-iproc.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/i2c/busses/i2c-bcm-iproc.c
+++ b/drivers/i2c/busses/i2c-bcm-iproc.c
@@ -821,8 +821,6 @@ static int bcm_iproc_i2c_xfer_wait(struc
 	}
 
 	if (!time_left && !iproc_i2c->xfer_is_done) {
-		dev_err(iproc_i2c->device, "transaction timed out\n");
-
 		/* flush both TX/RX FIFOs */
 		val = BIT(M_FIFO_RX_FLUSH_SHIFT) | BIT(M_FIFO_TX_FLUSH_SHIFT);
 		iproc_i2c_wr_reg(iproc_i2c, M_FIFO_CTRL_OFFSET, val);


