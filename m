Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CD083876BA;
	Sat, 17 Oct 2026 16:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253481; cv=none; b=CekSBNuAV3q9TALhnETecNtcCcadI4TcF4GAZDGxF26UWM9WGLLxCj3ioiY3adTH7nvyKuvQSLyLq4BER4jU3JDyomIsMS73fYBWMJG+vNISbQlvueMKzMZARaa3AWhxeSftp8D+jBds9tDD3F11DJGoDa/lVhDZXZAZwrlF87M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253481; c=relaxed/simple;
	bh=YZ9bLULjDqY2Fvm9EbDYPNkAu/znvtb4MshvIB6lYPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HI4f6URHrwSzZzhuq8A7z1/fLIomEdVqX8GUrjNqSRLgJ8Nmr/AP6N499rzykrMFWLMOYYeqwNE1rmX0avMKz0qCmZFH4VZkTFhTCMUR7yi7DkIJTI9iN6gi/sUFn5aJOkfaSOEYtM9gvs0Nzhi123xOlCCrPoOpFTAIbh9xtUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vuDdc8aR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vuDdc8aR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D88B41F000C4;
	Sat, 17 Oct 2026 16:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253480;
	bh=3uv3JrABRIlQsDbUiE2lBOnAjHKWLevFxfGZYYDyfaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vuDdc8aR7sxF4Qb0OEnmHObMaQL204hi+KRJOQ3bcGA1DpXTodERRavZs9YmCdme2
	 p3mazs0JFou+86nQGLcsJdoYHxjxeWJ88fDzwnnc0zzu8zU4kkc7O0aAwodiGU3+pO
	 QvDszgGu9xzQU10dFXEl3uZ58kAPOWxfw2a9aDQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 132/869] remoteproc: qcom_q6v5_pas: Simplify with dev_err_probe()
Date: Sat, 17 Oct 2026 17:49:33 +0200
Message-ID: <20261017160040.430828531@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 427442e873d7af7a06ff4382b57197f43afa8ed4 ]

Use dev_err_probe() to make error and defer code handling simpler.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20241011-remote-proc-dev-err-probe-v1-8-5abb4fc61eca@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Stable-dep-of: 142964960c7c ("remoteproc: qcom: pas: Shutdown lite ADSP DTB on X1E")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/qcom_q6v5_pas.c | 22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff --git a/drivers/remoteproc/qcom_q6v5_pas.c b/drivers/remoteproc/qcom_q6v5_pas.c
index c3a634454d53d..62b7e23eed4a1 100644
--- a/drivers/remoteproc/qcom_q6v5_pas.c
+++ b/drivers/remoteproc/qcom_q6v5_pas.c
@@ -451,24 +451,16 @@ static const struct rproc_ops adsp_minidump_ops = {
 
 static int adsp_init_clock(struct qcom_adsp *adsp)
 {
-	int ret;
-
 	adsp->xo = devm_clk_get(adsp->dev, "xo");
-	if (IS_ERR(adsp->xo)) {
-		ret = PTR_ERR(adsp->xo);
-		if (ret != -EPROBE_DEFER)
-			dev_err(adsp->dev, "failed to get xo clock");
-		return ret;
-	}
+	if (IS_ERR(adsp->xo))
+		return dev_err_probe(adsp->dev, PTR_ERR(adsp->xo),
+				     "failed to get xo clock");
+
 
 	adsp->aggre2_clk = devm_clk_get_optional(adsp->dev, "aggre2");
-	if (IS_ERR(adsp->aggre2_clk)) {
-		ret = PTR_ERR(adsp->aggre2_clk);
-		if (ret != -EPROBE_DEFER)
-			dev_err(adsp->dev,
-				"failed to get aggre2 clock");
-		return ret;
-	}
+	if (IS_ERR(adsp->aggre2_clk))
+		return dev_err_probe(adsp->dev, PTR_ERR(adsp->aggre2_clk),
+				     "failed to get aggre2 clock");
 
 	return 0;
 }
-- 
2.53.0



