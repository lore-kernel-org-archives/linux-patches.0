Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058219;
	b=BbMjNK22rZvyN67MxYTNO9L7ls3BsvY6peAXX1/rQxvOntlXZF1DFusFGBG8wIYT3HFs
	 A2vj7XCizr5OCsOT1ao691iR6A55UIGhMNin33QgVOWZDBNyI55yq31AIk2JZ5c73ghf2
	 rht5UP2J6Kk7gYnTNck+ZRUXsD1oE1YybF4EkY8FJ9+bx8hPAQaAGQyafg+DjNegazP6f
	 KuiFUCjaDOmPViirmTTQbsh7iyrasZHsVVwiJoCZQKzA+HqWQc19czu+O1+ZL5eCWuyLY
	 ax4sISS21W2GDb7IWeprvzC3VRtDEm4M8+1e6KvTt9uuUxNG8cvBbhcQLntJLdv+ddA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058219;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dnjOyc+sOGkPBrf90EYes2IegaeXWatHuCgT2iZvXRE=;
	b=PIoNnTRFX6jSuOEogqX4cyGwUy5EyAhxT2gLi5+4lMaGzOKLUTcgjue2/tQz+1sFtO6o
	 pPTCHKUV6ALM215oNfOjLwX3qqXWiCchLHPGNsNfa6mf8zCe6xPY9Pb1+uBd0vPcfocuq
	 9eZ/3Xuqi7SfDcwveJxh8w6kCV5xGEZj14agKXLNTZv4R+iAKcaF1SpVI5kNrBe4py9Mq
	 UgxwK5//zRGTaLOXKtZDTOGLzlkbRsmaw5l5n5WNMh6kA/oEkCUfytoGtcUS/673XgZpT
	 3rE49FmTDeW9WTKSwf0QmywbMDT9/a6XFDMk9qh7azWVMhAFWSGh8k24CXTdwV2T8Uw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h7+Schnu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8489D606A320;
	Thu, 19 Nov 2026 03:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h7+Schnu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD11F1F000C4;
	Thu, 19 Nov 2026 03:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058219;
	bh=dnjOyc+sOGkPBrf90EYes2IegaeXWatHuCgT2iZvXRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h7+SchnusRwI1iu1Hv8ikweRtSHytK8IC8b0a9UKOLB4uI6Yz1d1epnSKsrnBBw8L
	 NrGDkJAgOjXKqTWmiV+ZfUzRDdzW0oTYomTNx8QNZRloY6sP6c8Wg+jhYGrr7mqX3R
	 w/D6cVZt/VeG9yEu0CA84gSbwPXn9y0i4BWewATc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0409/1848] regulator: core: Fix rdev reference leak in regulator_resolve_supply()
Date: Wed, 18 Nov 2026 15:40:47 +0100
Message-ID: <20261118145931.005399518@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 6547776bebbfc..4ea977af2eefe 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1966,6 +1966,7 @@ static int regulator_resolve_supply(struct regulator_dev *rdev)
 	if (r == rdev) {
 		dev_err(dev, "Supply for %s (%s) resolved to itself\n",
 			rdev->desc->name, rdev->supply_name);
+		put_device(&rdev->dev);
 		if (!have_full_constraints()) {
 			ret = -EINVAL;
 			goto out;
-- 
2.53.0



