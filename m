Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17D363D565F;
	Fri,  9 Oct 2026 14:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555881; cv=none; b=CUP0Efrhg428MuXF4loBRHykcZar96GLl8jSySMU7XOG6eNULuCf0dOZFe+Vdku+/oHB/TWNddGoeQCRck1tjNvrXTfxVTnzxnw9fgaujEFb25XJCu4LTWIaFN1Q4gtygutXaoujbzq1jPNgjyBs0c3VVDmhg+vtMgDkwPYqLcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555881; c=relaxed/simple;
	bh=DdXl4g1xOMKN9xdXKDjZv4xdD3Z7/eG0kjmqZCdY7LQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dDGb11MiFQesFVdgtT6aG65jzL0hBd+pGB0rTSqLOQgO2xVEUlANjsK/sOdLcZnqN7PPFXqL1UuJ26SvUOKf8QLp+LJLoZr4B65gw8BldfFIC0mWCI+d4THj6CNFCyzY9M9wQcSMeoT08i7M52Ptv53lTmyBmT3jtu9n+mcxNjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jee96RXr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jee96RXr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 747D41F000FF;
	Fri,  9 Oct 2026 14:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555880;
	bh=/s3q5bj75u7LYzFETNW4ss0SBvArXMJ6bVqfiOWWJ4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jee96RXr9PxxgtJH2Mkglalhnw5ExtRM/9xaDoz167hUDiPcBB8OojQbCXhR5vDkS
	 0Li3ZLXq2ysjga7kEMymzm/Vlnd4VybEjs9u1LAUAOdIeVOPS073HX2bWCGWd20Xwo
	 E3/3a0hJ86V6+K1CXwXfI8qaEJIaepeK4vlmFVdY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 133/403] ALSA: core: Define auto-cleanup for snd_card_free()
Date: Fri,  9 Oct 2026 16:08:14 +0200
Message-ID: <20261009140955.185603587@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit f1d565dc92955f05383794e0fa27e61ee0555027 ]

For the errors at the probe time, we'd need to call rather
snd_card_free() instead of the snd_card_unref() -- the former calls
explicitly snd_card_disconnect() that cleans up the registered
devices, etc, while the latter may leak in corner cases.

For convenience, define a new auto-clean with snd_card_free.

Link: https://patch.msgid.link/20261001151039.592033-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: e6229c0402ea ("ALSA: ice1712: Fix the error handling via auto-cleanup at probe")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/core.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/sound/core.h b/include/sound/core.h
index 618055761fe01..0b7148b0d9d75 100644
--- a/include/sound/core.h
+++ b/include/sound/core.h
@@ -316,6 +316,15 @@ static inline void snd_card_unref(struct snd_card *card)
 
 DEFINE_FREE(snd_card_unref, struct snd_card *, if (_T) snd_card_unref(_T))
 
+/*
+ * For automatic error handling at probe time, assign the card like:
+ *	struct snd_card *card __free(snd_card_free) = NULL;
+ * then create and process as usual.
+ * But, don't forget to clear to NULL at successful return for avoiding
+ * the unexpected cleanup!
+ */
+DEFINE_FREE(snd_card_free, struct snd_card *, if (_T) snd_card_free(_T))
+
 #define snd_card_set_dev(card, devptr) ((card)->dev = (devptr))
 
 /* device.c */
-- 
2.53.0



