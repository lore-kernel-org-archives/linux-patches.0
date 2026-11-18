Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055625;
	b=G7On7lhfGPwvZXOaKqdpfIVOglQ3O2rRHePFJJ4yTTWg25CjWpJkVdiy7HeW7R2YxzNT
	 YN76agu7lbF9PiOhyazMDLiUkuWx0hLKBSIdmE92y8aEKcHVLDQ9AP7+6rcaxFERMt385
	 DmO3cQ2TVY6H3+vpOM+fRddveAHGwtM6BkZb8SQN5r6z/IcobtOC56bW8edegFx5cySNr
	 Br+Y1ulcQWlnrMhr+fzQzJYS4lXBJcZBdSmxidDVu3zpXkVy8ToD9IPe7SRHxWdOJXgy5
	 c0Uhm4le3c2Zp93JzW6Z1+SBZBeHTtpG0DhVnuAou9bTs3JNwR0yGFzd2p16DUTrWjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055625;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZiEKq/djh5SCSn9IFUQvzw3Td7PPzimUEMBEQTx2D3c=;
	b=3H4qrZNWhUCY4XPWZDIN7Za3JPCoUxHEMcj+b5DmaDLp40UbH3f7U6I+Rg8od7TQKKpU
	 hFjK3zLmYlknFUA4ryksoCwWzIzvfH0Ej+XVDlIJ983EvXW/Yp9xAAzQQ5tZ/RTKEn5NB
	 jpJf2qWuhqorgquBVP6uT7v2JU2PpX6mQ+NEL6v39cRrTO3A53HLs0cViSROtbnn/3qE/
	 dFHp7TVAbpN9iAYr5D7klEYRkjxqPkuWUZeU3ljvM8/nMKveYiT21hNvu/fhUWxUi8RNp
	 m+qV0sxfLqMLGLi0+kLn896EUk+PGzzuutlTBN5CYDh2LsdQQPWhzfMLG2G17Ua8K2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KmYbNgoL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 742E8606A320;
	Thu, 19 Nov 2026 02:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KmYbNgoL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C63C61F000C4;
	Thu, 19 Nov 2026 02:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055625;
	bh=ZiEKq/djh5SCSn9IFUQvzw3Td7PPzimUEMBEQTx2D3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KmYbNgoLVxjW1WkHp63D91BtsEyQArGVt5XI95YB0W6jOGDosIOIWQmZzqdUBucXH
	 /fseJVTKZr4PXRDeQ5VFa+sjQ+Ow5Nzoah+kE0SmSAs1cKTUd1+29BR9fwo1kwbrlq
	 ASDnNnqoIAaDCGO0xOfGORxn6BSc/oQcxsAO4avE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongyan Xu <getshell@seu.edu.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1681/2214] RDMA/hfi1: quiesce SDMA asynchronous cleanup on exit
Date: Wed, 18 Nov 2026 15:55:57 +0100
Message-ID: <20261118150119.077892300@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongyan Xu <getshell@seu.edu.cn>

[ Upstream commit e95d076bc1fca7cc36fc8f2f0e9687f79fd314bd ]

The SDMA state reference and completion cover the software cleanup
tasklet, but not the hardware cleanup tasklet, err_halt_worker, or
flush_worker. Queued instances can therefore access an SDMA engine after
per_sdma is released.

After the state machine has stopped, cancel err_halt_worker first
because it can publish the hardware cleanup tasklet. Then kill that
tasklet and drain the remaining flush work.

Fixes: 7724105686e7 ("IB/hfi1: add driver files")
Signed-off-by: Hongyan Xu <getshell@seu.edu.cn>
Link: https://patch.msgid.link/20260928134148.977-1-getshell@seu.edu.cn
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/sdma.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/hw/hfi1/sdma.c b/drivers/infiniband/hw/hfi1/sdma.c
index 969c5c3ab859e..1d4760ba1b48f 100644
--- a/drivers/infiniband/hw/hfi1/sdma.c
+++ b/drivers/infiniband/hw/hfi1/sdma.c
@@ -1583,6 +1583,9 @@ void sdma_exit(struct hfi1_devdata *dd)
 		 * it is not running.
 		 */
 		sdma_finalput(&sde->state);
+		cancel_work_sync(&sde->err_halt_worker);
+		tasklet_kill(&sde->sdma_hw_clean_up_task);
+		cancel_work_sync(&sde->flush_worker);
 	}
 }
 
-- 
2.53.0



