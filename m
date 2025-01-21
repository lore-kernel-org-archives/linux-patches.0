Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83AD91F8936;
	Tue, 21 Jan 2025 18:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482921; cv=none; b=BDyeyic2z175tqQHGZvtHt8n0qR4Zo1xWkvI2lHoumClozXJMpyx8whCKIqpNZq15QTZ507AjTjRmmif9qt37meaa6aO3fzJaHLiA4SIo09Ef4eCXW3kT+/pI3uGTUKpMqbW4jJwyylccjjTqFLvnw25toIfD7SRI9XjV+ntErE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482921; c=relaxed/simple;
	bh=u/h+VP4rrsj0c105nm2/Zj4X7+aDXgEibbdbEDlarmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tr+12j1LPKlcaXo4Kscr7WclAg1rbsyomyKeaGpRlwd7n6QQXT61CUIeuQqP3KPCkHdHTTCJMR9gji6kPTQGz93Z8WD6c+AQZXKTFQtF79CBsXyfxiFqf2hynODmVcc0DLugiY1V0HsLX9JLUCexcuS2gjxl7oiSVIpHFzx3KR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DO8uOlb4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DO8uOlb4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BD12C4CEE3;
	Tue, 21 Jan 2025 18:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482921;
	bh=u/h+VP4rrsj0c105nm2/Zj4X7+aDXgEibbdbEDlarmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DO8uOlb42mgdFUXc6f8JiWjoqSHSW0sQ255XPIcmcbc45PubtpSoq2e9OLYZOPifN
	 iDKkKB+a4q6kaKGDsSEubXgW1vJm+T4ZOzZ7uv530hy4FD7TK02QkAxHBGs2N/KfsZ
	 7hK+s1Lh8gtXv2XzGTpQXv9ljatSYWl0VawSu+Og=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuan-Wei Chiu <visitorckw@gmail.com>,
	"Ching-Chun (Jim) Huang" <jserv@ccns.ncku.edu.tw>,
	chuang@cs.nycu.edu.tw,
	Ingo Molnar <mingo@kernel.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Shile Zhang <shile.zhang@linux.alibaba.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 037/127] scripts/sorttable: fix orc_sort_cmp() to maintain symmetry and transitivity
Date: Tue, 21 Jan 2025 18:51:49 +0100
Message-ID: <20250121174531.109325914@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174529.674452028@linuxfoundation.org>
References: <20250121174529.674452028@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Kuan-Wei Chiu <visitorckw@gmail.com>

commit 0210d251162f4033350a94a43f95b1c39ec84a90 upstream.

The orc_sort_cmp() function, used with qsort(), previously violated the
symmetry and transitivity rules required by the C standard.  Specifically,
when both entries are ORC_TYPE_UNDEFINED, it could result in both a < b
and b < a, which breaks the required symmetry and transitivity.  This can
lead to undefined behavior and incorrect sorting results, potentially
causing memory corruption in glibc implementations [1].

Symmetry: If x < y, then y > x.
Transitivity: If x < y and y < z, then x < z.

Fix the comparison logic to return 0 when both entries are
ORC_TYPE_UNDEFINED, ensuring compliance with qsort() requirements.

Link: https://www.qualys.com/2024/01/30/qsort.txt [1]
Link: https://lkml.kernel.org/r/20241226140332.2670689-1-visitorckw@gmail.com
Fixes: 57fa18994285 ("scripts/sorttable: Implement build-time ORC unwind table sorting")
Fixes: fb799447ae29 ("x86,objtool: Split UNWIND_HINT_EMPTY in two")
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: Ching-Chun (Jim) Huang <jserv@ccns.ncku.edu.tw>
Cc: <chuang@cs.nycu.edu.tw>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Shile Zhang <shile.zhang@linux.alibaba.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/sorttable.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/scripts/sorttable.h
+++ b/scripts/sorttable.h
@@ -103,7 +103,7 @@ static inline unsigned long orc_ip(const
 
 static int orc_sort_cmp(const void *_a, const void *_b)
 {
-	struct orc_entry *orc_a;
+	struct orc_entry *orc_a, *orc_b;
 	const int *a = g_orc_ip_table + *(int *)_a;
 	const int *b = g_orc_ip_table + *(int *)_b;
 	unsigned long a_val = orc_ip(a);
@@ -121,6 +121,10 @@ static int orc_sort_cmp(const void *_a,
 	 * whitelisted .o files which didn't get objtool generation.
 	 */
 	orc_a = g_orc_table + (a - g_orc_ip_table);
+	orc_b = g_orc_table + (b - g_orc_ip_table);
+	if (orc_a->sp_reg == ORC_REG_UNDEFINED && !orc_a->end &&
+	    orc_b->sp_reg == ORC_REG_UNDEFINED && !orc_b->end)
+		return 0;
 	return orc_a->sp_reg == ORC_REG_UNDEFINED && !orc_a->end ? -1 : 1;
 }
 


