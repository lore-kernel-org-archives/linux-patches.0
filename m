Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 460551E522;
	Thu, 30 Jan 2025 14:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246943; cv=none; b=Q/+vgP3UBFqRe+Z0+Wuj86eauCjfmw0qVgRjjNHcFDoanDfAG/CmW8tvQSl/0U1bdSBsaDSCb+I2sqfVu+a5DagSwYcdGkXb9wWdLuEJPn5hMf8ANbc+w1JIkZ+9/ssU3WL3iq8LYyv/BsNqD6y6vsggIA/9oJwKEbyr36kwQA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246943; c=relaxed/simple;
	bh=5rjPvy8nHEO1TAaNPKUCpWiQfjCAlNDzAV3kKJtpMk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MUhT5qivWNGXZERdNXfSBUoMf8bdUdiJutg1Asu1QRSltWn10f5z/8AYSEgpH9U8qkqX9Ka4afsoa/hm5CARyLCxXqxXee/JzGKNfXqKcaWwZP5CC/QVeliC/iHJiHG55Fj0vMyPwW+AbrDDaQp3XlzbYwz1xb8Vsnls8o8My48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TLzCstQ/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TLzCstQ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA498C4CED2;
	Thu, 30 Jan 2025 14:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246943;
	bh=5rjPvy8nHEO1TAaNPKUCpWiQfjCAlNDzAV3kKJtpMk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TLzCstQ/XMrZvpN6oYXnZc53j4XOqOumhJCrZj+zcfAEZEHst0fG1msPPso4/Fqwu
	 YQM7WxGFvOgDRpbMJolPbDW6gfANCZOmWiASEDWOmCp092l/1fsC9w33t3MD5+2qma
	 epAchk3koZA9zG5OrAnZcddFJFMdXX/NBIgIu9I4=
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
Subject: [PATCH 5.10 028/133] scripts/sorttable: fix orc_sort_cmp() to maintain symmetry and transitivity
Date: Thu, 30 Jan 2025 15:00:17 +0100
Message-ID: <20250130140143.645489718@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140142.491490528@linuxfoundation.org>
References: <20250130140142.491490528@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 scripts/sorttable.h |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

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
@@ -120,8 +120,12 @@ static int orc_sort_cmp(const void *_a,
 	 * These terminator entries exist to handle any gaps created by
 	 * whitelisted .o files which didn't get objtool generation.
 	 */
-	orc_a = g_orc_table + (a - g_orc_ip_table);
-	return orc_a->sp_reg == ORC_REG_UNDEFINED && !orc_a->end ? -1 : 1;
+ 	orc_a = g_orc_table + (a - g_orc_ip_table);
+	orc_b = g_orc_table + (b - g_orc_ip_table);
+	if (orc_a->sp_reg == ORC_REG_UNDEFINED && !orc_a->end &&
+	    orc_b->sp_reg == ORC_REG_UNDEFINED && !orc_b->end)
+		return 0;
+ 	return orc_a->sp_reg == ORC_REG_UNDEFINED && !orc_a->end ? -1 : 1;
 }
 
 static void *sort_orctable(void *arg)


