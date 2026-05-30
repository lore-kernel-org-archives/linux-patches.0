Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CED62690D5;
	Sat, 30 May 2026 17:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160469; cv=none; b=EEQ3bcFVatnLIS4NPzuBabjECS6fut0Drnq83umPZ1ufzaNAMW3rpllB16WlbIBMvQj3rzJGsiRYrd+5YGSdLlebl7sVONHbh+iA3VyKUa+LSQSgC3MrYsQOQSeqsPOMSmTOEH++WicKgPmTxXNxCYNH7tJBWMyhPo9IIqesIwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160469; c=relaxed/simple;
	bh=+MK6hwz2L/zWPazNi0qHwc/ax7tTgWUccXcGRRBk3v8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iDH8DW9U0A9dAJUR+n5jOtuYuF1TMNDjMntZRCAYaK1TCtzQHr03riW3tgYKnf4JsL1rNZP7nMSzrHy15blHwnEBt2+lk3cQ8eVSH/kTkNaHZ7HXJMDYGFk0+XtsjQ7seUtlXlL5gzdZkX4OMBDdahifwO2/PRpfvdyT0WvYXpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kZLme5Ni; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kZLme5Ni"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 432761F00893;
	Sat, 30 May 2026 17:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160467;
	bh=Dh2hx5ayk3DC05kBP0V3oyLlzjOaWjch2+Vv+5la8BU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kZLme5NiIohRFv1rw+bGgm7blM6/cWh23l7OFVNQIGqPRzCY5s/0TvbTmVMB6E9HV
	 C7eN0bQkaqYHUqzbf87otImjZp1op4qtkyUky7JCKaDS/BHh0QDx5zTONTi57VrX1W
	 H+mWbHuPk22792D/xE+0bllBriEraGB4bqGDiUZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable@vger.kernel.org,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 347/969] ASoC: qcom: q6apm: remove child devices when apm is removed
Date: Sat, 30 May 2026 17:57:51 +0200
Message-ID: <20260530160309.942948831@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>

commit 4a0e1bcc98f7281d1605768bd2fe71eacc34f9b7 upstream.

looks like q6apm driver does not remove the child driver q6apm-dai and
q6apm-bedais when the this driver is removed.

Fix this by depopulating them in remove callback.

With this change when the dsp is shutdown all the devices associated with
q6apm will now be removed.

Fixes: 5477518b8a0e ("ASoC: qdsp6: audioreach: add q6apm support")
Cc: Stable@vger.kernel.org
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Link: https://patch.msgid.link/20260402081118.348071-3-srinivas.kandagatla@oss.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/qcom/qdsp6/q6apm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/soc/qcom/qdsp6/q6apm.c
+++ b/sound/soc/qcom/qdsp6/q6apm.c
@@ -763,6 +763,7 @@ static int apm_probe(gpr_device_t *gdev)
 
 static void apm_remove(gpr_device_t *gdev)
 {
+	of_platform_depopulate(&gdev->dev);
 	snd_soc_unregister_component(&gdev->dev);
 }
 


