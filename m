Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD4114FD261;
	Thu, 17 Sep 2026 17:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666068; cv=none; b=Yjg2+IlLCboZsZvvqA2CMIdLJhW4/BKWVtXXlODefgAktKSz5luEnxV0MV+dpGcmlTcqnqyfmz9fpAFFzgW43hm9iRE7dUiDx0HT5dsp4aA7AfTZNxK1yEsPJk/OB5+0s6Zlqbsbknwt6pd2DHzWDcs8cpFkTfZO0JOW6XclAhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666068; c=relaxed/simple;
	bh=RCX3du5NLdkzSOOiHsZKtn0ydMcBn1873z9dJAWOW8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TWn+TuXrOwg/UBPGc+V4Zs9NyuhyH+ZwTr7bEaIJyvBWYG8ur/5adL5nT3c7tFF7eXQsz2IthqVAV2eHj/Yed171f6h+kRlqZvPxUaNUd+nFZQxiHYovtvWroR0tCBNp9f/MXIqF2YXD0oLaKEfT0NZEk+GpkqoEc2ycuQhue8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uy/jJLJR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uy/jJLJR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 005AA1F000FF;
	Thu, 17 Sep 2026 17:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666066;
	bh=IaoOIEYxWhLnvWFpdt+OSdrEirMVZOS/kjOj3DGSFpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uy/jJLJRecQMyKSyRvda8YmJjx24fExM0rYb0FzBn2hA7eG608Vu5+NGmDI1sDKCw
	 gw2j+nGhZttcvfONZAyJBWToBqFbH6lmTs7McrSMByX+nxRVgAKQ7Sk4xO2i8xcS7K
	 lx5UtSbLGqGc0/k68EhkChyWaNaHe43dTClBvivQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thibault Ferrante <thibault.ferrante@canonical.com>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0914/1250] selftests/powerpc/tm: Fix tcheck() reading uninitialised CR value
Date: Thu, 17 Sep 2026 16:11:49 +0100
Message-ID: <20260917151616.771096246@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thibault Ferrante <thibault.ferrante@canonical.com>

[ Upstream commit ed28b16eab705071d28edaace47189c2eb3aa108 ]

tcheck() is used to check the current transaction state (active,
suspended, doomed) via the "tcheck" instruction, which writes its
result into CR field 0. The inline asm declared a GPR output operand
for this result but never actually moved the CR into it.

Every caller (tcheck_doomed(), tcheck_active(), tcheck_suspended(),
tcheck_transactional()) has effectively been testing bits of an unrelated,
arbitrary register value since this helper was introduced.
The "& 4" mask discards the TDOOMED and TS_lsb (suspended) bits before
they ever reach the callers, so tcheck_doomed() and tcheck_suspended()
can never return true, and tcheck_transactional() degrades to being
equivalent to tcheck_active().

Fix tcheck() to actually move CR into the output register with mfcr,
and widen the mask from "& 4" to "& 0xf" so the full CR0 nibble
(TDOOMED | TS_msb | TS_lsb | reserved) is preserved for the callers.

This bug has been present since tcheck() was introduced.

Link: https://bugs.launchpad.net/bugs/2107442
Fixes: 8e03bd4e70b6 ("selftests/powerpc: Add TM tcheck helpers in C")
Signed-off-by: Thibault Ferrante <thibault.ferrante@canonical.com>
Reported-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Closes: https://lore.kernel.org/all/364996ce-aba2-4213-8d20-7dd481b43fe6@linux.ibm.com/
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260907215420.1258678-1-thibault.ferrante@canonical.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/powerpc/tm/tm.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/powerpc/tm/tm.h b/tools/testing/selftests/powerpc/tm/tm.h
index c03c6e7788767..6024ce4ba6ffd 100644
--- a/tools/testing/selftests/powerpc/tm/tm.h
+++ b/tools/testing/selftests/powerpc/tm/tm.h
@@ -105,8 +105,12 @@ static inline bool failure_is_nesting(void)
 static inline int tcheck(void)
 {
 	long cr;
-	asm volatile ("tcheck 0" : "=r"(cr) : : "cr0");
-	return (cr >> 28) & 4;
+	asm volatile("tcheck 0;"
+		     "mfcr %0;"
+		     : "=r"(cr)
+		     :
+		     : "cr0");
+	return (cr >> 28) & 0xf;
 }
 
 static inline bool tcheck_doomed(void)
-- 
2.53.0



