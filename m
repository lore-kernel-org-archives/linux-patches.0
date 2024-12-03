Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23D5F1F75A0;
	Tue,  3 Dec 2024 15:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239335; cv=none; b=Xc/MXKY5RqvDy6HOvjk42Jv178DSOYHsFMLx49gB2ercAny86YftYJJPLCz8ZeO4RqJc0ky8YQx8lC8fkiq5DDKBbul0MA99q/YxDXvSQHsWpKtcmLdYf45UK1ExsVJO4+3gksnPPNj+loL/JXQ0m0XedyyFqZlXeWBi2iF4afo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239335; c=relaxed/simple;
	bh=+AWonIdbxwALlKB9bx5oC73uP1zRV1Qxby3loHXvAD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WPij5BTsEnHuJRIIvuneeFp5vTiq68PHapkw55S5ARIyIHK0zKqTYFXD7NMJCjMXpj8tjenalqomPBzBCyg23iYhnsfvUVjrI8VTLrH18cMFjW8mYc1k3zK5aQzN/Z+pFwmnzz9Cx6gdRBPIXukDTJ79BHxKZh6GkAKZlJEQYBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OWgPDBW9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OWgPDBW9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2F69C4CECF;
	Tue,  3 Dec 2024 15:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239335;
	bh=+AWonIdbxwALlKB9bx5oC73uP1zRV1Qxby3loHXvAD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OWgPDBW9wVuQxva5/Ds+P6cLwZyqNCFYweYswRdywrR8xUqHi21WDjQJyQSPyPhSp
	 OjCmXdNQLDARutg1ZcxSjUutQf55iXSuehVCvYOYVxJEtf2vSCdFVg+AguNfbWdfvw
	 yQGlejAOc7Z6SdR1S2bWarPyk8Z+TxM2yRXiMZI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Murad Masimov <m.masimov@maxima.ru>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 547/817] hwmon: (tps23861) Fix reporting of negative temperatures
Date: Tue,  3 Dec 2024 15:41:59 +0100
Message-ID: <20241203144017.258125732@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Murad Masimov <m.masimov@maxima.ru>

[ Upstream commit de2bf507fabba9c0c678cf5ed54beb546f5ca29a ]

Negative temperatures are reported as large positive temperatures
due to missing sign extension from unsigned int to long. Cast unsigned
raw register values to signed before performing the calculations
to fix the problem.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: fff7b8ab2255 ("hwmon: add Texas Instruments TPS23861 driver")
Signed-off-by: Murad Masimov <m.masimov@maxima.ru>
Message-ID: <20241121173604.2021-1-m.masimov@maxima.ru>
[groeck: Updated subject and description]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/tps23861.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/tps23861.c b/drivers/hwmon/tps23861.c
index dfcfb09d9f3cd..80fb03f30c302 100644
--- a/drivers/hwmon/tps23861.c
+++ b/drivers/hwmon/tps23861.c
@@ -132,7 +132,7 @@ static int tps23861_read_temp(struct tps23861_data *data, long *val)
 	if (err < 0)
 		return err;
 
-	*val = (regval * TEMPERATURE_LSB) - 20000;
+	*val = ((long)regval * TEMPERATURE_LSB) - 20000;
 
 	return 0;
 }
-- 
2.43.0



