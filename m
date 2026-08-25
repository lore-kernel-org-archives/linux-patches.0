Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2F45481AA9;
	Tue, 25 Aug 2026 13:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665515; cv=none; b=gM6KcQ/g8/VWk2nUs/OCw1UdjKSPtSf6hVpGLRAry16qN12eB6sUtFtNQF8JQNj5t0NQhn78ftpzNsk/tZcSSHJbXvJ76SzJ3T6/P0bbyOAFJpvBpVYpG4IqnMBMIdwQPPFJ2MuihKf/ED1sbQMpNncw6ypNJHpAqHxrnuYDR2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665515; c=relaxed/simple;
	bh=RetKJNblmlA0a3lbgcO9HrxSeFX9xETsl1+g26R0x9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h9bnZoRC5fkp2CU3IJJsdCCwcSqrCQyKSb6KOsAqbc34FYhLjv+GF8Ejg1qMRsF2p8mTRxLs9vf2lex272TgpIU3g4S5BkUC3+KXWDiv5vB58MvLrhOx+cma4GmMJAfL8HDjzR/6YS8ngwTol8I7trKE9vizsHQ5bUNChm6ZT6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XhnrBhur; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XhnrBhur"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4266C1F00A3A;
	Tue, 25 Aug 2026 13:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665513;
	bh=DU4rldn2vfnN2VasC+Y5BF2gP9BrJ290ZpOJr1QYZAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XhnrBhur7SbFYb+o6c8329DtAy7zPsU6qbn9Y7rAK74pRel4+882UQlj2sznWXgVU
	 GzIRcb0OLir07k8JLK/2wZ8IpX9ZrO0MwqUs5u39OB5qXRSYakwI02K7uEJ3JAgzwn
	 bvOMmw7cgjidPGUlwnGxn++mpzhm64Ed/fIDQw8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Jiang HongHui <jiang_hh2019@163.com>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.12 50/77] nvmet-fc: fix invalid free in LS IOD error path
Date: Tue, 25 Aug 2026 15:26:12 +0200
Message-ID: <20260825132543.519235226@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.580275153@linuxfoundation.org>
References: <20260825132541.580275153@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiang HongHui <jiang_hh2019@163.com>

commit ba98d6796d12258e837ece065d2ecb59d76ce4ff upstream.

nvmet_fc_alloc_ls_iodlist() advances iod while initializing the LS IOD
array. If an rqstbuf allocation or response buffer DMA mapping fails,
the unwind loop decrements iod past the start of the array. The final
kfree(iod) therefore frees an address before the allocated object.

This can be reproduced with nvme-fcloop and failslab by setting
fail-nth to 6 before creating a target port. KASAN reports:

  BUG: KASAN: invalid-free in nvmet_fc_register_targetport
  Free of addr ffff88816cf8ff48 by task nvmet_fail_nth/9552

Free the original allocation base stored in tgtport->iod instead. With
this fix applied, the same sysfs write with fail-nth=6 returns -ENOMEM
without any KASAN report.

Fixes: c53432030d86 ("nvme-fabrics: Add target support for FC transport")
Cc: stable@vger.kernel.org
Reviewed-by: Maurizio Lombardi <mlombard@redhat.com>
Assisted-by: Codex:gpt-5
Signed-off-by: Jiang HongHui <jiang_hh2019@163.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/target/fc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/nvme/target/fc.c
+++ b/drivers/nvme/target/fc.c
@@ -569,7 +569,7 @@ out_fail:
 		list_del(&iod->ls_rcv_list);
 	}
 
-	kfree(iod);
+	kfree(tgtport->iod);
 
 	return -EFAULT;
 }


