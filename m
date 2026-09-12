Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4F2525A640;
	Sat, 12 Sep 2026 15:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227760; cv=none; b=iWhAUdhCS1MVZj1rQapKMiJ+OS7vxGbOY/uMMwLkFHpKmdEbZtpCB/RzO+Nqp+6yXiWvbXhoukQgsFRiUF/3A1RrALpI1uXKoh5oAcY1ckXa0NMkkqM7kYQ9scidqreBT+oWd7LEnO4loqvUPZgsg3fmWDc8dC7ip6rM/PGCFL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227760; c=relaxed/simple;
	bh=z7q6NCxy6OoId3cR1cWNcOCCO/uQHsw3UY36x9bUqAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oFFCZXQzrsm1pIn4g5gwt6PZiKaQmqJ0L2tlYnVcaGPtXx1Rzmx4P/lvZb1hGF2Q3WUjDNh55+0WdQq0DOyxKHOfyNC8MJxN08DUQtBJ7pJQNx03W6nITk2t3z3KQ7YelZNA/Jc6h3XdOOXVH9AM1o3QMPXGhd/lwSgcbMGD7Ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oKLPdkO3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oKLPdkO3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17DB71F000FF;
	Sat, 12 Sep 2026 15:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227758;
	bh=t8vNl64x+bb2X5CqGGaZpyU5MLPcWVOuA4n7I/++bUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oKLPdkO3ev+pFzT0ru303/IXVk9Fg7m0ENWWl83GKcvtECfKHLUo0CANvfTQXbtQr
	 QO//86RIlI+BvEsGmnYNUmX4vdYPc7iir3hQgALbQX/5ntNwFrqn7kj/crS1vmJFIc
	 ndSmPcZWPVU9cbb+X6G7UPC/MkB+NauIklO8JpN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bradley Morgan <include@grrlz.net>,
	Oleg Deomi <oleg.deomi@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Balbir Singh <bsingharora@gmail.com>
Subject: [PATCH 6.1 0248/1191] taskstats: fix cpumask parsing cutting off the last character
Date: Sat, 12 Sep 2026 08:49:36 +0200
Message-ID: <20260912065553.788183618@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


