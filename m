Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E9491DE4C9;
	Wed, 19 Mar 2025 14:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395152; cv=none; b=lgBl+B7ZOJs/5Ae/LavbZymNd3o8rwkCb5U0WNW3INWQ1RgCMoo4XqJhC8i+tIb2hGPkMMsSDjWAZxxj6Vu+JerEet26Si5fn8FvAoPzuy2KYrCQEtXKSS4aWJ/DqIBbLf3LjfdSgOYmMEGsie9rKuOiyEJWeNgCbnMr/SJC1us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395152; c=relaxed/simple;
	bh=IZc+1CsldkWqz1WmVsQaQKJs5lnbAsKF/CnHkIED7uM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SKJJKJz3fHJsKhbfDOHX9us8qjVPcFEOkLigsNVATTg14XaMJpWzArEhPpQ1YKKUtcLiXwwr1RduNiuqboHGix6+JxWK2WlSMj/XdMhNakMwha7QmmppA7JctOkRYhXI4KYlexa97GWLr5ZveejvrkU1ugDcZ/nn2cHpPjJwp1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AYoXVsBt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AYoXVsBt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4186BC4CEE4;
	Wed, 19 Mar 2025 14:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395152;
	bh=IZc+1CsldkWqz1WmVsQaQKJs5lnbAsKF/CnHkIED7uM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AYoXVsBtIamkQ21hoTpm+xhB3e41WZFUj9KRlIAaFWJLaOY05opwD194PH2cTDBKC
	 Rpv0MQAP+f5eCXH5VFTKL7FybTDelvmsmG+9NHnIRvt1d7CnhaJP06iDfImWuW/GLf
	 NszUKnbd/KG+H70MpsvESbwxayZHLDZiKGfWRU40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Righi <arighi@nvidia.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.12 227/231] tools/sched_ext: Add helper to check task migration state
Date: Wed, 19 Mar 2025 07:32:00 -0700
Message-ID: <20250319143032.447732222@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrea Righi <arighi@nvidia.com>

commit 5f52bbf2f6e0997394cf9c449d44e1c80ff4282c upstream.

Introduce a new helper for BPF schedulers to determine whether a task
can migrate or not (supporting both SMP and UP systems).

Fixes: e9fe182772dc ("sched_ext: selftests/dsp_local_on: Fix sporadic failures")
Signed-off-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/sched_ext/include/scx/common.bpf.h |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/tools/sched_ext/include/scx/common.bpf.h
+++ b/tools/sched_ext/include/scx/common.bpf.h
@@ -333,6 +333,17 @@ static __always_inline const struct cpum
 	return (const struct cpumask *)mask;
 }
 
+/*
+ * Return true if task @p cannot migrate to a different CPU, false
+ * otherwise.
+ */
+static inline bool is_migration_disabled(const struct task_struct *p)
+{
+	if (bpf_core_field_exists(p->migration_disabled))
+		return p->migration_disabled;
+	return false;
+}
+
 /* rcu */
 void bpf_rcu_read_lock(void) __ksym;
 void bpf_rcu_read_unlock(void) __ksym;


