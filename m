Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052274;
	b=AdPT3FcjrYjn4tsnQMOEVGDhx2/34DZWjTAtPdeZuuzpPpENSqf816tQ8KsNSsk9XPY+
	 ooZnv6tq8LQFWXy5arookRy7P099XZ1LMN1GCn5n+znJNtHYc7iUqVz6KoKrg96jXhfyW
	 q7O2Pfr+QcPL+Hvyheb7fDzcloQezM32ZLr5EK8VbR6DCJilxYPJPgoHlygOBOaNdwQS3
	 izHsNgXtZb3NsPZP09i85i0fNsGBSPegMYdGzdSHY+rw0vjT0akt8Nw64tPh92KJ4vfN6
	 o5UYoGn7FDo9S0sQhDt9qmz+cNMIuzhZGcRgJvjrA/70jNsxm+OMxX89DxO4ekEWK3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052274;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PeLJlDMbqzn6zCR54GjZiL4CFs/UVOpzX6akS3bBV1E=;
	b=KAgtGs0ZC98i3L+ipMr6eOZi43/ttuGmcYWytPIDLO2aNEi8N/y0vggcqFhTOVigq8V6
	 cehNo1GUKXG6ux8YN+sF+fVRGVQetdxBqSyUJAX3qcB3I/tcaBN+S8p38oUxgiP+q5Esr
	 zxn/Mzn3YQ7Eune9yLSG1O5vJ+UcubrOsnKKgQVtgfK8XBXy/7M5JK6VsjMkGVZT8YgpV
	 QKzucy5yfkjryuEwJAI3PoTOa37SziRIwOON93fFEo/hyA0EdufO/VhBjkEOxJAChwP7h
	 HgcO1VN8erwVyG2PaNKHaEsBk/cI0URFYK9OTQnCr3iaEn9jEIBE9ioP2jou/h8H3Dg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GUVYE8iD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC4A5606A32C;
	Thu, 19 Nov 2026 01:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GUVYE8iD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29EF21F000C4;
	Thu, 19 Nov 2026 01:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052274;
	bh=PeLJlDMbqzn6zCR54GjZiL4CFs/UVOpzX6akS3bBV1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GUVYE8iDHSxMbZGicXLCK7zpCBov1h4WzRcNdxCLK5NpPGt6u+P94hl/QvRshQfm1
	 ZJgqCFQu7us3QARAkF30+dbqhT3Bgam7FIDWA+sUIwVPfx1ZazoQ0LgRK0HJML5xuc
	 tdKpm4BIvzQkHi4YQZTX6ZHNyUr2Cg3Ggo8Xa790=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0504/2214] regulator: core: Fix c_rdev reference leak in regulator_resolve_coupling()
Date: Wed, 18 Nov 2026 15:36:20 +0100
Message-ID: <20261118150031.311546022@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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
index 055a24dcb8569..d711dbe59ac10 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -5341,6 +5341,7 @@ static void regulator_resolve_coupling(struct regulator_dev *rdev)
 		if (c_rdev->coupling_desc.coupler != coupler) {
 			rdev_err(rdev, "coupler mismatch with %s\n",
 				 rdev_get_name(c_rdev));
+			put_device(&c_rdev->dev);
 			return;
 		}
 
-- 
2.53.0



