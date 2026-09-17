Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2582B4E0B7E;
	Thu, 17 Sep 2026 18:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668100; cv=none; b=C9xLxa5lraRCRGjeXQns1TKO2g/aoFQag6hjeGvsGmwKt1oLCiwEw60368Te2Sa9fal+juyT5VJCYnvf3Hk2mkvlSfewUCbHViNivNB6y6oSoJ6tyUlB0phG76cPcR57Bv7X5LaW2aDolTFecqfnbT23c6lc1Kq10gtewJyo+ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668100; c=relaxed/simple;
	bh=a3smZK5Cic9l73XGe4nTrht8qqVdfqs7ULuYDzHe8hA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XXBZT+Ah+CQVIhI+RgYVTCydqZYcc9Qs/bBsShLK/VC0n/qhIOhiWBNi7AknR9kYl9JWij28UCPuxHgVIakzIk2x9DV/UbH8yhujBQeI5M2LtEGAiiHeUAMIbr/N19NirP3v3KQFlxMe5fk/whxsI5kp0BRk4NlSRF3JZAXYdco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Oqnnq1x1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oqnnq1x1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CBCC1F000FF;
	Thu, 17 Sep 2026 18:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668099;
	bh=lMXojB3ucYSFYOP9Rnm1f6iF37Rklcgg1qcGBl8uGBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Oqnnq1x1R74AYDGSKh2svm/9VCTE6JWOZLEDhzNQZ11cj9q7eBmcJRsmtDD/5kY5G
	 e2qgvNOreADtgtGeRclLgDZSVVWC6N3nauntUgf8BBnHsrDKUjUBcleC44wJVFWDgD
	 21eyWk+zhF19mhcsS44cr/C+rX/t2JFlCRyVGWo8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Andreas Larsson <andreas@gaisler.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0312/1102] sparc: Disable compat support with LLD
Date: Thu, 17 Sep 2026 16:04:15 +0100
Message-ID: <20260917151547.455610135@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 852fed2e8bfe195351fb0078ba7245d41154e7a5 ]

An LLVM=1 sparc64 allmodconfig enables COMPAT and then tries to
build the 32-bit vDSO. That path cannot be linked with ld.lld:

  ld.lld: error: unknown emulation: elf32_sparc

ld.lld does not support the 32-bit SPARC ELF emulation used for
the compat vDSO, so keep COMPAT disabled when LLD is the linker.
This avoids selecting an unsupported build path while leaving the
existing GNU ld configuration unchanged.

Assisted-by: Codex:GPT-5.5
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Acked-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Andreas Larsson <andreas@gaisler.com>
Link: https://lore.kernel.org/r/20260508000834.834824-1-rosenp@gmail.com
Signed-off-by: Andreas Larsson <andreas@gaisler.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sparc/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index dcfdb7f1dae97..24e6e5bd45910 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -486,6 +486,7 @@ endmenu
 config COMPAT
 	bool
 	depends on SPARC64
+	depends on !LD_IS_LLD
 	default y
 	select HAVE_UID16
 	select ARCH_WANT_OLD_COMPAT_IPC
-- 
2.53.0



