Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55C74423784;
	Fri,  4 Sep 2026 06:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502991; cv=none; b=sORZ+IBU0t5Dfx2p413YQ1zVwx4Q/KgpIb4btwuJ9PQrkILeb87UcCY/fv8q5EdFpjzYd0gdNN2oRzPqUJuxST0OV+rTrgF2pm40BaQeot34JJFKqwZecCquyDGkyn8PtDJk77U+oawHlRIScjVYZBUpX5Amx4m/YtokN3/IpYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502991; c=relaxed/simple;
	bh=kOKrsYJp8zkIwp5Ni/wQHKUL9SqfYoIdKCdvpTvbbGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cKRpTzIBS6IwETxm8qLbAS1X6LVj0Ua/JpYVsxIh+QTrShPXZ+RNsdXbemVZFq3Nb7wDEa2s/rN9zvwgSOlWAcjPDi2Mf7yWrkYZ0LBXsJcfl3X1cmMeusw3r77J5JTs3uVVruqCwT80o9J1ExqPNkEbIvN5W3UKEMovTxEyVpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YPIuv+Lo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YPIuv+Lo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADFE61F00A3F;
	Fri,  4 Sep 2026 06:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502990;
	bh=6J54pBUjN6WiEbrL8Ld8sXa/2ENc78EnYOa+PmvirsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YPIuv+Lojz3f0bgwPsGfsADPXP+QDLLRSDkkP/4YCmw+adhAvLAeH9rBmljUGcuFY
	 snOpQX9i3rfKKnxQpliA953si8FXKsMCMm/2vjvGO94YlvV6/0M5RJZjgn7/XR8Og7
	 Qh0G4VHwWhA96uVR+S18I1pWTJNKqX52gGigqgag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bradley Morgan <include@grrlz.net>,
	Oleg Deomi <oleg.deomi@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Balbir Singh <bsingharora@gmail.com>
Subject: [PATCH 6.12 400/403] taskstats: fix cpumask parsing cutting off the last character
Date: Fri,  4 Sep 2026 07:03:23 +0200
Message-ID: <20260904045743.875262878@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

From: Bradley Morgan <include@grrlz.net>

commit 1f58a5335cdd14b3fb5f2a5d3763dee1f5cba1d3 upstream.

parse() hands nla_strscpy() len as dstsize, and nla_strscpy() copies at
most dstsize - 1 bytes.  When the attr payload comes in without a trailing
NUL, srclen == len >= dstsize and the last character of the cpumask string
gets cut off.  Register "0-15" and you are silently listening on "0-1",
exit data for the rest never shows up.

The bug only bites when the sender doesn't NUL terminate the payload;
senders that include the NUL were always fine (srclen gets decremented for
the trailing NUL, so srclen < dstsize).  Thats probably why this survived
20 years.  And the policy is NLA_STRING, not NLA_NUL_STRING, so a payload
without the trailing NUL is legit input here.

Skip the kmalloc/nla_strscpy dance entirely and use nla_strdup(), which
already allocates srclen + 1 and terminates.  The nla_len() bounds checks
stay as they were.

Link: https://lore.kernel.org/EC49FE41-7F5F-41E0-A07A-ABEB8ECA514D@grrlz.net
Fixes: f9fd8914c1ac ("[PATCH] per-task delay accounting taskstats interface: control exit data through cpumasks")
Signed-off-by: Bradley Morgan <include@grrlz.net>
Reported-by: Oleg Deomi <oleg.deomi@gmail.com>
Closes: https://lore.kernel.org/CAByWkfZ6b1=3H9pwkz-dDQOs9cZaF-HYQ6b9Yb0=Hq2r1Vv_Pw@mail.gmail.com
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/taskstats.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/kernel/taskstats.c
+++ b/kernel/taskstats.c
@@ -368,10 +368,9 @@ static int parse(struct nlattr *na, stru
 		return -E2BIG;
 	if (len < 1)
 		return -EINVAL;
-	data = kmalloc(len, GFP_KERNEL);
+	data = nla_strdup(na, GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
-	nla_strscpy(data, na, len);
 	ret = cpulist_parse(data, mask);
 	kfree(data);
 	return ret;


