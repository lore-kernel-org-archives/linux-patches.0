Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2409217704;
	Sat, 30 May 2026 18:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165553; cv=none; b=E4rU38xQVyS/EpXsR5K9gSSdL+XIRHDtJuoPS5loJdqHDzk5IUGppxubGUxBRWdfWclbqtErkK8Old/1Fyf+Y5zlQZojgNSrFuIuZ36qLVni5UttVh0L68BdpIUgakJKzX8zeJ3lk7BY1Ym1hcCqz88l+zYvzaf2Z/JQwumHL24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165553; c=relaxed/simple;
	bh=ZiFc8loYAX/OjX5Yki/z862+xsJfsdcn59QPBgAcPIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=avjWBt+iJmRKG9tjJZq0BmXdvimDAvwsasG6V1qMXc6xHQhTgBzVpCS0muiEtgXlBLAbuYwK3nk3xEF+AFAaha8smDfoT5S0jYGawJ93i7Y/iER3zcfRmqLIwDH3TdDE2om+Vs1FzN+t9uUInoMqAromE1fniUb9E8w8rqSmXYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q8BJG1db; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q8BJG1db"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 140801F00893;
	Sat, 30 May 2026 18:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165552;
	bh=lpBdBQ6Wh520vq/vICYgUPd7VRG4sx2lyYIc8v24ZPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q8BJG1db8tBReQ9uNTGh+pj7RIgOkHWbZDRrNwiC8+C+79Sq2luLNs/g1APbLl8hR
	 uzd+fZmYGyyjgixYGQLw/5Vwy6Hiu9jZAqvcjA5pCPZ7MMrCg3Bw64Yc3CNSNkGrkz
	 pCkHFzl7i+CQ/xf+4q3W3LODGK1fHwZaJd+2gW6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <cyeaa@connect.ust.hk>,
	Takashi Iwai <tiwai@suse.de>,
	Vasiliy Kovalev <kovalev@altlinux.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 095/589] ALSA: usb-audio: fix null pointer dereference on pointer cs_desc
Date: Sat, 30 May 2026 17:59:36 +0200
Message-ID: <20260530160227.194081368@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chengfeng Ye <cyeaa@connect.ust.hk>

commit b97053df0f04747c3c1e021ecbe99db675342954 upstream.

The pointer cs_desc return from snd_usb_find_clock_source could
be null, so there is a potential null pointer dereference issue.
Fix this by adding a null check before dereference.

Signed-off-by: Chengfeng Ye <cyeaa@connect.ust.hk>
Link: https://lore.kernel.org/r/20211024111736.11342-1-cyeaa@connect.ust.hk
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Fixes: 1dc669fed61a ("ALSA: usb-audio: UAC2: support read-only freq control")
[ kovalev: bp to fix CVE-2021-47211; added Fixes tag; the null
  check was added into both UAC2 and UAC3 branches since the
  older kernel still has the clock source lookup split between
  snd_usb_find_clock_source() and snd_usb_find_clock_source_v3()
  (see upstream commit 9ec730052fa2) ]
Signed-off-by: Vasiliy Kovalev <kovalev@altlinux.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/clock.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/sound/usb/clock.c b/sound/usb/clock.c
index 197a6b7d8ad6f..3d5d4f3aafce4 100644
--- a/sound/usb/clock.c
+++ b/sound/usb/clock.c
@@ -646,11 +646,17 @@ static int set_sample_rate_v2v3(struct snd_usb_audio *chip, int iface,
 		struct uac3_clock_source_descriptor *cs_desc;
 
 		cs_desc = snd_usb_find_clock_source_v3(chip->ctrl_intf, clock);
+
+		if (!cs_desc)
+			return 0;
 		bmControls = le32_to_cpu(cs_desc->bmControls);
 	} else {
 		struct uac_clock_source_descriptor *cs_desc;
 
 		cs_desc = snd_usb_find_clock_source(chip->ctrl_intf, clock);
+
+		if (!cs_desc)
+			return 0;
 		bmControls = cs_desc->bmControls;
 	}
 
-- 
2.53.0



