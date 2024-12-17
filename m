Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3287142E77;
	Tue, 17 Dec 2024 17:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456209; cv=none; b=Pxf69yPAEQwVW9hqphnvR/W2wm0qq3ufeSTfuqC7r9oJFX+h5Pqv9RKpAAyV3qVCCh37/7G96T13y/JKmCdeAOMB6O3vwZgOOMxKmlZpyt0C+Gt0MXnVQrNyVk36/a/tggapMu+45seueFEvISfreOXddiLAdvm+Bei+V1XTsyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456209; c=relaxed/simple;
	bh=Js9aHD8CwdfhY25GF6JUHtKE0gtm+DvjZLw6y7B3ql0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OpMuki9aq4oY+nARjyEBPSOS2Bytv+E8nJDt5rA88DBbo7lIbdZiRJnCQvnpqc+IEwAkizQgobst4TwtzEDwAIjhDpE8yFdp5iMyhI36gQ1SL2VpikCHnrfDq6w2xvyaK4p2iGC+cBrwQF79eFax+LcA3HjA+mtFynOhRYyFDXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JFnOBFTX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JFnOBFTX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26928C4CED3;
	Tue, 17 Dec 2024 17:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456208;
	bh=Js9aHD8CwdfhY25GF6JUHtKE0gtm+DvjZLw6y7B3ql0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JFnOBFTXB1QngMgzPJcot2AQY970A1ecfe2CudXWjRhvmtDBX0a+/KZ0uxC49zza9
	 t5SgwY1i6JYx6Y2TA9RA8mhgY3j18TvdqV+FCtN0s+rysgwxkIrErYmvsaxLximjDE
	 0vWIiMrIRnGqmvJzzI4jIRWr4aYZDG7PkCBlTOqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Laight <david.laight@aculab.com>,
	Linux Kernel Functional Testing <lkft@linaro.org>,
	kernel test robot <lkp@intel.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 093/109] blk-iocost: Avoid using clamp() on inuse in __propagate_weights()
Date: Tue, 17 Dec 2024 18:08:17 +0100
Message-ID: <20241217170537.276060261@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170533.329523616@linuxfoundation.org>
References: <20241217170533.329523616@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit 57e420c84f9ab55ba4c5e2ae9c5f6c8e1ea834d2 ]

After a recent change to clamp() and its variants [1] that increases the
coverage of the check that high is greater than low because it can be
done through inlining, certain build configurations (such as s390
defconfig) fail to build with clang with:

  block/blk-iocost.c:1101:11: error: call to '__compiletime_assert_557' declared with 'error' attribute: clamp() low limit 1 greater than high limit active
   1101 |                 inuse = clamp_t(u32, inuse, 1, active);
        |                         ^
  include/linux/minmax.h:218:36: note: expanded from macro 'clamp_t'
    218 | #define clamp_t(type, val, lo, hi) __careful_clamp(type, val, lo, hi)
        |                                    ^
  include/linux/minmax.h:195:2: note: expanded from macro '__careful_clamp'
    195 |         __clamp_once(type, val, lo, hi, __UNIQUE_ID(v_), __UNIQUE_ID(l_), __UNIQUE_ID(h_))
        |         ^
  include/linux/minmax.h:188:2: note: expanded from macro '__clamp_once'
    188 |         BUILD_BUG_ON_MSG(statically_true(ulo > uhi),                            \
        |         ^

__propagate_weights() is called with an active value of zero in
ioc_check_iocgs(), which results in the high value being less than the
low value, which is undefined because the value returned depends on the
order of the comparisons.

The purpose of this expression is to ensure inuse is not more than
active and at least 1. This could be written more simply with a ternary
expression that uses min(inuse, active) as the condition so that the
value of that condition can be used if it is not zero and one if it is.
Do this conversion to resolve the error and add a comment to deter
people from turning this back into clamp().

Fixes: 7caa47151ab2 ("blkcg: implement blk-iocost")
Link: https://lore.kernel.org/r/34d53778977747f19cce2abb287bb3e6@AcuMS.aculab.com/ [1]
Suggested-by: David Laight <david.laight@aculab.com>
Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
Closes: https://lore.kernel.org/llvm/CA+G9fYsD7mw13wredcZn0L-KBA3yeoVSTuxnss-AEWMN3ha0cA@mail.gmail.com/
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202412120322.3GfVe3vF-lkp@intel.com/
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-iocost.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index c3cb9c20b306..129732a8d0dd 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -1098,7 +1098,14 @@ static void __propagate_weights(struct ioc_gq *iocg, u32 active, u32 inuse,
 		inuse = DIV64_U64_ROUND_UP(active * iocg->child_inuse_sum,
 					   iocg->child_active_sum);
 	} else {
-		inuse = clamp_t(u32, inuse, 1, active);
+		/*
+		 * It may be tempting to turn this into a clamp expression with
+		 * a lower limit of 1 but active may be 0, which cannot be used
+		 * as an upper limit in that situation. This expression allows
+		 * active to clamp inuse unless it is 0, in which case inuse
+		 * becomes 1.
+		 */
+		inuse = min(inuse, active) ?: 1;
 	}
 
 	iocg->last_inuse = iocg->inuse;
-- 
2.39.5



