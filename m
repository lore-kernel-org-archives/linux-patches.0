Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8223B1F7553;
	Tue,  3 Dec 2024 14:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237769; cv=none; b=PDVomP9fV9EsSK+iADT0w+PvvZbBCPFelx2NZ1dLEYlDW1BoE2Ecfmpr6bHRR/8Vkcw4LOPxG1pIc2dO2seL5NP08+gPgW7W6DaddHIdNHG6sQ/ame08q5uWMq6hwGRCCY9BKEfDsN+gQxQZQJSjJWwB+1aCbSt1NG4LPkkA7wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237769; c=relaxed/simple;
	bh=+greI4ruE70XKa9kDpTvNUPt4YUkYNJNSNfsSDS5hNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MzOLsliVYeo43b82EpzD2L8CYxhtnPuXRWGyDCdMVj/p/k9iNt5Dlim5mZH/71km6sbAD45GDMSmVLp8cXOCGHM/4wLmX9M0Z5CmR7fH8J5BkqFoeYqoZHUIdeBS2p0uHgFU1Vgx3lZ12lfy1gTpQSXko/+7qA8A2J2s2qsxdxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WO3ECW/r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WO3ECW/r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3F60C4CECF;
	Tue,  3 Dec 2024 14:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733237769;
	bh=+greI4ruE70XKa9kDpTvNUPt4YUkYNJNSNfsSDS5hNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WO3ECW/rhTagi9SB8RCdA0FpcHi5DTIuL8augVcKvKO2jofmrC9gJ+aIWqF4cVuqX
	 SuChwSaj5VjALdn7J/0uYRYSoE3N+HwwmpNk+L02BlN7MEmxRirnTbNu07d7+u3Ioq
	 P5eFEqQvNQ0YhvIMFezJINEzTMz6MYan0kcGPI54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 063/817] mips: asm: fix warning when disabling MIPS_FP_SUPPORT
Date: Tue,  3 Dec 2024 15:33:55 +0100
Message-ID: <20241203143958.145195425@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



