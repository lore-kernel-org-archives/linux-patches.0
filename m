Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7099937EFFE;
	Thu, 20 Aug 2026 15:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238851; cv=none; b=KCRLYWh6hLp1Ek060x+CBiWunrMHWiTXuyUfrP6ixw1WVivJdkHe3fG/f8THx6lTJfaYhDmrOa/OG4EThBXRjO+WeigGBarBAXBMS4nNHtCeQFFHIoXyk9S3x99qpQkxSyBlSzTXwTSf0V9JctUskJE979iXDt/kzV/cvkFrH2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238851; c=relaxed/simple;
	bh=x1qeAneW8gLVbk/L7dVbWpo0G13c/nVX/Mwp4cPZ7nc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MsVTOYTh6+IY+DAaEXS58VAhzuboGC6MzW9jnvQkkYJ9XWTMLO8fYuh+Fmch753bo1syU4b4GEnJJ5bvCHcG6nlDotCsQsRgBH7fXW4tNKRystPRn3yL5BhGPEzVbINZBfbQP7x8lAQZHySzSOQ2uiAxPJmZjGRBrkT6Fdbxvvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DgavWD+w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DgavWD+w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB4041F000E9;
	Thu, 20 Aug 2026 15:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238850;
	bh=dRSdZXDgKMOJ/MkLT2FopcDzKMTkCFdU5lNzmlm0KsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DgavWD+w4tf+vDwks3AT4I8lIOGiKcdMy61Og2aUlrqBxceF28vBoAs3XhzH8Qcir
	 qpTpKlY8smpAEU6DaDcmy9AnfrJwxrt4+Jfq6f0Y+b30F8/Yxv4pnWWi7s1gJmYE5J
	 42UPqr/t1ZxVkGw3lqKERYaCxj28/MZ7sVh9LdSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiming Zhu <zhuyiming@kuaishou.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.18 063/217] ceph: fix MDS random selection readiness predicate
Date: Thu, 20 Aug 2026 16:53:51 +0200
Message-ID: <20260820145239.517653827@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


