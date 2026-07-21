Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A6FE446839;
	Tue, 21 Jul 2026 17:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655310; cv=none; b=tU9ARSDDpPs7JYkMCjvdNbC8ybkdFD2DdLwixPVyrZOTTdRI8SfzAodfXAjD3+kJreejmUWV7uwSfwjKsYq2Rlzy5IVtgI2w8V9LXmx6IFreOp/9CBuKjKu7WOwqe4Y3IcwjiDJSwJFKdC1mrTEocaulB0gPyjlV+Jr6tfA+FP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655310; c=relaxed/simple;
	bh=1zVN/lzOeMMbHMZBEhLwSlpB6Aw57zqUGNM0A04+gxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bBCjsaqm+cfX6VvZlhtTTIqr35DhEwMzvgmIcS6Bwws51YI3XdfisfeyTUIen1eVxy8qrmolVSZg3egYyTOnDIU1QP/VkX0SFDT1AWapLBhMupF5B1FELOxaFU1/yHnBtrMNGjsRec6ANLPxq0Ak+Yla3YeZmLwAsNe6ezDReO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MQ0fuFB6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MQ0fuFB6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A36CF1F000E9;
	Tue, 21 Jul 2026 17:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655309;
	bh=RFdwJloW3Fp4IbQN4ROI3j/Cm0+HVfHPhM3eJk1sGb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MQ0fuFB6YgDQYbIh0N1e/gxP5gwPkfX1Bawwr7ag5PPNJmcVhtSyoYiPokB9wwABx
	 xzMT4Rmv1LcIu4SBD7UCAcoaWDdTOTZn4tVr4IMCsq5WaSoxdFWFmrsHX1UtnaIMyA
	 qcYyKUKygd1lnLCb81aTCBlMFftAUC0PyKoiS3I8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Reinette Chatre <reinette.chatre@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Chen Yu <yu.c.chen@intel.com>,
	Ben Horgan <ben.horgan@arm.com>,
	stable@kernel.org
Subject: [PATCH 7.1 1983/2077] fs/resctrl: Free mon_data structures on rdt_get_tree() failure
Date: Tue, 21 Jul 2026 17:27:36 +0200
Message-ID: <20260721152639.482756405@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Luck <tony.luck@intel.com>

commit ca0676ae2e1a23ac3e858224fc630b99f9e216ea upstream.

If mkdir_mondata_all() or a subsequent call in rdt_get_tree() fails, the
mon_data structures allocated by mon_get_kn_priv() are leaked.

Add mon_put_kn_priv() to the out_mongrp error path to free the mon_data
structures.

Fixes: 2a6566038544 ("x86/resctrl: Expand the width of domid by replacing mon_data_bits")
Closes: https://lore.kernel.org/lkml/5d38c1fb-8f91-472b-8897-24b2f50c772b@intel.com/
Reported-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Chen Yu <yu.c.chen@intel.com>
Reviewed-by: Ben Horgan <ben.horgan@arm.com>
Cc: <stable@kernel.org>
Link: https://patch.msgid.link/433623b7e3316ffd52323255d1aa4f156ad97cb1.1783377598.git.reinette.chatre@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/resctrl/rdtgroup.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -74,6 +74,8 @@ static int rdtgroup_setup_root(struct rd
 
 static void rdtgroup_destroy_root(void);
 
+static void mon_put_kn_priv(void);
+
 struct dentry *debugfs_resctrl;
 
 /*
@@ -2895,6 +2897,7 @@ out_mondata:
 		kernfs_remove(kn_mondata);
 out_mongrp:
 	if (resctrl_arch_mon_capable()) {
+		mon_put_kn_priv();
 		rdtgroup_unassign_cntrs(&rdtgroup_default);
 		kernfs_remove(kn_mongrp);
 	}


