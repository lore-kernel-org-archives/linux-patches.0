Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590476;
	b=Hph1JIHovLTml3gdz4MRU5XGXeHY7wewDNR9FES47iJgrLj/POoiMtdFKCC+dWP34xRT
	 1w4xCTxur30eCQw56dC1uO831H7zB0/P7JjDTGE4V9YGlZb48+4Pn7VjLUbWP1thJqYIY
	 WB+qfJrAE8TJj5T/gWHZp/heLAxHcG1LonZT1zPdS1y5q6rC8hxzJovZt9RRpQTIBz4qy
	 7ODviGRPnoBleoVEFg3bftzDYluIi0rqK/N3d3SA43u0BiMUWZsQIWxuxJoaxU+R1LXGu
	 xaCG59GCVy3n7dPG4VYObVhF7OAS1Q0D3/x6Ds51dtpvtUGudOdI+Np/bcYynjczAAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590476;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PJ44ywkLYy9zidC+RPR4Vf6B3Zn++H7saLt1CwF17Ms=;
	b=LiX8JgWSZ56Yx46d0oLhVy+nFbc7VpTlKeGvr6xsKJJ8GeTVVcNWrj2UlAmfNVo2QExy
	 /0646GRGq7ILK0tyf7tcXEiF3zLZpBARQaz/9p/u+KckvJKvxTqNTrD5HxR7X7J5CgQey
	 IjYorR5xJswMkmPx3FsUg9WdANyN7PuGAsqB7r2RU19bXjyKvA8iXiJWaF1WnqhdvLdt0
	 9zen+tL4XyeVkSGpeNHAKhNx7nfjW+KldSrL7uWvBlgzZj4Pg91Vo1As8ycVbnDIXVJHe
	 XRahb2SNPypBZjbNc/8Ask/FkpxQEgK6mXso5J0t66rfxzCxkGyJhUdB7DFMAele82A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aIgyZSG4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9918606B820;
	Fri, 13 Nov 2026 17:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aIgyZSG4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 556741F000C9;
	Fri, 13 Nov 2026 17:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590476;
	bh=PJ44ywkLYy9zidC+RPR4Vf6B3Zn++H7saLt1CwF17Ms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aIgyZSG48/VC0yAn4f11Z5+xBjpk6mdu2jdrskCos3vazVo9bkVfRrG0efxG4Hbv1
	 eihRYftOngo0zVdipWDFO2qNBMG4vvhEK5BthM+X7Mlf2feHaE5xCMdmA3RBytP1gw
	 2NBkRRXoh1g7Dfqz1+em3duJKAq5EkW/NY0rX4Rg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Kazinsky <a.kazinsky@ideco.ru>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 429/686] ALSA: cs46xx: Handle SCB creation failures before dereferencing
Date: Fri, 13 Nov 2026 10:49:22 -0500
Message-ID: <20261113153835.466266391@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Kazinsky <a.kazinsky@ideco.ru>

[ Upstream commit 023d3e1176202339cd94a3d732e3aec74e36ba22 ]

With CONFIG_PM_SLEEP enabled, cs46xx_dsp_create_scb() can return NULL
if kmemdup() fails to allocate the SCB data saved for resume.
cs46xx_dsp_scb_and_task_init() and _dsp_create_generic_scb() dereference
the returned pointer without checking it, causing a NULL pointer
dereference on allocation failure.

Check both return values before accessing the SCB descriptors.
Return -ENOMEM when creating the null SCB fails and propagate NULL
from _dsp_create_generic_scb().

Found by Linux Verification Center (linuxtesting.org) with SVACE
static analysis tool.

Fixes: 41116e926cb9 ("ALSA: cs46xx - Fix suspend/resume with new DSP")
Cc: stable@vger.kernel.org
Signed-off-by: Alex Kazinsky <a.kazinsky@ideco.ru>
Link: https://patch.msgid.link/20261030142529.415697-1-a.kazinsky@ideco.ru
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/cs46xx/dsp_spos.c         | 2 ++
 sound/pci/cs46xx/dsp_spos_scb_lib.c | 3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/sound/pci/cs46xx/dsp_spos.c b/sound/pci/cs46xx/dsp_spos.c
index ba290f3a50e43..144c87097ae82 100644
--- a/sound/pci/cs46xx/dsp_spos.c
+++ b/sound/pci/cs46xx/dsp_spos.c
@@ -1106,6 +1106,8 @@ int cs46xx_dsp_scb_and_task_init (struct snd_cs46xx *chip)
 
 		null_scb.entry_point = null_algorithm->address;
 		ins->the_null_scb = cs46xx_dsp_create_scb(chip, "nullSCB", (u32 *)&null_scb, NULL_SCB_ADDR);
+		if (!ins->the_null_scb)
+			return -ENOMEM;
 		ins->the_null_scb->task_entry = null_algorithm;
 		ins->the_null_scb->sub_list_ptr = ins->the_null_scb;
 		ins->the_null_scb->next_scb_ptr = ins->the_null_scb;
diff --git a/sound/pci/cs46xx/dsp_spos_scb_lib.c b/sound/pci/cs46xx/dsp_spos_scb_lib.c
index 32ed415bf427c..b7c41f2bc312e 100644
--- a/sound/pci/cs46xx/dsp_spos_scb_lib.c
+++ b/sound/pci/cs46xx/dsp_spos_scb_lib.c
@@ -274,7 +274,8 @@ _dsp_create_generic_scb (struct snd_cs46xx *chip, char * name, u32 * scb_data, u
 	dev_dbg(chip->card->dev, "dsp_spos: creating SCB <%s>\n", name);
 
 	scb = cs46xx_dsp_create_scb(chip,name,scb_data,dest);
-
+	if (!scb)
+		return NULL;
 
 	scb->sub_list_ptr = ins->the_null_scb;
 	scb->next_scb_ptr = ins->the_null_scb;
-- 
2.53.0



