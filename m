Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BAF6214A93;
	Mon,  2 Jun 2025 14:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875932; cv=none; b=qOaRDBT33kAqYG8S5vc+A9KVg8OJtAuBxCZZ+slcZCL+/CxmJFr53IA+y9c2eYkC6txYiQmlQr9GrF0yHXae8csT8dAIaXx7hcIPDFONB2giVF9UBs25pIvUnZbXVbLtW/RJXY9RrYkQaKUK523MK7T0z2ZWl90Liot2Pp2ZZwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875932; c=relaxed/simple;
	bh=4BttjvV21wArM7wsmjktHQbi8O9DnwprU1HTY6eBhGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jZ7kGcbPXZEd0q8R4uDiF43hkou/H3w75yi8jm19buiRQwLoRebG5BX6ouT+ctjJ+AmppXCGUhyAI6MqH+W+qm2hjLt1SlsdRQg1Q/IznXLY3EozQf/LE5Jq4MY9UqATXKETGZjils1+l+Tf1lU1sZ0rdJ7UVz3QB7Vu4s67P7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WLpZLIzV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WLpZLIzV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC4A1C4CEEB;
	Mon,  2 Jun 2025 14:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875932;
	bh=4BttjvV21wArM7wsmjktHQbi8O9DnwprU1HTY6eBhGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WLpZLIzV9Ag10ye5hmtZS3xPgEHmL9jljTuRHuYSSkjuJ9Tf8TVCP+fa4JRZM8t6V
	 8xWmu7C4nrq9BEEPY0pzxN+y8wet/HJz1hy5g+0r/nv04NdZZCfb+i1MYHc1xF9lYI
	 tcq/196TAC5A2LSZyJJtdiiYkq9w3RjTmZCRhVzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	gao xu <gaoxu2@honor.com>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 004/207] cgroup: Fix compilation issue due to cgroup_mutex not being exported
Date: Mon,  2 Jun 2025 15:46:16 +0200
Message-ID: <20250602134258.942478694@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 1e87257fe4692..1a3b2e1436db0 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -89,7 +89,7 @@
 DEFINE_MUTEX(cgroup_mutex);
 DEFINE_SPINLOCK(css_set_lock);
 
-#ifdef CONFIG_PROVE_RCU
+#if (defined CONFIG_PROVE_RCU || defined CONFIG_LOCKDEP)
 EXPORT_SYMBOL_GPL(cgroup_mutex);
 EXPORT_SYMBOL_GPL(css_set_lock);
 #endif
-- 
2.39.5



