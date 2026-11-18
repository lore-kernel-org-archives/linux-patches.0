Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035965;
	b=EssSPj5jxEGWfSDiIc3RxsiTIyK7Hy+O1ORjP9Nhwf1NEMCKeKoQBpztYDp0Tig6/gx9
	 95q2019scM9jYxy0uxSZuNbGLHnag1ARvPeXvX/qp0Kn7Vx5eOSDrxJ2Vh+N8+Tb7EfxS
	 wiq+N+EQwZu0wMWeHPvJkd5TNPaHTd0nkob9NGC3sp2MU5iHtetifNeUDZuT3xlOdFyBo
	 i8vW45d+UsEQg+MkXQjOqKiEF5BF7PmZeJIDpLYz5bXGI6OhWHGbqE+ctbwnjsDGBC/ig
	 QWtOzXxNvpywzVmoICN29pnHKo5yvSnM2KHWwGWGh22VXN9WaenFysXLEb9VY0fUH6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035965;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dWgV3+5H9O8C61IiKi8Ag7oeXJ5baoijNaojl1FkH/M=;
	b=hCsiE1eCvxcDl9SK3I1s3POhdoGuxqf3peBOcI+FHaC7Bw1Ox4g7UPN/DqyBNPi5w2A4
	 Zb/kz8OjJxc2sSH9nAPNioZemGYWeKC5UVJWYjQ7SK4PSh96EmDcZggYke9jXr6xrN3iL
	 obqmqLD1QgOBWVZ/YaM+YcA2JRSUargI72kRuQ2Wwjd9G0Qy6dCN6z6RVweFWwlkZD7GL
	 tXBmUu9+sP3B5IR0rvrExqXeYjrIiGkWlpdaDGQkCUc5W5v4wWU+YvKjYvGyLcxXc65Wt
	 mEIdssjerG7jq4V86RyZCl05NemaMgT56W1ajyDs2noXJ6NhVC6xtCKnUf5kk6B8yhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PPAs252h;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 044DB606A31C;
	Wed, 18 Nov 2026 21:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PPAs252h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C2ED1F000C4;
	Wed, 18 Nov 2026 21:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035964;
	bh=dWgV3+5H9O8C61IiKi8Ag7oeXJ5baoijNaojl1FkH/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PPAs252hQ740DC/NTkO7tBH/DtALy4LdCCW82odRQpohs8H9UIr1smMcCdYGiK1Wr
	 9njvXi8ACHwu/eoQbxr8Kb8jLfbwm74fm9w6bEWKQ9i89/nQJXASZIJOjJ2jHtW94B
	 TcWYfJa6uuINiNb3fv0e+YzBsJ1wEYiTIra+gRf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0891/3318] regulator: core: Fix rdev reference leak in regulator_resolve_supply()
Date: Wed, 18 Nov 2026 15:25:13 +0100
Message-ID: <20261118150346.157179734@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 9707e90ddf0c2..8690166428a75 100644
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



