Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 298ED1CAA68;
	Wed, 19 Feb 2025 08:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955465; cv=none; b=py4BsTktFDevcv0WNmre1DEY1KRNuMx2DvZ0hdqQg9fqz2wd0E0gMbknQPdvXx4VRYCCI2G0FxZ7+Xn5Xr2fG4kONvppx187xjcIPsA1KjwuxCU02u405FnWDXAVDUxANM/q+VdlCHI326OcHWqkuCI/6qUxKt0Hi5uVCfS+Fsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955465; c=relaxed/simple;
	bh=1Qsr1RJz9J1ed0RKo//WWSLJvRCmoF+2XwZxPJZYHCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R6Ojx/zg4RakAMrsf5zpHbR6MNqRLg4FD2X4YlzdMnItdHePhPfpJN9OmjF4BdF2zCI+KXV+/GXUNO81wr+QBp/nuf41WE7+dwLh3uXtl7nNi/4cS+9vMRylI1M6obm4httbLEGKF5Sa6aqTy0pReyEvPIjfP+qpUZZyTlK/tII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M3STIGHc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M3STIGHc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0F42C4CED1;
	Wed, 19 Feb 2025 08:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955465;
	bh=1Qsr1RJz9J1ed0RKo//WWSLJvRCmoF+2XwZxPJZYHCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M3STIGHcUjinq68Niu1YwFPgbUOepLucNBdqXoSn1rV/oGravrMYO/mbFaF/o4u3Y
	 bG7bPt0hbgTEY0pLtK1Ux8Ha44tgo4E2KeEScwKN9d4N3OSnSV3j8c4DFQ5SV1eFP4
	 wtbHiCJCMskF8E2NRfssZPVsJvcVAykxeVoohJF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Axel Busch <axel.busch@ibm.com>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Muhammad Adeel <muhammad.adeel@ibm.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 015/152] cgroup: Remove steal time from usage_usec
Date: Wed, 19 Feb 2025 09:27:08 +0100
Message-ID: <20250219082550.629968056@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082550.014812078@linuxfoundation.org>
References: <20250219082550.014812078@linuxfoundation.org>
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
index d80d7a6081412..c32439b855f5d 100644
--- a/kernel/cgroup/rstat.c
+++ b/kernel/cgroup/rstat.c
@@ -469,7 +469,6 @@ static void root_cgroup_cputime(struct cgroup_base_stat *bstat)
 
 		cputime->sum_exec_runtime += user;
 		cputime->sum_exec_runtime += sys;
-		cputime->sum_exec_runtime += cpustat[CPUTIME_STEAL];
 
 #ifdef CONFIG_SCHED_CORE
 		bstat->forceidle_sum += cpustat[CPUTIME_FORCEIDLE];
-- 
2.39.5



