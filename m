Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064024;
	b=29bfjbQjC8tAn2IntRSf2NpXFNhqKrYk2TzURu3Poizen9OmP4IXZL3aCZVzZxz8zBDj
	 SRh/yNxDnDj+g4BojoSUpLyHldDom6T6z5TM7L27+y8VBa/UHE00BkB6re+HAQHu9MDBa
	 DLiYnrZQoLrVGDQytjLMnhwz2GditylZyIeUv0S6hlad5MbGkbC4RrgaoVCIoImgPneFd
	 yMlEdXRUaZx+aG6lKw5pVMsfKgG+V1sRxRBw4M9L6A/QAxFL+oWFxIQGtdKn/C01HUmmS
	 +LkZ887i+I+lcSAWSO9lzItcY4VGRSGy+GrWWUGdTeCEgadyDyO8jue+keosG/Mu5PQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064024;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UdYaXqWyag8ao8MpOl7eEnh1k4x78ukBB1J2nlKNO34=;
	b=TUWxLk3nrABHzwXW+HfXFnBpsSrVdmcisjXhh7cyQk7ieWDgxU2ztSKwrJssYcTmlFC9
	 Tn1pyg+P6QANO7ACOgGJumS/avrKd6osxSNt+c4OpHIwsdpisCXhELIR9Ufqi77n4QbvW
	 +WTOIbesLd3uW3OszNM/y0UBCZP0v9TOjtUmtYd5bT/fYshSPAYAaLaxYd354G4wX0fCE
	 JjojNlBYTKTW4jSq8y+diUNHhtQZ6uEhZa/D2V7JkpXGlPwSzCzCI17ODeYKHGLwkI+nB
	 X8H/vw8Z573TaQJCSxFUMrUruE/0sy7GOaMqIqEC1YOmBJ4ej5Li+C85/Am/MZtWAnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qDacTRCx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC8A9606A9CD;
	Sat,  7 Nov 2026 15:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qDacTRCx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8812A1F008A1;
	Sat,  7 Nov 2026 15:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064023;
	bh=UdYaXqWyag8ao8MpOl7eEnh1k4x78ukBB1J2nlKNO34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qDacTRCxW92/myePvnJNrJfknke8uD4Pi/VGSuRseIZRdZtSA7k++qh9ZzcFeU7ZV
	 ZvgBsuxVIBSha1f8WwxTkhhQxOLsjtdZMaSRK4+Qs96zQQLGTbM29nFbncXy6o//fi
	 lF/8uAmsEO/cFWuJxsE3vWM3BRvJW+iGCfouLTtI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0199/1257] regulator: core: Fix rdev reference leak in regulator_resolve_supply()
Date: Sat,  7 Nov 2026 08:41:35 -0500
Message-ID: <20261107134945.058584837@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index e813aeaa64ef5..811a890b88311 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2239,6 +2239,7 @@ static int regulator_resolve_supply(struct regulator_dev *rdev)
 	if (r == rdev) {
 		dev_err(dev, "Supply for %s (%s) resolved to itself\n",
 			rdev->desc->name, rdev->supply_name);
+		put_device(&rdev->dev);
 		if (!have_full_constraints()) {
 			ret = -EINVAL;
 			goto out;
-- 
2.53.0



