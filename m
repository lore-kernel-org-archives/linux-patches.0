Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC24C1922E7;
	Tue, 10 Sep 2024 10:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962958; cv=none; b=VbG1CKN8XNugGQb3aGcDy4Q7hesNxAnt+Yj/lWjzeV/dyIvnG+bdHlkIELOMhWvKt+VTy1M30giOv6stQZ76A1HAdbBtfXQP7gX0L1ZvwY5lfA74LoBDGPBWi82VnaA93SeaEYeJqWLHsvvqX+iDc2+YbWkas8biw0OOLy9E80w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962958; c=relaxed/simple;
	bh=PHNBvCujV5+RSInz40RhrW5aAOr72uheOw/B1fS0ytc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MtK+23Ro7N1iHZMpruJX+z9ktoSv5Cb/MoCldfVQZkt3UZhQvO/3qzZpG69zJG3W1boNPjZ27dvttANiMwX/oSD1NtMhhB/HqKMUO8aJvhNkKneik2kXejbePksmrXugWykJ5TayWGWn1Zjf3U+7uijvN4mYa1AL+BNmhMl1C0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=czZ4Vd2x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="czZ4Vd2x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40A56C4CECF;
	Tue, 10 Sep 2024 10:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962958;
	bh=PHNBvCujV5+RSInz40RhrW5aAOr72uheOw/B1fS0ytc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=czZ4Vd2xZMg1aoEtgiL+LWUAYy+XbOtzLnkXZc42mKhnzskzm2cYiJZnKiwNjUGFJ
	 fkcwsuTLtt2qzLktEBHIIzBEVmMjwSlsDlrse/VUGWjxTc+xS+baGeZfxMVQdwFJ+l
	 6tXZdd7icWJVP9x3YfwqYegh1Z+SukLNWKCj8Cqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 088/192] firmware: cs_dsp: Dont allow writes to read-only controls
Date: Tue, 10 Sep 2024 11:31:52 +0200
Message-ID: <20240910092601.627641136@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
References: <20240910092557.876094467@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 62412a9357b16a4e39dc582deb2e2a682b92524c ]

Add a check to cs_dsp_coeff_write_ctrl() to abort if the control
is not writeable.

The cs_dsp code originated as an ASoC driver (wm_adsp) where all
controls were exported as ALSA controls. It relied on ALSA to
enforce the read-only permission. Now that the code has been
separated from ALSA/ASoC it must perform its own permission check.

This isn't currently causing any problems so there shouldn't be any
need to backport this. If the client of cs_dsp exposes the control as
an ALSA control, it should set permissions on that ALSA control to
protect it. The few uses of cs_dsp_coeff_write_ctrl() inside drivers
are for writable controls.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://patch.msgid.link/20240702110809.16836-1-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/cirrus/cs_dsp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/firmware/cirrus/cs_dsp.c b/drivers/firmware/cirrus/cs_dsp.c
index 68005cce0136..cf4f4da0cb87 100644
--- a/drivers/firmware/cirrus/cs_dsp.c
+++ b/drivers/firmware/cirrus/cs_dsp.c
@@ -764,6 +764,9 @@ int cs_dsp_coeff_write_ctrl(struct cs_dsp_coeff_ctl *ctl,
 
 	lockdep_assert_held(&ctl->dsp->pwr_lock);
 
+	if (ctl->flags && !(ctl->flags & WMFW_CTL_FLAG_WRITEABLE))
+		return -EPERM;
+
 	if (len + off * sizeof(u32) > ctl->len)
 		return -EINVAL;
 
-- 
2.43.0



