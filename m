Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76CD444AB62;
	Tue, 21 Jul 2026 21:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667789; cv=none; b=jHTjNl5pC3XfLii5SVN/i+JQxGept//OdN2zV0dOqk0Ftip4asiSUu36kVC1aNiCrRB95kraepbteOtpB1C4jvOMZ0jyqAWkl0826/6T4TJoxZFR8jb/MnsdF6KU85XkPch2Ia4RB4CSM+ZfaEFeTNstRsCGoMVJmNv0cEeMPdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667789; c=relaxed/simple;
	bh=FaWTkWKq/yhPwtAQtuzoV1CAjqFeGLWJUJyIrteupvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hCAXnSgQij8QUcOyoGUUPSAOwewX9x/6YHmaz8dh7uMsRscQBrrfomffpSAETRaClMr5i1+9/ZiP0gV422df3ngdzkpFlP8BAp7GYgLR9erjATGwncsQ3EY1RZhwtjokPkH1BXu7IDBq9cGJVZxqZsEMp7G/GNZ96OgK88nDwB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EToPgDXI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EToPgDXI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FFBE1F00A3A;
	Tue, 21 Jul 2026 21:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667784;
	bh=VWQ+CZmx+NzoE22PG8w6FIbm0OlMPA5Bzjy54m4Uyl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EToPgDXISNVnmd4IFT5U6CA0YnOo1Dns+A8mw7eoXBvRzzAssVgGVh7DRVjhsEa0D
	 cvInlG6zAghzpK6k4aOALFxkGK4Qsu6BJxLqNcG8pUYxOCot7mVZKhNgDHiT8fsla7
	 ABSgOe5gQv0vFB7jbvyXQFtvW+c4jML4y8yc6KPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1190/1266] netfilter: ebtables: Use vmalloc_array() to improve code
Date: Tue, 21 Jul 2026 17:27:07 +0200
Message-ID: <20260721152508.425819724@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: Qianfeng Rong <rongqianfeng@vivo.com>

[ Upstream commit 46015e6b3ea75297b28d4806564f3f692cf11861 ]

Remove array_size() calls and replace vmalloc() with vmalloc_array() to
simplify the code.  vmalloc_array() is also optimized better, uses fewer
instructions, and handles overflow more concisely[1].

[1]: https://lore.kernel.org/lkml/abc66ec5-85a4-47e1-9759-2f60ab111971@vivo.com/
Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Stable-dep-of: cbfe53599eeb ("netfilter: ebtables: zero chainstack array")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bridge/netfilter/ebtables.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -923,8 +923,8 @@ static int translate_table(struct net *n
 		 * if an error occurs
 		 */
 		newinfo->chainstack =
-			vmalloc(array_size(nr_cpu_ids,
-					   sizeof(*(newinfo->chainstack))));
+			vmalloc_array(nr_cpu_ids,
+				      sizeof(*(newinfo->chainstack)));
 		if (!newinfo->chainstack)
 			return -ENOMEM;
 		for_each_possible_cpu(i) {
@@ -941,7 +941,7 @@ static int translate_table(struct net *n
 			}
 		}
 
-		cl_s = vmalloc(array_size(udc_cnt, sizeof(*cl_s)));
+		cl_s = vmalloc_array(udc_cnt, sizeof(*cl_s));
 		if (!cl_s)
 			return -ENOMEM;
 		i = 0; /* the i'th udc */
@@ -1021,8 +1021,8 @@ static int do_replace_finish(struct net
 	 * the check on the size is done later, when we have the lock
 	 */
 	if (repl->num_counters) {
-		unsigned long size = repl->num_counters * sizeof(*counterstmp);
-		counterstmp = vmalloc(size);
+		counterstmp = vmalloc_array(repl->num_counters,
+					    sizeof(*counterstmp));
 		if (!counterstmp)
 			return -ENOMEM;
 	}
@@ -1389,7 +1389,7 @@ static int do_update_counters(struct net
 	if (num_counters == 0)
 		return -EINVAL;
 
-	tmp = vmalloc(array_size(num_counters, sizeof(*tmp)));
+	tmp = vmalloc_array(num_counters, sizeof(*tmp));
 	if (!tmp)
 		return -ENOMEM;
 
@@ -1531,7 +1531,7 @@ static int copy_counters_to_user(struct
 	if (num_counters != nentries)
 		return -EINVAL;
 
-	counterstmp = vmalloc(array_size(nentries, sizeof(*counterstmp)));
+	counterstmp = vmalloc_array(nentries, sizeof(*counterstmp));
 	if (!counterstmp)
 		return -ENOMEM;
 


