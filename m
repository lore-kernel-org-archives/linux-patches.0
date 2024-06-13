Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A3D517FD;
	Thu, 13 Jun 2024 12:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282767; cv=none; b=luVkgZviZ5pHfSXmVMgAZijs27w13DUY6wj142ICUkEmxfF6Gkn6wgqaPZSidclEUoGlGDXVf6Ifk44mbEoHU8uunawQgiOXqMz/Qj0Br/BxWSFxSq4TW3f5nBx3pB8Wa/94bZS/HWznRdTJ80Fe9PNU1jGL54nXDuMhlj41Pa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282767; c=relaxed/simple;
	bh=1JBQIvWeipe4Q0+XUaabh0Co/wF6H4tl2kWGs/3+xTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=st5dm+4ttWmWQGz0T8fyN5XOE9AWPmu/wO0hGuRRvZdL+4RBn062A3Ti8t5+mjxBaRwF0+1btyqjmfxSuwcO4K3R69LWd/Zlkx+rSG1ifhuMVC8sHYx3zC9aCQlkupLktqHWlwA/kxJ5G/RHe1giFTYOR9ZfqV6w/dzMPa0ymZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hRrra4p3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hRrra4p3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71551C32786;
	Thu, 13 Jun 2024 12:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282766;
	bh=1JBQIvWeipe4Q0+XUaabh0Co/wF6H4tl2kWGs/3+xTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hRrra4p3FJNyamodBhS0Ulpz0JrcyjvUL4peDrRFGCm5b7R4TOMa8f1y0t1tuwXw7
	 +QcnUjai00AIOuCtOkMY4r3Ci8IHSdV/p3ohFjgikuJNsSBFcKW6ASOCxyq8pU7xD8
	 F+PUhAh3f1HvtvKLwquzc3s0nvKQhxhsYfm5Fk+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCH 5.15 357/402] thermal/drivers/qcom/lmh: Check for SCM availability at probe
Date: Thu, 13 Jun 2024 13:35:14 +0200
Message-ID: <20240613113316.061279137@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@linaro.org>

commit d9d3490c48df572edefc0b64655259eefdcbb9be upstream.

Up until now, the necessary scm availability check has not been
performed, leading to possible null pointer dereferences (which did
happen for me on RB1).

Fix that.

Fixes: 53bca371cdf7 ("thermal/drivers/qcom: Add support for LMh driver")
Cc: <stable@vger.kernel.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20240308-topic-rb1_lmh-v2-2-bac3914b0fe3@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thermal/qcom/lmh.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/thermal/qcom/lmh.c
+++ b/drivers/thermal/qcom/lmh.c
@@ -92,6 +92,9 @@ static int lmh_probe(struct platform_dev
 	int temp_low, temp_high, temp_arm, cpu_id, ret;
 	u32 node_id;
 
+	if (!qcom_scm_is_available())
+		return -EPROBE_DEFER;
+
 	lmh_data = devm_kzalloc(dev, sizeof(*lmh_data), GFP_KERNEL);
 	if (!lmh_data)
 		return -ENOMEM;


