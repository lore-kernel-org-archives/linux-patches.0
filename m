Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F4B11C5D53;
	Wed, 19 Mar 2025 14:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394997; cv=none; b=eVdT6m3n6mesj2uVmfqAQoSWsDIpiXW+1OABpLGltAuta+QclWfoaDOdLXL2wqgUQeoaei6FCB2ZY22xRb4L6YfCHlhWxpI4SgYYbE2oVpeIrnlvvG7sDpY6AD1X2Sld1XGWYLbAp2Ei5ZpijvwkgiJ5+noaDtrY0q25HvfX5vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394997; c=relaxed/simple;
	bh=yFxCaxMlOLYbOAwS32sSfGCIid//5lPC7p5bYkii0fQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NiFN1crEAQ73LMpPy1QQ0jUATKnRtWfSu2P6nUtAjMn7Tx3s/VZ0LTTDCpvY5qXu1E20qcbhpfI1xTGboW2Zm8YsUsieEG9tILwZIXncOsNNRAdqb7yyjMzcgF04AyNZgNNumcvGW++J380NNTo5j9jCO1Mp52acNqFC8Y92KFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mabI6wHc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mabI6wHc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51E16C4CEE4;
	Wed, 19 Mar 2025 14:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394997;
	bh=yFxCaxMlOLYbOAwS32sSfGCIid//5lPC7p5bYkii0fQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mabI6wHcELnqsLQXhfZsUd+JEv20XkNPWsCXbKTE8GoivNQKpfNar6NjaY6wexGQK
	 Dt1ibdj3JcPSeesj22y/2rP9aBjZvI/WniPJQJBNJkttBjbeZ9cCn+huhfWP2uvfnb
	 LDbTzMEG8Uaiesjk2MjIUPkR29hhlQQKq9MaItow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Righi <arighi@nvidia.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.13 236/241] tools/sched_ext: Add helper to check task migration state
Date: Wed, 19 Mar 2025 07:31:46 -0700
Message-ID: <20250319143033.579609466@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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


