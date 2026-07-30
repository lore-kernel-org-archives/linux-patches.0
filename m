Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB9413815D5;
	Thu, 30 Jul 2026 16:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427349; cv=none; b=QXHRNxKDu1nbzh+wkSaHKM655QDWkQ3GG+n4V8EQcAwVFQ1JsgSR/cM5rrkvz3S0KWYlnJ67edKzFEZl6sjbLhGogwYpaYZrntZQLCEfGrFGiHWo4SntT+otqcpB6mX09/Ry6XvNE1TIZtM62cS6sPEc4Rbpy+29zCxkcrXY/JU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427349; c=relaxed/simple;
	bh=Sxygthbfw1D9WBavRQraP6LeiXynJuXJVzCrVTMv3SE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mypIINRQiltjXZG0IukfzpskhNMi4Yf97u0PxIN8efO3uMIfH3KLX4pwFuggzZaknfmc1IAo+EyupOSz/1dpxQTTdS5Cla3i8UG1Lh8SXZHIJdM5VPq6hkejl+IepdYfBq5zalyqDuJ0/R5jd20FZCHQLqrLjsZMrYWqz03QoLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=raGjlZUi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="raGjlZUi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3399C1F000E9;
	Thu, 30 Jul 2026 16:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427348;
	bh=/F/OJm03IldecTGkLhli185ZEO5cnXZXoTNnV+Nbl9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=raGjlZUiqLtgBG0DhAAXYxh04Tb3j7nyUi4nIpLkUbxFM822+vAnha7sGyUWSHKNS
	 /KG/2Ul1xNH0ATU+st6N/p29N0pe8ZyWmc+M05jNMxDE0mT8lZ+oKe5YOh62UAWz49
	 OwK1KE23nrr7u8KmwR7XFYUCCGrL+12kjvzBTAnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eugene Shalygin <eugene.shalygin@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 140/484] hwmon: (asus-ec-sensors) fix looping over banks while reading from EC
Date: Thu, 30 Jul 2026 16:10:37 +0200
Message-ID: <20260730141426.503306212@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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
index bc2197f1dfb7f5..a6949358979e2f 100644
--- a/drivers/hwmon/asus-ec-sensors.c
+++ b/drivers/hwmon/asus-ec-sensors.c
@@ -754,7 +754,7 @@ static int asus_ec_block_read(const struct device *dev,
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



