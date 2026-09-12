Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 452FA3DD51A;
	Sat, 12 Sep 2026 11:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211129; cv=none; b=YWlAeBIuuDZZEne7Q/Sh6UMuGzFxqHgaksfemES3f/hwXAZNyLOyoZK9WXeXmoeL2PR5hdl4A/ZmXUEVZm71+YjzJkhuCyKja49WJeoKQPxx31kt0i7FkMKCt1AmxgyeXZ8Ibu/g9Iubs6I8+fWekch3Jg2zfld1m0ARhGJcie0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211129; c=relaxed/simple;
	bh=Y/ou90K6FgU1abAkX6Vat0YmvA4HvtJ1MD4fdDXTzx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MYalGe5/pRy9CojlQqon8u1eferLMQ+GTU4Lq93/8VPR/J3oPw1XtSsQRge1yupx8VOuLFAqMOp0jnZQdJ+FMHbSeC4f6qGER0EOTGfQD9UAopEnX6LqMjZIhlF+9Iu8+EMC7xCvd6cPbTYTEZYIAY0F901WnV42v8VeG8yDbmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JP27xKKI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JP27xKKI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08C491F000FF;
	Sat, 12 Sep 2026 11:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211128;
	bh=E8dDVlzdjMlKB03XZmbGjVaUsP7gN3aOE2Badr2uPbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JP27xKKI+aG8joH+58ghXXdBheq1cYVarvDZnpYtlR+jSapwXq36D3djWG6xhbR7A
	 HMQ3KCwPfryCOWK/3B5ZYzuwyFdRReX9zhVFzsHjQaIXy0a9DpNrmnRU5me9woqxuZ
	 5B4BL+qGOZlHwfnCGmVlY3oe57jINMgPpn7ypBko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henrik Grimler <henrik.grimler@axis.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1167/1518] power: supply: bq27xxx: bq27z561: fix invalid AverageEnergy address
Date: Sat, 12 Sep 2026 08:55:36 +0200
Message-ID: <20260912065649.864418440@linuxfoundation.org>
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

From: Henrik Grimler <henrik.grimler@axis.com>

[ Upstream commit 2da28b059e0ddcd2e1956eeae383246207965573 ]

bq27z561 currently uses the AveragePower reg, 0x22, for reading both
AveragePower and AvailableEnergy. The technical reference manual does
not mention AvailableEnergy, and it does not make sense to read a
cumulative, always positive, property like AvailableEnergy from a rate
property like AveragePower. Set REG_AE as invalid to fix it.

Fixes: 6f24ff97e323 ("power: supply: bq27xxx_battery: Add the BQ27Z561 Battery monitor")
Signed-off-by: Henrik Grimler <henrik.grimler@axis.com>
Link: https://patch.msgid.link/20260811-bq27z746-v1-5-3a4fa38205cc@axis.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/bq27xxx_battery.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/supply/bq27xxx_battery.c b/drivers/power/supply/bq27xxx_battery.c
index dab655a1cc20d..01c9ec1116fa0 100644
--- a/drivers/power/supply/bq27xxx_battery.c
+++ b/drivers/power/supply/bq27xxx_battery.c
@@ -495,7 +495,7 @@ static u8
 		[BQ27XXX_REG_RC] = 0x10,
 		[BQ27XXX_REG_FCC] = 0x12,
 		[BQ27XXX_REG_CYCT] = 0x2a,
-		[BQ27XXX_REG_AE] = 0x22,
+		[BQ27XXX_REG_AE] = INVALID_REG_ADDR,
 		[BQ27XXX_REG_SOC] = 0x2c,
 		[BQ27XXX_REG_DCAP] = 0x3c,
 		[BQ27XXX_REG_AP] = 0x22,
-- 
2.53.0



