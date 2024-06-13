Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0453817FD;
	Thu, 13 Jun 2024 12:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282805; cv=none; b=U3RYqL/H/EWr4uF5NpaBSl1riWJoLEkaqhkBXSKie3MTO9o9/lq8f96CdXqDGn81ZQ72CDWcGfQ9aSGUPTwd5gb/Dg7ggd9dNCc66BG4qth/OjC5hwaKtEqpbjf4FlsDGicSYW7BHBINVGMC/458pd6RncXPC6wQZKYr2tSFcFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282805; c=relaxed/simple;
	bh=O2gVVyDUOfCiSkXK5EDqA6lQBDPptfFILxFm7T+cXx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PQRSZkF8Rc5ri4Qiz2gEOlMqc7iINz67CVenvPvxYI0bc9l4CcQPnCbAiSC9UE7DTVAf2CfhlL53UPtNp5VrISQFM1YJ+InYX8njJicgzu1X/UVgEuRY+MFKT7kqq/lb+YnJoHtobq2yCgJacJyZ+lsrG4BodeP69hIvBbGqRkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sak0KR+t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sak0KR+t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76C0EC2BBFC;
	Thu, 13 Jun 2024 12:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282804;
	bh=O2gVVyDUOfCiSkXK5EDqA6lQBDPptfFILxFm7T+cXx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sak0KR+to6Qqob1OXTu5Y5hkh37DK6MhYYjksNTdvCuNR7X6rRDVt4lhkPjIpKU7f
	 UgQeVUxkx4LGRFu4beBgoVQTjtq4RZLmxSrAJTBy4T7Yz+v8MQTf0uzgvk3iYanh6n
	 HA0AYmXizKCf0kU9dqJXiLAM8I7fUVAmXI7dZbfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam Ravnborg <sam@ravnborg.org>,
	Nick Bowler <nbowler@draconx.ca>,
	Andreas Larsson <andreas@gaisler.com>,
	"David S. Miller" <davem@davemloft.net>,
	Atish Patra <atish.patra@oracle.com>,
	Bob Picco <bob.picco@oracle.com>,
	Vijay Kumar <vijay.ac.kumar@oracle.com>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5.15 384/402] sparc64: Fix number of online CPUs
Date: Thu, 13 Jun 2024 13:35:41 +0200
Message-ID: <20240613113317.123499283@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sam Ravnborg <sam@ravnborg.org>

commit 98937707fea8375e8acea0aaa0b68a956dd52719 upstream.

Nick Bowler reported:
    When using newer kernels on my Ultra 60 with dual 450MHz UltraSPARC-II
    CPUs, I noticed that only CPU 0 comes up, while older kernels (including
    4.7) are working fine with both CPUs.

      I bisected the failure to this commit:

      9b2f753ec23710aa32c0d837d2499db92fe9115b is the first bad commit
      commit 9b2f753ec23710aa32c0d837d2499db92fe9115b
      Author: Atish Patra <atish.patra@oracle.com>
      Date:   Thu Sep 15 14:54:40 2016 -0600

      sparc64: Fix cpu_possible_mask if nr_cpus is set

    This is a small change that reverts very easily on top of 5.18: there is
    just one trivial conflict.  Once reverted, both CPUs work again.

    Maybe this is related to the fact that the CPUs on this system are
    numbered CPU0 and CPU2 (there is no CPU1)?

The current code that adjust cpu_possible based on nr_cpu_ids do not
take into account that CPU's may not come one after each other.
Move the chech to the function that setup the cpu_possible mask
so there is no need to adjust it later.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Fixes: 9b2f753ec237 ("sparc64: Fix cpu_possible_mask if nr_cpus is set")
Reported-by: Nick Bowler <nbowler@draconx.ca>
Tested-by: Nick Bowler <nbowler@draconx.ca>
Link: https://lore.kernel.org/sparclinux/20201009161924.c8f031c079dd852941307870@gmx.de/
Link: https://lore.kernel.org/all/CADyTPEwt=ZNams+1bpMB1F9w_vUdPsGCt92DBQxxq_VtaLoTdw@mail.gmail.com/
Cc: stable@vger.kernel.org # v4.8+
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Atish Patra <atish.patra@oracle.com>
Cc: Bob Picco <bob.picco@oracle.com>
Cc: Vijay Kumar <vijay.ac.kumar@oracle.com>
Cc: David S. Miller <davem@davemloft.net>
Reviewed-by: Andreas Larsson <andreas@gaisler.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20240330-sparc64-warnings-v1-9-37201023ee2f@ravnborg.org
Signed-off-by: Andreas Larsson <andreas@gaisler.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sparc/include/asm/smp_64.h |    2 --
 arch/sparc/kernel/prom_64.c     |    4 +++-
 arch/sparc/kernel/setup_64.c    |    1 -
 arch/sparc/kernel/smp_64.c      |   14 --------------
 4 files changed, 3 insertions(+), 18 deletions(-)

--- a/arch/sparc/include/asm/smp_64.h
+++ b/arch/sparc/include/asm/smp_64.h
@@ -47,7 +47,6 @@ void arch_send_call_function_ipi_mask(co
 int hard_smp_processor_id(void);
 #define raw_smp_processor_id() (current_thread_info()->cpu)
 
-void smp_fill_in_cpu_possible_map(void);
 void smp_fill_in_sib_core_maps(void);
 void cpu_play_dead(void);
 
@@ -77,7 +76,6 @@ void __cpu_die(unsigned int cpu);
 #define smp_fill_in_sib_core_maps() do { } while (0)
 #define smp_fetch_global_regs() do { } while (0)
 #define smp_fetch_global_pmu() do { } while (0)
-#define smp_fill_in_cpu_possible_map() do { } while (0)
 #define smp_init_cpu_poke() do { } while (0)
 #define scheduler_poke() do { } while (0)
 
--- a/arch/sparc/kernel/prom_64.c
+++ b/arch/sparc/kernel/prom_64.c
@@ -483,7 +483,9 @@ static void *record_one_cpu(struct devic
 	ncpus_probed++;
 #ifdef CONFIG_SMP
 	set_cpu_present(cpuid, true);
-	set_cpu_possible(cpuid, true);
+
+	if (num_possible_cpus() < nr_cpu_ids)
+		set_cpu_possible(cpuid, true);
 #endif
 	return NULL;
 }
--- a/arch/sparc/kernel/setup_64.c
+++ b/arch/sparc/kernel/setup_64.c
@@ -684,7 +684,6 @@ void __init setup_arch(char **cmdline_p)
 
 	paging_init();
 	init_sparc64_elf_hwcap();
-	smp_fill_in_cpu_possible_map();
 	/*
 	 * Once the OF device tree and MDESC have been setup and nr_cpus has
 	 * been parsed, we know the list of possible cpus.  Therefore we can
--- a/arch/sparc/kernel/smp_64.c
+++ b/arch/sparc/kernel/smp_64.c
@@ -1210,20 +1210,6 @@ void __init smp_setup_processor_id(void)
 		xcall_deliver_impl = hypervisor_xcall_deliver;
 }
 
-void __init smp_fill_in_cpu_possible_map(void)
-{
-	int possible_cpus = num_possible_cpus();
-	int i;
-
-	if (possible_cpus > nr_cpu_ids)
-		possible_cpus = nr_cpu_ids;
-
-	for (i = 0; i < possible_cpus; i++)
-		set_cpu_possible(i, true);
-	for (; i < NR_CPUS; i++)
-		set_cpu_possible(i, false);
-}
-
 void smp_fill_in_sib_core_maps(void)
 {
 	unsigned int i;


