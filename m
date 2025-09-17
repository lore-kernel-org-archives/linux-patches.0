Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13C5531BC93;
	Wed, 17 Sep 2025 12:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113462; cv=none; b=YiQqNjLELQMTmd5qMzxVFsipdLkTTP8C8as2zEZZMG78SdgDkws9orsER+b9b2v5jjiCk8jmUrEmHEhXUu7vwcpu1pp2sWyZ6/1qKO6kiPSm9jqDXjXiclXuHcOKge9pGYLICRw4xHbsb0ooIKw9OlgBEJ4wK5FEbOBNkyxKomc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113462; c=relaxed/simple;
	bh=AkSfvze1deyWRlUqCHgYNMKo2/qFKrI0jzhY4YsBcFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PsIoMgvo0MB17x0nshGWpuc8qd9gtixrGf97s1TXvrzU0sabdU0vdbM7zFUxLxGJnx4qXXlkaIRfd7dupcAEVsdXyp6uC6dkPXs8DQoaXuvqLPrzzAa1Lswk7jm77vRfMsXeknMH9RGPCv8ZZZGEMOciLlEnDs+qpxcvffh0fNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vsbNEycn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vsbNEycn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8556DC4CEF0;
	Wed, 17 Sep 2025 12:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113462;
	bh=AkSfvze1deyWRlUqCHgYNMKo2/qFKrI0jzhY4YsBcFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vsbNEycn0ty7fNCbmieVF1iMdaVLRZw9b+kNEi5r7rGwOwVedvQHDja/0mgeDeRAM
	 oa1xdUFJa/cpLBrg6bMjA4N7W19OPyIeHbS/YWUxCwJfIoxRyhmxWZk9zL4vLYTjFI
	 C1BTq6ml91klB+fOrG8RX0LlxFbJZENt4Pppz7aQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damian Tometzki <damian@riscv-rocks.de>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 094/140] Disable SLUB_TINY for build testing
Date: Wed, 17 Sep 2025 14:34:26 +0200
Message-ID: <20250917123346.599146118@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123344.315037637@linuxfoundation.org>
References: <20250917123344.315037637@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 6f110a5e4f9977c31ce76fefbfef6fd4eab6bfb7 ]

... and don't error out so hard on missing module descriptions.

Before commit 6c6c1fc09de3 ("modpost: require a MODULE_DESCRIPTION()")
we used to warn about missing module descriptions, but only when
building with extra warnigns (ie 'W=1').

After that commit the warning became an unconditional hard error.

And it turns out not all modules have been converted despite the claims
to the contrary.  As reported by Damian Tometzki, the slub KUnit test
didn't have a module description, and apparently nobody ever really
noticed.

The reason nobody noticed seems to be that the slub KUnit tests get
disabled by SLUB_TINY, which also ends up disabling a lot of other code,
both in tests and in slub itself.  And so anybody doing full build tests
didn't actually see this failre.

So let's disable SLUB_TINY for build-only tests, since it clearly ends
up limiting build coverage.  Also turn the missing module descriptions
error back into a warning, but let's keep it around for non-'W=1'
builds.

Reported-by: Damian Tometzki <damian@riscv-rocks.de>
Link: https://lore.kernel.org/all/01070196099fd059-e8463438-7b1b-4ec8-816d-173874be9966-000000@eu-central-1.amazonses.com/
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Fixes: 6c6c1fc09de3 ("modpost: require a MODULE_DESCRIPTION()")
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/Kconfig b/mm/Kconfig
index 33fa51d608dc5..59c36bb9ce6b0 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -244,7 +244,7 @@ config SLUB
 
 config SLUB_TINY
 	bool "Configure for minimal memory footprint"
-	depends on EXPERT
+	depends on EXPERT && !COMPILE_TEST
 	select SLAB_MERGE_DEFAULT
 	help
 	   Configures the slab allocator in a way to achieve minimal memory
-- 
2.51.0



