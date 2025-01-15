Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFA5E248BD9;
	Wed, 15 Jan 2025 10:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937542; cv=none; b=BIok7iWAbq45/UgqdP1oslhF6up7LF49fve1Lg/fwMrw+n28YlMM50fRGUAyjzbh9/zWJYM2lz5rY45KcagUcRnRml/wSVUq5xbSdSc+ALAU/jYhbW9e97VJJCHaE3E0sx5+IAkznWSTI8CDHEdRj5gDohUEtVIUhy9MZtvTOIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937542; c=relaxed/simple;
	bh=JZtXvz4nLtfS60zg0VSQUZW7SjcW3y3/thaqnBPAzRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t6plFX9Okf67EiJhaRvZqSHtTiNGQnlbXb5/ss7w+DmOdngFcGlRxpcQBSWepTg5K0Io5QjjfsxXz4WLnEJwViQvcQfGV8/9/3M7SCbhrL/ngWmDKbwB2Pwi5/+bK7fRN8jo8fkFw9Vr2/B4RSK5tnIzIC4hVp54u9HQ9vmBCdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ud4/lY1h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ud4/lY1h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2954C4CEE2;
	Wed, 15 Jan 2025 10:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937541;
	bh=JZtXvz4nLtfS60zg0VSQUZW7SjcW3y3/thaqnBPAzRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ud4/lY1hYXjq6ZUilPx0uMnz4whg3eTiWMLCib3TPqBwzmM15WpPlEvphXZoBQKpC
	 vnVMSkHhcbzzm/Z2uf+IOdSu35qs80aDGT083Sfqa//fiEygRD2jVfE4LIQz1CSfFv
	 wXo5LrhWfQn4RxwHQ1WkQg2OxVkz7ZDOR1biWSB4=
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
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 11/92] scripts/sorttable: fix orc_sort_cmp() to maintain symmetry and transitivity
Date: Wed, 15 Jan 2025 11:36:29 +0100
Message-ID: <20250115103547.982736908@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103547.522503305@linuxfoundation.org>
References: <20250115103547.522503305@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuan-Wei Chiu <visitorckw@gmail.com>

The orc_sort_cmp() function, used with qsort(), previously violated the
symmetry and transitivity rules required by the C standard.  Specifically,
when both entries are ORC_REG_UNDEFINED, it could result in both a < b
and b < a, which breaks the required symmetry and transitivity.  This can
lead to undefined behavior and incorrect sorting results, potentially
causing memory corruption in glibc implementations [1].

Symmetry: If x < y, then y > x.
Transitivity: If x < y and y < z, then x < z.

Fix the comparison logic to return 0 when both entries are
ORC_REG_UNDEFINED, ensuring compliance with qsort() requirements.

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
(cherry picked from commit 0210d251162f4033350a94a43f95b1c39ec84a90)
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/sorttable.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/scripts/sorttable.h b/scripts/sorttable.h
index deb7c1d3e979..f0ba2bf5a886 100644
--- a/scripts/sorttable.h
+++ b/scripts/sorttable.h
@@ -110,7 +110,7 @@ static inline unsigned long orc_ip(const int *ip)
 
 static int orc_sort_cmp(const void *_a, const void *_b)
 {
-	struct orc_entry *orc_a;
+	struct orc_entry *orc_a, *orc_b;
 	const int *a = g_orc_ip_table + *(int *)_a;
 	const int *b = g_orc_ip_table + *(int *)_b;
 	unsigned long a_val = orc_ip(a);
@@ -128,6 +128,10 @@ static int orc_sort_cmp(const void *_a, const void *_b)
 	 * whitelisted .o files which didn't get objtool generation.
 	 */
 	orc_a = g_orc_table + (a - g_orc_ip_table);
+	orc_b = g_orc_table + (b - g_orc_ip_table);
+	if (orc_a->sp_reg == ORC_REG_UNDEFINED && !orc_a->end &&
+	    orc_b->sp_reg == ORC_REG_UNDEFINED && !orc_b->end)
+		return 0;
 	return orc_a->sp_reg == ORC_REG_UNDEFINED && !orc_a->end ? -1 : 1;
 }
 
-- 
2.39.5



