Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65FA9412BED;
	Sat, 12 Sep 2026 09:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206327; cv=none; b=huqZXdgNoqjzFv4t5GNQpsTrBC4H5xJyONoGF9H0jDnATlTD6NmUdpF4JT1FmZSos3M3csDyRdPXmQK5jsjUVL+5txXNaAKNZME+WaqSzY09eznjIAVsSJ/1e6wMYBAjr/Q+xg7HEqR0TCZooLipWKDGFPmTkWRM30MNOpL2AeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206327; c=relaxed/simple;
	bh=4fphM5FK8jqanjORgY3vm7yp/hYRpYC34XqtA0vhSeM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KjD5ryG5Dk3j5pIp/BPFzu1oz4QOOeSFnmeBVitwFM5uLGAm7NCWXC3oUsrpxYvc8Trr1PFxywe1M7qdyzZqo8SZdKo3gzJI/alMm97ng0XiD7aDT37FREK19Q5JHmfy2q8b8N61lHwTPIyk6mXSo50u1ZLdzRp7FL9vQuIppmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i7FGUZ6i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i7FGUZ6i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 289AF1F000FF;
	Sat, 12 Sep 2026 09:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206326;
	bh=4tduuKWkdVTF+9VobK8maUKR18o085UlHisRc5HDQRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i7FGUZ6iLm0GboIZseMmfbMWtM+GTd+A/s5QKnVVoLAVKz9GDFZ+Cs2WGaEF4z5Kk
	 zKcgHvsnkNN1uexwyCiINb75ryfreGoW+iV/aJMYDawDUIbuSwK5fH+jxfXdAkKMm6
	 zXYFrnsCkY24S+XN4e9OQiQsOfB9bA5tue2TDqho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zide Chen <zide.chen@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ian Rogers <irogers@google.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0142/1518] perf/x86/intel/uncore: Keep PCI PMUs working when MMIO/MSR setup fails
Date: Sat, 12 Sep 2026 08:38:31 +0200
Message-ID: <20260912065626.705586842@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 8301a589d9a61..a5793847ed5a9 100644
--- a/arch/x86/events/intel/uncore.c
+++ b/arch/x86/events/intel/uncore.c
@@ -1613,8 +1613,6 @@ static int uncore_event_cpu_online(unsigned int cpu)
 	die = topology_logical_die_id(cpu);
 	msr_ret = uncore_box_ref(uncore_msr_uncores, die, cpu);
 	mmio_ret = uncore_box_ref(uncore_mmio_uncores, die, cpu);
-	if (msr_ret && mmio_ret)
-		return -ENOMEM;
 
 	/*
 	 * Check if there is an online cpu in the package
-- 
2.53.0



