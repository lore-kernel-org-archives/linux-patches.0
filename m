Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F22E532ABC0;
	Thu, 28 May 2026 20:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999172; cv=none; b=YzNVNPLLCFIb32tMdbhhZIqjRYhZhACWKZ1wGltl1IjWCCH5pjWAVJwwtBGlEb9m/yZVbbuzbIicvGvu1dr4EbFBp1JVkGF7g157ncBHUdygLpjh5TjP/Nl6ctdO8C8LAw0mSZ0/2BZx+rJ/WkIG9QmLpyC10eC4IbEY+odykCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999172; c=relaxed/simple;
	bh=azWJVPwOFgr1AHRM4Bo+hKt426G7QQRg2zoQUdaAz7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=acK3eOGs+1ZGTDaJRGaripPIHOoyyV649O+SiSyor8Z3xu5Ql7td2Hi7Tk/+amXTPIUR+URC+xjaIwnfrL3AJrd3Qiafw2ggdlJ+6Ve6qWPBsKp/ZESbjHHZNc/OKNeGcsac+EieA1jJsjnISRI6Wt675zuHRpzwFKKdRNwYvtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ay+/LP75; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ay+/LP75"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 534C31F000E9;
	Thu, 28 May 2026 20:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999171;
	bh=p2cH3u6xznuk5RORifVZ2kmObs+YuuiZrq8YxTIZSEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ay+/LP75F5bc0+RtxDqMViBscneC6RXf0RxxJZT7lR/oXbeCMGRkO53DfGdmu1vZF
	 jUR2SaYXA6lOa5Y62OTjA9S6EkQ9NUHal+NU2AyZxg7UHRZDBKNRM4ELS6GOY9txwY
	 ECLFxDnIv5g5kzSPc7fX8OCWAdFF1Qtm1ywk75vk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robertus Diawan Chris <robertusdchris@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 397/461] ASoC: soc-utils: Add missing va_end in snd_soc_ret()
Date: Thu, 28 May 2026 21:48:46 +0200
Message-ID: <20260528194658.960727614@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robertus Diawan Chris <robertusdchris@gmail.com>

[ Upstream commit 298a43b54432fbc3a32949a94c72544ee18c8c00 ]

The default case in snd_soc_ret() use va_start without va_end to
cleanup "args" object which can cause undefined behavior. So, add
missing va_end to cleanup "args" object.

This is reported by Coverity Scan as "Missing varargs init or cleanup".

Fixes: 943116ba2a6a ("ASoC: add common snd_soc_ret() and use it")
Signed-off-by: Robertus Diawan Chris <robertusdchris@gmail.com>
Link: https://patch.msgid.link/20260519054024.274741-1-robertusdchris@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-utils.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/soc-utils.c b/sound/soc/soc-utils.c
index c8adfff826bd4..9cb7567e263eb 100644
--- a/sound/soc/soc-utils.c
+++ b/sound/soc/soc-utils.c
@@ -36,6 +36,7 @@ int snd_soc_ret(const struct device *dev, int ret, const char *fmt, ...)
 		vaf.va = &args;
 
 		dev_err(dev, "ASoC error (%d): %pV", ret, &vaf);
+		va_end(args);
 	}
 
 	return ret;
-- 
2.53.0



