Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ABC91C1AAA;
	Tue, 12 Aug 2025 19:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025517; cv=none; b=l0Re7ILF44pQXkYEOdUhuwUY+ta7SmMxJqEKVMlk0ZmN0FPn5dRIhiRfwDkFe9ZiE/Gxqk6vv2iFKQ2DNQUx2vLFQ+oDSNqhKsnYeRAD9rgpZ9fvulYO8P4lkLm+sXbqt2sJSuU0cQdd91FGTDsCtCdRFG7LW0WA92euYFWy6FE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025517; c=relaxed/simple;
	bh=JXWb/i+Z2zjuSVF5nB+KoobSfumRYHBySYj/Y6FfGRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WPRsv7Bvct1NC8ZyP4ZytqP6ailZ55ufJEEMH91OJf+6pGutL3Re5JiGRPGJ3wvXa/BSTwuZdcdr2JsvYdj+Rn3vywWM/U8yIgffTBOX6D+u9DcDM7RSJE0kt21K/1Rv6a2r/EMiI+qdmA50PNH2XQeGTtLHvsA6LqYdMMaw7tM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PspvQd7+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PspvQd7+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB3EFC4CEF0;
	Tue, 12 Aug 2025 19:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025517;
	bh=JXWb/i+Z2zjuSVF5nB+KoobSfumRYHBySYj/Y6FfGRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PspvQd7+K79LcWx4yW8RM4yDPC83+jgOFHs857B2oD7b5gAlsVlODS2KpkQCf5NI4
	 Lig4D1ncf+pWC5vBKRT1W6PGlVwSf//5DHzCatY1ZDi/P7Gfqd9BIFSJ1ujDS/XD+U
	 tmG2R8zu0C8FwkQtKwNwLRy62hPUKN4XNjYyHqmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9b9124ae9b12d5af5d95@syzkaller.appspotmail.com,
	Lizhi Xu <lizhi.xu@windriver.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 064/480] vmci: Prevent the dispatching of uninitialized payloads
Date: Tue, 12 Aug 2025 19:44:32 +0200
Message-ID: <20250812174400.062344770@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lizhi Xu <lizhi.xu@windriver.com>

[ Upstream commit bfb4cf9fb97e4063f0aa62e9e398025fb6625031 ]

The reproducer executes the host's unlocked_ioctl call in two different
tasks. When init_context fails, the struct vmci_event_ctx is not fully
initialized when executing vmci_datagram_dispatch() to send events to all
vm contexts. This affects the datagram taken from the datagram queue of
its context by another task, because the datagram payload is not initialized
according to the size payload_size, which causes the kernel data to leak
to the user space.

Before dispatching the datagram, and before setting the payload content,
explicitly set the payload content to 0 to avoid data leakage caused by
incomplete payload initialization.

Fixes: 28d6692cd8fb ("VMCI: context implementation.")
Reported-by: syzbot+9b9124ae9b12d5af5d95@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=9b9124ae9b12d5af5d95
Tested-by: syzbot+9b9124ae9b12d5af5d95@syzkaller.appspotmail.com
Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
Link: https://lore.kernel.org/r/20250627055214.2967129-1-lizhi.xu@windriver.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/vmw_vmci/vmci_context.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/misc/vmw_vmci/vmci_context.c b/drivers/misc/vmw_vmci/vmci_context.c
index f22b44827e92..d566103caa27 100644
--- a/drivers/misc/vmw_vmci/vmci_context.c
+++ b/drivers/misc/vmw_vmci/vmci_context.c
@@ -251,6 +251,8 @@ static int ctx_fire_notification(u32 context_id, u32 priv_flags)
 		ev.msg.hdr.src = vmci_make_handle(VMCI_HYPERVISOR_CONTEXT_ID,
 						  VMCI_CONTEXT_RESOURCE_ID);
 		ev.msg.hdr.payload_size = sizeof(ev) - sizeof(ev.msg.hdr);
+		memset((char*)&ev.msg.hdr + sizeof(ev.msg.hdr), 0,
+			ev.msg.hdr.payload_size);
 		ev.msg.event_data.event = VMCI_EVENT_CTX_REMOVED;
 		ev.payload.context_id = context_id;
 
-- 
2.39.5



