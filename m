Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EE1C37F011;
	Thu, 30 Jul 2026 15:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425713; cv=none; b=E54ozYI5yc41ozZj8mPGNJqzAeB05yw3uYVaFNv3wc2kb5hvel5EiEKtBA6zG3UR7gMpYtzoL2JwQjkVuUKD6OmNCdYmxnsP5TImA2xqn16Fa3RZbk1ZwQmUvk03S+46zcXSyQE4MxUXyiWhcTj9qDcsrmEpUuf144viVcE/Uhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425713; c=relaxed/simple;
	bh=48x6t5WsNCDBaKAo8U9aEjNFIqYd/2dLSEOaTVfZeN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X+oR7xsgqT6VnfcZ1zibX8KX9FXyiJY7W/gG9Pvn3oWUcPF3bzKllEy3Zuv6g5F0zfcVKm3g0yEVGhTL1w5JaSkHqB8tCy0ZXNbanb/Pih/84WAVsXcWtkA8fDUqJZJ1B/vy6QQVo4BC0964D9O5/Y7qTS/aNcpupiP/mGsxGI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZIxXeywT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZIxXeywT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A51AB1F000E9;
	Thu, 30 Jul 2026 15:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425712;
	bh=ro/mdVIYkELKkcV7uXAqI2JwwQuNZjSZ20hH0r+yxi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZIxXeywTFH8BTRTDrqJwP/I7qop55zoAkbZKbOLD2KAi0NjlyxRskgHfprLFEVnTl
	 umnjfSFVtH/z4BE9b9QLRY3cZu+nKib1fJgHtA+GehiglQkonGJVFqorEDSDwzMvGA
	 jVNsYZSX43owtd6F/2onULMQUJvFmBS2DHaB5Xr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eugene Shalygin <eugene.shalygin@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 165/602] hwmon: (asus-ec-sensors) fix looping over banks while reading from EC
Date: Thu, 30 Jul 2026 16:09:17 +0200
Message-ID: <20260730141439.438982276@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

From: Eugene Shalygin <eugene.shalygin@gmail.com>

[ Upstream commit e741d13cc2abfc6fccebe2008057aa52e285223e ]

Do not assume there are only bank 0 and bank 1 available, just use '!='
for bank comparison.

Fixes: d0ddfd241e57 ("hwmon: (asus-ec-sensors) add driver for ASUS EC")
Signed-off-by: Eugene Shalygin <eugene.shalygin@gmail.com>
Link: https://lore.kernel.org/r/20260711074217.554656-1-eugene.shalygin@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/asus-ec-sensors.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/asus-ec-sensors.c b/drivers/hwmon/asus-ec-sensors.c
index 483dfb806cc510..909720fbf2685f 100644
--- a/drivers/hwmon/asus-ec-sensors.c
+++ b/drivers/hwmon/asus-ec-sensors.c
@@ -776,7 +776,7 @@ static int asus_ec_block_read(const struct device *dev,
 		}
 		for (ireg = 0; ireg < ec->nr_registers; ireg++) {
 			reg_bank = register_bank(ec->registers[ireg]);
-			if (reg_bank < bank) {
+			if (reg_bank != bank) {
 				continue;
 			}
 			ec_read(register_index(ec->registers[ireg]),
-- 
2.53.0



