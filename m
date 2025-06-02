Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7124B224B05;
	Mon,  2 Jun 2025 14:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873052; cv=none; b=pRSH4j/DaiEHtCXxeJyGHF0ZUO+PO+DGM2qWIK3/zXf9oLkpiRp0mXXbk6krM9oq1tPvG6A4W+dWyC4jRQkWP0/bTtsVl8FYie2GAkegToAof1Q6qMkwlotSrdgocCzPxueQ1xmWmcX04N+lETBkLyDRQoGJt/nLZKEbd+1+YwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873052; c=relaxed/simple;
	bh=R8781RJdCFUD7OdTo0d0FrbU/TM0RPgXQkjKZETR8Uc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FpYol2yz+X0Cu+v6sbh85jMEM4Qplo/SWMjwOUR/xggxGcePcm6daYp1O7qPglIFNvazCoeRsuNwuDgzJtgqWWk7pffvO5dMYxzybEXbO2z/+FanL25oGsGEq8M6cTQqmtHXzFlqbDpRRE1wcqQQeg8mEjjsIsYfNKKUVKe2Fn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I9z1cEP9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I9z1cEP9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC131C4CEEB;
	Mon,  2 Jun 2025 14:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873052;
	bh=R8781RJdCFUD7OdTo0d0FrbU/TM0RPgXQkjKZETR8Uc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I9z1cEP9tpIPYjF1Ed8TQXvyxIJLT9TBA+6Yy5bPjwl2wyss0VPnEmr4Xqk5hQAYG
	 repdcpBzB4fCr34JJBIXkqnSeaf9w/LDhdCgb/2c+EIs3O3KXhgWPAF6Lvmllz9do4
	 zyPIdNGcbOygy2ngDstq6OTZg/HSq+7F0hrUC2rA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	gao xu <gaoxu2@honor.com>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 023/444] cgroup: Fix compilation issue due to cgroup_mutex not being exported
Date: Mon,  2 Jun 2025 15:41:27 +0200
Message-ID: <20250602134341.857649868@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 3ccf80dfa587a..e8ef062f6ca05 100644
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



