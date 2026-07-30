Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 091B743E08D;
	Thu, 30 Jul 2026 14:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421784; cv=none; b=ISzFQz/+o5jstR3ie9UcT2h63ph/xbWhYhjL2rJeCUSIVResPTbOqa77uUdreOTvSi2n/ERMsttbNPiAEn4g+vP7ooB6bT+pFRQoeF8bsoWcgJP8ncU7dzhKEhysf1MhRJGJFktyaonY0rCp8GjshOP7pjKXmq3vMRYj1WkjO2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421784; c=relaxed/simple;
	bh=Q3RNQ3F2DzSyT1ndknd6lOjtioTDoZtYqZJOJcpS8To=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CEFQtM+fzZYJwa1xojXBtbDJ668ifZH7musGI0XVs9khbVSIKRsQJK88Zd96n0b0drQPplXu8WrLRYxOEoTgWhbIea0ftsksT2wHb09FUTMQr9ndCU7UDDgM+kmSVFdsZHbwNhZBAqDJn8PTGjlcOQoYr0Oy/o9FOu+Oi3jnLaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kuKeIdBf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kuKeIdBf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F16C1F000E9;
	Thu, 30 Jul 2026 14:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421782;
	bh=ynapbSbUSaAkSaFBWA3JPYDfW4HA4VpBFze5RpNT1YA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kuKeIdBf91rrNMk/gXAwOHcqEl3lUapx6xIKeFC/ss5r26cs2LkpdjTJiLK1ZTerJ
	 toUSfGXkkJepAknDpxmLor4Exnq8tFCv9QXUjU6DGvikIIsUU/3JHLtwePpfIYL2Gh
	 ZUEtLIrjV+9OkLju6ipcMrFpyX2gdixy/7FYb2rY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eugene Shalygin <eugene.shalygin@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 217/744] hwmon: (asus-ec-sensors) fix looping over banks while reading from EC
Date: Thu, 30 Jul 2026 16:08:10 +0200
Message-ID: <20260730141448.896966470@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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
index b5d97a27f80d32..d0a58207b00d3b 100644
--- a/drivers/hwmon/asus-ec-sensors.c
+++ b/drivers/hwmon/asus-ec-sensors.c
@@ -1154,7 +1154,7 @@ static int asus_ec_block_read(const struct device *dev,
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



