Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052353;
	b=OhVU9+/SaQmCE0xHWj+aWCaulZ8XRylssvlZvnhgYKVpSuUdGDdxkJu0naNOC6o6p914
	 uO/wbcwKS204NiSUdsP6KrZw1BGWcdExZIHfnCRK8Eji8/sHuSaQ/+PGtM6mMZjCE1dH1
	 s5zkgv+XSrsnkzkwNYMAEswffTLHz2ZZr5IdkLqUyHZ1jKPOwYNBr6DAhejkmy93eegAp
	 08wrnE13OnVUiHU5CaxD+oUuq7CwTlpmrmHZol+DSQnDAxaXQFWXoqQd32lfu6BRjV2kN
	 B9UOh2e2H69wAhStaJDpJz0nGEZrTcJ99eYQ2/7BkFu2U4sDyfQhfuPIGjboWgu0GRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052353;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uVxRx2HffwVMGYB6zS5qNKYdb5GM72EVsDiS2jUBnFw=;
	b=RhGcCv3Uj7vI1Yh7jfJ85ywd+4WztEoR3c89ATc5QrRIaiaNrKDtjG8KFpyLCdmGVr0g
	 6tFrbTOR6ee3aWW4yz/f1Z/d0r+XasMhJWyRTIWmq2ubDT5FG8Y5I9hBMuy5NHFo0c6R6
	 cfW8ZZI96r69TkPxjFnIAfx3UmbQgHU+CNR4wt9A8YfeZlc7BZAOFZ2vXPQ4yJkZ86NiY
	 MBBhEcVmUeW2UYIHgpg+zCiPscrE/RnicEcQBqGBKYXwPr/rHq2WDi9sEYINs7P9veOG1
	 l917mcHQmrwP1uqWMRlpv5BTHZUfLLDTIEdy3qWU0cioMh37TunPe5/+76sEWXvfSng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sNb2ije0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2F2660A263E;
	Thu, 19 Nov 2026 01:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sNb2ije0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EE7C1F000C8;
	Thu, 19 Nov 2026 01:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052352;
	bh=uVxRx2HffwVMGYB6zS5qNKYdb5GM72EVsDiS2jUBnFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sNb2ije0ogLE0rBh93HPE/PDdvtipEumN1NfUBQg5V8mo/wSfg67r0xyaYQlC2Gw9
	 QhY9Hj9uVHmaZlWItr7Ey0iwDL05vDvgJ1uk57F/XQrfre2W9N+ZCeSfE4G+ok0hVn
	 aagks83II8WGJpmGdK0gPlC6+I+9XgLkUUNM3jq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0534/2214] regulator: core: Fix coupled regulators reference leak on removal
Date: Wed, 18 Nov 2026 15:36:50 +0100
Message-ID: <20261118150032.406643310@linuxfoundation.org>
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

[ Upstream commit b9205f0837ca91a0bbe6aa9002207656840c1406 ]

of_parse_coupled_regulator() returns the coupled regulator with its
device reference incremented and regulator_resolve_coupling() stores it
in coupling_desc.coupled_rdevs[]. regulator_remove_coupling() clears
those pointers without dropping the references, so they are leaked when
the couple is torn down.

Release the reference of each coupled regulator while removing the
coupling.

Fixes: d3d64537c339 ("regulator: core: Resolve coupled regulators")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20260917143052.2156903-1-vulab@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 3babf26da8545..840748071f468 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -5389,6 +5389,8 @@ static void regulator_remove_coupling(struct regulator_dev *rdev)
 
 		c_desc->coupled_rdevs[i] = NULL;
 		c_desc->n_resolved--;
+
+		put_device(&c_rdev->dev);
 	}
 
 	if (coupler && coupler->detach_regulator) {
-- 
2.53.0



