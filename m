Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207437;
	b=VPJifWkOeKal/wkxdDKD875YNOu9FO9ZQCMbaF9u6GNI675PdXJntILbZXtyVmdwV7Xi
	 kAuyEdWyw66xw9CnRd/G8q9/XHe9Fix9oozPQNEUu0UPT4zAWRdz5Y4y3nvqJnrF6uHsR
	 kBtQzbTqxSrDVgOy3IGbS3CKpAVEOXvUtUst7bNdBbTdjLUwejIp/UHq6W6K0xaoMyO5z
	 B0OBW4TDJhPj+SKyT+ZFjgE19VwOpyARhjMH+/p5JGUvtgO0ZNsg87OneQHJBBItMcQSH
	 CCQXoco95LTdN8Yo/dz3E8bpQlj8xNyJq3tQ9zrTPD+Jk7frauwThY9kbMYhG0lLEzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207437;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uKTi7j+Zv6K5CyfbkWjadKkMDxusm7/5x8pgalob6a4=;
	b=Z887aNCxSP9kUQz6LaGSEAYCzMXIU/VS5yQBHmEVvY+d5RUyn4M+DUBJ242e6fjPis79
	 Xht/hFOgB+Ak4rmtFvOnBdVVLo+b7Ud+lWxy/n1QkBoLA6T8tNx9kgGkOszwAd6CunrMD
	 tJgSMD8s7map7RiKmqdcE8m1UWMQISO8GwOcyoVa9PSvlSFqSdka/pHhxw0h7tUEoLTrD
	 pavwIKy1eql1r1w7nhme5uPK0EqGQu0Mg66OMEpuPvTPfybDTwzcE6G0JZIqJjPu5f4jO
	 JZgPDjZGxFKY9QiqaCrl4F97CMO9ANY3bDmEGLwMVgVOzB54ymbi8ZsvpEAmF2BsRHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="NDkld/mt";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C645C606A31A;
	Wed, 28 Oct 2026 17:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NDkld/mt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20A2A1F01825;
	Wed, 28 Oct 2026 17:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207436;
	bh=uKTi7j+Zv6K5CyfbkWjadKkMDxusm7/5x8pgalob6a4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NDkld/mtXQc3oWXdwquwF4q5qKHLsVlf6Kz+pm6YYYGhCVjH/M7ihjnHRWGIEGbu0
	 s8DNQqRdyZEhjQoHRHOlZIVW90rAbxPI/4RNLDW1bZzb4NKo9JM/fiuB7P6y5kWaqE
	 D4+ZI3OdUVvpY9aZKb+LVgTCNqQ3FqXGIoktvTyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xueqin Luo <luoxueqin@kylinos.cn>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 017/247] power: supply: ds2780: Fix ds2780_get_capacity() returning raw value
Date: Wed, 28 Oct 2026 17:57:00 +0100
Message-ID: <20261028165947.767813432@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xueqin Luo <luoxueqin@kylinos.cn>

[ Upstream commit a58cbc8b36ec0cd00d2ba3de7d003de818a27523 ]

ds2780_get_capacity() returns the raw register value instead of 0 on
success.  The capacity is already stored in *capacity, so the function
should return 0 to indicate success.

Fixes: 275ac74629c4 ("w1: add Maxim/Dallas DS2780 Stand-Alone Fuel Gauge IC support")
Signed-off-by: Xueqin Luo <luoxueqin@kylinos.cn>
Link: https://patch.msgid.link/20260901072954.1953121-1-luoxueqin@kylinos.cn
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/ds2780_battery.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/supply/ds2780_battery.c b/drivers/power/supply/ds2780_battery.c
index 1e7f297f6cb18..7219ee3def5ad 100644
--- a/drivers/power/supply/ds2780_battery.c
+++ b/drivers/power/supply/ds2780_battery.c
@@ -304,7 +304,7 @@ static int ds2780_get_capacity(struct ds2780_device_info *dev_info,
 		return ret;
 
 	*capacity = raw;
-	return raw;
+	return 0;
 }
 
 static int ds2780_get_status(struct ds2780_device_info *dev_info, int *status)
-- 
2.53.0



