Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 005FC377A89;
	Thu, 20 Aug 2026 16:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243276; cv=none; b=eK2FfP5cOezDtrQgZKFlWD8staugxBpiz4wN77U1GW/CkUXOXvbFIo3DFGwhwF+GtZThzLgiOFXAa3GTQD2EoDHB3MMncQskPJM9+M/GWZlPns0DcUIFCrLRf8NQhxCqLbh0BTFgG4uxnOrDcXKJ1XTnnaM4hBh2wZ5clhXKubI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243276; c=relaxed/simple;
	bh=FXlmuB0RPGjlumNWTNz4uUI6AW9Gyl+8TQ12tOWmPSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uCb04Le6bjDe35AW1R42oLZ9PAj7fi83tY6LMZNWRQIy78JCqTxIxeZWrRKK6udsdrXtCIsX+YB2si9OXnR9SoK0JeZtb5dXIAOuWRpEoFyRttZfPeF5qnuy6UcwuYSI/u6Ltpo37sRJIuDb4jNGjFsDZErj9RqjsoOHxts5NNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iht5KPXs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iht5KPXs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E9031F00A3A;
	Thu, 20 Aug 2026 16:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243274;
	bh=osXQBwaHRQRXVlvzTpsoExWu3uJ0bFIWJdrg0krMoeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iht5KPXsBIJRfbxZNXdtr5tkOexhjU5q7i0BdMq/vUe/EVoxkZYD+bECmBJvxRjH7
	 1CZPVYS3KkxgEa5yJ28bIWcCfo4DU+viRJTae7FpGfRJnP0xsMyJeh4bHYaHr1xtFY
	 ZeX/i4RFjzXQ45M81LKBw0io1VuDT3sUmHCI3uOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiming Zhu <zhuyiming@kuaishou.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 5.15 031/272] ceph: fix MDS random selection readiness predicate
Date: Thu, 20 Aug 2026 16:53:35 +0200
Message-ID: <20260820145232.163935759@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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


