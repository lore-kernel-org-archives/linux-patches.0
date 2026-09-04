Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4691D378838;
	Fri,  4 Sep 2026 06:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501770; cv=none; b=bPH6b3y7XYzg8eW+ymEYnFwKcJShHDaKglKQRPNA87u+DgXMFn22rG3G9czfsCXN5i1ACdADaAaKPLVCtJnhl4dO4k+975R+XY+9qOVVrxnHOV4xU8SBnhKl4xMbI+NjAsPJDWLf2+uGdimcynjxoLew3uCqNg3s9eqP3qlc8EM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501770; c=relaxed/simple;
	bh=OZm19TLwTtwtz0Nvp3eqQkBGm9Y8+q/QARrGCWHoQ0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b63HCMgSVMoyuWqNvxoDR3+g5smTgW6pxTsKQqOfhbXcfoJMZgzwHpeClC6V7VPifVBDU9RUqvWQ9BJF2QLGGgS7PotB1PXLOPh8aZL4izvP8NtX9lq07BabSnoY/eZaKy2wZnr2D7gbFnSvbSaX0c+dsc1mf3ppILPiODvZ4yU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DXUK61rY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DXUK61rY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A11F51F00A3E;
	Fri,  4 Sep 2026 06:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501769;
	bh=w4oCOMx0l7ZULFa9ATulooEa9JQCBxbRP34uTeM59DM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DXUK61rYCrnHWF0esz1uNEfmzAIOImU6iiRrMyF/Z+idxSvhBq4IOk2Y8UNuSUEa7
	 aeDFj94nUTYtHRmGgceWCiSsPtbwDbzdlSCILPQ0avx8lNLlgPML9df7AeFbSOXW3K
	 ALbV8qQMYcHPZsAd1Fw/R2UOwwMEdjhV4t5AOYvA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 489/552] ALSA: hda/ext: preserve PPLCCTL bits when clearing reset
Date: Fri,  4 Sep 2026 07:00:46 +0200
Message-ID: <20260904045801.752752566@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

From: Xu Rao <raoxu@uniontech.com>

commit 36aa66de481d29edd63cbad9b5c4dc18c340fdf6 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/core/ext/stream.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/hda/core/ext/stream.c
+++ b/sound/hda/core/ext/stream.c
@@ -211,8 +211,8 @@ void snd_hdac_ext_stream_reset(struct hd
 			break;
 		udelay(3);
 	} while (--timeout);
-	val &= ~AZX_PPLCCTL_STRST;
-	writel(val, hext_stream->pplc_addr + AZX_REG_PPLCCTL);
+	snd_hdac_updatel(hext_stream->pplc_addr, AZX_REG_PPLCCTL,
+			 AZX_PPLCCTL_STRST, 0);
 	udelay(3);
 
 	timeout = 50;


