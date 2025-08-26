Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78A2917332C;
	Tue, 26 Aug 2025 11:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208425; cv=none; b=cZL14eWDXQ4oLdLex2ObXTalJKcmv4bZt/ddjVEMX/9AmV2hgFAiQbGMHPzu5MiJ97N0wyEHURljV+oLBQOYh1qNH/FbgGxKQDOHBmwzhAjnyPi6p43Dv+Dp7Jf0y2uteY0ugRSZWyfz5161bpr/tJMb0kxlEhPkXxTF0fsM/C4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208425; c=relaxed/simple;
	bh=LV3xA1arGqXTtGZ990gfKgzyaDCE3p+501u6E9AofN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E/j/FH0U6sm5Y1ZujKdENgbEzXVfC/DI1OtP4sc76PJv6BzK4Yt5qQ9upWQXyJbw1XVZQKwBGZNzde4UuuDzEdUUjtFiwsJb8RFL5wb570lrybM5F6+5jeycBmQzBJkLkt75GPRc357kfmqSmVG7EUftlB9JqziBCwDxL7nKQB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=alFRmeR8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="alFRmeR8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12456C4CEF1;
	Tue, 26 Aug 2025 11:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208425;
	bh=LV3xA1arGqXTtGZ990gfKgzyaDCE3p+501u6E9AofN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=alFRmeR8b+ZlD3y7/AugiFZvLarHnE0nwOoKI29m4kQHDndDQrvJxuXM437PiF4Ui
	 Jt2EQ3T0OaZSrQYFpkI6KNjb36h5cuctWgmkGg2phzqVlVwnAxvpIbT/WuA3Bf13Qs
	 SD76nU4Hm5/USWJHDxDFoc8+Qm58XuE0WRKw2z+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 6.12 075/322] PCI: endpoint: Fix configfs group list head handling
Date: Tue, 26 Aug 2025 13:08:10 +0200
Message-ID: <20250826110917.455173096@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

From: Damien Le Moal <dlemoal@kernel.org>

commit d79123d79a8154b4318529b7b2ff7e15806f480b upstream.

Doing a list_del() on the epf_group field of struct pci_epf_driver in
pci_epf_remove_cfs() is not correct as this field is a list head, not
a list entry. This list_del() call triggers a KASAN warning when an
endpoint function driver which has a configfs attribute group is torn
down:

==================================================================
BUG: KASAN: slab-use-after-free in pci_epf_remove_cfs+0x17c/0x198
Write of size 8 at addr ffff00010f4a0d80 by task rmmod/319

CPU: 3 UID: 0 PID: 319 Comm: rmmod Not tainted 6.16.0-rc2 #1 NONE
Hardware name: Radxa ROCK 5B (DT)
Call trace:
show_stack+0x2c/0x84 (C)
dump_stack_lvl+0x70/0x98
print_report+0x17c/0x538
kasan_report+0xb8/0x190
__asan_report_store8_noabort+0x20/0x2c
pci_epf_remove_cfs+0x17c/0x198
pci_epf_unregister_driver+0x18/0x30
nvmet_pci_epf_cleanup_module+0x24/0x30 [nvmet_pci_epf]
__arm64_sys_delete_module+0x264/0x424
invoke_syscall+0x70/0x260
el0_svc_common.constprop.0+0xac/0x230
do_el0_svc+0x40/0x58
el0_svc+0x48/0xdc
el0t_64_sync_handler+0x10c/0x138
el0t_64_sync+0x198/0x19c
...

Remove this incorrect list_del() call from pci_epf_remove_cfs().

Fixes: ef1433f717a2 ("PCI: endpoint: Create configfs entry for each pci_epf_device_id table entry")
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20250624114544.342159-2-dlemoal@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/endpoint/pci-epf-core.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/pci/endpoint/pci-epf-core.c
+++ b/drivers/pci/endpoint/pci-epf-core.c
@@ -334,7 +334,6 @@ static void pci_epf_remove_cfs(struct pc
 	mutex_lock(&pci_epf_mutex);
 	list_for_each_entry_safe(group, tmp, &driver->epf_group, group_entry)
 		pci_ep_cfs_remove_epf_group(group);
-	list_del(&driver->epf_group);
 	mutex_unlock(&pci_epf_mutex);
 }
 


