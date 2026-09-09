Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C528856C627;
	Wed,  9 Sep 2026 14:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962776; cv=none; b=Bp5o5rkl5y+GMj/GUMoTaYdso3kVJlAxqW0/KCrICYSmxnhgpHsMzr9bof5+JNhi5VlLIN/R4oUFcqXWUj4PDPZlI81UdR5gpDr+bl8WINbjJJo+LA8i9CLoSlJaoyoqE7n1RHuAh4U3yrKELW1jd+3Jqm2HjCC3KWjbexUUem8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962776; c=relaxed/simple;
	bh=f7zDr3zrXDpoKczk/2yrVD/QmC6kjyFIJOKaL0Siyeg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vDZI2DXfYZuSxBw+2WVaY1c5fMibu/A7lqs3ltyugspJ889HWSqdxZ0qQjtIP28Hchce7kFXbEeK+NPh8ZqqBAuENBy2gPKm7tnqzt92xmHd88hBF2ANs4uFLd/hZS4bC3L/ZVbgOgKE/kF9P4JciGQW9il6/bEM+eS+7H70p6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g0/B4zvT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g0/B4zvT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1A011F00A3D;
	Wed,  9 Sep 2026 14:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962774;
	bh=v1gf9lS3gvi3cIDydYOuPbqlmm5X4f9z2LvnQdQEo/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g0/B4zvT2Yo4iaZSZw4AIyclfEZuzyRNHhIlAAEMVaTOEs4W1CNxPq2dKPT0mEmZr
	 PHgz1qyfXcbkHBY/Gre01P90TZx/wNw2S+gMpIieqPIJDDc80SFrnybUNulVDqahMW
	 NXpigf6BLznjMHrZ5cL7+4HurxrHqemcmmYXkvg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Hungyu Lin <dennylin0707@gmail.com>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Bryan ODonoghue <bod@kernel.org>
Subject: [PATCH 7.2 407/556] media: qcom: iris: use disable_irq() during power-off
Date: Wed,  9 Sep 2026 15:41:27 +0200
Message-ID: <20260909134244.943539705@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hungyu Lin <dennylin0707@gmail.com>

commit b9c2215bdedc9c532a7e9d57ec49ee1b6381f863 upstream.

The IRQ is registered as a threaded IRQ.

Using disable_irq_nosync() in iris_vpu_power_off() does not wait
for an already queued threaded IRQ handler to complete before
returning.

As a result, a threaded IRQ handler may still run after the VPU has
been powered down and access hardware registers after power-off.

Replace disable_irq_nosync() with disable_irq() so the power-off path
waits for any in-flight threaded IRQ handler to complete before
returning.

Fixes: bb8a95aa038e ("media: iris: implement power management")
Cc: stable@vger.kernel.org
Suggested-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/iris/iris_vpu_common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/platform/qcom/iris/iris_vpu_common.c
+++ b/drivers/media/platform/qcom/iris/iris_vpu_common.c
@@ -237,7 +237,7 @@ void iris_vpu_power_off(struct iris_core
 	iris_unset_icc_bw(core);
 
 	if (!iris_vpu_watchdog(core, core->intr_status))
-		disable_irq_nosync(core->irq);
+		disable_irq(core->irq);
 }
 
 int iris_vpu_power_on_controller(struct iris_core *core)


