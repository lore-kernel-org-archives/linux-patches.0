Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8670F46C4CC;
	Wed, 30 Sep 2026 17:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789787; cv=none; b=izsAcuzUxP5xU6OEFxbG7ITZZMRSfyoreMYr42yuWPnnCEx1egdwQ6JNp9tk8Wct5o8tUkYm5iDkP9CDnzx0OpIA1mKyBNJk9PhyQ5E0W42pknWVm9VqSt3c2LS7OAD/eN2Z9QL6FUGOr3m6j2VPwE/kAaeRMhOckJWiCOr2n+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789787; c=relaxed/simple;
	bh=5PzCX9lkgnrN/Qm4Jwai/ZUrpHlIqORqdkT5tHYuxC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m/kZkJLUR3RKRrbPMh1a06ykO8rvFSK+pH767Kt0xezBhP569P/BkdpgCTD3n3mDk9HlwB7XrVnkLcWIXMQdXdFkVBkXbN/getRK9t8ELeytPR0wJWOasIlireVpMbnPYBNJUCRsrS7XTkUeDkPgj/1C+nhJMKBtB8ClWFtDDow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WL4EGXys; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WL4EGXys"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C814C1F000FF;
	Wed, 30 Sep 2026 17:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789786;
	bh=8LfSIt1i6C3cKpWFrfD7LqopZTFp39P4jhuRCWzZc6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WL4EGXyss3nqRgGbcOz2+FSTxnjecJWptwbqJAwCFhK89ij4bac0pwcD1T4Pk7m0L
	 0DdG2wWkPpjY42K6taHIGgbLl6T5lMEcHjLa2kNIT8jesFQDod0ftJ0aWaQmOAK7TO
	 wPU/vsZt47Jx/qq6irI6LfxeYEbY3fiBZ1PFJExA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 601/877] ALSA: hda/ext: preserve PPLCCTL bits when clearing reset
Date: Wed, 30 Sep 2026 17:25:12 +0200
Message-ID: <20260930152427.626662700@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Rao <raoxu@uniontech.com>

[ Upstream commit 36aa66de481d29edd63cbad9b5c4dc18c340fdf6 ]

snd_hdac_ext_stream_reset() polls PPLCCTL for STRST by masking the
register value with AZX_PPLCCTL_STRST:

	val = readl(...) & AZX_PPLCCTL_STRST;

The same masked value is then used when clearing STRST. Since val
contains no bits other than STRST, clearing STRST from it always
produces zero. The subsequent writel() therefore writes zero to the
entire PPLCCTL register instead of clearing only the reset bit.

PPLCCTL contains other stream control fields, including the stream tag
in AZX_PPLCCTL_STRM_MASK. Those fields must not be modified as a side
effect of clearing stream reset.

Use snd_hdac_updatel() to clear STRST, matching the existing set-reset
path and preserving all unrelated PPLCCTL bits.

Fixes: df203a4e46f4 ("ALSA: hdac_ext: add extended stream capabilities")
Cc: stable@vger.kernel.org
Signed-off-by: Xu Rao <raoxu@uniontech.com>
Link: https://patch.msgid.link/43BB7930B0F07C09+20260813065524.1955696-1-raoxu@uniontech.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/ext/hdac_ext_stream.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/hda/ext/hdac_ext_stream.c
+++ b/sound/hda/ext/hdac_ext_stream.c
@@ -212,8 +212,8 @@ void snd_hdac_ext_stream_reset(struct hd
 			break;
 		udelay(3);
 	} while (--timeout);
-	val &= ~AZX_PPLCCTL_STRST;
-	writel(val, hext_stream->pplc_addr + AZX_REG_PPLCCTL);
+	snd_hdac_updatel(hext_stream->pplc_addr, AZX_REG_PPLCCTL,
+			 AZX_PPLCCTL_STRST, 0);
 	udelay(3);
 
 	timeout = 50;


