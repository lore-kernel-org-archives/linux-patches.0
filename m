Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041205;
	b=uLhq/AxAjDEu0z4mY1Inh111ACuXmqfeFAdHIUsom/IL0HgvNt10gdsSF/z1Z4aZ+emI
	 AzULjeDzoE07yF2Xoo9+62yp2oPPWma48pNjHvu4ZNTwMt7Rk6fCsqt0FTtg31HPdmvQV
	 NxcPwfM+5v0luliUdoe/+YsXUmoYObdKQKcAijxQ9goN5USufZwtqPNAlzhlhYD9MYb0B
	 8fygiQXjgncy9z0A/1FqWaXY+u6edXhs9hKQ2YjVm9M5hOswHAMVaSD4FvUTmX09EZVzM
	 dXn+NuxZLn+krBX3N8sxtsehzrLN7kv8v8t7XP7pRwPT0biMPsyaZ5RBc2ZjoJIyzWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041205;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eyjyrWCfm2e3wePvqQKfONYUBDw01p5KzJnWHhVBpIo=;
	b=ExW7E1Vd7EmBeWQLDWtjB0VXstf1w0+GvJ7v4PrNuLbkRZvYukQgseX9yrqmiFGTWjVi
	 +8GcN5za20Zgbaztu7XSDgRO6vUflpubBASkK9sYcgo3kwI9G3PybAIwQY10Pb9g5nt4R
	 yJj2s7MuNCyjFEQd9/pq2mmwux0jW+amd77D9SgNXJYD+JBab3IKFV+KzX6SEDIHy9ne/
	 u3IBC15dpydhl3dt4JaUyvBc2Jw+T4zCu/lHL8gzsD8HUCJJkP71+YJDnKRhd5QEumMiM
	 jHy7so4nhnUZH2yNApcOJF3mt3I83yTsV+4BUNpmJjhPCwS0f6idJvgBHBpJLhWtVUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k2CrKUHc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1122606A32A;
	Wed, 18 Nov 2026 22:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k2CrKUHc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DECE1F000C4;
	Wed, 18 Nov 2026 22:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041205;
	bh=eyjyrWCfm2e3wePvqQKfONYUBDw01p5KzJnWHhVBpIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k2CrKUHc4gm70zDYpnabBihWdpUqmVY1ZIhNvhwEyxYbyEIr/OCV1bXmnvtDLV0CR
	 Dvh2jHD124uiICA2m/whg/dd3YXM4IgQB0GbPbdf4Va/rsLbMzEqb/9N7P3noBcLXs
	 AoNRg/Er1ks0WXDaZdIjcNNkTZfqq7NGRIuiqQLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Changyul Lee <lcy8047@gmail.com>,
	Sang-Hoon Choi <csh0052@gmail.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2731/3318] xhci: dbc: lock the minor IDR on registration failure
Date: Wed, 18 Nov 2026 15:55:53 +0100
Message-ID: <20261118150442.744060800@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sang-Hoon Choi <csh0052@gmail.com>

[ Upstream commit 47f4e983b5de7616fb11d5f537fc9a605387d136 ]

dbc_tty_minors is protected by dbc_tty_minors_lock when entries are
allocated and during normal device removal. The registration error path
removes an entry without taking that lock. Different DbC instances have
separate event work items, so this removal can race with an IDR update
for another instance.

Take the same mutex around the error-path removal.

Fixes: e1ec140f273e ("xhci: dbgtty: use IDR to support several dbc instances.")
Reported-by: Changyul Lee <lcy8047@gmail.com>
Assisted-by: LLM
Signed-off-by: Sang-Hoon Choi <csh0052@gmail.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://patch.msgid.link/20261009151624.618967-6-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-dbgtty.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/host/xhci-dbgtty.c b/drivers/usb/host/xhci-dbgtty.c
index d2ad264824a2a..18d5be21a3d38 100644
--- a/drivers/usb/host/xhci-dbgtty.c
+++ b/drivers/usb/host/xhci-dbgtty.c
@@ -503,7 +503,9 @@ static int xhci_dbc_tty_register_device(struct xhci_dbc *dbc)
 err_free_fifo:
 	kfifo_free(&port->port.xmit_fifo);
 err_exit_port:
+	mutex_lock(&dbc_tty_minors_lock);
 	idr_remove(&dbc_tty_minors, port->minor);
+	mutex_unlock(&dbc_tty_minors_lock);
 err_idr:
 	xhci_dbc_tty_exit_port(port);
 
-- 
2.53.0



