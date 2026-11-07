Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062890;
	b=Agqf0fgSV72epNxKQ9I4X1IOBZDrQ2VYSy6hsmNBcSCAJiyGvcZ+Vs5Y3YfxunKjbzEu
	 g9EEHBawrHIBfNL17gGvFKSJ4IYMH1estJKKFwSykvZSyxQh7zd5R6oNBil3+xKf1OzsT
	 H3q9i1jXSosxIJxvjtI1MfhvW6pWKhZY9eBHUDn2QS1z4IAFOkoi2unNX5FWjTSm61Yrt
	 lqy//IliBAx+Le0MbRarQk53H5SFZXx+eTK3Qd9v4lsnGZlUhWGRgtMrQxUtjbBcoq/El
	 Hw6StwHz/bNfRxxtxEhpJsQ8s4WMqdDdchSJNBIkCs5Gd6+ai9fv+6VRNrhaKW/gtNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062890;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jduO1YGlCY3FLg9FYiJ1jCxt5ppfWZim+VSA20pseHM=;
	b=lAy6z0cczSQGA+E8hrdLIZcQCyqvNb9WSEROu+eu+EcnSUZgWgcGGeWwrbndRkgGDZdH
	 JMfkffB1BKp2XpuIMyfT2/65F/79ClS8neoUmC+os7uinX0CGDSzx+U5cz8bAzcHbdDvu
	 fV82r67gxw0tIvMHuhgPvn5dU+KWKGFV+EJz2rPTjJkPveEeiWK9DgDjG46g8wfvuxcQl
	 qan8JkDEeOzTKHd2FJbTPD5f5zamG1VpU63RN7Z/i9JNfmjv99aRzdY7nseJJJNE4P4nC
	 j/P6oesx9zUplwCmBwzlsAnli8/5PHWiL4zyakxrv1SbEq0fnveId9jUBufI/zOU83Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eQYn2BpN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10A15606A326;
	Sat,  7 Nov 2026 14:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eQYn2BpN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B27CD1F0089F;
	Sat,  7 Nov 2026 14:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062889;
	bh=jduO1YGlCY3FLg9FYiJ1jCxt5ppfWZim+VSA20pseHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eQYn2BpN/QySCyGrG4E38M5smAUxiCoWh7jN4+WcuEJnn7cBSVhYdGi4j4KdW7DkO
	 V96WGDozRQ7OvzdFkvuAYt0UcHmeMpgexklpA4lw/ThhrXfkYSpDkpHU0TSBIomG/P
	 3Mv5V7OGttnOEWeRclunSszkB/RZBAuR2G5yvd6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	ChiYuan Huang <cy_huang@richtek.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 168/869] regulator: rt6190: Fix runtime PM imbalance in rt6190_out_enable()
Date: Sat,  7 Nov 2026 08:47:30 -0500
Message-ID: <20261107134857.927845540@linuxfoundation.org>
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

[ Upstream commit e0d673e5a5c4084f0da90c06ed3b0bc45e47d679 ]

In rt6190_out_enable(), pm_runtime_get_sync() is called at the start of
the function. However, if any subsequent regmap or regulator operation
fails, the function returns directly without dropping the runtime PM
reference, causing a runtime PM reference leak.

Add an error handling path with pm_runtime_put() to keep the reference
count balanced on failure.

Fixes: e6999e7cca7e ("regulator: rt6190: Add support for Richtek RT6190 regulator")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: ChiYuan Huang <cy_huang@richtek.com>
Link: https://patch.msgid.link/20260916072541.1968033-1-vulab@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/rt6190-regulator.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/regulator/rt6190-regulator.c b/drivers/regulator/rt6190-regulator.c
index 3883440295edf..bf99e18f6d5b0 100644
--- a/drivers/regulator/rt6190-regulator.c
+++ b/drivers/regulator/rt6190-regulator.c
@@ -109,19 +109,27 @@ static int rt6190_out_enable(struct regulator_dev *rdev)
 	ret = regmap_raw_read(regmap, RT6190_REG_OUTV, out_cfg,
 			      sizeof(out_cfg));
 	if (ret)
-		return ret;
+		goto err_pm_put;
 
 	ret = regulator_enable_regmap(rdev);
 	if (ret)
-		return ret;
+		goto err_pm_put;
 
 	ret = regmap_raw_write(regmap, RT6190_REG_OUTV, out_cfg,
 			       sizeof(out_cfg));
 	if (ret)
-		return ret;
+		goto err_pm_put;
+
+	ret = regmap_update_bits(regmap, RT6190_REG_SET5, RT6190_ENGCP_MASK,
+				 RT6190_ENGCP_MASK);
+	if (ret)
+		goto err_pm_put;
+
+	return 0;
 
-	return regmap_update_bits(regmap, RT6190_REG_SET5, RT6190_ENGCP_MASK,
-				  RT6190_ENGCP_MASK);
+err_pm_put:
+	pm_runtime_put(data->dev);
+	return ret;
 }
 
 static int rt6190_out_disable(struct regulator_dev *rdev)
-- 
2.53.0



