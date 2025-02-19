Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A01D1EE7BE;
	Wed, 19 Feb 2025 08:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954792; cv=none; b=FRciQq1r+W9tNjw2lHvNj7iW1hh+jhq2cpseictT0l6/4Fhd8VuMd+WlOev6j0E0pBq4C6s9cmCPHEvHVlRIl9blk+shmuLD2xlhOqhy+/0opCGowpH2mYiZ1QqgI/DrVIFgd5QEmC9IPcohBVz1j3aFVwTQGwWoE6SeRmkN1Ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954792; c=relaxed/simple;
	bh=+YC0PFeNjqTeV9c7l5/FNa7NgdjnjoKZItFo6GXmELo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r1w5d8XyyuXAay/2EAKl/+wUBjT6vHPoriNzeuhJRASe1IxSGNtp8vKUJh3PEiASsTkkj/tHp5LWkwLID4zpbptRjyuuHAxeLexFrYK4SlEzeUkBX63c/1GzzX27bBdJzAOrMBnSDEe6PcGtlWz5FZyDE0F5ayUR/nn1v0fzkfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bPc8ryZQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bPc8ryZQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D984C4CED1;
	Wed, 19 Feb 2025 08:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954792;
	bh=+YC0PFeNjqTeV9c7l5/FNa7NgdjnjoKZItFo6GXmELo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bPc8ryZQtakiwgsNeUhbQTqfZAX8BnbjOoFWWK/wCBMiGmXzQ/p+LBST/3bk4vPsS
	 DgTdpZllXLTQRmbioK7JauhX6hPW9D0OWoHiXQzA1RGG0rWY48wztaSXXkTnwwYLKI
	 yXXj0mhTbwyyK5GHcboP1R0F1GtYMV3dX4Qac0nk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Axel Busch <axel.busch@ibm.com>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Muhammad Adeel <muhammad.adeel@ibm.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 038/230] cgroup: Remove steal time from usage_usec
Date: Wed, 19 Feb 2025 09:25:55 +0100
Message-ID: <20250219082603.201186615@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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

From: Muhammad Adeel <Muhammad.Adeel@ibm.com>

[ Upstream commit db5fd3cf8bf41b84b577b8ad5234ea95f327c9be ]

The CPU usage time is the time when user, system or both are using the CPU.
Steal time is the time when CPU is waiting to be run by the Hypervisor. It
should not be added to the CPU usage time, hence removing it from the
usage_usec entry.

Fixes: 936f2a70f2077 ("cgroup: add cpu.stat file to root cgroup")
Acked-by: Axel Busch <axel.busch@ibm.com>
Acked-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Muhammad Adeel <muhammad.adeel@ibm.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/rstat.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
index a06b452724118..ce295b73c0a36 100644
--- a/kernel/cgroup/rstat.c
+++ b/kernel/cgroup/rstat.c
@@ -586,7 +586,6 @@ static void root_cgroup_cputime(struct cgroup_base_stat *bstat)
 
 		cputime->sum_exec_runtime += user;
 		cputime->sum_exec_runtime += sys;
-		cputime->sum_exec_runtime += cpustat[CPUTIME_STEAL];
 
 #ifdef CONFIG_SCHED_CORE
 		bstat->forceidle_sum += cpustat[CPUTIME_FORCEIDLE];
-- 
2.39.5



