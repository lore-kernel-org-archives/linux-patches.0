Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD83A1EABAB;
	Tue, 15 Oct 2024 11:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993155; cv=none; b=oNAeeSzBdHGtlDNxO6xXz1h7hyEw56vwW8xqFGq+nIPSSocKs4UypTTGPuIr0Xv9LarCxBy5rk9IwO1DjKwWFJ3v60msh0zb+3qWG3aV1He1nLmK85V8CdKOydG2rmYhio2EESZSRCUGDoLZg4Brb8S5DEgTd2BHfvd6sb8v7t8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993155; c=relaxed/simple;
	bh=R8T8E2oX/nr/Dy46GX23F5Bn0VyVW9uruliExJwFBwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j0eEGllMGRQutJwrsgUwuRe1v1kmsdGURTY4boed9kqTEhjRMOTEd1/kWX6IiMb8JlRbN63Vtn51+lE+keWUBwzlG4ICXxG2AusxZGwOdt0ki2rk/ogdX936+Q3atbVyVAG9UxjDiPagkghcx6qr0ZJ9PHoX6DLwVHXjJ9af0pM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2GHZfhiB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2GHZfhiB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EE68C4CEC6;
	Tue, 15 Oct 2024 11:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993155;
	bh=R8T8E2oX/nr/Dy46GX23F5Bn0VyVW9uruliExJwFBwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2GHZfhiBD1ZZPygse4a5M1RYGJGOAAEYs2o8UWyuht0lN1Y9gEsDxGyvm0sSpxXGu
	 dqzFJ6TPyJbI+IsWRqqujA0MJ38TkZO4OMj3q8zwlihMp6/n0CGzTogoBGpzHFyrml
	 Sa7bKLV0FN+YwdvuYQ+KRTJqZUCUAdVk1qo5id3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavan Kumar Paluri <papaluri@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.15 328/691] crypto: ccp - Properly unregister /dev/sev on sev PLATFORM_STATUS failure
Date: Tue, 15 Oct 2024 13:24:36 +0200
Message-ID: <20241015112453.355069024@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

From: Pavan Kumar Paluri <papaluri@amd.com>

commit ce3d2d6b150ba8528f3218ebf0cee2c2c572662d upstream.

In case of sev PLATFORM_STATUS failure, sev_get_api_version() fails
resulting in sev_data field of psp_master nulled out. This later becomes
a problem when unloading the ccp module because the device has not been
unregistered (via misc_deregister()) before clearing the sev_data field
of psp_master. As a result, on reloading the ccp module, a duplicate
device issue is encountered as can be seen from the dmesg log below.

on reloading ccp module via modprobe ccp

Call Trace:
  <TASK>
  dump_stack_lvl+0xd7/0xf0
  dump_stack+0x10/0x20
  sysfs_warn_dup+0x5c/0x70
  sysfs_create_dir_ns+0xbc/0xd
  kobject_add_internal+0xb1/0x2f0
  kobject_add+0x7a/0xe0
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? get_device_parent+0xd4/0x1e0
  ? __pfx_klist_children_get+0x10/0x10
  device_add+0x121/0x870
  ? srso_alias_return_thunk+0x5/0xfbef5
  device_create_groups_vargs+0xdc/0x100
  device_create_with_groups+0x3f/0x60
  misc_register+0x13b/0x1c0
  sev_dev_init+0x1d4/0x290 [ccp]
  psp_dev_init+0x136/0x300 [ccp]
  sp_init+0x6f/0x80 [ccp]
  sp_pci_probe+0x2a6/0x310 [ccp]
  ? srso_alias_return_thunk+0x5/0xfbef5
  local_pci_probe+0x4b/0xb0
  work_for_cpu_fn+0x1a/0x30
  process_one_work+0x203/0x600
  worker_thread+0x19e/0x350
  ? __pfx_worker_thread+0x10/0x10
  kthread+0xeb/0x120
  ? __pfx_kthread+0x10/0x10
  ret_from_fork+0x3c/0x60
  ? __pfx_kthread+0x10/0x10
  ret_from_fork_asm+0x1a/0x30
  </TASK>
  kobject: kobject_add_internal failed for sev with -EEXIST, don't try to register things with the same name in the same directory.
  ccp 0000:22:00.1: sev initialization failed
  ccp 0000:22:00.1: psp initialization failed
  ccp 0000:a2:00.1: no command queues available
  ccp 0000:a2:00.1: psp enabled

Address this issue by unregistering the /dev/sev before clearing out
sev_data in case of PLATFORM_STATUS failure.

Fixes: 200664d5237f ("crypto: ccp: Add Secure Encrypted Virtualization (SEV) command support")
Cc: stable@vger.kernel.org
Signed-off-by: Pavan Kumar Paluri <papaluri@amd.com>
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/ccp/sev-dev.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1141,6 +1141,8 @@ void sev_pci_init(void)
 	return;
 
 err:
+	sev_dev_destroy(psp_master);
+
 	psp_master->sev_data = NULL;
 }
 


