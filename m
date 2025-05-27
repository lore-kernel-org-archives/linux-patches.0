Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 118D127C856;
	Tue, 27 May 2025 16:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364336; cv=none; b=MjLq7HCaXLLZJV5ZT9TeVbCbpPzr3BWpIdtbBjQ3J/dWzN3qNUwOhhbbeM0Xa0uJ3cOt5SAsBupkBX73cTf73gBb33tpgYeMkOsgyoGbSl5Y2Eh6dceLMCRLm5SLTxY/qPzQDPeiXi37ASFPh1XFsAcf4dc4SjVqHOUKkc7VEE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364336; c=relaxed/simple;
	bh=bmOb30sKa70WIX/AM/DLicQd4vguY0/jAlPsJJXiXHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=facj+WESf3SAOVhc3NcvP1X/zC6qy6ePBm9n7BqXjaUDZDJHTCEfL62+0PLWTcZnsRTV5WSet1Fh4IsIxmtquQx222/xWNA6bQd+XH5nwNFvYAKZzkhrwYNk/yPzH3mV2OfvtuyR26K5TSLVvBVjd3Ttd3PDdNoSVDXXy7MWlf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l3/zdGpN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l3/zdGpN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 934EEC4CEE9;
	Tue, 27 May 2025 16:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364335;
	bh=bmOb30sKa70WIX/AM/DLicQd4vguY0/jAlPsJJXiXHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l3/zdGpN0nz/pC1giYTzD7M2Q0870t2ErZb1cGLjungmDNwQ38mO1TS4dnX3qB30t
	 dhkjr3UfF0P/iyRI6r7cffPidxfB6ON6IwhUZ/Cw+0n5efB03M+Iy4dYpNhIDMHT9f
	 kHjBVVvTj8CuXiFgE7+OLLBpzRHy8U63XyfZuuMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	gao xu <gaoxu2@honor.com>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 024/626] cgroup: Fix compilation issue due to cgroup_mutex not being exported
Date: Tue, 27 May 2025 18:18:37 +0200
Message-ID: <20250527162446.054571661@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: gaoxu <gaoxu2@honor.com>

[ Upstream commit 87c259a7a359e73e6c52c68fcbec79988999b4e6 ]

When adding folio_memcg function call in the zram module for
Android16-6.12, the following error occurs during compilation:
ERROR: modpost: "cgroup_mutex" [../soc-repo/zram.ko] undefined!

This error is caused by the indirect call to lockdep_is_held(&cgroup_mutex)
within folio_memcg. The export setting for cgroup_mutex is controlled by
the CONFIG_PROVE_RCU macro. If CONFIG_LOCKDEP is enabled while
CONFIG_PROVE_RCU is not, this compilation error will occur.

To resolve this issue, add a parallel macro CONFIG_LOCKDEP control to
ensure cgroup_mutex is properly exported when needed.

Signed-off-by: gao xu <gaoxu2@honor.com>
Acked-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index e63d6f3b00470..62933468aaf46 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -90,7 +90,7 @@
 DEFINE_MUTEX(cgroup_mutex);
 DEFINE_SPINLOCK(css_set_lock);
 
-#ifdef CONFIG_PROVE_RCU
+#if (defined CONFIG_PROVE_RCU || defined CONFIG_LOCKDEP)
 EXPORT_SYMBOL_GPL(cgroup_mutex);
 EXPORT_SYMBOL_GPL(css_set_lock);
 #endif
-- 
2.39.5



