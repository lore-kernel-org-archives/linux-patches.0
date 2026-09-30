Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BD345111AC;
	Wed, 30 Sep 2026 16:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785221; cv=none; b=d2w0RllZ3UBvKSUjSBzy08OBtiRA6vruvI9gXkNrdmkOf6D7ZHYr3VrKbIaJ0I1RNHTZp6Zn6rPO2sk4UBd6qcgAetaf1dR4yen4KwAOmLJFUVlgF+eaoNaArw9ziKx2ac6Jpl4pECTjYSdzY1ac7EeZpE4PDckfbBjbFD2Xq2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785221; c=relaxed/simple;
	bh=31TTsZaCok/O2IBJx38gWKj3UexUT8c37BnW672ZblY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YMZnPGgPIWC58rT8pIMDw0sEKoEBcVtKdiJBGcs1Vz3OiWcbow+ucpcrslvUCnQczTc/rxAdxqr0Cg3y59y5UVs3joXGf0ZN62pBql66zIwAAls1wpMLfBp+anJq65If+jYxOcuiIyN/Gk31CywuqCUa4FbaPdl94gq+TJPJz9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FlR0ulHD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FlR0ulHD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03C5B1F00893;
	Wed, 30 Sep 2026 16:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785217;
	bh=JruDyR1kne4TQzSuvWo73WyK/Sn46Qv7EszKIr9i6DU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FlR0ulHDzl6YGKQ8rlpXO00VsUQQt47Wni8AazpAkmKEXl1b9ut/9/EAYrHpSElFT
	 GaBb5fahXPkK6OgMu72DvyZhWDY2wu5sIdcAnOChGHEtHyQyrH1g/rXnRF5e63HtCs
	 VSJsuddLC0zMirgzKGulxqciZfQze8BzHeKaOrUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Allen Pais <allen.lkml@gmail.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 430/982] workqueue: Introduce from_work() helper for cleaner callback declarations
Date: Wed, 30 Sep 2026 17:19:26 +0200
Message-ID: <20260930152426.034743323@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

From: Allen Pais <apais@linux.microsoft.com>

[ Upstream commit 60b2ebf48526567b53e0188dbd1a4df8e646bcc1 ]

To streamline the transition from tasklets to worqueues, a new helper
function, from_work(), is introduced. This helper, inspired by existing
from_() patterns, utilizes container_of() and eliminates the redundancy
of declaring variable types, leading to more concise and readable code.

The modified code snippet demonstrates the enhanced clarity achieved
with from_wq():

  void callback(struct work_struct *w)
   {
     - struct some_data_structure *local = container_of(w,
						       struct some_data_structure,
						       work);
     + struct some_data_structure *local = from_work(local, w, work);

This change aims to facilitate a smoother transition and uphold code
quality standards.

Based on:
  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git disable_work-v3

Signed-off-by: Allen Pais <allen.lkml@gmail.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Stable-dep-of: 38b6be101006 ("net: macb: fix NULL pointer dereference on unbind with fixed-link")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/workqueue.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 5d052e193a85c..737219d7dd2b6 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -436,6 +436,9 @@ alloc_workqueue(const char *fmt, unsigned int flags, int max_active, ...);
 #define create_singlethread_workqueue(name)				\
 	alloc_ordered_workqueue("%s", __WQ_LEGACY | WQ_MEM_RECLAIM, name)
 
+#define from_work(var, callback_work, work_fieldname)	\
+	container_of(callback_work, typeof(*var), work_fieldname)
+
 extern void destroy_workqueue(struct workqueue_struct *wq);
 
 struct workqueue_attrs *alloc_workqueue_attrs(void);
-- 
2.53.0



