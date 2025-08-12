Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB95305E08;
	Tue, 12 Aug 2025 18:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022052; cv=none; b=coV1RCyl6AlcFTMpWXfiNIuOOHbE3CNQanpSFjQDMK1ZGHmPz6TrGK9Kb1oGrn3eRz3s3NmI+b1IK+WpypyA8k03dC1Q3AU0tXl4+/5w1S0YR8mLVz0KDLJ0HKgcv3J5VThuI+OUVBlZivYo/TAMyllvfkz9oXuBX+fncmUAHcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022052; c=relaxed/simple;
	bh=qtB9Tim6lpu09BJplISP0HvaKpiuQVz4EcHKVxm0fJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oc1dkEDbS+rwVeQRsT5kVop/AHTbKTLqjYXu3LXzaFR/qMfQY535DXDMMm3tNQhqTQrPTTeJ51fQrXJC5Ezk4//G1VAq0o+Ax3NpAq/wq1CVrFKG61KK/8wr7FSZXbAWBD7/DYZxhdecud8IFC4/oyly/5USoiVjz2kF509OltM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f+7Efk+T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f+7Efk+T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06C3BC4CEF0;
	Tue, 12 Aug 2025 18:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022052;
	bh=qtB9Tim6lpu09BJplISP0HvaKpiuQVz4EcHKVxm0fJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f+7Efk+T9FUgHiS1Ka/LaxOxpZUwyTKQPpHxTPQmV6BPhppzaYnZIjWJCjcArX5I3
	 26IiGxijwKs5jDHlvi/qYf0yLPos7vsyeCBEOf/bno5uMQUFSkeY6hJMJMk+Tef1oj
	 X3EtMioQzYV433ShRkmVU8RoP3u9hDwBN21OhgJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9b9124ae9b12d5af5d95@syzkaller.appspotmail.com,
	Lizhi Xu <lizhi.xu@windriver.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 042/369] vmci: Prevent the dispatching of uninitialized payloads
Date: Tue, 12 Aug 2025 19:25:39 +0200
Message-ID: <20250812173016.341947210@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



