Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 098F64CCDC7;
	Fri,  4 Sep 2026 05:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500190; cv=none; b=qcXSU2PYqO9QXDnv7p2BAqNhzUxOt3xVbuSH8Qc/Pgoa1Eaq4FN1x+2dMwAPYefYqLLhoyJko6XhC8tEw2+I26sSLUm3GJyghmIMqRZHn9MwSX8LampA5yNN6lu2Xg8BDjEQqwOVonDrLxftZnsKmUOgXHfg1N4O/g8JwBsHPzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500190; c=relaxed/simple;
	bh=HYkOb0qytLfaCDa6zNuZIv8OmwusXr44onG0+T2btUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fwclL5CNH8X5CMDdCmlpHn14N/golHcySTHDcBCVzrVG01Yx22kJxdar1hQmHm6RmtFhpXCGB8r9tvXqUPLTtyW/LVXLPprLP+5FJjvrwPodyffKuriHpfeT1y3DYgCNr6wWsXMXT9DxE8WDTb3FfGvcroy8m6zKMUwauAazsP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J3tVqwEw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J3tVqwEw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62EF81F00A3D;
	Fri,  4 Sep 2026 05:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500188;
	bh=8uNTDcDsWN0Lbkq19lSXQfMAU4+0EVWF1FVimW2OvCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J3tVqwEwJwGGNyge8cYnMjHudPtbcR+4ReZW8GlhpTJeW50XDNoFuX3QLSolQpQR0
	 Yp/Yzru79QLL2MnyzU1K5px959yJOHD0mERWcyyy2LerJAOM9Cso5CtzySLKOKTCLR
	 q7PPvy5KzSm2HCv1Hl5/RQgUsyO0NZydaGIsfURk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.2 639/713] ALSA: hda/ext: preserve PPLCCTL bits when clearing reset
Date: Fri,  4 Sep 2026 07:00:07 +0200
Message-ID: <20260904045818.153832544@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -210,8 +210,8 @@ void snd_hdac_ext_stream_reset(struct hd
 			break;
 		udelay(3);
 	} while (--timeout);
-	val &= ~AZX_PPLCCTL_STRST;
-	writel(val, hext_stream->pplc_addr + AZX_REG_PPLCCTL);
+	snd_hdac_updatel(hext_stream->pplc_addr, AZX_REG_PPLCCTL,
+			 AZX_PPLCCTL_STRST, 0);
 	udelay(3);
 
 	timeout = 50;


