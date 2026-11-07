Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062015;
	b=nTM7ZJlBbfS2u3szoYc1EB6QpBFenr/uMJfSVCVa1Ep2far21lDTKnNwpVV/aRWXcS0c
	 c8j0Lo2ZC/YJHe7WIwcVNGGDBh2rxsV7zAB6kE6pkP02KL7Cr+KgxJzzoMSKOagopQF99
	 Xgy7+oBJnEExFJKDm0WnGwmrT7K63C49lqLY4oHLGLSOTttplZGphryVKKaGpTtMUAw0d
	 xdXu8laDSY0m/hWwAWNA5Hnqt9veCTCsNsBf0VcEH16PX5MJSM7fsh2o0TygMi7gmFSY0
	 Y7BgoZb6KBTRsS8pnfKYo3lUhQO/rTZutT3YHU0Ggy/E1VX1vBYp7gkDO1qn50+wTtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062015;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hvxFPs0cm3fPTxwceLUpsJkSHuRj4nDsm0/2EnAc+cA=;
	b=23terpKnX5FOFqq46TO7g1ZQisTOrmXFN0gwlDOq1gYu/uz+/rbirbjw04g/PvqVxE6j
	 e2EsAT3xWvHoju8QFzuwwi68ZcSOSww+UwxbNUVG4CxR5mtEW6LXOpeQ4sxsh6KCH1Xtz
	 PaI4C1/FbJD2K47vs7WJtuf29i++xIEfBmIFDYqx5w+rWgfMDJLpzLMqa1AdlkR6e6ngN
	 BJ+9CEDsIAL2/9JA2c8CSh89nGWyKhZb42xgL+utl24QCn0sK9KPN8+3YMluSSdzHcIW5
	 JqCM+ry9fPLhISegStBBkgPb48e9ECPVYycld0RHs+sJB5xBaMETQNlfxgqoped5qiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DCyZVpBS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7757C606A32E;
	Sat,  7 Nov 2026 14:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DCyZVpBS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 258AD1F0089F;
	Sat,  7 Nov 2026 14:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062015;
	bh=hvxFPs0cm3fPTxwceLUpsJkSHuRj4nDsm0/2EnAc+cA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DCyZVpBSLfJNVuNp2xVkU5M8hZDm9Hhjpit0ESCSRrVYjru7CGs46FvY/x+R6ZE9X
	 FgK90hYt6RlwrY0y85ykd+7y+f18P5MduEhocC9RA6I6K0PsOzzVbE9myTyngPUgNf
	 r8eWPa+Z9/WD8nB4PGgJvkw0es/IekJgYnWpB7d8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1004/1536] regulator: core: Fix rdev reference leak in regulator_resolve_supply()
Date: Sat,  7 Nov 2026 08:50:20 -0500
Message-ID: <20261107135025.869438026@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index 41dd9b2a41b76..707fa12836471 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2070,6 +2070,7 @@ static int regulator_resolve_supply(struct regulator_dev *rdev)
 	if (r == rdev) {
 		dev_err(dev, "Supply for %s (%s) resolved to itself\n",
 			rdev->desc->name, rdev->supply_name);
+		put_device(&rdev->dev);
 		if (!have_full_constraints()) {
 			ret = -EINVAL;
 			goto out;
-- 
2.53.0



