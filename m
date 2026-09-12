Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74BDE34F497;
	Sat, 12 Sep 2026 19:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240623; cv=none; b=gV2yTZXUEHQU9P0JWakYJQ4wbmr8v/H6hZ1aUIPgyiUEPsM6PEEvO6pTbmEGL4v+FIrhuDMjwq+SU0XdupFGqifqlO9PlHBwMSYkxJcQHYQc1DURaR6A+N5MGeLHx50HIei3NSfYoYZrLo66890jsZkrao0qi2+fGMziWxg4/1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240623; c=relaxed/simple;
	bh=5+NXVUR3L06I/Q4U8ZnJGE5yDVfmnZjo9yPCPM3LUxU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GQKjN60x1Hg2Z/6tavmg3gZvbZ7Q7Ddq8MMYjOaaJuH7qfG64YQneOFBSh35BAZdaKQEOFOvT13glFky8jKhjeKdHtrm4AyYxwQbpJbzR9PVVA26BECDqHXc28w+p7FXYkdW6WrQykYsuf27NaBUHOe7AIs+Q7JgLBE5Ibco3NM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zHDECHsI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zHDECHsI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D32A71F000FF;
	Sat, 12 Sep 2026 19:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240622;
	bh=/jMEqA5yZrnXdd/4Jkco3LPz9xp+EdxPGUUTDKvhWcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zHDECHsIFhP/ShRmEYX2+g5b1lIEEy+Fm3m9XMIvoW2e9SWi85QxXu18lf3vH69/2
	 Iy+LJ2dSXpw0svUjjuXKZ2zIYmyEecyoWo5lavk9ls6nfnoiyl4bEOHNlT6g8uUfrn
	 beZawTGc4FAlI8kpkPCGW5CiXRoc90affklphPBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bradley Morgan <include@grrlz.net>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Cyrill Gorcuno <gorcunov@openvz.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 864/935] prctl: fix PR_SET_MM_AUXV losing the forced AT_NULL terminator
Date: Sat, 12 Sep 2026 09:04:54 +0200
Message-ID: <20260912065546.637985644@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 2cfb829864c63..0c28a8eff0e35 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -2109,7 +2109,7 @@ static int prctl_set_auxv(struct mm_struct *mm, unsigned long addr,
 	BUILD_BUG_ON(sizeof(user_auxv) != sizeof(mm->saved_auxv));
 
 	task_lock(current);
-	memcpy(mm->saved_auxv, user_auxv, len);
+	memcpy(mm->saved_auxv, user_auxv, sizeof(user_auxv));
 	task_unlock(current);
 
 	return 0;
-- 
2.53.0



