Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 476AF3BA246;
	Wed, 30 Sep 2026 19:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795480; cv=none; b=ZytJm3dzW0KNP7DOKswzJTOB16GuiSTnOHmk+qAtEIs/v9fuGPbwBrq6MlpKUHiYOG/1wL7X/Y4VYvHTTvTEMvFTCcW3TqPr6NmkBqKye/hEuyem+EZhTAykW30vPWFDyf6saqLsSG8B/GuhFW8FqREqz8M17165nRt+sKV+kts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795480; c=relaxed/simple;
	bh=98hd11ffxFLC+p8C3dOb54lRX6ahPcMcGVi4vwWg51Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=atnre4JmwN1iaSLp8O8pWdUOog50mcM+NFHjbuigZMYFVmL6SumNJtO29wNGuN5WoRzfFsvs+DcdZ5tn93hkKmOV2JCi1XrDUWyzrRg8qWl25lBwR0nkTOim2oVWmO0oqjckkyD6ZxI62eROXy3cXjC6GHsXqS8I0F3tanfD+LM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wiuBZuN5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wiuBZuN5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F3A81F000FF;
	Wed, 30 Sep 2026 19:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795479;
	bh=+eqcnATraBnFbpdCmqhXb406DJO2Ti/ZqGpnCXjzjDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wiuBZuN5NyIvOMF135j/wEuwZzK4U1Deehbo4YQeWd4Wbw3kxNvmWCq9oiZ9TH2nz
	 F9pMtTTN2jv3GuYXQJNr0vJ8ukQzlnwysO25im0cCmijusvry/uABePuNmz2h1nCtL
	 Mym+DbxeLZtJ3dXG7+DvockF12kQMAQ95DbfWOKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thibault Ferrante <thibault.ferrante@canonical.com>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0577/1193] selftests/powerpc/tm: Fix tcheck() reading uninitialised CR value
Date: Wed, 30 Sep 2026 17:21:01 +0200
Message-ID: <20260930152447.060818684@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



