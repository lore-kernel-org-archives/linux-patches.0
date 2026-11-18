Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045125;
	b=bGirpuI/CJBpHZuZ42nW03ejvwAkaOjoso0TGeTj4oPqjMr8SkZpWllilssBLkSqCCR6
	 wnSFLJatxsf3zkThurQRtpcSKvQSjlg9dg8FruKPTHRmm8lnabb5EUM/F9T2R46FjSzGH
	 DNcE/O8PtVw1X3cAancbTv95dK8PhC5uI0PIbPu+wzHBeIi8hdtFJt76ld0h4cX2stPV1
	 5crgTcAGWbB/o1ykwugbL43xZHygmrgBqoxynNEewO1MwOrYmi19MYh5gPFxtvHAOlwXA
	 p/OoNa8/KvSWgNHSPiPCWr8BkVC2E8Jgfu9tSVtpxil5ji/rNiEUYoq5mO+33Ug8HbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045125;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=b9kCsb7g2iWnNg6QbEPUwo7iRiSmzTSQ/VzUZy0lmyc=;
	b=jUheZiPmLh4GhTc1YGvuLTWYmz7pung7GBSiQqqFXmRLsHkRpO4f0yuNnpzTffmGP+Qr
	 HGrUaohj/RtHpN2igD4y2TrhdhBJ4bMnZEdEgK9ej6PfXWgtb0T0+7ZZKrap1GtbopvIE
	 aK7HREd8pmsZng3ClNUrv+NeUAKrdI39LY0TmfO4DzyXCoYGAccphQlowM4W87dqPris+
	 YfAvwW2B6LAV5gciUS0EhEgdpscpAFgDAYuky71Bo2w9uopY1tMZw1oQ2wKhYXrrGQck6
	 dE/v+vgXJaqdiuLIwNctGWUVfQkV/P6HyY+/hBYlpyGOvDK+jJlpzrF0slBVbmsXc6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BIE7ZYtF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A020606A320;
	Wed, 18 Nov 2026 23:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BIE7ZYtF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B5081F000C4;
	Wed, 18 Nov 2026 23:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045124;
	bh=b9kCsb7g2iWnNg6QbEPUwo7iRiSmzTSQ/VzUZy0lmyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BIE7ZYtFUadaftcmNtWrl19w8sDQ6WZScrCOjhzr/KFE9JjOlrDa7GYCrKAXrzR2m
	 1JD2zYIGPhlgd7cPpcgu+rp7ZOS7NTBIqylmaOd4RdqI25ZQkyTBUjLbHFXHVwhv5J
	 i0zdGZGL54ajNkRmM2Rdrv4k7A53W2Mo8PM8CWQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0785/2857] regulator: core: Fix rdev reference leak in regulator_resolve_supply()
Date: Wed, 18 Nov 2026 15:30:19 +0100
Message-ID: <20261118150229.832841672@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 195bbe5e1c29aa1349655a6162958149c1176034 ]

regulator_resolve_supply() takes a reference on the looked-up regulator
with regulator_dev_lookup(), but when the supply resolves to the
regulator itself that reference is never dropped: it leaks on the early
return and is lost as well when r is replaced with the dummy regulator.

Release the reference before handling the self-referent case.

Fixes: 4b639e254d3d ("regulator: avoid resolve_supply() infinite recursion")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20260917142810.2156816-1-vulab@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 44ae5fb8dad36..4c0d8cd5bcbf3 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2130,6 +2130,7 @@ static int regulator_resolve_supply(struct regulator_dev *rdev)
 	if (r == rdev) {
 		dev_err(dev, "Supply for %s (%s) resolved to itself\n",
 			rdev->desc->name, rdev->supply_name);
+		put_device(&rdev->dev);
 		if (!have_full_constraints()) {
 			ret = -EINVAL;
 			goto out;
-- 
2.53.0



