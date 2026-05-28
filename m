Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F26C32FD7C3;
	Thu, 28 May 2026 20:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000193; cv=none; b=JAOjHGYMm3219JqC3+kjDRND5agXUxzez3QJNBewekXquHPwIUGQ3Eg4dY7alFOt2fz5FZHbljIp5JC+q3RZsLiaGxhbrfFvkvWcI43UGJmAb/dsHzWT9IIOwPc6MuoYM2CDsJ1PXW74c7uPaF+1g59a9caQK+SzBG1Cd1gqbrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000193; c=relaxed/simple;
	bh=qrMr05GEbyM6HUf+Mdk3tA/SQgyqXDbDtasfJ4cc1rc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FAspghViSwkwk3nW4sxE/1oLd3/2HjBPUPDiyv0SDcNTTPOnLDzbH5F9EOmn3GIBOoGuNEvj2UQqGcC/h51PFVdG5QqPZuijEla65cW6wOG6lJJUTCXAVQTMs93vCxXdxWpeoBY0M2VNnUY/s133/oX6lHZEBHjuIGWBk5auHe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G9UsW5v2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G9UsW5v2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BEA71F000E9;
	Thu, 28 May 2026 20:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000192;
	bh=C9ILqQd1GlieVAUkDoPD8sXSOxGi0kxRX/51glL2KgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G9UsW5v2b7PXRF9LuLTSNNL5J0mKBJkOXTFOe8aw9uo7TN8+YebP4TCxOVIM/pGaK
	 JoadxjbUZeC29FisD81zn7Tom2fS3VDAkcbZBYQ5Afjx8WXBbYDbGG8FXArwDI9X+0
	 GGXuIM/HzeqbxnG7AYGHnzFBqW6qdcScBZIUesLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robertus Diawan Chris <robertusdchris@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 335/377] ASoC: soc-utils: Add missing va_end in snd_soc_ret()
Date: Thu, 28 May 2026 21:49:33 +0200
Message-ID: <20260528194648.116709134@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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



