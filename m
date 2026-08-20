Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11DAF381AEC;
	Thu, 20 Aug 2026 17:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247890; cv=none; b=K7/S/ag3DQXhdohaj0hyFkKj3M1LzcBxjUeHTEklDJ6wYIBCvP1VhOnDovYkEMC2cqmCi8GxKrDdqqEvTkNSlogHoTvc6jEXF3cN/WdSOd5JxvJWTALDR7QiE75vnZXXVMm4uQ6k0HpFPPFWHdlTUkG4Ec7Mj7jqggA+WSAOZf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247890; c=relaxed/simple;
	bh=jhF/g3KVJzdpR4VWB6lJ5fG2E0NxNViQ16AZgOJXsSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JfieC3+NlLy3rOEAfrJs8dndTG9EsOaXKcmdMDvtA6kJRtOQI5xHR8nmNnx9wf5sBq4TfMiLAxnYGZd5vYskYTSFHq/F3qiU1NqyakNKC3kFVQ9grhu6wdXgI8UCD5DVwddwiPa30xJThfQ9GDFYzEe4Xx1TIBoq1/EtfFr6geA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ysUn/+k5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ysUn/+k5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D5C11F000E9;
	Thu, 20 Aug 2026 17:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247889;
	bh=ZwgOlgwoDENggmO0gnQX4w1/TbMQfb6qpWGPxDoA0jA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ysUn/+k5gm6WvbmC6MtKJPEL0aglSomGIoo5UyfMMRCUxMdI9F2Qf/TBfIT8qe5PL
	 cw6TuSumQIQPdgam+SF/Pgmf1xAaSHigNZdU6ioGJHiI4QEFdjf0OK8tQagK9cYswS
	 R5YOD4Y605Yohg1ps/nXbJxWQbfOlAYyjPyXfPH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiming Zhu <zhuyiming@kuaishou.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.1 037/303] ceph: fix MDS random selection readiness predicate
Date: Thu, 20 Aug 2026 16:52:53 +0200
Message-ID: <20260820145254.301808945@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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
@@ -14,7 +14,7 @@
 #include "super.h"
 
 #define CEPH_MDS_IS_READY(i, ignore_laggy) \
-	(m->m_info[i].state > 0 && ignore_laggy ? true : !m->m_info[i].laggy)
+	(m->m_info[i].state > 0 && (ignore_laggy ? true : !m->m_info[i].laggy))
 
 static int __mdsmap_get_random_mds(struct ceph_mdsmap *m, bool ignore_laggy)
 {


