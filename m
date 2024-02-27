Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE21313B2B3;
	Tue, 27 Feb 2024 14:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042962; cv=none; b=W2qQ4SfY5OqnfUerm4yEgU0SPgoleFiZUmlYKz50xpnf/3ipZqnasgR9+/dMj8wP/lrYpyq6Nl86uXGT7TbXTECt8KCX2VoQ5xdRu6QvdMC/GvCM0nBAsXgiqgdbxb9jW14TQc1ExWJoh70uctySYZGH6TGGkSjWTYV3bcFuUAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042962; c=relaxed/simple;
	bh=CGECvdvkRrRbddeitHMsHeUM6/btlwZRmHl7Q6p47Z4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mMMWzM0ZOr+/P1v/dRxT9342RjbycYhFgSxoOcjd6XCktvyMcNAAB9RAfQmYmcky8WQgUGcg+6lyb4znqy6GCRK/Tdqk7w0T3U02XMxV/ygKH8xUoDtWvMsjDFmXs1eyEfV88bmgilwwb7JHkmVKh8HOEBD4kM1HWz3/HJHkpQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a0LE63MS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a0LE63MS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72B37C433F1;
	Tue, 27 Feb 2024 14:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042961;
	bh=CGECvdvkRrRbddeitHMsHeUM6/btlwZRmHl7Q6p47Z4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a0LE63MStltd/nCWhmCdaDqxvJgYTjittMbhhy1QIktztHWmaJBsAyNoHaO0Qltqd
	 skivvr/uxKtVpI6KvkcDjreTF0apOhPNqJQznTLBVNgJMsCjjU3optCEi3h9Y5cc99
	 kUG1PqtVvDcAr/S+LGYq1/lRSvwRbH9QAsm6SW2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Cercueil <paul@crapouillou.net>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Arnd Bergmann <arnd@arndb.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 155/245] PM: core: Redefine pm_ptr() macro
Date: Tue, 27 Feb 2024 14:25:43 +0100
Message-ID: <20240227131620.252855947@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Cercueil <paul@crapouillou.net>

[ Upstream commit c06ef740d401d0f4ab188882bf6f8d9cf0f75eaf ]

The pm_ptr() macro was previously conditionally defined, according to
the value of the CONFIG_PM option. This meant that the pointed structure
was either referenced (if CONFIG_PM was set), or never referenced (if
CONFIG_PM was not set), causing it to be detected as unused by the
compiler.

This worked fine, but required the __maybe_unused compiler attribute to
be used to every symbol pointed to by a pointer wrapped with pm_ptr().

We can do better. With this change, the pm_ptr() is now defined the
same, independently of the value of CONFIG_PM. It now uses the (?:)
ternary operator to conditionally resolve to its argument. Since the
condition is known at compile time, the compiler will then choose to
discard the unused symbols, which won't need to be tagged with
__maybe_unused anymore.

This pm_ptr() macro is usually used with pointers to dev_pm_ops
structures created with SIMPLE_DEV_PM_OPS() or similar macros. These do
use a __maybe_unused flag, which is now useless with this change, so it
later can be removed. However in the meantime it causes no harm, and all
the drivers still compile fine with the new pm_ptr() macro.

Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: 18ab69c8ca56 ("Input: iqs269a - do not poll during suspend or resume")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/pm.h | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/include/linux/pm.h b/include/linux/pm.h
index 1d8209c09686c..b88ac7dcf2a20 100644
--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -373,11 +373,7 @@ const struct dev_pm_ops __maybe_unused name = { \
 	SET_RUNTIME_PM_OPS(suspend_fn, resume_fn, idle_fn) \
 }
 
-#ifdef CONFIG_PM
-#define pm_ptr(_ptr) (_ptr)
-#else
-#define pm_ptr(_ptr) NULL
-#endif
+#define pm_ptr(_ptr) PTR_IF(IS_ENABLED(CONFIG_PM), (_ptr))
 
 /*
  * PM_EVENT_ messages
-- 
2.43.0



