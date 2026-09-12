Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 301712BDC0E;
	Sat, 12 Sep 2026 11:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212396; cv=none; b=ImRSnPLDawk9Su173WdCmerME1flqYESuUCFLBQVilv2acFFTmgcY+8jSxJVxGY0C8UVP9IB/KciR3C662p2shGaemypLlWJAycvBnlx6hurMSRtm7ODtMwksrbfEv+UHlmCy5gR1UYYQUm4+Je2OOm7jEAqwNs0nOynNRiGqSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212396; c=relaxed/simple;
	bh=Wd4+1jH0TH4BeKyAqAQXmiEdQLQ00gcREGp77gH3Nwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jivvaecjLRRiJ5kFAcDwaDwGq1idox/uARYSzf1CMTy2/z22n4DmwU4QcX9IVYHM+Ady+tIiHJL8CeLRMaig70Jg17k4o28yomjE3Aq2Rqw8Ij6uY0ht0AWSVuQNZTryPlBv+UFeMpF+CAwGUqB8GXChJbOWNg7welF0BX/8m3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fRkqwm/I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fRkqwm/I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B46E1F000FF;
	Sat, 12 Sep 2026 11:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212391;
	bh=+DWQ5thKL7a0TfxBshQ/7jTIdtpfdtNlVJmSw0DFqrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fRkqwm/I+mgjTwSqKRrmkga8Nse/sjnmWEyXXaHcL6JKZNIMYK7nMm+QX3aytr6kq
	 9dZKmQf4dB7R1B3bcZdk39TTZ67ziS6X8PEKURkjKrP6khouSQFG4g7c6LZmSMLyVa
	 zk2TsOzu7Idy/RkUFY8aeIeYSfS4ewDUEKhasWtI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Guenter Roeck <linux@roeck-us.net>,
	Chao Yu <chao@kernel.org>,
	Gao Xiang <xiang@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1384/1518] erofs: Fix EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS default logic
Date: Sat, 12 Sep 2026 08:59:13 +0200
Message-ID: <20260912065654.856255386@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit ab74edaeb1ae7c7194e79007e6afdfe788111a3f ]

When NR_CPUS is less than 16, or when SMP is disabled, the default value
of 16 is invalid.

While actual configuration picks up a sensible and valid default
(NR_CPUS or 1), "make savedefconfig" will still write a line like

    CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS=1

to the defconfig file, even if that matches the sensible default.

Avoid needlessly enlarging the defconfig files, and reduce churn for
updating them, by specifying valid defaults depending on SMP and
NR_CPUS.

While at it, make the prompt depend on SMP, as there is no point in
asking the user about the maximum number of decompression streams if
there is only one valid answer.

Fixes: c9b47e6b23114e93 ("erofs: cap LZMA stream pool size")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Gao Xiang <xiang@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/Kconfig | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/erofs/Kconfig b/fs/erofs/Kconfig
index 0be8a38cfb119..473a22167c154 100644
--- a/fs/erofs/Kconfig
+++ b/fs/erofs/Kconfig
@@ -121,11 +121,13 @@ config EROFS_FS_ZIP_LZMA
 	  If unsure, say N.
 
 config EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS
-	int "EROFS LZMA default maximum decompression streams"
+	int "EROFS LZMA default maximum decompression streams" if SMP
 	depends on EROFS_FS_ZIP_LZMA
 	range 1 NR_CPUS if SMP
 	range 1 1 if !SMP
-	default 16
+	default 16 if SMP && NR_CPUS >= 16
+	default NR_CPUS if SMP
+	default 1
 	help
 	  By default EROFS allocates one LZMA decompression stream per CPU.
 	  Each stream can hold a dictionary of up to 8 MiB taken from the
@@ -133,7 +135,7 @@ config EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS
 	  of memory.  This caps the default; the lzma_streams module parameter
 	  still overrides it.
 
-	  If unsure, keep the default of 16.
+	  If unsure, keep the suggested default (16 or lower).
 
 config EROFS_FS_ZIP_DEFLATE
 	bool "EROFS DEFLATE compressed data support"
-- 
2.53.0



