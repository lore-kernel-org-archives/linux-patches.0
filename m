Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56658471268;
	Tue, 21 Jul 2026 20:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664351; cv=none; b=g4g241cWNNDrDi1tMEQzWCKBEVk4De7k9Nc+bnVVTI9yBkmfNupz9qiHftwd2f33pGZDgM+vlpMM7KcdeMh1O6IKud/k3mjkTKmk2iQPOisSE+YVFTGHrtehLmlPuHR1jqQHYgSaLDowLWFBQdDpPDjvM/gv4MJ3N/vNxwlSqsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664351; c=relaxed/simple;
	bh=42uSHo+m989Ker+8JNWIyahcrphoo8ONu/DnEjAUDqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YJPcE3cls+hgyWUa0GsrdARUF/vZiBdW1rh2vZrxrothgGD+Szw+EazPhWE8zoK25pI7Mg5Uo1Z/hvjuEgDTknVOiC5Fg6SbV+wMzYXzZjCwjTFmQiL9NbMntvFPwc9/4+B3XKn9djicvyxrH1g/NNAz41J1bVQ/5bArC2Lr7GQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NrKevjOk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NrKevjOk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C5BE1F000E9;
	Tue, 21 Jul 2026 20:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664349;
	bh=VHz47CbYlALNE6JWsSpw8giMAacBSmZzvFALRa4/tDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NrKevjOkVROp6JufEoWKiH2NEVqgjnI9cE6DZfUCSJdJSxY0eARFntjqlrzRvEGaj
	 oQL2MLx9HzJ7rIuPC9psnJx3F2S7DwLcqJIWJA71DCEthAiacmj5E2cOvZ7RGbS5+V
	 6Ol+YtTR4cR6dpcX5zgKuJDEW7oMVb6crymS0P8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1168/1276] netfilter: ebtables: Use vmalloc_array() to improve code
Date: Tue, 21 Jul 2026 17:26:51 +0200
Message-ID: <20260721152512.159955412@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


