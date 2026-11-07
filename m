Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062880;
	b=IafF31w6wHZMAFtzKtohgVJtbGnt1IrMFc38TlhRsc247DyiG2fwyR72neij0USKQ5WW
	 VZkXyBUQJeRiXPR3J8P5iuOzstYaWdTGBZJ1Hvc+ieJIjleDG7vyHUZf3qRncFexo7Yjm
	 XAVWglK9DHutfUlZVLihuymLCXaqiyF5GIhVgKZz8ozGquHeCk9DRanmj/BBonyX64lhj
	 l3PX0n6Qv/d4xYgSzQhWvsZJ3JMo5+wlOTgBOQagF4jC0Um9p0CJ8lsR1CDOkwxtM416H
	 7guoM5Y262+DbuVLJEFzzC1PUFs1vac2VLb/f5008NKbn7oYL9Opvai7rguNTi4ikcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062880;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aNRWQLk4WvLizWP8XTNpYHns9V46a1I7kVAS8JehDZA=;
	b=h45qsiOp1hmzooAButnjlzRwoWBnyyKmwnP/IufBE5mLQiVvBQRBIb4U21uYC49Y0RIC
	 bI7IhxGP2PiajuVwnVd/7QX/shpGTLSamiFUlE5e3kTSjGA9ly/Gk7xNoNlKGxasgz59m
	 hJoeNWdWWGqDc/lZ69xprBhnA2kwZxl6rc0HYEoveXkpJ+TenOF5HdZOYaAGoRYdfMFpQ
	 FcJnB1tX9WLnZkOjvQQIpywM25BCqu1BQvKGbkavYf0yvLkkR/CpVmw66wUtCTsUli3t7
	 rA37wIrIBbVb+Jhl0km5+aTPVTEdPFVoRJTtFFeuHEls2Ck4WKZP+K/LL/3ZmPmCOkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="BSVMvfO/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D94E4606A326;
	Sat,  7 Nov 2026 14:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BSVMvfO/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8621E1F0089F;
	Sat,  7 Nov 2026 14:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062879;
	bh=aNRWQLk4WvLizWP8XTNpYHns9V46a1I7kVAS8JehDZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BSVMvfO//8qz4QmV9jTtv9USP4q+RpBAXSlr3rEyotPMwWzAbEbqbFLRkklf7SsiM
	 RJyx+euSXBouBKeHtsrF+XBppfkAjOARGZD5+AHlJZj3U59egFI4b5xl/H6Iuaow5o
	 DaA+6aJPpTfikCZ/whadVV1dp46wueWkgWWCd90M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 161/869] regulator: core: Fix c_rdev reference leak in regulator_resolve_coupling()
Date: Sat,  7 Nov 2026 08:47:23 -0500
Message-ID: <20261107134857.739141192@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit c41b69e9f76fd9632662714c1d37860468e8d773 ]

of_parse_coupled_regulator() returns the coupled regulator with its
device reference incremented, but regulator_resolve_coupling() returns
without dropping it when the coupled regulator belongs to a different
coupler, leaking the reference.

Fixes: d8ca7d184b33 ("regulator: core: Introduce API for regulators coupling customization")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20260917142535.2156720-1-vulab@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index eae756c82c262..ad7f26b14621b 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -5659,6 +5659,7 @@ static void regulator_resolve_coupling(struct regulator_dev *rdev)
 		if (c_rdev->coupling_desc.coupler != coupler) {
 			rdev_err(rdev, "coupler mismatch with %s\n",
 				 rdev_get_name(c_rdev));
+			put_device(&c_rdev->dev);
 			return;
 		}
 
-- 
2.53.0



