Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774386;
	b=kccmnV3p74P7G7md9jxiXtRXzsuP5yMtit3qQEfoUX/xa+GpZyet6pzXAfq9FGL5p1pn
	 Iy28QupyW8CO8tVwJa/yZRA6pXzphhmNbTOpyQo1rUYZJrg6DRL1LZC1g4mnBsyoZsfy6
	 9vnJ90+9L1wqB5FFSdlXx5rOyAjFPwbW3JiGuyKIzteuMWna10NxnxsjKqBVGlc3YyMSW
	 MYE5zJqmjf+GOBgNj4pppraepDJWsJj1I+GZDZgC2DejSPXV4BiSsAyi3kygx83z7sGE9
	 KyeZIu4U5NvBgTBNzknwApjFhRhIkp2f4IJSTiKJ8Y4EUKQCJX61w2E1192kMMQkmaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774386;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+3bG7Wu9RHzmWMVt2GHmNu4vB2gsc+dRoCrytyr0IXY=;
	b=N3gSMWA+F1k7UvYWGMHjQgsluAmVzTNMc2DPQXOd0pmsdWrAeNwCpIuAqPszNf/JjUxs
	 pzntmR7EfwWjexIxx4eFrQ9Ez2rF5hNnT9jdiLDMvxTFMDc24NgZIhhwICQL32lb+BYqW
	 9xYmvn8Od9RzVISRUrWBCQjj80LSajRB8IZssi4pTpNhxpLtOUggmdVJPl5l/6d67SEav
	 05IkjGV5TAuAz8TdGE9zhZI0zq+ptQHfqt6Fvyldnh+1GDxlNoh5MDclIPQW+GrutJ0g1
	 pfXe8T1vEUgsLz7obd2HQy0aVEREORdn4KbYsxUKNqoXaNvEbMwZ2OcWpi8GSqk7XMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AVLNZePi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C614606A31B;
	Fri, 23 Oct 2026 16:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AVLNZePi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B75AC1F01825;
	Fri, 23 Oct 2026 16:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774386;
	bh=+3bG7Wu9RHzmWMVt2GHmNu4vB2gsc+dRoCrytyr0IXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AVLNZePiWViVw7BMOqdy6kVarVQjZK9h0wxEleIWSZLWvtm0Tf6QS4nV2uz6LG9K7
	 NceqJFE3RgtFVmi3CccQ7L8uXPmbUAHWjKXlnOLWRuOQejd4KQGgqgTlhXUX0TwimN
	 A5jjX53xlPpvlGG9Y6rfGeg8lLwELZsYosnBc6e0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xueqin Luo <luoxueqin@kylinos.cn>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 006/242] power: supply: ds2780: Fix ds2780_get_capacity() returning raw value
Date: Fri, 23 Oct 2026 18:37:28 +0200
Message-ID: <20261023163713.955508531@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 5b57bbba79d44..ef2446386c2af 100644
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



