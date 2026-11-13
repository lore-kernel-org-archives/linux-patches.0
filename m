Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585809;
	b=gGgtsaQWnS1TCjgqKe1qNV3YzKLp89Y6sKHJND0lNCQWgHDnADmoxHFpnej4QTGUertA
	 LeKGP4ae/ojYcbkKk0hUfDrITFSLG4yu41jl84GCQG+1G77Q/eOo+3eW7f5Z+zRiMjKag
	 zqB82GZQYf3jd3MPd4h3cdYcN0AwAU3cq1cGl8epbSfj30U8pl8h6xEPrCV+Nqmk7OBUU
	 ew8cCPWh+rcHhRjdaSfgppLgNSfYtpwBTTV5hoBdxeAjM3dFOF3fZ+dBqy/BN6/+Pu40L
	 t8WnG7dAcgax8Bq5yS408Ngjs0ddoex2sA7RBC26E3KsujUK01LetuP9vaHbHpeuTMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585809;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uCWU5KTsZ3lhlryJnM73TxNspwZymMGCikPT2RPQiSk=;
	b=24tB57qqxk4FA9BrzNNCzq0zfKwhQLUdwyOu5d/oQlWE8z+qWRDEMNYOdUhj1lG+GV3w
	 QOzOqrxfrts8UHg3s4y6yx6S5vWVKn+G8yGRsRQBpSOtXxTjw1urtjwPScKI1c8YajJKT
	 izC10cZ4vx7yOLIY+W/j4Sv2bQDNp0gjy4MDW9w8RBNup8WpPmc79aBoEXQ5IRGc1BMvV
	 JOKTsMF4SPHY9BqrZjiVR7u8lA72UdYrvgcC4+zHAzEAGayhFG52UL4N+ZsuJRXc+R3bY
	 3oFRx1ucrMl2FLpx/IqfYL3EoeshOvGNg91knxaGQwLbIuHWq8wxO6HZxz1cS1p1w8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=taXBXKww;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DFD5606BA98;
	Fri, 13 Nov 2026 16:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=taXBXKww
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDCCD1F000C4;
	Fri, 13 Nov 2026 16:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585809;
	bh=uCWU5KTsZ3lhlryJnM73TxNspwZymMGCikPT2RPQiSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=taXBXKww9Rf2QV1H1+UL7exApykprPwDwZirMq+592foh4UUE4qn5deDFP/u5RakH
	 GOHKRNXaDCsvVoqMa9XpmOiAopNciURPcwkhgcNqynVap76lcy3KHsnMj4gvKmKxte
	 1w3V08Hr+xVcKsGWHqch5vYzUeEhp+LHGjuuiWro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Kazinsky <a.kazinsky@ideco.ru>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 393/507] ALSA: cs46xx: Handle SCB creation failures before dereferencing
Date: Fri, 13 Nov 2026 10:51:37 -0500
Message-ID: <20261113153810.075982880@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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
index a77e6f5a14ada..57b0a6321e0b6 100644
--- a/sound/pci/cs46xx/dsp_spos.c
+++ b/sound/pci/cs46xx/dsp_spos.c
@@ -1104,6 +1104,8 @@ int cs46xx_dsp_scb_and_task_init (struct snd_cs46xx *chip)
 
 		null_scb.entry_point = null_algorithm->address;
 		ins->the_null_scb = cs46xx_dsp_create_scb(chip, "nullSCB", (u32 *)&null_scb, NULL_SCB_ADDR);
+		if (!ins->the_null_scb)
+			return -ENOMEM;
 		ins->the_null_scb->task_entry = null_algorithm;
 		ins->the_null_scb->sub_list_ptr = ins->the_null_scb;
 		ins->the_null_scb->next_scb_ptr = ins->the_null_scb;
diff --git a/sound/pci/cs46xx/dsp_spos_scb_lib.c b/sound/pci/cs46xx/dsp_spos_scb_lib.c
index fd19365026b4a..c5208e42cde95 100644
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



