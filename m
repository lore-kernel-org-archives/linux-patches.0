Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFD182F7461;
	Tue, 12 Aug 2025 17:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020428; cv=none; b=GeSb5H8jr2wM4CzpPBDgfO61rOPUtwAtzEjw32LRZXIcJSwygj7+2iq9KPzhkna2xYcX9GqFBvl9IdlsEG2LTQ5LSiuk8Pc0YWUd4h8n+RJ6ZZzcRuSCE/olBCPcfXb8XkROEmnC4v6dj71BSoxQmqZHb78avhbC8DxWA9FKG+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020428; c=relaxed/simple;
	bh=NGplUrI3WimMACrB3RGJi9vlXpB8mkMAe8lXlpMqfoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JN5zeN7IZQ5JAlHEMo1qQ8mLIV4jwIbQEeRWCTaMBb3Gkx/rmeHw9Kn1bwq40EUecKtVVj8SmF+qDKUYegt6BOOlPab5tERAJUfOhqURVjViadu6h6KXRXEjYWMpkAgh+OX3t7FymxqTW7TTJMfTx2tgUZ1PjYJv8Izw8ikSWEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AKU1sgYm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AKU1sgYm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D472C4CEF1;
	Tue, 12 Aug 2025 17:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020428;
	bh=NGplUrI3WimMACrB3RGJi9vlXpB8mkMAe8lXlpMqfoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AKU1sgYmYay+iktWTBEY4/T5Wzz0+0gK8i8bR1NdNhhvJvYqN3rUMzGzJ12OUUqXP
	 meRNMxBQh0iNgWq+5DAE3vWMny7cEmTMbAwjok8F/mGIwyIxiFCSiG7cO4+VivOoSw
	 +tuOOBYpvEd/L26QylnlWOQUkXyLQYssZcLwsPvA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9b9124ae9b12d5af5d95@syzkaller.appspotmail.com,
	Lizhi Xu <lizhi.xu@windriver.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 078/253] vmci: Prevent the dispatching of uninitialized payloads
Date: Tue, 12 Aug 2025 19:27:46 +0200
Message-ID: <20250812172952.050653269@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 172696abce31..ab5060df80aa 100644
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



