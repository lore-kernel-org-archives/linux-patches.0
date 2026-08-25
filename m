Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E03B480968;
	Tue, 25 Aug 2026 13:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787664680; cv=none; b=kurhRbC0oPTdflPJeMg0lBFl+DF9YMJ82lQGrTdV3ScMVouYhzVXJWzY1bK56dBteccpbRo6VIvceQ6zQbo/4EG2UXQocOGZM5ejvhAfFUCun/8VNoy3bawN0cTMgSPqD6ePH2qExmSn7VrmmbZwIysqzPRdhe3J8yrvVSs3Kx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787664680; c=relaxed/simple;
	bh=w0gX7ai1rvgZbit1q3EdRA0HgfODRDy9BlfcLEPiebw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t0paRNFN2ffRJNemBD7zWnMEXB7ZD2GkAReyQSzZCMzMfXJd2Gt5SUXGSvzU4Nhwh+kxx3njxagh2/owAnjT4O0LZB/FTmXCO1HHHIZIJgdtpLI0uI/a46ZjvseSFw3F4kh7wue++TAzyFtuQG5u8cfSyko/WOm6jbJDPE3MJ1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uaz4Q5dU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uaz4Q5dU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A37B1F000E9;
	Tue, 25 Aug 2026 13:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787664678;
	bh=GTEnBTvqUdl514HkTGvvIAZ/9esK0Zo8a51YYxdzAh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uaz4Q5dU4UBk1yX2BlaenLpttj2igESXhWCnDy11xY+Y+oG4HfqpTs0eKKW+4PPZX
	 3zE2jJ2s4IZCYOiDd22T+yGkxf/ihOrNsKyY08SSaVrvZ3IEsaiMJysedwyOuhK+Nl
	 FQMMdv0YLMF2Y0n6LfSAblj1CKVAEAAsvZQs6vwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Jiang HongHui <jiang_hh2019@163.com>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 7.2 51/82] nvmet-fc: fix invalid free in LS IOD error path
Date: Tue, 25 Aug 2026 15:25:38 +0200
Message-ID: <20260825132543.523089616@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.560541185@linuxfoundation.org>
References: <20260825132541.560541185@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -566,7 +566,7 @@ out_fail:
 		list_del(&iod->ls_rcv_list);
 	}
 
-	kfree(iod);
+	kfree(tgtport->iod);
 
 	return -EFAULT;
 }


