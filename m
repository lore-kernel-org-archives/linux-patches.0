Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8643B20969B;
	Thu, 12 Dec 2024 15:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018856; cv=none; b=X+3ljVpx7qHVgAunYcC8V3QWbcHiAdzl3250dE9wzpUZYD9j5P0GuV8PWAUkwzuFE4dihnDnJ11LE6p87byaLHqjDdfvlYsv1FDmXd3rI62kH/7+u/CiXtXFy4DuQyWdLjS1Xu/Bt/Q6AQljG043Vpn1q1cX5htfho1c9MgrNiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018856; c=relaxed/simple;
	bh=owi93kzNNlJMDZ1/X/fuS+364X15BqMHji7NixipAvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AL6pm9MZ2mjiBHSaV4uNkJIKLiYziGphLQfxMLlzCWcvS60t2bIOe/oDUG3/pTvqwGu4j1fzITU0JPfSV5rR+Xjl1aRvNu6pFIMuWp4xR3KLy4CH6PYNDW4+ufoGBnjBJw1Eo9GL6N93es9zUgLmlRXojQ5lKa7/Waxu1LwNmOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mP2nBi/z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mP2nBi/z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5BB9C4CECE;
	Thu, 12 Dec 2024 15:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018856;
	bh=owi93kzNNlJMDZ1/X/fuS+364X15BqMHji7NixipAvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mP2nBi/zn8C47IqPJ7W5onbXncpuQYKYzsqTTUJTt7/VEqsfrgrCOpKGAElLWYeJE
	 FvWA7N1AEoaK3PG+cyF9NYmfUi2xVK4Z6CjLEY/hAN4nsinIrHzf+zZL7R34aZUpYI
	 M+X7Xxqv3ZYDaDCPkb2ZErdAfodEKj9erT8oU7R8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 052/772] mips: asm: fix warning when disabling MIPS_FP_SUPPORT
Date: Thu, 12 Dec 2024 15:49:57 +0100
Message-ID: <20241212144352.097585538@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



