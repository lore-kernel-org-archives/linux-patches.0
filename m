Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618461;
	b=dVt9V7ib5pLukQjjVEt9ddlvAvth3a57BWYZwtSm5osBnAts0vT92QZcdYaxukls0Nbj
	 toKZwQdzbH40NnM+bGsVK4ThaJYZySq0n0lTS9XnKzdqh9nZ6m1am7gfVb3nyTaLtsZAd
	 q5MJp1eHyyEib3humv+MfcGKpkmGh6ymIA9er+tb4AiFBek7t2q1j9kft4em6D4f45Yd+
	 5tVAAMCc0fRbjtbwiBm/q3+2hEpeDqv8vQjrzLedo6EpR6/xehP+ynlEA+2u5faVaWiq+
	 ONCNUAtfbduNw4N8p8BFj8okrGIxi9FGR/0g3wRlLRHFq8Z2lryqjpd/l6T6GCgs7hQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618461;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0lM4z7UYdjORrPfD5uVULrrIOIU0UQ8k/H004tSjJ3w=;
	b=BpKsW8RpZcINMOPEl3RwwCnBEENWzouyslxcR2iBe5JfDfllZE7msM5ta4YhdVyMOclZ
	 cSVO97ZqgQvQU47hR8Csk+KGupJmvhWxiOm6696UV6B0XjgbuskskqnHjqzznIsKHNBd1
	 qqarPec0KRzt9vDlrhmXzNVcNqIdtdDuhZlbnaXm62qsgepEpTcTefGpaodzra/4J0gZA
	 VymxL6/ECErX/QQ3Qlqt1qxTaaqvSuX5CD3TDJ3VNZbYgH4EHdhK+GGHXAiOoZaN5eU1+
	 eGHQOvL60376yixTBP9+rMvNl5GQnDggadwP7L7DSXbBYbd/Pow9gDV/6zW1M9rwyKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iyCp8rAH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C27B606A31E;
	Wed, 25 Nov 2026 14:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iyCp8rAH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BC761F000D0;
	Wed, 25 Nov 2026 14:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618460;
	bh=0lM4z7UYdjORrPfD5uVULrrIOIU0UQ8k/H004tSjJ3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iyCp8rAHtBFzLEKWYqVe3f7kseUWD98ca86zE8+yolIQ/ZHKSxuHvHE1vnMchLSV3
	 EsZ7W0BVgTI9RqwRQroZdSq/7/s3jxJ8VJojffEgth1KF/3cWPR3BOltuIByq1cEgA
	 W4209GHe9O5L4M4LYdu7SSEaQdH0avK5JxluLyUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0287/1005] firmware: cs_dsp: Fix memory leak on cs_dsp_power_up() error path
Date: Wed, 25 Nov 2026 15:27:05 +0100
Message-ID: <20261125143828.464071823@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 39d31f76ad1b12f1b5e6ef4c15f89e6b3c3f603a ]

If cs_dsp_power_up() fails on or after cs_dsp_load() mark the controls
disabled and free the alg regions.

Fixes: f6bc909e7673c ("firmware: cs_dsp: add driver to support firmware loading on Cirrus Logic DSPs")
Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://patch.msgid.link/20261104152402.1153795-1-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/cirrus/cs_dsp.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/firmware/cirrus/cs_dsp.c b/drivers/firmware/cirrus/cs_dsp.c
index 838fece8dc01a..413fb997be2bf 100644
--- a/drivers/firmware/cirrus/cs_dsp.c
+++ b/drivers/firmware/cirrus/cs_dsp.c
@@ -2793,6 +2793,7 @@ int cs_dsp_power_up(struct cs_dsp *dsp,
 		    const struct firmware *coeff_firmware, const char *coeff_filename,
 		    const char *fw_name)
 {
+	struct cs_dsp_coeff_ctl *ctl;
 	int ret;
 
 	mutex_lock(&dsp->pwr_lock);
@@ -2838,6 +2839,11 @@ int cs_dsp_power_up(struct cs_dsp *dsp,
 
 	return 0;
 err_ena:
+	list_for_each_entry(ctl, &dsp->ctl_list, list)
+		ctl->enabled = 0;
+
+	cs_dsp_free_alg_regions(dsp);
+
 	if (dsp->ops->disable_core)
 		dsp->ops->disable_core(dsp);
 err_mem:
-- 
2.53.0



