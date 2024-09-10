Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7326E18C02E;
	Tue, 10 Sep 2024 10:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964323; cv=none; b=tvdidtQ2pNH46NQAz4VcZ6H5oSJFySO4cPF7KaoVfXxWn2zrukI/rAFQ3krD23bipOF+n/2bE/HKym+r5ZatbQg+bxcMPiw2MYeYz/m50RVoSJRmCWKbxp5HFcsiNFT3jejUi5lLY83P9eNA/8E3/A0smjWi6DnTffm0KfW9C04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964323; c=relaxed/simple;
	bh=vmdxBA+k6ZyAtjBveOC1G2ur4VzLBpHRx3/KzgaIlmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l13hIbyk+LxlWd48QXnGlphyxZ+kHT/NqCn+bkm5KyPAeGiuEMsnBpEYmrNygCfYaBYztb4PH71xZbDANzWfaP3GaSjCdI5ODoc7HFstAnhdEGUKl81aPWLV488wcLBSHmCHeUHhQNZ2LK9tQZAbmcgWUqc7h+VQFlwMP/wgpCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M9nukwpx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M9nukwpx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE8E3C4CEC3;
	Tue, 10 Sep 2024 10:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964323;
	bh=vmdxBA+k6ZyAtjBveOC1G2ur4VzLBpHRx3/KzgaIlmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M9nukwpx7vljBAjdDHDgsNpzdHomJYCUrYNKltXIDFoN5A++lVLj4gYHL0aFM7TpJ
	 bNy878v1ir/rK2Rhb2rrnO3MfsHWVsTFn9ewBGf/fBQJ7OvBMyzAOLE23825zHrRcj
	 u7aQGjxOhxkDVocXZUgWhDXmk8oXJnwGCmH55fdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 143/269] cgroup: Protect css->cgroup write under css_set_lock
Date: Tue, 10 Sep 2024 11:32:10 +0200
Message-ID: <20240910092613.303159696@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Waiman Long <longman@redhat.com>

[ Upstream commit 57b56d16800e8961278ecff0dc755d46c4575092 ]

The writing of css->cgroup associated with the cgroup root in
rebind_subsystems() is currently protected only by cgroup_mutex.
However, the reading of css->cgroup in both proc_cpuset_show() and
proc_cgroup_show() is protected just by css_set_lock. That makes the
readers susceptible to racing problems like data tearing or caching.
It is also a problem that can be reported by KCSAN.

This can be fixed by using READ_ONCE() and WRITE_ONCE() to access
css->cgroup. Alternatively, the writing of css->cgroup can be moved
under css_set_lock as well which is done by this patch.

Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 5eca6281d1aa..660817c125e7 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -1829,9 +1829,9 @@ int rebind_subsystems(struct cgroup_root *dst_root, u16 ss_mask)
 		RCU_INIT_POINTER(scgrp->subsys[ssid], NULL);
 		rcu_assign_pointer(dcgrp->subsys[ssid], css);
 		ss->root = dst_root;
-		css->cgroup = dcgrp;
 
 		spin_lock_irq(&css_set_lock);
+		css->cgroup = dcgrp;
 		WARN_ON(!list_empty(&dcgrp->e_csets[ss->id]));
 		list_for_each_entry_safe(cset, cset_pos, &scgrp->e_csets[ss->id],
 					 e_cset_node[ss->id]) {
-- 
2.43.0



