Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1551F4195C0;
	Thu, 20 Aug 2026 16:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244030; cv=none; b=nNMG2drY3gJKsSngo5n8j4Y75TI5ERhd/Rp5TOw1SD9OIiyn7A0Dp5E7x6SRByrfQQGFOcErU303bZgZvXZmJyOpw75Lt/xFsl1rMxXHXlBty8jcqPTzqVPOWewE/zjyR45bIv8ybbYa1cACysiwubI4j9pihRV36XsSr/pYGJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244030; c=relaxed/simple;
	bh=RLjzp7enCuBWCNGBTB34QnnFpYk9om4CU8lG7/rStds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uiW9tQgRQDobiGA2w7QIyYOmXhvD/NogcA8DwGRa4FcFODbLtkKey+/Lquaq7KFuAg0iYajajekcg8OV4E/Zsm5cZ44cfJ6t6PflrNp5MIsxWOG05yMrYpYgHImAarFpebS3/KQQ+Hba7hS2q1sXRKyyjCtVjYInT1cmwfIWLT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TjsoUxJC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TjsoUxJC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7134A1F000E9;
	Thu, 20 Aug 2026 16:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244029;
	bh=YmcC03bkQUrWvTyCwBb4MVGCI4Ad8CZjL9My84dZis8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TjsoUxJC4YMw6971Jqj6ovTu4s3D+QqichhcApY5yi5a5TzdQjv07iUfha61KAuNX
	 CLN+ffgyr6fN3GgwH5sKWjo0gjkIzFds6Ux41al/RyO+z4ElS44fgTtq9xQSM4InKE
	 SqQSQySKAWg/EzyxtjRa70fpXRz/c3wqeDYq8G+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiming Zhu <zhuyiming@kuaishou.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 5.10 028/235] ceph: fix MDS random selection readiness predicate
Date: Thu, 20 Aug 2026 16:54:24 +0200
Message-ID: <20260820145217.291417135@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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


