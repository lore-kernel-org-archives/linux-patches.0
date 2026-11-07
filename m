Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062881;
	b=sS8Excu59YVs8CWKzywKZccyV86LPPRTfEdMBILTGYCxxSI8HXs49gY8srYuXTZ+2fh7
	 p7WKxgSYxnRTMGSf03+sv7nO0Z/46uEJC1GbzC0wOiF5z8Cx/SaTOUY0bRKf12UYCqAC9
	 9R5qsniVDpvOMzHaCGHrImJOw2oBmSqwuPnzwPLyxAWCjKsfYyfybNdWoWMJYJ+tXndJg
	 CUv2b9mVt5rBt4NtT+g3NbbSuWmF1sWg3HFuXj9p20crFrkeGLPKSvgpmWsE9DSjV2Bem
	 AiXMbXH8XYlkDq82vynWsy1GfyPl3a15lyloSlpHqAoduQ7uf01SEjlcAO4e0A6TztQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062881;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=e/yYOl4zE/RWIoet0Jm0a7GB4bHZScQ9or4M/DNiNv0=;
	b=J/dUp8eBWELZ34BPR/Ph8N7RDtbvARTDLrysa5Yn8iCCVmGmRbfFoe5Tz/e9OUVua0MC
	 ZOpjU2FpQ7q16P2fSjpb00T6WbsmDVcksY3E5hCW6LAGhDgx5mTNvqybFGNQX/75paMfh
	 iqyJZjsx/0wWKrPZK5IxUt0pB/h+Jc8b156PoNFUCoMDgq1r/P102ObuH4iQrXfwjRIjX
	 8VER4//PONpYL0cnZ5rSo68CkRKQ1mfMpwBIvfY5QwU+h4CBUagRuNhXYfn0VRastKAOW
	 cylh20IDzADTkqxLOvNZSHL1PhtqxMZgo2yoY/OYvIfJtkspQ3NBEnHfUIEooiFSw3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DxaGZlm5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28933606A326;
	Sat,  7 Nov 2026 14:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DxaGZlm5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C185E1F0089F;
	Sat,  7 Nov 2026 14:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062881;
	bh=e/yYOl4zE/RWIoet0Jm0a7GB4bHZScQ9or4M/DNiNv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DxaGZlm5wXwxVmOFfp0PMocPxGlMl94jHSLtcGTlrL4yFpRbWoT8fjsdfs6n68MAN
	 sxO04wrNuba4QNugkCNwMSOeWeZZBHp/6YX5DQtWdS7oPUyXZqgoyPIoQCCZSg/fmq
	 FxE80lcuN/MrCSdCsOCd2pZm0yNk3FAl+LG4UX7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 162/869] regulator: core: Fix rdev reference leak in regulator_resolve_supply()
Date: Sat,  7 Nov 2026 08:47:24 -0500
Message-ID: <20261107134857.765678456@linuxfoundation.org>
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
index ad7f26b14621b..e2328539b9fdc 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2110,6 +2110,7 @@ static int regulator_resolve_supply(struct regulator_dev *rdev)
 	if (r == rdev) {
 		dev_err(dev, "Supply for %s (%s) resolved to itself\n",
 			rdev->desc->name, rdev->supply_name);
+		put_device(&rdev->dev);
 		if (!have_full_constraints()) {
 			ret = -EINVAL;
 			goto out;
-- 
2.53.0



