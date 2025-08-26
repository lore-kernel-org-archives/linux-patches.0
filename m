Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87F44350D47;
	Tue, 26 Aug 2025 14:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218641; cv=none; b=TMgf/xkQxvLWYwL67o4x5+3Nwee9bo838GMZomDuacH89AY4oUbBqqnGSXzAAGEPpkF8y+bEr5aZJQChTQYNsWLkMGP/YyXoXM8N+Z3vEo7LBV1RMgPPuNCWC2Qdb6oOcLSKEvImk4x5lrqDpz+9bqqJJqDMJczsM2bBrjuI6MM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218641; c=relaxed/simple;
	bh=34BTHudvTne33MY8PvyS+nzDcEuajad/QSo/19/sWW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dzbJhS4D4iVvNylrLrY/0bEcZw9icZvsyNF6DX1DQE+otztEBiSiIJxpLmHX93mZjrZpsbGIfYCbcJZkPzkxgxxys0TiR8uStgt1rVTHOPOcYitwzkoh4t21mfXXeMzXYdl+gTtLt8DebBdtq/CrVWl9bnafOKA/Lm8IrTkFvJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CPGiQW2k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CPGiQW2k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE53FC4CEF1;
	Tue, 26 Aug 2025 14:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218641;
	bh=34BTHudvTne33MY8PvyS+nzDcEuajad/QSo/19/sWW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CPGiQW2kDW0J9/vLshr2XieX3YJs2AyxK15ojaQB+mPkBKQXerdKlqZyjoCSfF38F
	 vFiJ5JvxAGnWSuweywnF0vw9x30/egk3MeO+Et6yFr9BpKg7MevDt1VY4K3krQj5FT
	 Yk9tNOb/Xn4xYefw1PY6EMm32S1jU8WkxTEnbFgo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9b9124ae9b12d5af5d95@syzkaller.appspotmail.com,
	Lizhi Xu <lizhi.xu@windriver.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 076/403] vmci: Prevent the dispatching of uninitialized payloads
Date: Tue, 26 Aug 2025 13:06:42 +0200
Message-ID: <20250826110908.503555939@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 26ff49fdf0f7..ccadbc0d8f7d 100644
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



