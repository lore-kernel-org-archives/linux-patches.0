Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02E2C480941;
	Tue, 25 Aug 2026 13:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665051; cv=none; b=ZFaNBNvaqoa9jri+Zh9lLd8zAklUTarsxD3EU4X/anLaHpwyvLvukEVhuxJ8Lv3ZLB57Uu6vlOCb5b1FPuYtOzODi9FgAFPizZtSVNEGGH4EwFa7ItZMzR2GJ2231ijtZEdqsvLgsB/+KnxiL84oQz/7FSzoLAtph4Xd4XPPNEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665051; c=relaxed/simple;
	bh=LdAChFyjtsvTA1v+zmnF8Gkvpnnh6ql53p9uyBGw460=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=amn2TJoeCkBTNg8+VaNOzL9fyK0KYWIxnLrLVkUHFX4nACYmMytTlF8S1eHUwS6BR3yu0lM7n7VMmi5kpeA50g/E6Cb6fFNliHhao7w3AT0rhVSFpxcFeueeUvIqtIsB723LW4YuazvlZ3lZG5Rw6F5Rg217toSMbxkF1PDDR64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gl+y52gB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gl+y52gB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5920B1F000E9;
	Tue, 25 Aug 2026 13:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665049;
	bh=Mwf+MOQJemTkE3/BYOZonkA7BTJCY6U12MdeQn6arsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gl+y52gBhP1YTUOjEzoFs9SGd/ub3l1MHxBpUKSL+eHAc7uxo1sOZNLipes4jtDAF
	 HVbY9buadRyRfoaQipBHQg8PiZYu0Cf3FjYAmxlZiPehSOqahhNVUxg3XaYURuM9lH
	 fZ7d29jriXrm4EtppqwVbLsqqVAbc8SgeqqlngI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Jiang HongHui <jiang_hh2019@163.com>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 7.1 054/101] nvmet-fc: fix invalid free in LS IOD error path
Date: Tue, 25 Aug 2026 15:25:32 +0200
Message-ID: <20260825132544.123131825@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.986300899@linuxfoundation.org>
References: <20260825132541.986300899@linuxfoundation.org>
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


