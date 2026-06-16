Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA59283FE5;
	Tue, 16 Jun 2026 15:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623372; cv=none; b=uQtpuI/MxWbIjMi7ZW2AkSxiOTEuBpoVrSATylJgb0LF7SBDBqT0zMIJWue40WTdFLKWs5ML60sDa4IC+mniT176/z+8B2M6QJ5ko7g6qAV9tq2wD0wr6Pg/whjyMBaQcSvKCrZVUGjmRx2KlnJeJMCbf0jrUmausd4K2JHhALM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623372; c=relaxed/simple;
	bh=ajQWZxluQX67STYZLl48wXyCj54PhtDxyoaQl/VV+F8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pByMSN+t3z4A/7pmUq1U36uyDOug+vw1CqiK7mZ/cQyCH3K7Pd6cv61Ja0YeZ7InTY6J+ShfomwlmXFyPbtMw8uWq5LVcKUgp2qTKeKgcNrDaSCElFSrIlGdWOtdmjqTMqnAh1RIPruQnJfycFW4INHvoyIHiLDJJ2mLOT42L/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cJpvuS72; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cJpvuS72"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D28CB1F000E9;
	Tue, 16 Jun 2026 15:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623370;
	bh=e7VqVUtMGbO5iF/gCpwzTCvXiyeRJHyKjaH7KXOjedQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cJpvuS72Fbx4anYsM5qq/zoKGY8JihlZtQOTgfjm9klJV5xMM1fYqoUY2yfgKxoZz
	 8ASUAdObGPAqi2xs9zB6eq7myk1u6G54CZARPgPYnOTp+KkoUGStB8UO0YC8AZ2Lmu
	 HBkTz3nL8bNVmvhhZg0FGRHXkd5r4IiP8elAiopw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 108/378] ASoC: wm_adsp: Fix NULL dereference when removing firmware controls
Date: Tue, 16 Jun 2026 20:25:39 +0530
Message-ID: <20260616145116.056778081@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 7d3fb78b550301e43fdc60312aed733069694426 ]

In wm_adsp_control_remove() check that the priv pointer is not NULL
before attempting to cleanup what it points to.

When cs_dsp creates a control it calls wm_adsp_control_add_cb() so that
wm_adsp can create its own private control data. There are two cases
where private data is not created:

1. The control is a SYSTEM control, so an ALSA control is not created.

2. The codec driver has registered a control_add() callback that
   hides the control, so wm_adsp_control_add() is not called.

When cs_dsp_remove destroys its control list it calls
wm_adsp_control_remove() for each control. But wm_adsp_control_remove()
was attempting to cleanup the private data pointed to by cs_ctl->priv
without checking the pointer for NULL.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Fixes: 0700bc2fb94c ("ASoC: wm_adsp: Separate generic cs_dsp_coeff_ctl handling")
Link: https://patch.msgid.link/20260604101244.1402862-1-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm_adsp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/codecs/wm_adsp.c b/sound/soc/codecs/wm_adsp.c
index 2e23848e1dce94..d7ba14ce613b74 100644
--- a/sound/soc/codecs/wm_adsp.c
+++ b/sound/soc/codecs/wm_adsp.c
@@ -666,6 +666,9 @@ static void wm_adsp_control_remove(struct cs_dsp_coeff_ctl *cs_ctl)
 {
 	struct wm_coeff_ctl *ctl = cs_ctl->priv;
 
+	if (!ctl)
+		return;
+
 	cancel_work_sync(&ctl->work);
 
 	kfree(ctl->name);
-- 
2.53.0



