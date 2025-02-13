Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0601615853B;
	Thu, 13 Feb 2025 15:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459003; cv=none; b=szewAJBy+9iYTXIDxUCnuKzNcVZtrulEXQVN/xU/lCBJOR1e7LmhYle/WuJkwu8CHC0DwBPrJwij7J+EeAksW+n3rmibiZbPdBLDw953HQ43J0A7Obi23CYsn/SVTNjFxvPlW8T+nZIdiLw+NtLuyscmoFiFo3AlMfzX8zArPqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459003; c=relaxed/simple;
	bh=00QYngDnONxZR45AeBBo4GfJG8/Op53g3Y/YV7CLw0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W1SaMcrRs03BzLmco6KB4xyAV7kowqBezyvcj5yPDeUVEsZwqUvrszhIHRx54t5hl/3HcW541SThS0TwhDufYBpITqlS3dVmLaJnqZ0dKUGP+oAicFK1EgV6Y3e/n9yQwTdvKlncVhhm9cKxoRDevRzn+tj8xZXQDmPxcVphc3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wRSbg6v/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wRSbg6v/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01294C4CED1;
	Thu, 13 Feb 2025 15:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459002;
	bh=00QYngDnONxZR45AeBBo4GfJG8/Op53g3Y/YV7CLw0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wRSbg6v/DjgN57igG4JTL71nzdHv6mE3v9lnvv/wU+8dm+Da5v3XH9ymaxTjyH0Fr
	 9DXkOAaWZr5H6yqZqZES9UBW+Kz7os7Fv2Zlfq6VxkjMNifYKgP68fAji0vxHvt8bJ
	 JCW5sbaFWAYBFpUmbeMYTNvolxG7aHUp0WtJxhhg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sagi Grimberg <sagi@grimberg.me>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 107/443] nvmet: fix a memory leak in controller identify
Date: Thu, 13 Feb 2025 15:24:32 +0100
Message-ID: <20250213142444.739656706@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sagi Grimberg <sagi@grimberg.me>

[ Upstream commit 58f5c8d5ca07a2f9fa93fb073f5b1646ec482ff2 ]

Simply free an allocated buffer once we copied its content
to the request sgl.

kmemleak complaint:
unreferenced object 0xffff8cd40c388000 (size 4096):
  comm "kworker/2:2H", pid 14739, jiffies 4401313113
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace (crc 0):
    [<ffffffff9e01087a>] kmemleak_alloc+0x4a/0x90
    [<ffffffff9d30324a>] __kmalloc_cache_noprof+0x35a/0x420
    [<ffffffffc180b0e2>] nvmet_execute_identify+0x912/0x9f0 [nvmet]
    [<ffffffffc181a72c>] nvmet_tcp_try_recv_pdu+0x84c/0xc90 [nvmet_tcp]
    [<ffffffffc181ac02>] nvmet_tcp_io_work+0x82/0x8b0 [nvmet_tcp]
    [<ffffffff9cfa7158>] process_one_work+0x178/0x3e0
    [<ffffffff9cfa8e9c>] worker_thread+0x2ec/0x420
    [<ffffffff9cfb2140>] kthread+0xf0/0x120
    [<ffffffff9cee36a4>] ret_from_fork+0x44/0x70
    [<ffffffff9ce7fdda>] ret_from_fork_asm+0x1a/0x30

Fixes: 84909f7decbd ("nvmet: use kzalloc instead of ZERO_PAGE in nvme_execute_identify_ns_nvm()")
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/admin-cmd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvme/target/admin-cmd.c b/drivers/nvme/target/admin-cmd.c
index fa89b0549c36c..7b70635373fd8 100644
--- a/drivers/nvme/target/admin-cmd.c
+++ b/drivers/nvme/target/admin-cmd.c
@@ -915,6 +915,7 @@ static void nvme_execute_identify_ns_nvm(struct nvmet_req *req)
 		goto out;
 	}
 	status = nvmet_copy_to_sgl(req, 0, id, sizeof(*id));
+	kfree(id);
 out:
 	nvmet_req_complete(req, status);
 }
-- 
2.39.5



