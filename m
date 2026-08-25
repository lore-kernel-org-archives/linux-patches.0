Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89BD841A92C;
	Tue, 25 Aug 2026 13:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665761; cv=none; b=sF6wjatVDXjfsHxUcTgyB3oQ3g6q1E8sYQ7V5GtY3xHwI60IDuwxm7TLYUpCc/eDqVeJGrJTo4NmvJThpBYg1WUcvznn3eXkUqIERf6edFFJROFocn9TPWKY596m7YmtadJdu4n1u64bAxsyTR/w0ALi52DN4gScCf2hijEVWJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665761; c=relaxed/simple;
	bh=A104N7UW/6ePbO13Vnvy/Bxe3j22u6ylSM6RuT6r7Ng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t7ylsoAMJrv7LRv2QQbgfoYwPIoS0vdSxd8Sa2ECu4Sbnv9oFW8biYJxm+DVwV8PGy0I+P/70kvy3kE9U4DgKIUneem4PbRj+ZpCkY9NjbSrj8uYYm/6b8sDETZct3759L+VD8YZWXf3tAI7HHa7rFTk0ZXSEBEqOSwl7z1ORYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PI9IENni; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PI9IENni"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E46F71F000E9;
	Tue, 25 Aug 2026 13:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665760;
	bh=gJZ2zWoWYL3+eKOoB+NhDWoE06UaxtHMDPG1FZl1Nbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PI9IENnirgeAzw4/H7Ez2kzM0H3P3fprmVvVNzFkeyj2OC9XYWIlcpB8DhsePwoh/
	 TS5CP+vbqo76VwRwCfeC5Iwcf990EM4fla9oetLQidWUA1juk9WBYKU0h5Mz21jslY
	 Is4X+mq66KXmwp4H90x2fLqiNXymCS48ZKg6HLGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Jiang HongHui <jiang_hh2019@163.com>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.6 55/87] nvmet-fc: fix invalid free in LS IOD error path
Date: Tue, 25 Aug 2026 15:26:18 +0200
Message-ID: <20260825132543.999771932@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.813800447@linuxfoundation.org>
References: <20260825132541.813800447@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -571,7 +571,7 @@ out_fail:
 		list_del(&iod->ls_rcv_list);
 	}
 
-	kfree(iod);
+	kfree(tgtport->iod);
 
 	return -EFAULT;
 }


