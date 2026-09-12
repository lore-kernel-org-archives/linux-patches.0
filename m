Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 590183A2E00;
	Sat, 12 Sep 2026 20:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243394; cv=none; b=pGWs+d9aoHd0U7SHXDlVolh2tnf2RO2zZElNxyqxznRrqABzdupjXC9/bMbXnrdXVHLUNxoD1JG4Kfz66y0gAVsHhbrrBXJZJ5EcG/2ZSvXinS7PhnkN7ioKG+ifLJinrq8w0SoyvQ1BZnd4Agatg+mlwUsV5iZu1PGy0nyr1zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243394; c=relaxed/simple;
	bh=QQer3Q/cDGBR+gu5IWV3V6Jzl+frvPeS0fiGnX1CXH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K4EtsvIRK3ABdvKx2ScsYIIOGcWDxlcFvXyYsjJ2rXxVqjRTvko585UfMVCTDhWSJk8BEzgldDxJj+d77cTYegG8fMIYqKEw5sf4sejCbkZDoSutxFRaZ/4COxL3xB0zw7xsjAPE2Gx0LNBPxDQH4RDlbn/zO74aJWRdPudad+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q8vbJUZV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q8vbJUZV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B79361F000FF;
	Sat, 12 Sep 2026 20:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243393;
	bh=G1d1CoAUH++e2StgTsEFLwBWziXRMomVkjYMT/T+qEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q8vbJUZVmwSwr60Iri9BhgvRgJdjR1X/OUohBG+wJqXrMHJ0x1aKNTbYnVjdAulkm
	 /DJL9zkdYjLZMnvTLEutICqrn1fNNxXmnn25wpKFsrJvr9aQB7aLEgLV9HE6jILvmX
	 KD12w252/nuU8oVGrXu14BVWOIdqJNxH/131ETlA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bradley Morgan <include@grrlz.net>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Cyrill Gorcuno <gorcunov@openvz.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 738/798] prctl: fix PR_SET_MM_AUXV losing the forced AT_NULL terminator
Date: Sat, 12 Sep 2026 09:06:06 +0200
Message-ID: <20260912065533.990969227@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bradley Morgan <include@grrlz.net>

[ Upstream commit 5146e0688d86f0654263e4b0e4ff1719b4072f16 ]

prctl_set_auxv() copies the user vector into a stack buffer, forces
AT_NULL on the last two entries there, and then copies only len bytes into
mm->saved_auxv.  Which is fine until the vector is shorter than the
buffer, because then the forced terminator sits past the end of the copy
and never lands in saved_auxv at all.

The code even says

	/* Make sure the last entry is always AT_NULL */

and it does, just not in the part that gets copied.

So mm->saved_auxv keeps the stale tail from exec.  Reproducing it is easy:
from a process with CAP_SYS_RESOURCE (just run it as root), call
prctl(PR_SET_MM, PR_SET_MM_AUXV, ...) with a vector that has a couple of
entries and no AT_NULL inside len (32 bytes on arm64), and then hexdump
/proc/self/auxv, or gcore the process and look at the AUXV note with
readelf -n.  This is arm64, the new vector was just { AT_UID, 0x1111,
AT_GID, 0x2222 }:

    idx  before (from exec)               after the prctl
    [0]  AT_SYSINFO_EHDR   0x7ed1d6e000   AT_UID    0x1111    <- new
    [1]  AT_MINSIGSTKSZ    0x1270         AT_GID    0x2222    <- new
    [2]  AT_HWCAP          0x119fff       AT_HWCAP  0x119fff  <- stale
    [3]  AT_PAGESZ         0x1000         AT_PAGESZ 0x1000    <- stale
    ...  16 more entries                  ...                 <- stale
    [20] AT_NULL           0x0            AT_NULL   0x0

21 entries before the prctl, still 21 after: the two new ones plus all 19
left over from exec.

Every consumer walks the vector until AT_NULL, so what they get now is a
vector that never existed at exec, the head from the prctl glued onto the
tail of the old binary.  gdb and crash pull the AUXV note out of coredumps
to find AT_PHDR, AT_ENTRY, AT_SYSINFO_EHDR and friends, and a mixed vector
points them at the wrong layout.  /proc/<pid>/auxv and PR_GET_AUXV hand
the same mess out to live processes too.  Nothing crashes, everything just
quietly reads a frankenstein auxv.

And callers that terminate their own vector hide the whole thing, which is
likely why nobody noticed since PR_SET_MM_AUXV landed in 2012.  Nothing
exciting security wise either, I mean it needs CAP_SYS_RESOURCE to begin
with.

prctl_set_mm_map() right above already copies the whole buffer for exactly
this reason, so just do the same here.  user_auxv is zero initialized and
only partially filled from userspace, so the rest is zeros and nothing
leaks.

Link: https://lore.kernel.org/20260809002901.32591-1-include@grrlz.net
Fixes: fe8c7f5cbf91 ("c/r: prctl: extend PR_SET_MM to set up more mm_struct entries")
Signed-off-by: Bradley Morgan <include@grrlz.net>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Cyrill Gorcuno <gorcunov@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sys.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index 7a2cfb57fa9e7..811f6df1caed0 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -2113,7 +2113,7 @@ static int prctl_set_auxv(struct mm_struct *mm, unsigned long addr,
 	BUILD_BUG_ON(sizeof(user_auxv) != sizeof(mm->saved_auxv));
 
 	task_lock(current);
-	memcpy(mm->saved_auxv, user_auxv, len);
+	memcpy(mm->saved_auxv, user_auxv, sizeof(user_auxv));
 	task_unlock(current);
 
 	return 0;
-- 
2.53.0



