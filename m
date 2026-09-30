Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 014083D9DBF;
	Wed, 30 Sep 2026 19:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795306; cv=none; b=H8fg9pRt1bDEcY6ENIpTYpL5bxP7yxMa7dVy3tGUZJ60Cnt+lSlPh78yMrr8lVQXAl/QvVpGVwH0Tb3Wr0R3lWcdk7f2mWd5decrKIK5xuXjjSASsytMJ0AZblU/TKM509ZWw1LsYE0YYhlGageDQKLbf2jox8eI4q3Hn8u60ZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795306; c=relaxed/simple;
	bh=ktmtNQ4+ODapEoPwgEwdnW9wBZjbjNXPkScY2LMfpSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=keBVX1EGr9sk5A+ehz2EoCASNPIKZPFdKvEGwvkigKQ2SJqo7ldlmxQiGKIT5XrCZGiVtGnXHXyr+FfpGFDJs7v7m7G8KPsyw5cSk+WF1WjrfOCad9SsVH/GtrCGjA2DJ2TzqSZkJ5kZyTrdJ2RabcGHZrJzOOQNF+lvhzWD7LQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xowttYib; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xowttYib"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 539FC1F000FF;
	Wed, 30 Sep 2026 19:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795304;
	bh=etugZ8agjeQqPVlGyOT7JDj6PMJiEFwtcEquGVBKZCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xowttYibaajkrfayUPPQbcbT12rcFc5tNkAOrk4pvbqnSSYEXaU1fbvgioEoecZVg
	 3oe0PoNS/D5HiANGFU5wKS+9npNFzy8V0eOHG+hyV41zwy4+NAdtIGJkH/xM9CSi33
	 dcKZSevc3URH95ILYpsxLBqEP5BslAJxfQAYY2BQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Allen Pais <allen.lkml@gmail.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0513/1193] workqueue: Introduce from_work() helper for cleaner callback declarations
Date: Wed, 30 Sep 2026 17:19:57 +0200
Message-ID: <20260930152445.564692490@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
index 0abbc3b67d29b..c01adbc2910ec 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -487,6 +487,9 @@ alloc_workqueue(const char *fmt, unsigned int flags, int max_active, ...);
 #define create_singlethread_workqueue(name)				\
 	alloc_ordered_workqueue("%s", __WQ_LEGACY | WQ_MEM_RECLAIM, name)
 
+#define from_work(var, callback_work, work_fieldname)	\
+	container_of(callback_work, typeof(*var), work_fieldname)
+
 extern void destroy_workqueue(struct workqueue_struct *wq);
 
 struct workqueue_attrs *alloc_workqueue_attrs(void);
-- 
2.53.0



