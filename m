Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2B5863CB;
	Wed, 20 May 2026 16:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295346; cv=none; b=fnINjeje9dqRi4OWRJ7r83h8vtti1zmXniKUlrvs6OHrVJ938JmWWtDEN+G+uomyfAe3FRXrusEjYARUEHrP1b2/RiOeRDfCnXkDp62WdBA0Xk254Qn8CUM+otAiyGR5ogC9stOtNciWnaIjZZeZIo8yOV1K1OihOCvSMNohbws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295346; c=relaxed/simple;
	bh=CjX8L/IcLRJCCaxDi26YbBW6ddXifnHBdPsX8L+e8Pg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jdQAdkv1y7wWho3p+sptEivm/gBGGoVNSp+9I7PT6UCXSqsmbAeKDScXIs7CnNMYUGTNTX37VNSrTyz8p3xWllBeaYkkHcn4QlRcV7UY4KFuwwbCHAtXFhVf6rHJxLK/lisv9MU9D36r6vZmusozk4exm5ACyFukZ3YVDNmPFZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RxMlqf5L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RxMlqf5L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3509A1F00893;
	Wed, 20 May 2026 16:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295345;
	bh=fX1spIT6m5VFkq/7+E49JT+OX8oH9zZIIGZzjEzEcWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RxMlqf5LuasfzChONbpjQHASeVIiMZTXZ9Pk6cZ7bn3TAXdzgxFpYj/a5I6IAa5Ae
	 yqwf/GRuiIdJtWQJM/w7qlmYccD9uLz1OLWvDspEnzfp4lMELPhYLrWevmXQdvL0Cm
	 /Z/58U4P8ibP7G2AEOlguYj7erClnOr05tRZ+jGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0382/1146] ASoC: qcom: qdsp6: topology: check widget type before accessing data
Date: Wed, 20 May 2026 18:10:32 +0200
Message-ID: <20260520162156.845112217@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>

[ Upstream commit d5bfdd28e0cdd45043ae6e0ac168a451d59283dc ]

Check widget type before accessing the private data, as this could a
virtual widget which is no associated with a dsp graph, container and
module. Accessing witout check could lead to incorrect memory access.

Fixes: 36ad9bf1d93d ("ASoC: qdsp6: audioreach: add topology support")
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Link: https://patch.msgid.link/20260402081118.348071-4-srinivas.kandagatla@oss.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/qdsp6/topology.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/sound/soc/qcom/qdsp6/topology.c b/sound/soc/qcom/qdsp6/topology.c
index e732fac9b8ca0..1f69fba6de26d 100644
--- a/sound/soc/qcom/qdsp6/topology.c
+++ b/sound/soc/qcom/qdsp6/topology.c
@@ -952,9 +952,6 @@ static int audioreach_widget_unload(struct snd_soc_component *scomp,
 	struct audioreach_container *cont;
 	struct audioreach_module *mod;
 
-	mod = dobj->private;
-	cont = mod->container;
-
 	if (w->id == snd_soc_dapm_mixer) {
 		/* virtual widget */
 		struct snd_ar_control *scontrol = dobj->private;
@@ -963,6 +960,11 @@ static int audioreach_widget_unload(struct snd_soc_component *scomp,
 		kfree(scontrol);
 		return 0;
 	}
+	mod = dobj->private;
+	if (!mod)
+		return 0;
+
+	cont = mod->container;
 
 	mutex_lock(&apm->lock);
 	idr_remove(&apm->modules_idr, mod->instance_id);
-- 
2.53.0



