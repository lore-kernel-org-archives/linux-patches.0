Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6299367B67;
	Thu, 30 Jul 2026 15:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423891; cv=none; b=OqwTvA/y1bDN+KL6tL3SURibH5VSqJT7ho+AJLcOLgGevvi2N4tpp7t7eJ6d/ZYvcUDH+jxaZ6Lumi25i+2PRtnsBca+VjCGIv+oxeyskv+1uKXGQObAqfKsdmR2VsLO3qxW/J6ytVZ9qnzdmdVJFwHVN80m5SgTOchYAZj+9n0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423891; c=relaxed/simple;
	bh=VHrzPuMIYeVeY7ZxHjnonIdAs7nwKhnq5OJJcDU9Gtc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sgdb/2zc8bdw/L7A1Vff4SBSeyg1enVGvmqqvb/HuGEdx6gNgJayb5wrlZKKJQ1rTgZ9X94fBXExA13/Ge1GBaSUp6UUwObbPZ0ik1CA7xHajcIN1qrfIfQbdbfEoxCd/UKKryWx8uxr1ovcVL5EbEbqZ5QfCWTU7vFNQtTH5FU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B0pk0Dp4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B0pk0Dp4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C774F1F000E9;
	Thu, 30 Jul 2026 15:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423890;
	bh=NV6fzdymMDeOytvA94TeD9z/LOHu4xGJouH0tjvvH4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B0pk0Dp4wan4IlHtUv93pQjvXILxr6P7tZUMgNIcQph2GsPruBJhPJOe1Ij5Dmnbt
	 JNKB2G74nEqZLrG2S0p8GoXYWiT8DgmVJ+5GGpaYFKODdnYTZ53NFrvQYBpbZx3Msm
	 yD+o9etatFnwwcXvp+oqpipoomTWY9lIbj17CQS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eugene Shalygin <eugene.shalygin@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 201/675] hwmon: (asus-ec-sensors) fix looping over banks while reading from EC
Date: Thu, 30 Jul 2026 16:08:51 +0200
Message-ID: <20260730141449.415531755@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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
index 95c50d3a788ce7..aac4706cd437fe 100644
--- a/drivers/hwmon/asus-ec-sensors.c
+++ b/drivers/hwmon/asus-ec-sensors.c
@@ -1050,7 +1050,7 @@ static int asus_ec_block_read(const struct device *dev,
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



