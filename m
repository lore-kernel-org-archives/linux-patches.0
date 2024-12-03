Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E1A51FAC53;
	Tue,  3 Dec 2024 15:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240085; cv=none; b=q6WZvcQ2JoP8LB8xQ23C904slyTlAdQDR5/dTeXDBFVVqI18Yd3VwmSmRhMHKAo7ODHoKejIfxqyGU4/uyMjP/G8xEHwsQtqYeSt62BZQD+HgRMuBzE+MDhOa7rw5XtOw6WaKuFMTMtl/UeXytY+1hcMc+O9qH27xgwXZPHbsKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240085; c=relaxed/simple;
	bh=UHT1Dqjpfpe6iXKH3DGfu4Kh9GCImnBl/Bf25RdFuq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eh+BglC9GfabOpQSJO1aUIxZF8cPhTBbENmEWYdx4IIKTbbZxTAl4aYqB/r8BSknR6FEqOfhZ8pHaTRZKkyCaQuKtgqVN7l9iuPwOzga9SyFh8PEp9kFKRgUoUAizC25wTgzVnvHI2fa9TD0JbzSC2FxmtGO8799z54XrlimmN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P6e3loYr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P6e3loYr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6070C4CECF;
	Tue,  3 Dec 2024 15:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240085;
	bh=UHT1Dqjpfpe6iXKH3DGfu4Kh9GCImnBl/Bf25RdFuq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P6e3loYrR6s0VhRbW6AjMFMOEn8+D3JgPWwG7N2W1kIrwXPO0wHwKTfnLzvf8OIZC
	 Fixz4o+n3idBwSnTgteuKuCkIjmvwOTaejBa0brlbFRecOf49ej3V9IWkzjZUe9jbz
	 cQm5bH7SnLp1f0aFEPynq3gXdpNl6Lc3TYvtizfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 018/826] mips: asm: fix warning when disabling MIPS_FP_SUPPORT
Date: Tue,  3 Dec 2024 15:35:45 +0100
Message-ID: <20241203144744.168314003@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Gorski <jonas.gorski@gmail.com>

[ Upstream commit da09935975c8f8c90d6f57be2422dee5557206cd ]

When MIPS_FP_SUPPORT is disabled, __sanitize_fcr31() is defined as
nothing, which triggers a gcc warning:

    In file included from kernel/sched/core.c:79:
    kernel/sched/core.c: In function 'context_switch':
    ./arch/mips/include/asm/switch_to.h:114:39: warning: suggest braces around empty body in an 'if' statement [-Wempty-body]
      114 |                 __sanitize_fcr31(next);                                 \
          |                                       ^
    kernel/sched/core.c:5316:9: note: in expansion of macro 'switch_to'
     5316 |         switch_to(prev, next, prev);
          |         ^~~~~~~~~

Fix this by providing an empty body for __sanitize_fcr31() like one is
defined for __mips_mt_fpaff_switch_to().

Fixes: 36a498035bd2 ("MIPS: Avoid FCSR sanitization when CONFIG_MIPS_FP_SUPPORT=n")
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Reviewed-by: Maciej W. Rozycki <macro@orcam.me.uk>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/include/asm/switch_to.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/include/asm/switch_to.h b/arch/mips/include/asm/switch_to.h
index a4374b4cb88fd..d6ccd53440213 100644
--- a/arch/mips/include/asm/switch_to.h
+++ b/arch/mips/include/asm/switch_to.h
@@ -97,7 +97,7 @@ do {									\
 	}								\
 } while (0)
 #else
-# define __sanitize_fcr31(next)
+# define __sanitize_fcr31(next) do { (void) (next); } while (0)
 #endif
 
 /*
-- 
2.43.0



