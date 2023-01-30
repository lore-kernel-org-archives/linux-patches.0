Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E711D28EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:15:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ED4AC433EF;
	Mon, 30 Jan 2023 14:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675088101;
	bh=PiQIi1sGWYNyhdFwLS8tLrQSCzg4TBXd2U/CVxrfxjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eSa3rLhVsOhY2s52waTbcvXuxi2vXCspn4fEyAO1xGf6VyfKPUedRhSu5Ya6Hr4zs
	 KkT3iMsexFuce3QXmegpWulk3Q/JlnwOloWG5KLEtRqV82grOoGNUhcwVoI2uIZgw6
	 SvIux2kcAePnjrQ4RfAbUvhfk5zYNIJ4Jx1cfrX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mateusz Guzik <mjguzik@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>,
	Tony Luck <tony.luck@intel.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 5.15 116/204] lockref: stop doing cpu_relax in the cmpxchg loop
Date: Mon, 30 Jan 2023 14:51:21 +0100
Message-Id: <20230130134321.567176074@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mateusz Guzik <mjguzik@gmail.com>

[ Upstream commit f5fe24ef17b5fbe6db49534163e77499fb10ae8c ]

On the x86-64 architecture even a failing cmpxchg grants exclusive
access to the cacheline, making it preferable to retry the failed op
immediately instead of stalling with the pause instruction.

To illustrate the impact, below are benchmark results obtained by
running various will-it-scale tests on top of the 6.2-rc3 kernel and
Cascade Lake (2 sockets * 24 cores * 2 threads) CPU.

All results in ops/s.  Note there is some variance in re-runs, but the
code is consistently faster when contention is present.

  open3 ("Same file open/close"):
  proc          stock       no-pause
     1         805603         814942       (+%1)
     2        1054980        1054781       (-0%)
     8        1544802        1822858      (+18%)
    24        1191064        2199665      (+84%)
    48         851582        1469860      (+72%)
    96         609481        1427170     (+134%)

  fstat2 ("Same file fstat"):
  proc          stock       no-pause
     1        3013872        3047636       (+1%)
     2        4284687        4400421       (+2%)
     8        3257721        5530156      (+69%)
    24        2239819        5466127     (+144%)
    48        1701072        5256609     (+209%)
    96        1269157        6649326     (+423%)

Additionally, a kernel with a private patch to help access() scalability:
access2 ("Same file access"):

  proc          stock        patched      patched
                                         +nopause
    24        2378041        2005501      5370335  (-15% / +125%)

That is, fixing the problems in access itself *reduces* scalability
after the cacheline ping-pong only happens in lockref with the pause
instruction.

Note that fstat and access benchmarks are not currently integrated into
will-it-scale, but interested parties can find them in pull requests to
said project.

Code at hand has a rather tortured history.  First modification showed
up in commit d472d9d98b46 ("lockref: Relax in cmpxchg loop"), written
with Itanium in mind.  Later it got patched up to use an arch-dependent
macro to stop doing it on s390 where it caused a significant regression.
Said macro had undergone revisions and was ultimately eliminated later,
going back to cpu_relax.

While I intended to only remove cpu_relax for x86-64, I got the
following comment from Linus:

    I would actually prefer just removing it entirely and see if
    somebody else hollers. You have the numbers to prove it hurts on
    real hardware, and I don't think we have any numbers to the
    contrary.

    So I think it's better to trust the numbers and remove it as a
    failure, than say "let's just remove it on x86-64 and leave
    everybody else with the potentially broken code"

Additionally, Will Deacon (maintainer of the arm64 port, one of the
architectures previously benchmarked):

    So, from the arm64 side of the fence, I'm perfectly happy just
    removing the cpu_relax() calls from lockref.

As such, come back full circle in history and whack it altogether.

Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
Link: https://lore.kernel.org/all/CAGudoHHx0Nqg6DE70zAVA75eV-HXfWyhVMWZ-aSeOofkA_=WdA@mail.gmail.com/
Acked-by: Tony Luck <tony.luck@intel.com> # ia64
Acked-by: Nicholas Piggin <npiggin@gmail.com> # powerpc
Acked-by: Will Deacon <will@kernel.org> # arm64
Acked-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/lockref.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/lib/lockref.c b/lib/lockref.c
index 5b34bbd3eba8..81ac5f355242 100644
--- a/lib/lockref.c
+++ b/lib/lockref.c
@@ -24,7 +24,6 @@
 		}								\
 		if (!--retry)							\
 			break;							\
-		cpu_relax();							\
 	}									\
 } while (0)
 
-- 
2.39.0



