Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5977026B956;
	Tue,  8 Apr 2025 12:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116124; cv=none; b=AgDXIR+bYms7TNFaabV6ZQQexqGLQyiHkltn0UnMEoHgSCrleASmqxEesgHtfpIuTeTV7SNEz7csR+mPniC8iwI5k4VAjyEETahYLgEh7XB65/6JGm6FVn9176lVlzm7m9cRYaxYKNqSgmIM6kb3SVlcZI2toropzTnDIGZRsCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116124; c=relaxed/simple;
	bh=sjWadk+GVboP165CdFi8dZiz5Pas1SwAQIthPWQSMkg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sMXERz7F5o6Tce8Ec3oUbYW2rkFRluTVuVOwtYR255RAEJ6GLRGNveQbjb93wjpBJ6XdeQ7SI7oIh7P5z3b5rVqAfh1S1a1xSXC4m1WQEMuzCMUu7+EEl+pcQCtWv4681KqcIrPvXgdNVa0KlI6TU4pKeLBfK4MSM/Y6C8fDQi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xeH+0zK6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xeH+0zK6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6F0EC4CEE5;
	Tue,  8 Apr 2025 12:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116124;
	bh=sjWadk+GVboP165CdFi8dZiz5Pas1SwAQIthPWQSMkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xeH+0zK6Vy2QukpwXPoAV2lnPhpbNEKS7gDtDlslkfq1BowKe333jk04gkO15Hpsk
	 5NVZclUwA9Rr7pVYGyEAvuGt2fOhwDWgy8mNu2vh2g6AIpJrJOOCwm6meR8s3GOk1r
	 GdCX8QttL+5ZCVlE4kRrGEIcrWEwVKhN3osIl5nc=
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
Subject: [PATCH 6.12 024/423] x86/resctrl: Fix allocation of cleanest CLOSID on platforms with no monitors
Date: Tue,  8 Apr 2025 12:45:50 +0200
Message-ID: <20250408104846.308883098@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d7163b764c626..2d48db66fca85 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -148,7 +148,8 @@ static int closid_alloc(void)
 
 	lockdep_assert_held(&rdtgroup_mutex);
 
-	if (IS_ENABLED(CONFIG_RESCTRL_RMID_DEPENDS_ON_CLOSID)) {
+	if (IS_ENABLED(CONFIG_RESCTRL_RMID_DEPENDS_ON_CLOSID) &&
+	    is_llc_occupancy_enabled()) {
 		cleanest_closid = resctrl_find_cleanest_closid();
 		if (cleanest_closid < 0)
 			return cleanest_closid;
-- 
2.39.5



