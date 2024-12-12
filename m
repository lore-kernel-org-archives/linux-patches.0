Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71E2B53365;
	Thu, 12 Dec 2024 17:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023803; cv=none; b=WDpAvUnT7cJazFrYqmKLPh5Eq5H9rotF5Ckmk7NYkcod2DTRMo/R10VSMqFVYN2GqC54mN9e4tVBO7W11sjnSYuPuaRoTB5Q4t4tTNxju0IoDt+d1DMzKV+VlyGwrym5TvOZpv0W8Xy3aV0QS4xFhnYktM0yxK1Lg1vnQFIzK+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023803; c=relaxed/simple;
	bh=DtOc/qv3HiO44ndkuZ5+EFeBenv9GejD9dPICXy5LIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ko7lLd4Z2rtfOufSioPVig/TmV6Mbc3r8yVW6bhw8uSH8wDJaNrNitVVhrPDnuw6QJAXcLQwTl5Jn3DSeScEqketDf0qEKKZsj4H7HzXRikP1neLtWImwkEea2JWdOFblDT+dQ3ye5G4/neSd48IY5FFuAQXXLHdSI3Rej4HLgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VVBYyviA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VVBYyviA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8690C4CECE;
	Thu, 12 Dec 2024 17:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023803;
	bh=DtOc/qv3HiO44ndkuZ5+EFeBenv9GejD9dPICXy5LIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VVBYyviAvaYEeMyWs1MxI17y3U5QhZAHidJLbuJTh5Qt5NYuBJnNiLOOd/o7EUDwg
	 nvJF1FdYCWMQbwe13mmtdZLQLRx3tG/VbXu9nasiCVpNxbawstwW26qoJpGIw9oaZ8
	 LNmM9Mc8TBwy5mjAMmh5zGoZ2a5ZvLK+MQhD6A/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 057/459] mips: asm: fix warning when disabling MIPS_FP_SUPPORT
Date: Thu, 12 Dec 2024 15:56:35 +0100
Message-ID: <20241212144255.772308249@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



