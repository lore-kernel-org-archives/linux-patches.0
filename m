Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C3A04ABBC1;
	Thu, 17 Sep 2026 15:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659926; cv=none; b=sO9fQP5EhYGfamCYZ20gntEJZAGAner7r75enpYadbHfzpVJIRb0lWAmCFK5cSj0Te65yzlLa/cjxzTG/HXJsl+yKF7HIcIxmihBkNroSOU4CQxxr8nKwueuG7X/Mxy7SLQvA/cKJprxvjClevYoC7vAH8tPJs0PpHTe4+5qRsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659926; c=relaxed/simple;
	bh=SnMr3SQ8ryCVOqRiex1NKsZ/4sJa6g62HcrXtexBTTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BNcqjQ/SFT/URu0111YKe7lXz4+EUB4FnXGhqPuhXAwPJoSb2FhceD7qstTFyVAhf9Z3Y2cZ80gXbYs/zWU0Kckr1yeJrz2mPhIXw2muS+3E1Vvyd7sGrl9WSyqP1kEKo131BfxRjwKL+swe2CYQeqsj2mlDEg8/hK/7DgPkvAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eupYZP29; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eupYZP29"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CE371F00898;
	Thu, 17 Sep 2026 15:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659920;
	bh=vaoZUeE4P47xD+BiKDGjuQz7Klvco4H21acwFV0S7R4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eupYZP29z9IB7nrX4hhMKq8VuIuzJOlPoRQz/cjiE+srMDEbU1yG8EmDu7lEIbAMh
	 rfrlY8ieg4RAezzZn7BefUIqsgRkhYK8Z49vfHT+cd7w8khlnvxR0D8I0EOrjs/ulr
	 ejV6Mk6x0emlZcMOk5I7pqqAPgHqOxutOgsxrnGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thibault Ferrante <thibault.ferrante@canonical.com>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 411/733] selftests/powerpc/tm: Fix tcheck() reading uninitialised CR value
Date: Thu, 17 Sep 2026 16:11:59 +0100
Message-ID: <20260917151402.011068664@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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



