Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D204B2BE7CD;
	Fri,  9 Oct 2026 14:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556303; cv=none; b=reI5+jLu5zCO9clB3VlSTeeqapvtaljofvVJZz7KvqFPvIm6bE99yzlE8kxVIEKJF0lK6GliucbSJM3Mn/61NWNrxvniR7gzXynckHdxfiVXtR/mueQXMIKgbXMFeCq0PdjWC1OQo3r7C9cJmbFTMjjdbydCw7ucqSDjAcle2H8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556303; c=relaxed/simple;
	bh=QZB6XBAq4ijP/DO0KQyj9bd2c0FIRuTyExuqPQyNKZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pfAWu+wp8P0yuInVrEusaHW9nOwD28SkYdIJsgWmtCuuMtN7i4qqC2Vu+TsXn7FhdIqcZKg82KujtcmMCwl6uUdV6GadBfuS3szuAfae9JuoZjngzL/OGQ0uRGKJsY2XRGMlX0xE5N83BA2kDJCGGARZUvLo1Ec9lZnYM4wRYvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TCPWYv/O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TCPWYv/O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33D091F000FF;
	Fri,  9 Oct 2026 14:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556302;
	bh=rrYfCimQYli1W9M0O1QnqSCoWr3xCKGlp/IOHHD5oC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TCPWYv/OCOym7KDfW3H8Ei4ysiR2rLDEluZNyVKJ+uotoF1H0NhpkEkp1FTxi0mhX
	 i4BgttimzhElGRJJykepditjLuxUeC+s5uRbs9Urrwr7dl6gCItReVzDR+ETRh3rk4
	 9ZMihxLnDclRGetfafbvIw8xCnTEOPE9eEPXDsAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Kling <webgeek1234@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 212/403] ALSA: hda/tegra: Re-enable SDO workaround for Tegra194
Date: Fri,  9 Oct 2026 16:09:33 +0200
Message-ID: <20261009140957.098313860@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaron Kling <webgeek1234@gmail.com>

commit 89365897f4210979966aa808d7b013edf4080558 upstream.

This workaround was originally added for Tegra194, but no longer gets
applied for it. Commit 615d43540043 ("ALSA: hda/tegra: fix tegra-hda on
tegra30 soc") changed the guard to tegra30-hda, which worked because all
affected archs had the fallback compatible. However, commit 7f0ea5acfc19
("arm64: tegra: Use correct compatible string for Tegra194 HDA") removed
the fallback compatible for Tegra194, causing this to break.

Fixes: 7f0ea5acfc19 ("arm64: tegra: Use correct compatible string for Tegra194 HDA")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Aaron Kling <webgeek1234@gmail.com>
Link: https://patch.msgid.link/20260926-tegra194-hda-sdo-v1-1-f7a636a07a58@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/controllers/tegra.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/sound/hda/controllers/tegra.c
+++ b/sound/hda/controllers/tegra.c
@@ -374,7 +374,8 @@ static int hda_tegra_first_init(struct a
 	 * in powers of 2, next available ratio is 16 which can be
 	 * used as a limiting factor here.
 	 */
-	if (of_device_is_compatible(np, "nvidia,tegra30-hda"))
+	if (of_device_is_compatible(np, "nvidia,tegra30-hda") ||
+	    of_device_is_compatible(np, "nvidia,tegra194-hda"))
 		chip->bus.core.sdo_limit = 16;
 
 	/* codec detection */


