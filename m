Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA4EB2248B3;
	Mon,  2 Jun 2025 15:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877086; cv=none; b=FVOH06Y0BO4et+Gj1aXeuzX5SL8b10ihgOeDGUd3EIQ29E8rpi4Ohl4NKfj4ulNLxetfv9C1ugHA5xQbYLtdxc0fbBahE71fzBCvuT1OC9GYv+2lGmBFhCgfdfGIDJUEctX9wvXcCrHquQKbMnmBtzusww5iQCwmN0cKFdWVLNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877086; c=relaxed/simple;
	bh=KOvPiQVaV1lgom0jEw7FZUBPRs6CgOCCZ4pWs7+Wy8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=foMJ7PkB+txDX7y6rY9XpN9jnQesCLTFRM2VWx2rFJBE/fTa7QW87qMJhtB/bpKsmT8GuxvojKmo+KC71cC0PN/nJH6U+A8lZwQMVKAZlW56hlxEdQlkd6I4XPUV7NGEgXk3C0Ue01NnY8SMPTPrL1b7jcpdbU6Vt10WcHZ0ZGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w0q2zq+T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w0q2zq+T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD535C4CEEB;
	Mon,  2 Jun 2025 15:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748877086;
	bh=KOvPiQVaV1lgom0jEw7FZUBPRs6CgOCCZ4pWs7+Wy8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w0q2zq+TMUZuL78SAfb80pCLEKIF9uCD+/JjiaR0iM/FB3REpM685rcXjZytu6udu
	 vgcYfM9yXHvjXNbsfJXXYQR+I6z2c1xgSV0rJdFZxyRwIlE/ppGQCCsutq+neBvUgj
	 OAC4kEQgBD2WkcFlFcdR33SXRp1QNoHhZWGs2udI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Martin=20Povi=C5=A1er?= <povik+lin@cutebit.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 167/325] ASoC: ops: Enforce platform maximum on initial value
Date: Mon,  2 Jun 2025 15:47:23 +0200
Message-ID: <20250602134326.602192758@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Povišer <povik+lin@cutebit.org>

[ Upstream commit 783db6851c1821d8b983ffb12b99c279ff64f2ee ]

Lower the volume if it is violating the platform maximum at its initial
value (i.e. at the time of the 'snd_soc_limit_volume' call).

Signed-off-by: Martin Povišer <povik+lin@cutebit.org>
[Cherry picked from the Asahi kernel with fixups -- broonie]
Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://patch.msgid.link/20250208-asoc-volume-limit-v1-1-b98fcf4cdbad@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-ops.c | 29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/sound/soc/soc-ops.c b/sound/soc/soc-ops.c
index b4cfc34d00ee6..eff1355cc3df0 100644
--- a/sound/soc/soc-ops.c
+++ b/sound/soc/soc-ops.c
@@ -638,6 +638,33 @@ int snd_soc_get_volsw_range(struct snd_kcontrol *kcontrol,
 }
 EXPORT_SYMBOL_GPL(snd_soc_get_volsw_range);
 
+static int snd_soc_clip_to_platform_max(struct snd_kcontrol *kctl)
+{
+	struct soc_mixer_control *mc = (struct soc_mixer_control *)kctl->private_value;
+	struct snd_ctl_elem_value uctl;
+	int ret;
+
+	if (!mc->platform_max)
+		return 0;
+
+	ret = kctl->get(kctl, &uctl);
+	if (ret < 0)
+		return ret;
+
+	if (uctl.value.integer.value[0] > mc->platform_max)
+		uctl.value.integer.value[0] = mc->platform_max;
+
+	if (snd_soc_volsw_is_stereo(mc) &&
+	    uctl.value.integer.value[1] > mc->platform_max)
+		uctl.value.integer.value[1] = mc->platform_max;
+
+	ret = kctl->put(kctl, &uctl);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
 /**
  * snd_soc_limit_volume - Set new limit to an existing volume control.
  *
@@ -662,7 +689,7 @@ int snd_soc_limit_volume(struct snd_soc_card *card,
 		struct soc_mixer_control *mc = (struct soc_mixer_control *)kctl->private_value;
 		if (max <= mc->max - mc->min) {
 			mc->platform_max = max;
-			ret = 0;
+			ret = snd_soc_clip_to_platform_max(kctl);
 		}
 	}
 	return ret;
-- 
2.39.5



