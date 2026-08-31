Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03308599A31;
	Mon, 31 Aug 2026 13:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184294; cv=none; b=gv2k/YMzJidYXegdQi+W1tX8iUJvxUBE+vhxodxgEV8jKdf0nBzYY29xbdf5NQPpyQ4pNtRvHa7vSCxmCvOGMB1p/GGEQhLN3l7xJFmiIuPh6fbkqpfFu/eDCI6hUeKdXcloAeSWY15tJbZuHV0YbyLEaXqQVMbjJmdQyH1WwwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184294; c=relaxed/simple;
	bh=BV81FqyIT8BVlKjhdy1qUvqJYDKpVd2vf5dGL/JKOFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GcHyYC5ngn+8SSRp4v7C8YaN5myz9kEfrMJ1y80477vLPWOlQAdvD831qqmbpMolqPcV9ZTfBRqb5MgZb23WVQkxP4/EZnfxuVhm8jn3KXYrmnG+iOoxeqn5NSSMbxl2KltfWOGqdoTuRtt9UyBJzUppey7vWsjqvATrP1pFBfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YARDxJdZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YARDxJdZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81E281F00A3E;
	Mon, 31 Aug 2026 13:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184292;
	bh=WFTfbcK4otYt3jpwLnO/8ESzLJc9jboGWz2kohh5Qqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YARDxJdZpUWgwBPNjyqANnso0NNDrWmgRny9hX/jkAJsr4ygJ0ACNle3kf68jxTjw
	 hhiRtHtivK/VJXXu1cZkGFmRBguf1wRukE4tIDKGgCtNSsaebtjVyY2FsKQhzovEEr
	 Yrlp0C6MVx+tjV2ElphDN8zA2/E2bX+PsP1byPYs5LGCI1ag5Nc6976u629Pvp0HqJ
	 0sUbd5HM5uzzvhQvlQucnPQr912e0FIk66P/CvdbGXh6/CYKPe23DH7vn2CPNZe1qG
	 OA8155AwPmriwk0tBysFCNxF4a6/JA1vhAYg0pv4Tv0hKo2lANxBhz2lyxLzJbD9gl
	 4rM5hr9Kf6lHQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
	kernel test robot <lkp@intel.com>,
	Dexuan Cui <dexuan@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] x86/topology: Add missing struct declaration and attribute dependency
Date: Mon, 31 Aug 2026 09:30:34 -0400
Message-ID: <20260831133314.4125787-606-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Transfer-Encoding: 8bit

From: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>

[ Upstream commit bdf5eb306c4d07a3bfdd4e2ab8f2acc7ff824940 ]

The prototypes for get_topology_cpu_type_name() and
get_topology_cpu_type() take a pointer to struct cpuinfo_x86, but
asm/topology.h neither includes nor forward-declares the structure.
Including asm/topology.h, directly or indirectly, without including
asm/processor.h triggers a warning:

    ./arch/x86/include/asm/topology.h:159:47: error: ‘struct cpuinfo_x86’
    declared inside parameter list will not be visible outside of this
    definition or declaration [-Werror]
    159 | const char *get_topology_cpu_type_name(struct cpuinfo_x86 *c);
        |                                               ^~~~~~~~~~~

Since only a pointer is needed, add a forward declaration of struct
cpuinfo_x86.

Additionally, sysctl_sched_itmt_enabled is declared in asm/topology.h with
the __read_mostly attribute, but the header does not include linux/cache.h.
This causes a build failure when including asm/topology.h but not linux/
cache.h:

     ./arch/x86/include/asm/topology.h:264:27: error: expected ‘=’, ‘,’,
     ‘;’, ‘asm’ or ‘__attribute__’ before ‘sysctl_sched_itmt_enabled’
     264 | extern bool __read_mostly sysctl_sched_itmt_enabled;
         |                           ^~~~~~~~~~~~~~~~~~~~~~~~~

Include the required header.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202511181954.UMxCeTV1-lkp@intel.com/
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202511190008.AA0NTn3G-lkp@intel.com/
Signed-off-by: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
Signed-off-by: Dexuan Cui <dexuan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The background search finished: `git log --grep='missing struct
declaration'` only turned up an unrelated `drm/i915/perf` commit, and
nothing matched `attribute dependency`. That confirms the topology
header fix isn’t in this v6.18.44 tree yet, which matches the earlier
analysis — the buggy code is still present and the patch should be
backported.

**YES**

 arch/x86/include/asm/topology.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index 21041898157a1..63489ec410320 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -156,6 +156,8 @@ extern unsigned int __max_threads_per_core;
 extern unsigned int __num_threads_per_package;
 extern unsigned int __num_cores_per_package;
 
+struct cpuinfo_x86;
+
 const char *get_topology_cpu_type_name(struct cpuinfo_x86 *c);
 enum x86_topology_cpu_type get_topology_cpu_type(struct cpuinfo_x86 *c);
 
@@ -259,6 +261,7 @@ extern bool x86_topology_update;
 
 #ifdef CONFIG_SCHED_MC_PRIO
 #include <asm/percpu.h>
+#include <linux/cache.h>
 
 DECLARE_PER_CPU_READ_MOSTLY(int, sched_core_priority);
 extern bool __read_mostly sysctl_sched_itmt_enabled;
-- 
2.53.0

