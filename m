Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F650229690;
	Thu, 12 Dec 2024 16:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022534; cv=none; b=BLILYMURFbIhBNmgGtf9nNhfqWkvmGIiDwF/OoqXbelNKsW1cHP4aaeQKzkScF0OKvQNW5spII8rU2llJWZxzsGAfnk30F+WehzOssbrLXCf+uluHrc12e2IHs/hUAg1W+Y+yNsAerYd+tNe9z/ZYPqa5kAaJ2dEjaPzOiQGnzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022534; c=relaxed/simple;
	bh=cWyRP9cLV4fkVtkZbf/BZFF+ClULPRM1LNtKCgUNr7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Myzq1Rj53gLD07Cj1lT3rKZ0GTW5G9IhdY0R0UrYLC06TQ5q2sCLfWhc9/NDwq92rMks6Sm0XI5zvKdlrHUfC+c89iu89bbXTOnmLTCHsO+EeXWGmxkoRLR73EJHrKbJFEQvqd9C13AYvcqausWNYvfeqEwHpplt0wUgp2B4qmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2UubcWs4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2UubcWs4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8C74C4CECE;
	Thu, 12 Dec 2024 16:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022534;
	bh=cWyRP9cLV4fkVtkZbf/BZFF+ClULPRM1LNtKCgUNr7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2UubcWs4pt9AtN/Qa0jbHnpGr5n2jlKkNuILM2yURJW9oIMvfoSYYJCbaZWvMt4hf
	 lz4TXzz34HhZ4ipjlPUo6OJ6R8jwi931Syh7SlxbPnYxa9mVnFkrkOf3YYAi90ENHI
	 QvMHpE04PFOZkA12ANYyX5ejBG9uymusEcCGnqrs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Murad Masimov <m.masimov@maxima.ru>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 268/565] hwmon: (tps23861) Fix reporting of negative temperatures
Date: Thu, 12 Dec 2024 15:57:43 +0100
Message-ID: <20241212144322.060048228@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 2148fd543bb4b..3b2e72ed38c57 100644
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



