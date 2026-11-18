Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049458;
	b=ueLju7AvMhsP5etAquiQUC6BsUMTfBpKzcZvlRguEaoVISGhU0vGLv18PBcebwq7aBvq
	 sVDjn5HJW4jq5Z4+yFoKkCezKkQ+7u+jL6TEmz1z6+2c2Ikg/hgfYijVO8zCRA8+WmiPl
	 Dm6zLi0tvj5zosRtRg0vjJgyuk3BZj93VN9jkiYLXa+VDVQUi9U4FM11+WPlUwoUPMmml
	 CwljdrkwDZM+JJFqBTHav2+s02c9zhrL10kiQ/YMg9cJOEtr8/Sg1okDPIrGdNuQ9VkPN
	 1rfYPWj/HD3yfd2L1Int3rXRuOLl7OO04RdFqGH7t+BBtFomkWEhd8/SZ6v0uzqRi7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049458;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qFqVHAv8khgRiyUxomthKjtfnpoyku8Wz5yHqKF6gCc=;
	b=pwuaoyybo5i+El1gEx9zD1h901CSVjgYi69ed9z3moBUMtATKKpasUxi67//SqsHUnR0
	 6FZ92IKMuDQwFm6NwNH1IU9l3uCrUIkZasGhJC31dJXFtOHtBlcyybjjOpT+S9WQfS4W9
	 RGHYD43622UAFOK70x//eEtjO94ylVeyR+kVSAdNNaEb0GZnKGFYZ5UNCLmYpqAKiKW5x
	 VSptpjeLWGCQxmlHwf1y7d3K/nWb1iUCYP6Gd6Jej7YvacNOMJYN/j/IFNbdGrWpRyZBK
	 OlWt5TnkZ5xvcVKGp9Ut1+fcBdORl/2+ZDpPX6IfnKlHHBBCJPlCGJpE+samk1VzysQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="S9pHGL/C";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CFA7606A325;
	Thu, 19 Nov 2026 00:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S9pHGL/C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 888C11F000C4;
	Thu, 19 Nov 2026 00:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049458;
	bh=qFqVHAv8khgRiyUxomthKjtfnpoyku8Wz5yHqKF6gCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S9pHGL/CmycIsfQTocuUPvIz7hG8ln+o6tgyos3g4nBB3Muiu+nJsVYsukz8+xI3D
	 dZbbd7+mM38wMph9j38Oj9sjggHkzgIHzVvQ/AdKqNCZ81IjFFCESjut0DHNVjH0vl
	 Dz4E9gU70FJSkze0UDm71qKOSy0ND5SDsEMXkQm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Changyul Lee <lcy8047@gmail.com>,
	Sang-Hoon Choi <csh0052@gmail.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2356/2857] xhci: dbc: lock the minor IDR on registration failure
Date: Wed, 18 Nov 2026 15:56:30 +0100
Message-ID: <20261118150326.354043341@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index eac847efab2ea..713532453eacf 100644
--- a/drivers/usb/host/xhci-dbgtty.c
+++ b/drivers/usb/host/xhci-dbgtty.c
@@ -502,7 +502,9 @@ static int xhci_dbc_tty_register_device(struct xhci_dbc *dbc)
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



