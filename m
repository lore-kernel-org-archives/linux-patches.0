Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8ADD422094
	for <patches@lists.linux.dev>; Fri, 13 Jun 2025 16:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749833854; cv=none; b=gtpZxjLtnZfBUyAc0s2GnWw3V+aViRL4Bh7hpvApHu03InJDv9n4JnFr/nFdZrU4LfIETke2wKRnyE7m6txjPdGXfUHMQ8shRhrjTW3iI6E73I3mEOuoYB84yevu5NYqwFY3D/3y5kmlaN7lkN11yr29JvXHNpZVzZxPQo+3lKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749833854; c=relaxed/simple;
	bh=ZNbcIEXcQlkDEAo1JFwu7B5sDIunoFfI2hZA8W11ttg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kSVhwq7ItBtd9J3V87Klg8OBHYyK3g8AN9shVQM5knK9Kle7ZGnTl3pE8KFfqwgi/JMMiVnSvHbDXyCNEyQt7zsKTBVJeaXE4nziIqdGe8cwt/0hzXzkxggOADX0UdILfLuxsId2CI4fY1rmngvE0Y0jqDPi775kA9mYlTdQlg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 91EDA1C0A;
	Fri, 13 Jun 2025 09:57:11 -0700 (PDT)
Received: from [10.1.197.43] (eglon.cambridge.arm.com [10.1.197.43])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DC73E3F66E;
	Fri, 13 Jun 2025 09:57:29 -0700 (PDT)
Message-ID: <61133be0-1ace-457c-9b0f-d6dde3003389@arm.com>
Date: Fri, 13 Jun 2025 17:57:26 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 00/29] x86/resctrl telemetry monitoring
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>,
 Reinette Chatre <reinette.chatre@intel.com>,
 Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
 Peter Newman <peternewman@google.com>, Babu Moger <babu.moger@amd.com>,
 Drew Fustini <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>,
 Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
 Chen Yu <yu.c.chen@intel.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <20250521225049.132551-1-tony.luck@intel.com>
Content-Language: en-GB
From: James Morse <james.morse@arm.com>
In-Reply-To: <20250521225049.132551-1-tony.luck@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Tony,

I'm still going through this, but here is my attempt to describe what equivalents arm has
in this area.


On 21/05/2025 23:50, Tony Luck wrote:
> Background
> ----------
> 
> Telemetry features are being implemented in conjunction with the
> IA32_PQR_ASSOC.RMID value on each logical CPU. This is used to send
> counts for various events to a collector in a nearby OOBMSM device to be
> accumulated with counts for each <RMID, event> pair received from other
> CPUs. Cores send event counts when the RMID value changes, or after each
> 2ms elapsed time.

This is a shared memory area where an external agent (the OOBMSM) has logged measurement data?

Arm's equivalent to this is two things.
For things close to the CPU (e.g. stalls_llc_miss) these would be an PMU (possibly uncore
PMU) which follow a convention on their register layout meaning the general purpose pmu
driver should be able to drive them. The meaning of the events is described to user-space
via the perf json file. The kernel knows how to read event:6, but not what event:6 means.
The spec for this mentions MPAM, values can be monitored by ~RMID, but none of this is
managed by the MPAM driver.

The other thing arm has that is a bit like this is SCMI, which is a packet format for
talking to an on-die microcontroller to get platform specific temperature, voltage and
clock values. Again, this is another bit of kernel infrastructure that has its own way of
doing things. I don't see this filtering things by ~RMID ... but I guess its possible.
That can have shared memory areas (termed 'fast channels'). I think they are an array of
counter values, and something in the packet stream tells you which one is which.


Neither of these need picking up by the MPAM driver to expose via resctrl. But I'd like to
get that information across where possible so that user-space can be portable.


> Each OOBMSM device may implement multiple event collectors with each
> servicing a subset of the logical CPUs on a package.  In the initial
> hardware implementation, there are two categories of events: energy
> and perf.
> 
> 1) Energy - Two counters
> core_energy: This is an estimate of Joules consumed by each core. It is
> calculated based on the types of instructions executed, not from a power
> meter. This counter is useful to understand how much energy a workload
> is consuming.
> 
> activity: This measures "accumulated dynamic capacitance". Users who
> want to optimize energy consumption for a workload may use this rather
> than core_energy because it provides consistent results independent of
> any frequency or voltage changes that may occur during the runtime of
> the application (e.g. entry/exit from turbo mode).

> 2) Performance - Seven counters
> These are similar events to those available via the Linux "perf" tool,
> but collected in a way with much lower overhead (no need to collect data
> on every context switch).
> 
> stalls_llc_hit - Counts the total number of unhalted core clock cycles
> when the core is stalled due to a demand load miss which hit in the LLC
> 
> c1_res - Counts the total C1 residency across all cores. The underlying
> counter increments on 100MHz clock ticks
> 
> unhalted_core_cycles - Counts the total number of unhalted core clock
> cycles
> 
> stalls_llc_miss - Counts the total number of unhalted core clock cycles
> when the core is stalled due to a demand load miss which missed all the
> local caches
> 
> c6_res - Counts the total C6 residency. The underlying counter increments
> on crystal clock (25MHz) ticks
> 
> unhalted_ref_cycles - Counts the total number of unhalted reference clock
> (TSC) cycles
> 
> uops_retired - Counts the total number of uops retired
> 
> The counters are arranged in groups in MMIO space of the OOBMSM device.
> E.g. for the energy counters the layout is:
> 
> Offset: Counter
> 0x00	core energy for RMID 0
> 0x08	core activity for RMID 0
> 0x10	core energy for RMID 1
> 0x18	core activity for RMID 1
> ...

For the performance counters especially, on arm I'd be trying to get these values by
teaching perf about the CLOSID/RMID values, so that perf events are only incremented for
tasks in a particular control/monitor group.
(why that might be relevant is below)


> Resctrl User Interface
> ----------------------
> 
> Because there may be multiple OOBMSM collection agents per processor
> package, resctrl accumulates event counts from all agents on a package
> and presents a single value to users. This will provide a consistent
> user interface on future platforms that vary the number of collectors,
> or the mappings from logical CPUs to collectors.

Great!


> Users will continue to see the legacy monitoring files in the "L3"
> directories and the telemetry files in the new "PERF_PKG" directories
> (with each file providing the aggregated value from all OOBMSM collectors
> on that package).
> 
> $ tree /sys/fs/resctrl/mon_data/
> /sys/fs/resctrl/mon_data/
> ├── mon_L3_00
> │   ├── llc_occupancy
> │   ├── mbm_local_bytes
> │   └── mbm_total_bytes
> ├── mon_L3_01
> │   ├── llc_occupancy
> │   ├── mbm_local_bytes
> │   └── mbm_total_bytes

> ├── mon_PERF_PKG_00

Where do the package ids come from? How can user-space find out which CPUs are in package-0?

I don't see a package_id in either /sys/devices/system/cpu/cpu0/topology or
Documentation/ABI/stable/sysfs-devices-system-cpu.

> │   ├── activity
> │   ├── c1_res
> │   ├── c6_res
> │   ├── core_energy
> │   ├── stalls_llc_hit
> │   ├── stalls_llc_miss
> │   ├── unhalted_core_cycles
> │   ├── unhalted_ref_cycles
> │   └── uops_retired
> └── mon_PERF_PKG_01
>     ├── activity
>     ├── c1_res
>     ├── c6_res
>     ├── core_energy
>     ├── stalls_llc_hit
>     ├── stalls_llc_miss
>     ├── unhalted_core_cycles
>     ├── unhalted_ref_cycles
>     └── uops_retired

Looks good to me.

The difficulty MPAM platforms have had with mbm_total_bytes et al is the "starts counting
from the beginning of time" property. Having to enable mbm_total_bytes before it counts
would have allowed MPAM to report an error if it couldn't enable more than N counters at a
time. (ABMC suggests AMD platforms have a similar problem).


How do you feel about having to enable these before they start counting?

This would allow the MPAM driver to open the event via perf if it has a corresponding
feature/counter, then provide the value from perf via resctrl.


Another headache is how we describe the format of the contents of these files... a  made
up example: residency counts could be in absolute time, or percentages. I've been bitten
by the existing schemata strings being implicitly in a particular format, meaning
conversions have to happen. I'm not sure whether some architecture/platform would trip
over the same problem here.


> Resctrl Implementation
> ----------------------
> 
> The OOBMSM driver exposes "intel_pmt_get_regions_by_feature()"
> that returns an array of structures describing the per-RMID groups it
> found from the VSEC enumeration. Linux looks at the unique identifiers
> for each group and enables resctrl for all groups with known unique
> identifiers.
> 
> The memory map for the counters for each <RMID, event> pair is described
> by the XML file. This is too unwieldy to use in the Linux kernel, so a
> simplified representation is built into the resctrl code.

(I hope there are only a few combinations!)


> Note that the
> counters are in MMIO space instead of accessed using the IA32_QM_EVTSEL
> and IA32_QM_CTR MSRs. This means there is no need for cross-processor
> calls to read counters from a CPU in a specific domain.

Huzzah! RISC-V has this property, and many MPAM platforms do, (...but not all...)


> The counters can be read from any CPU.
> 
> High level description of code changes:
> 
> 1) New scope RESCTRL_PACKAGE
> 2) New struct rdt_resource RDT_RESOURCE_PERF_PKG
> 3) Refactor monitor code paths to split existing L3 paths from new ones. In some cases this ends up with:
>         switch (r->rid) {
>         case RDT_RESOURCE_L3:
>                 helper for L3
>                 break;
>         case RDT_RESOURCE_PERF_PKG:
>                 helper for PKG
>                 break;
>         }
> 4) New source code file "intel_aet.c" for the code to enumerate, configure, and report event counts.
> 
> With only one platform providing this feature, it's tricky to tell
> exactly where it is going to go. I've made the event definitions
> platform specific (based on the unique ID from the VSEC enumeration). It
> seems possible/likely that the list of events may change from generation
> to generation.

My thinking about this from a perf angle was to have named events for those things that
resctrl supports, but allow events to be specified by number, and funnel those through
resctrl_arch_rmid_read() so that the arch code can interpret them as a counter type-id or
an offset in some array. The idea was to allow platform specific counters to be read
without any kernel changes, reducing the pressure to add resctrl support for counters that
may only ever be present in a single platform.

With the XML data you have, would it be possible to add new 'events' to this interface via
sysfs/configfs? Or does too much depend on the data identified by that GUID...


Thanks,

James
