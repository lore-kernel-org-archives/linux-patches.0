Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7AD015218A;
	Tue,  2 Jul 2024 17:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941159; cv=none; b=HRYuk0ULVFbpic+DRDH/dyHgB5Rn0g7oJ3RfZMYVvBZVe17kUwUJGlSrQxvw9Ek+Pci5wrjc4nNHd9o6kftW//UrrBUtzAtw8fAkdbo7E/zuqd/7ze7p18QD4ba7J2XID4QgHMe+z4LnT0ys7m+cjr2XziMEhA/JOI1BjKMTWaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941159; c=relaxed/simple;
	bh=4kLTWoxJCn89xH9psW4g7u5tGphlaXZ6GE8m9dnfvn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vAvQj9zArxRWoPM+pRcm0vibrHOPYfOnVN9Hy/DYVbL5Rt40KrB0E95x0RDUggHU+y7TGJaS/ImiO16L2XSWnTWBPFwyrpGOtZGmVmY5r82a7ptz9ubjjncHkyDj1mtXwkpByE/LfBveATwvSdVa5m/4c6gtvqdG7aANJ3DT5B8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=seF/o87o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="seF/o87o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29C55C4AF0A;
	Tue,  2 Jul 2024 17:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941159;
	bh=4kLTWoxJCn89xH9psW4g7u5tGphlaXZ6GE8m9dnfvn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=seF/o87oAxTVQd/8Ta11mUgf6T/acW/1IncyQw+VgCvooZm1jxqF6k5t5wl+7vNC3
	 tRZb6Das2OOB5rs/enS4+j6EfOdB96hy3ezmcmxPf94AV/xtFUTs8tXxOM3Bh5W9BO
	 +8uoN92Mi5YrBRgZfyPILWltSdUQ9OH1OgGPcxJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 6.6 146/163] ata: libata-core: Fix double free on error
Date: Tue,  2 Jul 2024 19:04:20 +0200
Message-ID: <20240702170238.577638518@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <cassel@kernel.org>

commit ab9e0c529eb7cafebdd31fe1644524e80a48b05d upstream.

If e.g. the ata_port_alloc() call in ata_host_alloc() fails, we will jump
to the err_out label, which will call devres_release_group().
devres_release_group() will trigger a call to ata_host_release().
ata_host_release() calls kfree(host), so executing the kfree(host) in
ata_host_alloc() will lead to a double free:

kernel BUG at mm/slub.c:553!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
CPU: 11 PID: 599 Comm: (udev-worker) Not tainted 6.10.0-rc5 #47
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-2.fc40 04/01/2014
RIP: 0010:kfree+0x2cf/0x2f0
Code: 5d 41 5e 41 5f 5d e9 80 d6 ff ff 4d 89 f1 41 b8 01 00 00 00 48 89 d9 48 89 da
RSP: 0018:ffffc90000f377f0 EFLAGS: 00010246
RAX: ffff888112b1f2c0 RBX: ffff888112b1f2c0 RCX: ffff888112b1f320
RDX: 000000000000400b RSI: ffffffffc02c9de5 RDI: ffff888112b1f2c0
RBP: ffffc90000f37830 R08: 0000000000000000 R09: 0000000000000000
R10: ffffc90000f37610 R11: 617461203a736b6e R12: ffffea00044ac780
R13: ffff888100046400 R14: ffffffffc02c9de5 R15: 0000000000000006
FS:  00007f2f1cabe980(0000) GS:ffff88813b380000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f2f1c3acf75 CR3: 0000000111724000 CR4: 0000000000750ef0
PKRU: 55555554
Call Trace:
 <TASK>
 ? __die_body.cold+0x19/0x27
 ? die+0x2e/0x50
 ? do_trap+0xca/0x110
 ? do_error_trap+0x6a/0x90
 ? kfree+0x2cf/0x2f0
 ? exc_invalid_op+0x50/0x70
 ? kfree+0x2cf/0x2f0
 ? asm_exc_invalid_op+0x1a/0x20
 ? ata_host_alloc+0xf5/0x120 [libata]
 ? ata_host_alloc+0xf5/0x120 [libata]
 ? kfree+0x2cf/0x2f0
 ata_host_alloc+0xf5/0x120 [libata]
 ata_host_alloc_pinfo+0x14/0xa0 [libata]
 ahci_init_one+0x6c9/0xd20 [ahci]

Ensure that we will not call kfree(host) twice, by performing the kfree()
only if the devres_open_group() call failed.

Fixes: dafd6c496381 ("libata: ensure host is free'd on error exit paths")
Cc: stable@vger.kernel.org
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Link: https://lore.kernel.org/r/20240629124210.181537-9-cassel@kernel.org
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-core.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5587,8 +5587,10 @@ struct ata_host *ata_host_alloc(struct d
 	if (!host)
 		return NULL;
 
-	if (!devres_open_group(dev, NULL, GFP_KERNEL))
-		goto err_free;
+	if (!devres_open_group(dev, NULL, GFP_KERNEL)) {
+		kfree(host);
+		return NULL;
+	}
 
 	dr = devres_alloc(ata_devres_release, 0, GFP_KERNEL);
 	if (!dr)
@@ -5620,8 +5622,6 @@ struct ata_host *ata_host_alloc(struct d
 
  err_out:
 	devres_release_group(dev, NULL);
- err_free:
-	kfree(host);
 	return NULL;
 }
 EXPORT_SYMBOL_GPL(ata_host_alloc);


