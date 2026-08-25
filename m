Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AD3C481672;
	Tue, 25 Aug 2026 13:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787666297; cv=none; b=WSf3MKIedqbwRn7MprSqWtO4/DPFKv5XBiEdoPn13Rf1MUw5szT7Pe1PPeOgJu3ptmunvxyLVysqm1sE/rxquj8y7I522admh//5Hqv4cfnfAyQLBMhGvB2zRx7k/SoriAqrHuT+U+CmcJlX+VnYlklPclchV9s4aUPHgE900/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787666297; c=relaxed/simple;
	bh=+rWDd5qR2AKs2a7XiPhjOJPr4r3JExoPVLl/qSiv0QU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q4Z+/7HjR61/WAnJhQI0K+xJOwCF3C1bAR0DdIT4kE0JWhlUdVKhfLNq8dnND/kr/Dmo81Cb/r03lSUkm7UuO57N994wZTXK1L+7zoGct8pNIIXzlt2FTHDLtMdKIl0wGpE6KBiRVe68jGEz4gq48vUtjkDxOC34zCmZeLacCq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=svPKuHfN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="svPKuHfN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1AB91F000E9;
	Tue, 25 Aug 2026 13:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787666296;
	bh=m/8VfcscTr5K6WjyHBycLO51e5tMYqoMHCJ36NjD0Wc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=svPKuHfN9clhhS+QZOYXmS4RT6pOZ6j6MRZvL17wXj+R0LnsxPX834ItbcPEEzfW+
	 pBT6gAqEUn/XsaLgXVSN9B/qyfgXVM8kCPl2QR6aqPhp+2qy9bmBc/JacE13m2f3ZF
	 s8Ng8oSBT6bIdjzFxybhzI7wAbNPEVKxv/gFg2Go=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Jiang HongHui <jiang_hh2019@163.com>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 5.15 44/76] nvmet-fc: fix invalid free in LS IOD error path
Date: Tue, 25 Aug 2026 15:26:37 +0200
Message-ID: <20260825132543.298864177@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.568214149@linuxfoundation.org>
References: <20260825132541.568214149@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


