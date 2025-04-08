Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 639361FBCB2;
	Tue,  8 Apr 2025 11:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110506; cv=none; b=iWvmgFYFAqgWFy16aHNGF4dMHwTDv+n06r6xDX3WTUFSdTKxx0ekVNEbp9OQWpeIqIFZzODSySqECwrtRVE3rHNFnmrwJ0d9pwSIvBGwWNpfgbKaLyy1JO7FBlfsIHuTekASCGw1q79yGmHf/aAUwaTkGNyN+AkGpqsAqAOJDIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110506; c=relaxed/simple;
	bh=j93atKpkvIL7wTiCYkFwV8ZJIoqyuuwNztd3m9lIVZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ozdTfEb7GfutN+fwtOUT1xDcwoZJpGltvHbSud4iBNQjUSX6LomxAQqOo86eRctAa4pEtz7LSk2Ws0WpVpO1P2juC/yjpU3m3EhUAhdoZ/XBgpC2HSWmZ8QkJ9N/BqnTBhKZIKY5TuqDMLcok3s7ttdzWxATpqCXdMNDjHLXw1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0+j1vjyA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0+j1vjyA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2965C4CEE5;
	Tue,  8 Apr 2025 11:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110506;
	bh=j93atKpkvIL7wTiCYkFwV8ZJIoqyuuwNztd3m9lIVZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0+j1vjyAVi4TOCB3MxfAizivM5TIVW6p0ocn+wfCexoUn3I/dApBeHpdYbY6i6FJ6
	 PiMS0ne7jsxZp8SR5k8if3OH0jV5iFjwkAf6RW6raoqahyY3gNzFOH3dD2hwMhOzl2
	 D1nmTudx3RPDlZV3RtY/8hkjrdN8vd87hyWnD5AM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Morse <james.morse@arm.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>,
	David Hildenbrand <david@redhat.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Fenghua Yu <fenghuay@nvidia.com>,
	Babu Moger <babu.moger@amd.com>,
	Peter Newman <peternewman@google.com>,
	Sasha Levin <sashal@kernel.org>,
	Carl Worth <carl@os.amperecomputing.com>,
	Amit Singh Tomar <amitsinght@marvell.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>
Subject: [PATCH 6.14 039/731] x86/resctrl: Fix allocation of cleanest CLOSID on platforms with no monitors
Date: Tue,  8 Apr 2025 12:38:56 +0200
Message-ID: <20250408104915.184392117@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Morse <james.morse@arm.com>

[ Upstream commit a121798ae669351ec0697c94f71c3a692b2a755b ]

Commit

  6eac36bb9eb0 ("x86/resctrl: Allocate the cleanest CLOSID by searching closid_num_dirty_rmid")

added logic that causes resctrl to search for the CLOSID with the fewest dirty
cache lines when creating a new control group, if requested by the arch code.
This depends on the values read from the llc_occupancy counters. The logic is
applicable to architectures where the CLOSID effectively forms part of the
monitoring identifier and so do not allow complete freedom to choose an unused
monitoring identifier for a given CLOSID.

This support missed that some platforms may not have these counters.  This
causes a NULL pointer dereference when creating a new control group as the
array was not allocated by dom_data_init().

As this feature isn't necessary on platforms that don't have cache occupancy
monitors, add this to the check that occurs when a new control group is
allocated.

Fixes: 6eac36bb9eb0 ("x86/resctrl: Allocate the cleanest CLOSID by searching closid_num_dirty_rmid")
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Fenghua Yu <fenghuay@nvidia.com>
Reviewed-by: Babu Moger <babu.moger@amd.com>
Tested-by: Carl Worth <carl@os.amperecomputing.com> # arm64
Tested-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
Tested-by: Peter Newman <peternewman@google.com>
Tested-by: Amit Singh Tomar <amitsinght@marvell.com> # arm64
Tested-by: Shanker Donthineni <sdonthineni@nvidia.com> # arm64
Tested-by: Babu Moger <babu.moger@amd.com>
Link: https://lore.kernel.org/r/20250311183715.16445-2-james.morse@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/resctrl/rdtgroup.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index 6419e04d8a7b2..04b653d613e88 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -157,7 +157,8 @@ static int closid_alloc(void)
 
 	lockdep_assert_held(&rdtgroup_mutex);
 
-	if (IS_ENABLED(CONFIG_RESCTRL_RMID_DEPENDS_ON_CLOSID)) {
+	if (IS_ENABLED(CONFIG_RESCTRL_RMID_DEPENDS_ON_CLOSID) &&
+	    is_llc_occupancy_enabled()) {
 		cleanest_closid = resctrl_find_cleanest_closid();
 		if (cleanest_closid < 0)
 			return cleanest_closid;
-- 
2.39.5



