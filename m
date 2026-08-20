Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2BB133263B;
	Thu, 20 Aug 2026 15:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238230; cv=none; b=fE9lKwwPYPRaOCKk/t2AwYgszgMXwDO52jjJ3In659OICpzgtKTaYuP5+aaVfninFQ1KVmjgffRwVo1C16XIzB8ETYxP7Q/TR3Bi6sjiZAxXRQlaoNNXHxkNdpehSbbE3yLwXP5rE70HfinBz1XWbH1zexuPH2vkAdvY/6LeRSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238230; c=relaxed/simple;
	bh=jOj4haE7WirMcvFy0i8Licqx5wFxDHTDiIQaHDlds34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eemMQQt4SrCqQ4Y9EzC85+jvFDEMCLvPeBwHVoVoQJJI6O6BW0yUr37HpqjNAwOtmxLeyrzXBQd9bknLaoctaMu02gdtqu5f6aAQMlQIr15jjpwLiJcKEYDFyzuR49fokhYVuA5ZoBr+u6d/2Z1XgG00k7/rxUgzASB1UjsAq2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MJcgb4AT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MJcgb4AT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58B131F000E9;
	Thu, 20 Aug 2026 15:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238228;
	bh=NgsrD7dhKPMXtzcq3zN2kvpfZCSUwlcMFQnLrmkOsK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MJcgb4ATGjzLyRkDzC3iNgx57yIqPE+JUJP/hNfTLHyUJts21V9j/sOM1nFL/pXI3
	 BbMjpso0OpfqwHvK9Fs3Dt5DH1RHQH11rao264yAL3t+MdR369Lt1khTzJNS5Xqg/C
	 lJNjkIZ5Oc1QRUBlVEf6BcLFSt3AjUYP2UymUU8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiming Zhu <zhuyiming@kuaishou.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 7.1 076/228] ceph: fix MDS random selection readiness predicate
Date: Thu, 20 Aug 2026 16:53:38 +0200
Message-ID: <20260820145246.785935581@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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


