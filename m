Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16EB5434409;
	Tue, 21 Jul 2026 23:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674808; cv=none; b=phQJ2aox6ls+AyhZ4LMEp7fnSN1G0JOLp3C6WKmmLJOQ2J+FGscUK3jQ1ZxoIgLgFlQU1LOHtBZITH751XUAkYW5zWH4RwIKJXjEnHNBmGJ0cgcGuV9BEIcj45lXc0cI6bVbSKC5QwCKDgSOHODckCWEFl9k+dTCCj5sCBYeZVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674808; c=relaxed/simple;
	bh=Hss8OpbucjoPPMrT7kBjlKHUGNCGcX7AXZN04PQ/uL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rYKnVLLz4JuYbkJhO0M4Hpv6gEyLxlgZaAlPHuWMFfCgnQDT552LAknY4/7n+689M9LpRp8gKL/zfPWmiG9OZ1tDj46P+CbJaVK3te7fbC2FobLoIPesraxH5UaJvOSX5wJSUpYpo4gGGcvTUT3gw8V16PLqQCCnX8g5fTNPIDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cs3ykqOs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cs3ykqOs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C47C1F000E9;
	Tue, 21 Jul 2026 23:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674807;
	bh=OigoA0EZ6wEUzfZvC0bdeR1aZqyRMO/ANRcNrYpD7o0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cs3ykqOsIlNgAyjoVpNa17j3/muYiWaVUKUGRZH3O+FutsvHuDIDpCBOk55NabxUI
	 B2hOaSUuvjCatWk7j152Qy606bScoBasYD4NNQFMSQfBR3/AJoPGJ9bGOmjnBImWv8
	 p2RV5U7nGOV0gzuNAziQO9sT/OQtqrRNvqmMgvhg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 637/699] netfilter: ebtables: Use vmalloc_array() to improve code
Date: Tue, 21 Jul 2026 17:26:36 +0200
Message-ID: <20260721152410.119796317@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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
@@ -884,8 +884,8 @@ static int translate_table(struct net *n
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
@@ -900,7 +900,7 @@ static int translate_table(struct net *n
 			}
 		}
 
-		cl_s = vmalloc(array_size(udc_cnt, sizeof(*cl_s)));
+		cl_s = vmalloc_array(udc_cnt, sizeof(*cl_s));
 		if (!cl_s)
 			return -ENOMEM;
 		i = 0; /* the i'th udc */
@@ -980,8 +980,8 @@ static int do_replace_finish(struct net
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
@@ -1276,7 +1276,7 @@ static int do_update_counters(struct net
 	if (num_counters == 0)
 		return -EINVAL;
 
-	tmp = vmalloc(array_size(num_counters, sizeof(*tmp)));
+	tmp = vmalloc_array(num_counters, sizeof(*tmp));
 	if (!tmp)
 		return -ENOMEM;
 
@@ -1417,7 +1417,7 @@ static int copy_counters_to_user(struct
 	if (num_counters != nentries)
 		return -EINVAL;
 
-	counterstmp = vmalloc(array_size(nentries, sizeof(*counterstmp)));
+	counterstmp = vmalloc_array(nentries, sizeof(*counterstmp));
 	if (!counterstmp)
 		return -ENOMEM;
 


