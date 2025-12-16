Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C34E83563C8;
	Tue, 16 Dec 2025 12:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886534; cv=none; b=tof953yGW4sbDh9nptLHPKWpbzeS9jqFvEM4P/b6M99kYiaIDmi/qvY9kK+yb/CDX51da+74qvAy2vz9XILutGF7gdGCzan2cJJOrk5vOTqu6CQn3A6FhkYmLKSEwB4Vs7zMwjuuyOX8Cw3Ob489PveWR8bqMz5DsPqPMEC6fpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886534; c=relaxed/simple;
	bh=n+yGXqQZXM+ah5IAApfw9jHIzXWv5Q1VokmVuz1luAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kPOnlHlVvvoGh2vq9ktEHz42S6pqlUyWWIjMacnRDyb8btz5h6qFHlOQtq43EHREjEEGeVpSA2gM+bLfLyDNxkWEoanpm8dIoHTrIL8ZF6miVTwRcRZPtOV+/X75E+a8ij/wrcDFEhaRgl0yYsuekBoDFc2e9Lel68Tm4m/XDUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S4hSJ/ce; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S4hSJ/ce"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EC51C4CEF1;
	Tue, 16 Dec 2025 12:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886534;
	bh=n+yGXqQZXM+ah5IAApfw9jHIzXWv5Q1VokmVuz1luAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S4hSJ/ceWxV1uqosFfV1jltyW1wwYAdoSbTeoswBAcwEUyPdCLYP2ir+HkYy6Hqrm
	 j/gCMfberkOeUmNNuoB4DgO6Aal3gZKIjABRLC/Ogrma8/xLxED86FahCNKqOIKeJM
	 ucBQKhUI2BJcV9Nhi0zTstqamMhELDcS9zS3QsrE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 466/507] ALSA: firewire-motu: fix buffer overflow in hwdep read for DSP events
Date: Tue, 16 Dec 2025 12:15:07 +0100
Message-ID: <20251216111402.328196267@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junrui Luo <moonafterrain@outlook.com>

[ Upstream commit 210d77cca3d0494ed30a5c628b20c1d95fa04fb1 ]

The DSP event handling code in hwdep_read() could write more bytes to
the user buffer than requested, when a user provides a buffer smaller
than the event header size (8 bytes).

Fix by using min_t() to clamp the copy size, This ensures we never copy
more than the user requested.

Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Reported-by: Junrui Luo <moonafterrain@outlook.com>
Fixes: 634ec0b2906e ("ALSA: firewire-motu: notify event for parameter change in register DSP model")
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
Link: https://patch.msgid.link/SYBPR01MB78810656377E79E58350D951AFD9A@SYBPR01MB7881.ausprd01.prod.outlook.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/firewire/motu/motu-hwdep.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/sound/firewire/motu/motu-hwdep.c b/sound/firewire/motu/motu-hwdep.c
index fa2685665db3a..e594765747d5b 100644
--- a/sound/firewire/motu/motu-hwdep.c
+++ b/sound/firewire/motu/motu-hwdep.c
@@ -83,10 +83,11 @@ static long hwdep_read(struct snd_hwdep *hwdep, char __user *buf, long count,
 		event.motu_register_dsp_change.type = SNDRV_FIREWIRE_EVENT_MOTU_REGISTER_DSP_CHANGE;
 		event.motu_register_dsp_change.count =
 			(consumed - sizeof(event.motu_register_dsp_change)) / 4;
-		if (copy_to_user(buf, &event, sizeof(event.motu_register_dsp_change)))
+		if (copy_to_user(buf, &event,
+				 min_t(long, count, sizeof(event.motu_register_dsp_change))))
 			return -EFAULT;
 
-		count = consumed;
+		count = min_t(long, count, consumed);
 	} else {
 		spin_unlock_irq(&motu->lock);
 
-- 
2.51.0



