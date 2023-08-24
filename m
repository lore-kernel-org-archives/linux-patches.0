Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C08C288EC
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 14:51:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F7D4C433C7;
	Thu, 24 Aug 2023 14:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692888702;
	bh=l9TXvh63oZNnvBOy59ADhd5nUHUpAaJRUqFTbwqzZBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sf3y0kocff82tnksUKBAQ9/onjaMiG3wlJlWzRoNRe3Sq7mtD+Y/Na7RhOR5i9Doj
	 1CV7VklmZsQcnbmezmcNhXOEBxw0DoUQ84EITLPqmuGv7cBm1OmJv9IOK6i50znvfi
	 lBPE+aF2qmj5dGNIxcQgs4+CXhQrTvKPJQpxb9g8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Tony Lindgren <tony@atomide.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 011/139] iopoll: Call cpu_relax() in busy loops
Date: Thu, 24 Aug 2023 16:48:54 +0200
Message-ID: <20230824145024.078785670@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230824145023.559380953@linuxfoundation.org>
References: <20230824145023.559380953@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit b407460ee99033503993ac7437d593451fcdfe44 ]

It is considered good practice to call cpu_relax() in busy loops, see
Documentation/process/volatile-considered-harmful.rst.  This can not
only lower CPU power consumption or yield to a hyperthreaded twin
processor, but also allows an architecture to mitigate hardware issues
(e.g. ARM Erratum 754327 for Cortex-A9 prior to r2p0) in the
architecture-specific cpu_relax() implementation.

In addition, cpu_relax() is also a compiler barrier.  It is not
immediately obvious that the @op argument "function" will result in an
actual function call (e.g. in case of inlining).

Where a function call is a C sequence point, this is lost on inlining.
Therefore, with agressive enough optimization it might be possible for
the compiler to hoist the:

        (val) = op(args);

"load" out of the loop because it doesn't see the value changing. The
addition of cpu_relax() would inhibit this.

As the iopoll helpers lack calls to cpu_relax(), people are sometimes
reluctant to use them, and may fall back to open-coded polling loops
(including cpu_relax() calls) instead.

Fix this by adding calls to cpu_relax() to the iopoll helpers:
  - For the non-atomic case, it is sufficient to call cpu_relax() in
    case of a zero sleep-between-reads value, as a call to
    usleep_range() is a safe barrier otherwise.  However, it doesn't
    hurt to add the call regardless, for simplicity, and for similarity
    with the atomic case below.
  - For the atomic case, cpu_relax() must be called regardless of the
    sleep-between-reads value, as there is no guarantee all
    architecture-specific implementations of udelay() handle this.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Tony Lindgren <tony@atomide.com>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Link: https://lore.kernel.org/r/45c87bec3397fdd704376807f0eec5cc71be440f.1685692810.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/iopoll.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/iopoll.h b/include/linux/iopoll.h
index 2c8860e406bd8..0417360a6db9b 100644
--- a/include/linux/iopoll.h
+++ b/include/linux/iopoll.h
@@ -53,6 +53,7 @@
 		} \
 		if (__sleep_us) \
 			usleep_range((__sleep_us >> 2) + 1, __sleep_us); \
+		cpu_relax(); \
 	} \
 	(cond) ? 0 : -ETIMEDOUT; \
 })
@@ -95,6 +96,7 @@
 		} \
 		if (__delay_us) \
 			udelay(__delay_us); \
+		cpu_relax(); \
 	} \
 	(cond) ? 0 : -ETIMEDOUT; \
 })
-- 
2.40.1



