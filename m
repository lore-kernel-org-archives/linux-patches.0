Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 076B61D5CE5;
	Mon,  6 Jan 2025 15:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178079; cv=none; b=UMesM9zSs5G0M5wrPUBCfImtbZQJuI30KQrwIaYw3L1Jjm32HSykRA+2yMzK9Raydq/DjKBXaghomau6dVpAv5Ki/bSGli1AHGyrp9KVbdVR67FxlSXqDOqz7pYHEM4BSF+8Wbr41NV2gOyfO/d0M6pRzJfGjyyS1RlKFTlfFX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178079; c=relaxed/simple;
	bh=kZI0lXgsdvEQYSbaaRGEv733VakyarErqlDM0epyU0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i5p63KksV8o2z70cA/l07taB1WQfHd+/f6w7cUY9KoboD1ZodBK+K5WAUGWIWBkVpdACRKv5UBf5u9fsNsnLwiWvscj8cRkQjC5xWcNLgndGHmN+nJaTyWk2cL+dty1kl8jAwgjR6Goy8232VBIwzNzOPvkRZ3uMRGv+1JY/43I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YFTn2x3N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YFTn2x3N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55B35C4CEDF;
	Mon,  6 Jan 2025 15:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178078;
	bh=kZI0lXgsdvEQYSbaaRGEv733VakyarErqlDM0epyU0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YFTn2x3NWhfQ0IQVceEs6vL831ApesPE/s1QT6ZrhDcIC0z6ep9XaqLZzNVhxEEOu
	 Ax+EUNCOVovCn3JCjE3ue35h0Yv06n2aHQ96MIWE1Q+qforry8XLmln0AW1SLwv9iP
	 p1WhOYHWRpn/tb9mjOOUXv5wqveQ5Pl+9YOe6fhg=
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
Subject: [PATCH 6.12 123/156] scripts/sorttable: fix orc_sort_cmp() to maintain symmetry and transitivity
Date: Mon,  6 Jan 2025 16:16:49 +0100
Message-ID: <20250106151146.363755794@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/sorttable.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/scripts/sorttable.h
+++ b/scripts/sorttable.h
@@ -110,7 +110,7 @@ static inline unsigned long orc_ip(const
 
 static int orc_sort_cmp(const void *_a, const void *_b)
 {
-	struct orc_entry *orc_a;
+	struct orc_entry *orc_a, *orc_b;
 	const int *a = g_orc_ip_table + *(int *)_a;
 	const int *b = g_orc_ip_table + *(int *)_b;
 	unsigned long a_val = orc_ip(a);
@@ -128,6 +128,9 @@ static int orc_sort_cmp(const void *_a,
 	 * whitelisted .o files which didn't get objtool generation.
 	 */
 	orc_a = g_orc_table + (a - g_orc_ip_table);
+	orc_b = g_orc_table + (b - g_orc_ip_table);
+	if (orc_a->type == ORC_TYPE_UNDEFINED && orc_b->type == ORC_TYPE_UNDEFINED)
+		return 0;
 	return orc_a->type == ORC_TYPE_UNDEFINED ? -1 : 1;
 }
 


