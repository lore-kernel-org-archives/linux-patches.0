Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F02E18C02E;
	Tue, 10 Sep 2024 10:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964309; cv=none; b=hwri6OtGwMu9UmWyaC0ikwBjoZXjcx4SrmaskyIoTqgaTmgUCnkufXCA1kwHRg28C7eXn2mYzhd6F/UOg8qvXQKRk2rceg4CNXaFvq8H/Q05iM4bB2iykQ402PrviCNuPH04XxByHfddRPFA6T8sCvyPTrKa2LZGUbz/hii6Shk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964309; c=relaxed/simple;
	bh=b4z6qL0jXogsBKdpVO6zXYlFZSzKUvun+WjlbpZpjdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bDQPMNEK+4qxEufOuLwKTvr+1/F3e1Wu9vwtSgaVaiZ+uEWR0Ga+cZgTdoZsuFfiebUwUFmjZ7CeLoiT+uQZsKnKMMQAcm+3a1fOpWCw/ovrcC27xsioQT/waPOofJLVt6CO26+tHOqU5az/zBgRg5lriyVl+QkFV9JK79/G2aM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BIeom02c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BIeom02c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4070EC4CEC3;
	Tue, 10 Sep 2024 10:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964308;
	bh=b4z6qL0jXogsBKdpVO6zXYlFZSzKUvun+WjlbpZpjdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BIeom02csTyzY0218307UT4iU3IC0DMi/xntep27woAv6x9lgrFDYjmHxEjjw9LhP
	 iNrkTenTNg4p+gCbbBXAeZsldKhUOLERLjz1FJUrdb9SRl2KKALlmM5cxI4eeqPmBS
	 oVJx9gfN63JhfrKio9kTv+fkOez+64DVSejUUL9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 138/269] firmware: cs_dsp: Dont allow writes to read-only controls
Date: Tue, 10 Sep 2024 11:32:05 +0200
Message-ID: <20240910092613.124756603@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a1da7581adb0..e62ffffe5fb8 100644
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



