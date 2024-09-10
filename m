Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1276046444;
	Tue, 10 Sep 2024 09:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961820; cv=none; b=L9O4iVXLSfJY5njPbZ/Iqh9dIgJpHrWzC6NDO3n0hBx/BvioVhrwpFySYmHz0DH29j6SvxNTBYhD6JOupRPWFJvdgRGSW4m6PH4WNw5D4rKSok7klIQgoC6ahJUGqQdbwg8ye6OPQ/TWa6omKnaghBMhJvF7qYiEgYcQ8cHxk14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961820; c=relaxed/simple;
	bh=ydT67DBNtsCpIziBZn/YXHeheUXGpptovNI2FEOm4M8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oKufliY//X90L4g55xKTAjfWp8XcfY7M9Y22Zb/NbYT3loizJepPxRDwoalEWDOMVi+g362KVOKIOmqb7nL6dTP3IUVPAiA2W/WWI7Knnqn0hEYqJK5klxtavYRkaE+nYqjfwx9aZnx/sM7G02g0Of2fd56btxNOpc1dz8AyNig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D535UWd6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D535UWd6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D321C4CEC3;
	Tue, 10 Sep 2024 09:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961820;
	bh=ydT67DBNtsCpIziBZn/YXHeheUXGpptovNI2FEOm4M8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D535UWd6vueIGvoRqY0YVlUqU56CvYz8Zudb1ZcQUhLtWhZ2GYead91WmcgZR3UpE
	 jFNJMEZ5KVuGNFoMkWlxNwNbE4N6K/Mx/bxLh3jr96mCjgUMho/4aQE5TvxRnG2O0h
	 Vo2ejaBQFV/nnjiQHjrSUcqRWOYWMoO/u3AggFxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 200/375] firmware: cs_dsp: Dont allow writes to read-only controls
Date: Tue, 10 Sep 2024 11:29:57 +0200
Message-ID: <20240910092629.223206175@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 8a347b938406..89fd63205a6e 100644
--- a/drivers/firmware/cirrus/cs_dsp.c
+++ b/drivers/firmware/cirrus/cs_dsp.c
@@ -796,6 +796,9 @@ int cs_dsp_coeff_write_ctrl(struct cs_dsp_coeff_ctl *ctl,
 
 	lockdep_assert_held(&ctl->dsp->pwr_lock);
 
+	if (ctl->flags && !(ctl->flags & WMFW_CTL_FLAG_WRITEABLE))
+		return -EPERM;
+
 	if (len + off * sizeof(u32) > ctl->len)
 		return -EINVAL;
 
-- 
2.43.0



