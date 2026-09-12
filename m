Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E9E8274B46;
	Sat, 12 Sep 2026 18:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237471; cv=none; b=aMCfg+lIHK2AScT3+txUvOI0sXV3FsNNHh7F97Mjk+9H4k+FjY5MvjUFIjdI1ZOi93UbyOHUz/jiQ6yl/6fexWK0FbUPfTb5a/zl559+LSrNyAzOGsxvaQJzqY6pXM+pdE5evSFYOdEl3A7Eul316gq/8rWCFRSurVlvssCrjm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237471; c=relaxed/simple;
	bh=1dGkK8FtKvndAzgWGLYI5WK1gk8hnkJzr8l1smUnGvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TXXnwwQ0x6df2YRnKWB+UV9HhE1wKbzAOwY/m6SphHUi4xaAtjD0NfD+oDQaRAbtGnFLC7UzS7IwVF9hqWv8BqmT5C/RjZno1lNmmV2NZ7QhUz/X/Msk9VzreRJ5PQrQTHseuPXuflvTi1dXgI13qwgYJz4BJCd+9uZpG2i4CYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J5On9uEr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J5On9uEr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57CB91F000FF;
	Sat, 12 Sep 2026 18:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237469;
	bh=h5FM6UjEc14zz6LDY+pLOn9PhlCtz45SfNh4OspmNq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J5On9uEr4T1hKdGCh2LHg6IKxKw0Gyv5a5t6KMYZwJGwDQnQLwH/OtcJHuz/Fk5OO
	 cS5LoM6oStPp95cp0NuYqlDTz16Vs4Qd8HSLIVpR+kU9XJ+X1oUEMm2vBBXG5IV4tv
	 ZKIvh7Ps4mvT05bEWWgr3rsz8emYviV+et6k0HKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bradley Morgan <include@grrlz.net>,
	Oleg Deomi <oleg.deomi@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Balbir Singh <bsingharora@gmail.com>
Subject: [PATCH 5.15 213/935] taskstats: fix cpumask parsing cutting off the last character
Date: Sat, 12 Sep 2026 08:54:03 +0200
Message-ID: <20260912065531.710610777@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -346,10 +346,9 @@ static int parse(struct nlattr *na, stru
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


