Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8709519CD1D;
	Thu, 30 Jul 2026 15:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426019; cv=none; b=EtWuLJychrgq5i1MPEDD426W2ukRabBQScPKqllGcggCrEzpKwSWVc5lZVKd64bfhaI1+20s+VzQ3QyDnjsFFnxUQyYTr5UuG0QD3ZxtgDhKb+HesoSe11RX53KKS5+SZaY/3eqMu+Xk3ErM+0W8OHAxmroppcrSy+2Lckj1MfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426019; c=relaxed/simple;
	bh=fwYf61/MP40z0n2VMIEnW1BW0ytBP38X+YKK1/w2sH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BPCd2rCLxsoklCRvaJn+K8gq7mWR/ao5PNLZgYMZ4bQHdD24Qm+f2Ofb0T2TgVJkHZZvmUMcNM4XqQSg5THaq5b2CHmoEINYLpmFNP+uNYeOSB5tbxzU+//8ocWSnh97aZ4mrA31bh/0VafJ4C5Vc0UHTwRsefqF+xfmKe68cwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=00rYe6ST; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="00rYe6ST"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8041C1F000E9;
	Thu, 30 Jul 2026 15:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426018;
	bh=OpwMKo5AqqmlIi5LQwo3ZOJIoMtZazfoVCEGpnwhKKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=00rYe6STl5HmvtF8M0S5MRx36pZplN9ucl5APsfvteJgox3AYQoQLR+37xpFkjxd/
	 MIVmcVYo+dVtD0ZlG0qIN7IaScOfGtnJomrVUGp5xTyzDpOwU723+dl2+WljQre2yP
	 XLR9ZEQR5m98dhZrOFBvyGrY+75a1h2hLaaF2pkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 235/602] net: qrtr: restrict socket creation to the initial network namespace
Date: Thu, 30 Jul 2026 16:10:27 +0200
Message-ID: <20260730141440.911196069@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aldo Ariel Panzardo <qwe.aldo@gmail.com>

[ Upstream commit 3b536db8fb32da9e9c62f2bb45e2e319331f0426 ]

QRTR keeps its entire port and node state in module-global variables
that are not partitioned per network namespace: qrtr_local_nid is a
single global node id (always 1) and qrtr_ports is a single global
xarray. qrtr_port_lookup() and qrtr_local_enqueue() operate on that
global state with no network-namespace check, and qrtr_create() places
no restriction on the namespace a socket is created in.

As a result an unprivileged process that creates an AF_QIPCRTR socket
in a separate network namespace, e.g. via
unshare(CLONE_NEWUSER | CLONE_NEWNET), can send QRTR datagrams -
including control-plane messages such as QRTR_TYPE_NEW_SERVER - to QRTR
sockets owned by another namespace, and vice versa. The receiving
socket sees such a message as coming from node id 1, indistinguishable
from a legitimate local client, breaking the isolation that network
namespaces are expected to provide.

QRTR is a transport to global hardware endpoints (the modem and other
remote processors) and has no per-namespace semantics; its in-kernel
name service already creates its socket in init_net only. Confine the
socket family to the initial network namespace, as other
non-namespace-aware socket families do (see llc_ui_create() and the
ieee802154 socket code).

Fixes: bdabad3e363d ("net: Add Qualcomm IPC router")
Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
Link: https://patch.msgid.link/20260716154319.3297699-1-qwe.aldo@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/qrtr/af_qrtr.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/qrtr/af_qrtr.c b/net/qrtr/af_qrtr.c
index 305523cebe3baa..fcd24a7df3f00d 100644
--- a/net/qrtr/af_qrtr.c
+++ b/net/qrtr/af_qrtr.c
@@ -1261,6 +1261,14 @@ static int qrtr_create(struct net *net, struct socket *sock,
 	if (sock->type != SOCK_DGRAM)
 		return -EPROTOTYPE;
 
+	/* QRTR keeps its port and node state in module-global variables that
+	 * are not partitioned per network namespace, and the in-kernel name
+	 * service only operates in init_net. Confine the family to init_net so
+	 * a socket in another namespace cannot reach the global control plane.
+	 */
+	if (!net_eq(net, &init_net))
+		return -EAFNOSUPPORT;
+
 	sk = sk_alloc(net, AF_QIPCRTR, GFP_KERNEL, &qrtr_proto, kern);
 	if (!sk)
 		return -ENOMEM;
-- 
2.53.0



