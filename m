Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 312CA1CAA6F;
	Wed, 19 Feb 2025 08:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739953935; cv=none; b=ZNEHaF4pnaufZga41CCvQnfp5twnZlyPg+E5+u4z/b1sEPH7w/l7fodOlJAVxzs7ONnEVst8RKOcBbkItTcSPlpGRx+W5nBxdgfnA6AZHM0b3OJWfyYi7RK6p2t6HWkHzwANA3aruXGfkifBkcxejNlar1b5xsuQANjTo65kAg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739953935; c=relaxed/simple;
	bh=MRK73paQdeqRSiFiMqxavWDrGk2eXS04lJF6LLNxHgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L9MqqBkQaB9j/KaVh+LXcfckTAxHchZfc9iCHGfEYi7f6E7P5ic/TihD7KN5hwvxcXC9EE5OVnkL/X1OeyaFBHy4Sl1KF19ivD8kKsmnsL1d1A7sC1VrZm8IAGiby3Z4RXx8dhflyhP0AcViCO43RMRKWWykqdXJgV2VReFau0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xfmUdqZG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xfmUdqZG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A49F3C4CED1;
	Wed, 19 Feb 2025 08:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739953935;
	bh=MRK73paQdeqRSiFiMqxavWDrGk2eXS04lJF6LLNxHgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xfmUdqZGeFa5pInZtnvMP4jEe2EmRXHoSRquvawOJJb298nNW1JC60PQ52u9sV7/a
	 TwibQrFRpikqE5BnJxGpmMKjb6uhwFxnqozS8SknEqWJG5UzG5LypUWkMliglD5v3P
	 43x3O1ZKAeKsrr6y7l+mi5mpQ5jhYT6sDLh49XXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Axel Busch <axel.busch@ibm.com>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Muhammad Adeel <muhammad.adeel@ibm.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 044/274] cgroup: Remove steal time from usage_usec
Date: Wed, 19 Feb 2025 09:24:58 +0100
Message-ID: <20250219082611.248569345@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 5877974ece92c..aac91466279f1 100644
--- a/kernel/cgroup/rstat.c
+++ b/kernel/cgroup/rstat.c
@@ -590,7 +590,6 @@ static void root_cgroup_cputime(struct cgroup_base_stat *bstat)
 
 		cputime->sum_exec_runtime += user;
 		cputime->sum_exec_runtime += sys;
-		cputime->sum_exec_runtime += cpustat[CPUTIME_STEAL];
 
 #ifdef CONFIG_SCHED_CORE
 		bstat->forceidle_sum += cpustat[CPUTIME_FORCEIDLE];
-- 
2.39.5



