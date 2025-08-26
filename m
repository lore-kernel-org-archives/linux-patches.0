Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DECB434DCC3;
	Tue, 26 Aug 2025 13:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216625; cv=none; b=fUBU6B3QSvu5CSLTOs5qA16TpPcBVFYfoGrYVEgLndm44gEIuvY1+r/t7EMBXTlgz0EvXkfXzlmRFUDrmB+fG17iX/hSJrHUKm1ojuspii5EVqVmy1zpBJE8Cubc+OecIO8rdcPv6g+aqimjmRXP1XusYj4agfsPP9W2T7ELR3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216625; c=relaxed/simple;
	bh=2mRogVjEvW7YIZP4hGukKUqyAUTDpxDispERX8nLckU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XgGEZY0LrditNxVQneH7yNduo+ZmXjmBJlF9zDKcn/eQGGtXC01JVfkyMWDaiEYelj2Q8Bt57PByXWFplwcY5oLehY/bXG8oky9gJgudy0dnSntm7iwlAoE57aPBMXHemMqK0wzGb1ZrxgjPfTOXPp01n5kJ9t9BMSUecng0ep0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wz5DToBk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wz5DToBk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DA9AC113CF;
	Tue, 26 Aug 2025 13:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216624;
	bh=2mRogVjEvW7YIZP4hGukKUqyAUTDpxDispERX8nLckU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wz5DToBkBgbQ5GTlOFbNfy7eyx0tPtlVsbbzc/1nOurJnc3ADxhR4kr1FQZwt51v3
	 2puKyFGX0xgrn8dEuKYCSMpXDuELEDOA+VvhEW6f/V0vcP/9JOkfot77QUpzb3S1ti
	 xpLuNS1uTN8NXyCcyQKUby/FbaP0lePHl6992XfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 5.15 482/644] PCI: endpoint: Fix configfs group list head handling
Date: Tue, 26 Aug 2025 13:09:33 +0200
Message-ID: <20250826110958.429689727@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -343,7 +343,6 @@ static void pci_epf_remove_cfs(struct pc
 	mutex_lock(&pci_epf_mutex);
 	list_for_each_entry_safe(group, tmp, &driver->epf_group, group_entry)
 		pci_ep_cfs_remove_epf_group(group);
-	list_del(&driver->epf_group);
 	mutex_unlock(&pci_epf_mutex);
 }
 


