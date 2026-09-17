Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4675E5218BE;
	Thu, 17 Sep 2026 16:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664200; cv=none; b=eRgsmTGLLDOmK4bo4jUHrX/5CNk6OBdV6YEmSqheqC6MAV/jphqrBkFiCFISjnEGqzHi9SrxqTnVxVmSencDwTbu1fWG1rK7r+oCMRoAoYh8Vf/6mUHfxkKWUI0zoEWWFIpsYG7CjfhIx/I/8bxsTr3Sn+05HLTjm7nas2s8iFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664200; c=relaxed/simple;
	bh=A5gyq/zmuJiY3bzTSsJGOtqvOzWzTnrn1ZyvVo9LFcE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OhYi64kf0lsADNsgfSZzTZOw2jIPQAPyczjhkcCmUPSngie0KtyND0PuZtbZolqFuLL5Nddvzh5juyUJ2axbsUp7AU34tH0K7CwHD9xrD4zp+j272GL3a41RzIdSIMEAQvEZgneT30dRTFRzvFPV+OvUitVnSom52mvxLJNxZWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EwQI0zxg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EwQI0zxg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D38C1F000FF;
	Thu, 17 Sep 2026 16:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664199;
	bh=lDj8Q2GccifCHzPysUjLFmk+2rCnQmos0llsYGBG9Q0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EwQI0zxg1nUGNHpV/k8t1b3R4xIIqU6LJpIlPQ6xUBpx4GS65a/3w1TBJjDpx6Tk2
	 EkaFWFpa/YBlJ9cU3HKSmxHabB63hf7hFja6D/kcJtFwU1MYovGGbETaPH+HLBC/ny
	 4Ip7JehlKcLW0f/PKXzgA91RdMF6uGBtH3e8cHxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
	Dexuan Cui <dexuan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0255/1250] x86/topology: Add missing struct declaration and attribute dependency
Date: Thu, 17 Sep 2026 16:00:50 +0100
Message-ID: <20260917151559.068455246@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

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



