Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96F6E1DFEF;
	Tue, 23 Jan 2024 12:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706014222; cv=none; b=LOG/l/JbTSxXkyb3EGqJS/mXsNnJY9DbVy4vhQQYtPv6H09pwo6Uq/hIBp12roZULYgYLuLDWyHybfwiTUulXA/6K9ZUhUc1G0GQ9rZ+mY1XHfNgmqevlPtx2b4qxt+sLsLGJvc6h3oMlnFWPT+e3NwDD5xe1ci1znMcj8rMa6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706014222; c=relaxed/simple;
	bh=GGRkTi1Zr7qfzZXOfe/OvD9nvTQ2yobOAJCrxTYIkHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f1cP9vlB3EBVE3j65vpkUqPrUjI9BS4JBKH5TzPNvIXfKTnEeFKZQU7bL8YNzfLaAE2wGRsAAf3GDheqQPpVLPDVQ4VfaxcTa2vPdBMK2hGTfKgjBZwI6HJX88pm8wCMO6uV58PZOL6dVc2nEQ9T9eA9OUNnRGxHsMNGiyu+Y18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zM6ihgiH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zM6ihgiH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04AA8C43601;
	Tue, 23 Jan 2024 12:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706014222;
	bh=GGRkTi1Zr7qfzZXOfe/OvD9nvTQ2yobOAJCrxTYIkHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zM6ihgiHzNmZKdT0hOGHPA4UJf3MeOmTLEuIcbTm6rLt+NygBichMEX2HSzCJ35JM
	 xBjm6CFkuadPeDv5CPlw+xgZG4gKgcaT4UXfXZOp14n74xo72PJkAIoh2ec2OimyuD
	 FIVYTa2JZekdFTPXSUZpJepgEz2EskJdrh02jpqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sagi Grimberg <sagi@grimberg.me>,
	Maurizio Lombardi <mlombard@redhat.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 323/374] nvmet-tcp: fix a crash in nvmet_req_complete()
Date: Mon, 22 Jan 2024 15:59:39 -0800
Message-ID: <20240122235756.140346556@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit 0849a5441358cef02586fb2d60f707c0db195628 ]

in nvmet_tcp_handle_h2c_data_pdu(), if the host sends a data_offset
different from rbytes_done, the driver ends up calling nvmet_req_complete()
passing a status error.
The problem is that at this point cmd->req is not yet initialized,
the kernel will crash after dereferencing a NULL pointer.

Fix the bug by replacing the call to nvmet_req_complete() with
nvmet_tcp_fatal_error().

Fixes: 872d26a391da ("nvmet-tcp: add NVMe over TCP target driver")
Reviewed-by: Keith Busch <kbsuch@kernel.org>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/tcp.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index a0a7540f048e..d25ca0742f91 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -950,8 +950,7 @@ static int nvmet_tcp_handle_h2c_data_pdu(struct nvmet_tcp_queue *queue)
 			data->ttag, le32_to_cpu(data->data_offset),
 			cmd->rbytes_done);
 		/* FIXME: use path and transport errors */
-		nvmet_req_complete(&cmd->req,
-			NVME_SC_INVALID_FIELD | NVME_SC_DNR);
+		nvmet_tcp_fatal_error(queue);
 		return -EPROTO;
 	}
 
-- 
2.43.0



