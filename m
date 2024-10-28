Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C84186E52;
	Mon, 28 Oct 2024 06:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097135; cv=none; b=XOmyk3FhacxYVuy8xHlkwp36RaqqCvgHbYPGKetDExXq6TMzvHVlo/+1Ey4LU6Mu2VuP2x+RF0kR3M1kTde5kgAAji/7jg1mK1YjLO14ekOuUakinvyK50CYiFR/5srcWdxhfjqMekkZW1dyei08UX15QlP4AJdLRE+r2mxoJxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097135; c=relaxed/simple;
	bh=7HYYwKAlb3pd7afBRSm1CD6arKP3iQnCELi+mDEoKyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A5Jpuw5kJMWohf7jiegbA97/UaWWLbrLouo6iK75Rzsz3NlpWaUS3uztpoH2O+Ed5peykpVXd6t3cngu10Gz0rkJXQyJi102XyvsEslzxtPtSURPhrv8kwqpQb//wlNdhCk1nq2L42c/qKjgAGJhSY/wUo2L/si2o/mIn9g7b6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0GsQFALv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0GsQFALv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1400AC4CEC7;
	Mon, 28 Oct 2024 06:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097135;
	bh=7HYYwKAlb3pd7afBRSm1CD6arKP3iQnCELi+mDEoKyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0GsQFALvmHu+BN3k2Q9bWgF7tzzOeT7KyOnqAWSrFq2IavalngH/c8EE84uIkB7d1
	 lOKuL2jNcuIo0mhfwlXhHC2MUjmBJEWeCHeIn+cwCoSL3TdDMrJo5XlYFy0rPJWacv
	 VcZhFObWMwFcv1WrDjHqt7vJHMPhJZC+b6GfInw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zichen Xie <zichenxie0106@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 80/80] ASoC: qcom: Fix NULL Dereference in asoc_qcom_lpass_cpu_platform_probe()
Date: Mon, 28 Oct 2024 07:26:00 +0100
Message-ID: <20241028062254.833111825@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062252.611837461@linuxfoundation.org>
References: <20241028062252.611837461@linuxfoundation.org>
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

From: Zichen Xie <zichenxie0106@gmail.com>

commit 49da1463c9e3d2082276c3e0e2a8b65a88711cd2 upstream.

A devm_kzalloc() in asoc_qcom_lpass_cpu_platform_probe() could
possibly return NULL pointer. NULL Pointer Dereference may be
triggerred without addtional check.
Add a NULL check for the returned pointer.

Fixes: b5022a36d28f ("ASoC: qcom: lpass: Use regmap_field for i2sctl and dmactl registers")
Cc: stable@vger.kernel.org
Signed-off-by: Zichen Xie <zichenxie0106@gmail.com>
Link: https://patch.msgid.link/20241006205737.8829-1-zichenxie0106@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/qcom/lpass-cpu.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/soc/qcom/lpass-cpu.c
+++ b/sound/soc/qcom/lpass-cpu.c
@@ -975,6 +975,8 @@ int asoc_qcom_lpass_cpu_platform_probe(s
 	/* Allocation for i2sctl regmap fields */
 	drvdata->i2sctl = devm_kzalloc(&pdev->dev, sizeof(struct lpaif_i2sctl),
 					GFP_KERNEL);
+	if (!drvdata->i2sctl)
+		return -ENOMEM;
 
 	/* Initialize bitfields for dai I2SCTL register */
 	ret = lpass_cpu_init_i2sctl_bitfields(dev, drvdata->i2sctl,


