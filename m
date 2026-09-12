Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4287B37F729;
	Sat, 12 Sep 2026 07:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197101; cv=none; b=HzbeaZmfC8U9P5CgkF0fP720LOonHmhBkD4fHsO0EyFhgd2qmwaxQjIS8bGmScrnRAMGiH3fKqbYLrKaVhwehQ76twAWHPj6SwEr9b0K/SlHBjKPhd1t+2v/YDwVqS8wzq4ywdzFUN5806L85yh/RU5T4nHkSn88qZ2FB6eoTvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197101; c=relaxed/simple;
	bh=7jpMQ1FGMD/VZbp6doj0luPygqXRnEYarORJb4J2yLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SFwr4rhIv53eIJfoEOTYBq3mPT4pmsjpmjEo/SzlPGitPYDf6K8UVRP+zoXY26urYGosgx05j2VxcWUmBoWTkp9k/uPB95Ku5dpwY0Qzg9S0PsQCg23RyCoK2PfJs9bfrznkiyDSS6m9lTCEEQ9gcUsnctZXppJ98ORgjgRIXrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zPKW6WEV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zPKW6WEV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDACA1F000FF;
	Sat, 12 Sep 2026 07:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197100;
	bh=ZT3JwjjB2l1uONlpo7Eok93PSLI6HiycC6HqNARxvxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zPKW6WEVCnj/0WP6TUeM6zBoymIDajfc7Slb1TQ8twpKPAeVs3GrWzFXeOJojwsw5
	 yv8rSTxQk32mXDvw0uLmH8DnJ2x+T5K2dOXPpZJRaXmsB/pcvBobbt4u27AVjT1jBj
	 m9KFbu+Fys3k+jRtTeRYhWHrwxqE44lghCbzWl2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zide Chen <zide.chen@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ian Rogers <irogers@google.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0102/1815] perf/x86/intel/uncore: Keep PCI PMUs working when MMIO/MSR setup fails
Date: Sat, 12 Sep 2026 08:30:52 +0200
Message-ID: <20260912065651.402701873@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zide Chen <zide.chen@intel.com>

[ Upstream commit 3012af7df3430788eddd30b3c6654d0a0a5f06c6 ]

uncore_event_cpu_online() returns -ENOMEM early when both the MSR and
MMIO box allocations fail.  This also aborts PCI uncore setup, even
though PCI PMUs are independent of the MSR/MMIO paths.

Remove the early return so PCI uncore setup always runs regardless
of whether MSR or MMIO box allocation succeeds.

Fixes: 3da04b8a00dd ("perf/x86/intel/uncore: Support MMIO type uncore blocks")
Signed-off-by: Zide Chen <zide.chen@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Ian Rogers <irogers@google.com>
Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Link: https://patch.msgid.link/20260611160033.66760-5-zide.chen@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/uncore.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/events/intel/uncore.c b/arch/x86/events/intel/uncore.c
index 7857959c6e823..cb61f2a65d853 100644
--- a/arch/x86/events/intel/uncore.c
+++ b/arch/x86/events/intel/uncore.c
@@ -1631,8 +1631,6 @@ static int uncore_event_cpu_online(unsigned int cpu)
 	die = topology_logical_die_id(cpu);
 	msr_ret = uncore_box_ref(uncore_msr_uncores, die, cpu);
 	mmio_ret = uncore_box_ref(uncore_mmio_uncores, die, cpu);
-	if (msr_ret && mmio_ret)
-		return -ENOMEM;
 
 	/*
 	 * Check if there is an online cpu in the package
-- 
2.53.0



