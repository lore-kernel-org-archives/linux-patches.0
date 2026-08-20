Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7D6F47FAEA;
	Thu, 20 Aug 2026 17:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247424; cv=none; b=BP6c/j83rfw+F6+fEXIIrIB0IlRKdL6GV4fhFLkUBlLN8N1ko+NP7Ds2HJIQE5ky8t0WEPAsUuVChnTnP+C25HWprUuXXTAK7cZNCAczsKHIrP8rdlhN/quYxBAkq8VxFHhi5S6gXP2/Ha9XzLQ3lAKxP3peQHl1P/cOckpIT2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247424; c=relaxed/simple;
	bh=ZvjbBNQBji/mYMdRfakY2JepCUSRiRue56F/+a4FqDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mURrqZ9An3COqm8fKRb4GjQ4YEHBjkaoejYrRF71gDsCplfTQxN4qxFcHr3I4T3PDTmamwH1vGCdFN/ZrcIM0qYNEYW8yD1/xu1OaD/g/TwnB2GNjCpUctAA7D6bao8qd2QV+LIblbOC8Fxl/ICuR1jdsCqP/P7S+Xtqq6PAkiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RcGQo/W5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RcGQo/W5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FBDF1F000E9;
	Thu, 20 Aug 2026 17:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247423;
	bh=jiYqYBAYEbfbpRACb3GaKJ/tmYIe7fmtqHO1bEhA4Uw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RcGQo/W5nJ5vCS0PJNvQhtvRn4+bEOgIENXCWjiGW6EOB+Rx4c8deXUsLqMlpdtar
	 ig5N+URggwKGfeJnaFg1LNsQ1hqP+0AqnaUN9bglRJtlCU0onVvH7tmtjXjWn861FB
	 HGBRgPenYoH8CI2j65ANrS9RUxEfDA+q3olWsaqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiming Zhu <zhuyiming@kuaishou.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.6 042/166] ceph: fix MDS random selection readiness predicate
Date: Thu, 20 Aug 2026 16:55:01 +0200
Message-ID: <20260820145212.440029568@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145211.194104353@linuxfoundation.org>
References: <20260820145211.194104353@linuxfoundation.org>
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

From: Yiming Zhu <zhuyiming@kuaishou.com>

commit 2c11c4bfdb7bd2808b3b3ac228e1f2d9bcf25457 upstream.

CEPH_MDS_IS_READY() is parsed so that the ternary expression can
return true for an MDS entry with state 0 when it is not laggy. This
allows the random selector to choose a down/DNE rank.

Group the ternary expression under the state check so zero-state ranks
are not treated as ready.

Cc: stable@vger.kernel.org
Fixes: b38c9eb4757d ("ceph: add possible_max_rank and make the code more readable")
Link: https://tracker.ceph.com/issues/78648
Signed-off-by: Yiming Zhu <zhuyiming@kuaishou.com>
Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/mdsmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ceph/mdsmap.c
+++ b/fs/ceph/mdsmap.c
@@ -15,7 +15,7 @@
 #include "super.h"
 
 #define CEPH_MDS_IS_READY(i, ignore_laggy) \
-	(m->m_info[i].state > 0 && ignore_laggy ? true : !m->m_info[i].laggy)
+	(m->m_info[i].state > 0 && (ignore_laggy ? true : !m->m_info[i].laggy))
 
 static int __mdsmap_get_random_mds(struct ceph_mdsmap *m, bool ignore_laggy)
 {


