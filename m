Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211830;
	b=leTGA6EbaVaHvPHjjaxQU+460XVA2T2DZGMFRaITRq4atQlMblCtYgGKFWCmH1pa/xCb
	 0ThRQkOcs0akqPI/IIyv/vGxMjfWaOQEuhnhUg+wcDz/d0ka7pODmAAT933E7McJUUOrT
	 qSfIzXQ+L8HV6BSXYCaIDrC500aDjPYvahgQChfp35uRQnw2YVUytwJb/RRRnNRg7Mt0v
	 p+TglJY7W0yJHrtJRgNKCm2HMjTrGLYxDY4ev1gz1VF9kpK611URwAu1FoiZbHT/sB+st
	 f6mu/tCDjaKxQs5tAmzojkgMPx6JWvWbs6i6PKRP4B4dG2jmnxyA5lLwqQNBngSTsQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211830;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JrAgIGCc13iHppJbOehtuNCGSRbPQNjiqNEXadYY8po=;
	b=0LCFhvL6Owa44Wfqqg7w7O07n5DsIRWIfsoRmF52pDtp3c6IYiDYDc4b+lmiujkrV7zH
	 beuZBk+2APaEwzbrOaUK0W5qQRoEyORokU+BTG2GfyUr5g1E3d3HmWBj3TkoZjNcgX+c3
	 Zsm+O6j7G++rJoo3Y5CKT/PvwGgxvF9OeiXa3JtIVuklQ3Id9lJPN+l+6qyU5Nqk0yvVe
	 /f0f+ZyZYTiMnKsK738IUrOXSzlZ9hq+l26iOnXhX7P7tuA3gtiO2Ki6OGfNGLFzP28Ys
	 dP47mK2nPabuMlUEVzYco+EAFukJpFUIKmW41FbneeYao8qo9jZwA1DVn87Q/F95mcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0APxMJO3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC327606A337;
	Wed, 28 Oct 2026 18:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0APxMJO3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A7851F01825;
	Wed, 28 Oct 2026 18:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211829;
	bh=JrAgIGCc13iHppJbOehtuNCGSRbPQNjiqNEXadYY8po=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0APxMJO3RoeJwnZmxuVi8ZWGhxzjaYrMKjhb7SXZpr3paPRyLAlIvtJzwqIS5nqhu
	 q7IfnCY6XtnnjhM4cWPegdBvINgKRH+ZtpFb/+eDGe2o7ia7ZnnlB9mdlw93qrrNON
	 L+KIG60e37dmYenuL0+a6mbl441PIhlAC65JQBAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xueqin Luo <luoxueqin@kylinos.cn>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 469/571] power: supply: ds2780: Fix ds2780_get_capacity() returning raw value
Date: Wed, 28 Oct 2026 18:00:16 +0100
Message-ID: <20261028170019.150366435@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 2b8c90d843257..0a1f79600c608 100644
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



